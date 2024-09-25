

import 'package:coinbase/api/coinbase_websocket.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class CoinbaseStatusRepository {
  final CoinbaseWebsocket _coinbaseWebsocket;

  CoinbaseStatusRepository(this._coinbaseWebsocket){
    _init();
  }

  WebSocketChannel? _channel;

  void _init() {
    _channel = _coinbaseWebsocket.connect();
  }
}
