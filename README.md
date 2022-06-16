# RCON.dart

A client for Minecraft's RCON protocol written in Dart.

# Usage
```dart
import 'package:rcon/rcon.dart';

main() async {
  Client client = await Client.create("192.168.1.1", 25575);
  client.login("test");
  print(client.send(Message.create(client, PacketType.command, "help")));
  client.close();
}
```

# Command Line Usage
For command line usage, run the [example.dart](https://www.github.com/OneLemonyBoi/rcon-dart/examples/example.dart) file.