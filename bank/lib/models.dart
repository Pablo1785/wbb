import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

// Model ALL dataclasses like this one, so they can easily be deserialized from http responses
class SubAccount {
  final String sub_address;
  final double balance;
  final String currency;

  SubAccount({this.id, this.username, this.email});

  factory SubAccount.fromJson(Map<String, dynamic> json) {
    return SubAccount(
      id: json['id'],
      username: json['username'],
      email: json['email'],
    );
  }
}

//Sending data to server and getting response:
Future<SubAccount> createSubAccount(
    String username, String password, String email) async {
  final http.Response response = await http.post(
    'http://127.0.0.1:8080/auth/users/',
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, String>{
      'username': username,
      'password': password,
      'email': email,
    }),
  );

  if (response.statusCode == 201) {
    return SubAccount.fromJson(jsonDecode(response.body));
  } else {
    throw Exception('Błąd przy tworzeniu konta.\n\n${response.body}');
  }
}
