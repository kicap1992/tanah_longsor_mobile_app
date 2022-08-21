import 'package:logger/logger.dart';
import 'package:socket_io_client/socket_io_client.dart';

class MySocketIO {
  static final dev = Logger();
  static final MySocketIO _singleton = MySocketIO._internal();
  factory MySocketIO() {
    return _singleton;
  }
  MySocketIO._internal();

  late Socket _socket;
  // static const String _url = 'http://192.168.43.125:3004';
  static const String _url = 'https://tanah-longosor-be.herokuapp.com';

  init() {
    _socket = io(_url, <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': true,
    });

    _socket.on('connect', (_) {
      dev.i('connect : ${_socket.id}');
    });
  }

  Future<void> emit(String event, dynamic data) async {
    _socket.emit(event, data);
  }

  Future<void> on(String event, Function(dynamic) callback) async {
    _socket.on(event, callback);
  }

  Future<void> off(String event) async {
    _socket.off(event);
  }

  Future<void> disconnect() async {
    _socket.disconnect();
  }

  Future<void> connect() async {
    dev.i('connect : ${_socket.id}');
    _socket.connect();
  }
}
