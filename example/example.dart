import 'dart:io';
import 'package:rcon/rcon.dart';

main(List<String> args) async {
  String ip = input(
      "Enter the IP address of your server: ",
      (str) => InternetAddress.tryParse(str) != null,
      "Please enter a valid IP address.");
  String port = input("Enter your server's RCON port: ",
      (str) => int.tryParse(str) != null, "Please enter a number.");
  print("Waiting...");
  Client client = await Client.create(ip, int.parse(port));
  print("Connected to the server at $ip:$port");
  input("Enter your server's RCON password: ", (str) => client.login(str),
      "Enter the correct password.");
  print("You have been authenticated.");
  print("You can now run any command by entering it below.");
  print("You can end the program by typing \"rcon.exit\"");

  bool killswitch = false;
  while (!killswitch) {
    String input = stdin.readLineSync() ?? "";
    if (input == "rcon.exit") {
      killswitch = true;
      continue;
    }
    print(processCommand(client, input));
  }

  print("Program exited successfully.");

  client.close();
}

String input(String query, Function(String) check, String errorMessage) {
  print(query);
  String? out = stdin.readLineSync();
  while (out == null || !check.call(out)) {
    print(errorMessage);
    out = stdin.readLineSync();
  }
  return out;
}

Message processCommand(Client client, String input) {
  return client.send(Message.create(client, PacketType.command, input));
}
