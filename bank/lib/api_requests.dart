import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'package:bank/models.dart';

const String server_port = '8000';
const String server_address = 'http://127.0.0.1';

//Sending data to server and getting response:
Future<UserProfile> createUser(
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
    return UserProfile.fromJson(jsonDecode(response.body));
  } else {
    throw Exception('Błąd przy tworzeniu konta.\n\n${response.body}');
  }
}


class Requestor {
  final String serverAddress;
  final String serverPort;

  // Ths class doesn't handle logging in, it should be initialized with atuhToken and refreshToken on first login
  String authToken;
  String refreshToken;

  Requestor(String authToken, String refreshToken, {this.serverAddress = 'http://127.0.0.1', this.serverPort = '8000'}) {
    this.authToken = authToken;
    this.refreshToken = refreshToken;
  }

  Future<TokenData> login(String username, String password) {
    
  }


  // Subaccount creation:
  Future<SubAccount> createSubaccount(String currency) async {
    final http.Response response = await http.post(
      '${this.serverAddress}:${this.serverPort}/api/subacc/',
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'JWT ${this.authToken}'
      },
      body: jsonEncode(<String, String>{
        'currency': currency,
      }),
    );

    if (response.statusCode == 201) {
      return SubAccount.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Błąd przy tworzeniu rachunku.\n\n${response.body}');
    }
  }

  Future<List<SubAccount>> fetchSubaccounts() async {
    final http.Response response = await http.post(
      '${this.serverAddress}:${this.serverPort}/api/subacc/',
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'JWT ${this.authToken}'
      },
    );

    if (response.statusCode == 200 || response.statusCode == 204) {
      List<Map<String, dynamic>> results = jsonDecode(response.body);
      return List.from(results.map((model) => SubAccount.fromJson(model)));
    } else {
      throw Exception('Błąd przy pobieraniu rachunków.\n\n${response.body}');
    }
  }
}

