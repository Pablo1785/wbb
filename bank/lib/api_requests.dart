const String server_port = '8000';

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