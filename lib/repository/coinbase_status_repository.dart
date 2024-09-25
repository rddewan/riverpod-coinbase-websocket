

import 'dart:convert';

import 'package:coinbase/api/coinbase_websocket.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class CoinbaseStatusRepository {
  final CoinbaseWebsocket _coinbaseWebsocket;

  CoinbaseStatusRepository(this._coinbaseWebsocket){
    _init();
  }

  WebSocketChannel? _channel;
  bool _isDisposed = false;
  bool _isSubscribed = false;

  void _init() {
    _channel = _coinbaseWebsocket.connect();
     _subscribeToStatus();
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
}
