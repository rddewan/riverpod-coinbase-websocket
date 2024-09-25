

import 'dart:async';
import 'dart:convert';

import 'package:coinbase/api/coinbase_websocket.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

final coinbaseStatusRepositoryProvider = AutoDisposeStreamProvider<Map<String, dynamic>>((ref) {
  final coinbaseWebsocket = ref.watch(coinbaseWebsocketProvider);
  final coinbaseStatusRepository = CoinbaseStatusRepository(coinbaseWebsocket);

  return coinbaseStatusRepository.stream;
});

class CoinbaseStatusRepository {
  final CoinbaseWebsocket _coinbaseWebsocket;

  CoinbaseStatusRepository(this._coinbaseWebsocket){
    _init();
  }

  WebSocketChannel? _channel;
  bool _isDisposed = false;
  bool _isSubscribed = false;
  final StreamController<Map<String, dynamic>> _streamController = StreamController<Map<String, dynamic>>();
  Stream<Map<String, dynamic>> get stream => _streamController.stream;

  void _init() {
    _channel = _coinbaseWebsocket.connect();
     _subscribeToStatus();
     _listen();
  }

  void _subscribeToStatus() {
   
    // check if we are not already disposed
    if (_isDisposed) return;

    final message = jsonEncode({
      "type": "subscribe",
      "channels": [{ "name": "status"}],
    });

    // Subscribe to status
    _isSubscribed = true;
    // Send subscription message to websocket
    _channel?.sink.add(message);

  }

  void _listen() {
    if (_isDisposed) return;

    _channel?.stream.listen((data) {
      final jsonData = jsonDecode(data) as Map<String, dynamic>;
      _streamController.add(jsonData);      

    }, 
    onDone: () {
      
    },
    onError: () {
      
    },
    cancelOnError: true,
    );
  }
}
