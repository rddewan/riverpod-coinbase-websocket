


import 'dart:async';
import 'dart:convert';

import 'package:coinbase/api/coinbase_websocket.dart';
import 'package:flutter/foundation.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'coinbase_price_repository.g.dart';

@riverpod 
Stream coinbasePriceRepository(CoinbasePriceRepositoryRef ref, List<String> productIds) {
  final coinbaseWebsocket = ref.watch(coinbaseWebsocketProvider);

  final coinbasePriceRepository = CoinbasePriceRepository(coinbaseWebsocket, productIds);

  ref.onDispose(() {
    coinbasePriceRepository._unSubscribeToPrice();
    coinbasePriceRepository.dispose();
    ref.invalidate(coinbaseWebsocketProvider);
    
    debugPrint('CoinbaseStatusRepository disposed');
  });

  return coinbasePriceRepository.stream;
  
}


class CoinbasePriceRepository {
  final CoinbaseWebsocket _coinbaseWebsocket;
  final List<String> _productIds;

  CoinbasePriceRepository(this._coinbaseWebsocket, this._productIds) {
    _init();
  }

  WebSocketChannel? _channel;
  bool _isDisposed = false;
  bool _isSubscribed = false;
  
  final StreamController<Map<String, dynamic>> _streamController =
      StreamController<Map<String, dynamic>>();
  Stream<Map<String, dynamic>> get stream => _streamController.stream;

  void _init() {
    _channel = _coinbaseWebsocket.connect();
    _subscribeToPrice();
    _listen();
  }

  void _subscribeToPrice() {
    // check if we are not already disposed
    if (_isDisposed || _isSubscribed) return;

    final message = jsonEncode({
      "type": "subscribe",
      "product_ids": _productIds,
      "channels": ["ticker"],
    });

    // Subscribe to status
    _isSubscribed = true;
    // Send subscription message to websocket
    _channel?.sink.add(message);
  }

  void _unSubscribeToPrice() {
    // check if we are not already disposed
    if (_isDisposed || !_isSubscribed) return;

    final message = jsonEncode({
      "type": "unsubscribe",
      "channels": ["ticker"],
    });

    // Subscribe to status
    _isSubscribed = false;
    // Send subscription message to websocket
    _channel?.sink.add(message);
  }

  void _listen() {
    if (_isDisposed) return;

    _channel?.stream.listen(
      (data) {
        final jsonData = jsonDecode(data) as Map<String, dynamic>;
        _streamController.add(jsonData);
      },
      onError: (e) {
        _reconnect();
      },
    );
  }

  void _reconnect() {
    if (_isDisposed) return;

    Future.delayed(const Duration(seconds: 3), () {
      _init();
    });
  }

  void dispose() {
    _isDisposed = true;
    _channel?.sink.close();
    _streamController.close();
  }
}
