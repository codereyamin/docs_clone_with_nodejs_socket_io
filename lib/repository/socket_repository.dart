import 'package:docs_clone_with_nodejs_socket_io/clients/socket_client.dart';
import 'package:socket_io_client/socket_io_client.dart';

class SocketRepository {
  final _socketClient = SocketClient.instance.socket!;

  Socket get socketClient => _socketClient;
  void joinRoom(String documentId) {
    _socketClient.emit('join', documentId);
  }
}
