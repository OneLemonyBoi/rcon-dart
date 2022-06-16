import 'dart:convert';
import 'dart:typed_data';
import 'client.dart';
import 'typed_data_manipulation.dart';

class Message {
  final int id;
  final PacketType type;
  final String payload;

  Message._(this.id, this.type, this.payload);

  static Message create(Client client, PacketType type, String payload) {
    return Message._(client.messageCount++, type, payload);
  }

  static Message fromByteList(Uint8List list) {
    int messageSize =
        list.getRange(0, 4).toList().uint8List().uint32List().elementAt(0);
    int requestId = list.getRange(4, 8).toList().uint32List().elementAt(0);
    int requestType = list.getRange(8, 12).toList().uint32List().elementAt(0);
    String payload = utf8.decode(list.getRange(12, messageSize + 2).toList());
    return Message._(requestId, fromInt(requestType), payload);
  }

  /// Used to access payload seperately from rest of request
  static Uint8List getPayload(Uint8List list) {
    int messageSize = list.getRange(0, 4).toList().uint32List().elementAt(0);
    Uint8List payload = list.getRange(12, messageSize + 2).toList().uint8List();
    return payload;
  }

  /// Creates an RCON packet
  List<int> assemble() {
    List<int> message = [];
    // int -> array with one int -> array with previous int split into byte values
    message.addAll([id].uint32List().uint8List());
    message.addAll([type.index].uint32List().uint8List());
    message.addAll(utf8.encode(payload));
    // Terminator
    message.addAll([0, 0]);
    // Message length
    message.insertAll(0, [message.length].uint32List().uint8List());
    return message;
  }

  /// Removes up the color codes in Minecraft from the payload
  @override
  String toString() => payload.replaceAll(RegExp("(§[0-9 a-f])"), "");
}

enum PacketType { response, none, command, login }

/// Converts an integer to a PacketType
PacketType fromInt(int value) {
  for (PacketType type in PacketType.values) {
    if (type.index == value) return type;
  }
  return PacketType.none;
}
