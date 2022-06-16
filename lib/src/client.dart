import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'message.dart';

class Client {
  final InternetAddress ip;
  final int port;
  final RawSocket tcpSocket;
  int messageCount = 0;

  Client._(this.ip, this.port, this.tcpSocket);

  static Future<Client> create(String ip, int port) async {
    return Client._(
        InternetAddress(ip), port, await RawSocket.connect(ip, port));
  }

  bool login(String password) {
    Message response = send(Message.create(this, PacketType.login, password));
    return response.id != 255;
  }

  StreamSubscription<RawSocketEvent> listen(
      void Function(RawSocketEvent event)? onData,
      {Function? onError,
      void Function()? onDone,
      bool? cancelOnError}) {
    return tcpSocket.listen(onData,
        onError: onError, onDone: onDone, cancelOnError: cancelOnError);
  }

  Message send(Message msg, [int offset = 0, int? count]) {
    tcpSocket.write(msg.assemble(), offset, count);
    Uint8List out = Uint8List.fromList([]);
    Stopwatch time = Stopwatch();
    while (time.elapsed < Duration(milliseconds: 250)) {
      Uint8List? packet = tcpSocket.read();
      if (packet == null) continue;
      if (out.isEmpty) {
        out = packet;
        time.start();
        continue;
      }
      out = Uint8List.fromList(out.toList().sublist(0, out.length - 2) +
          Message.getPayload(packet) +
          [0, 0]);
    }
    return Message.fromByteList(out);
  }

  Uint8List? read([int? len]) {
    return tcpSocket.read(len);
  }

  void close() {
    tcpSocket.close();
  }
}
