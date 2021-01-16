import 'package:bank/models.dart';
import 'package:test/test.dart';
import 'package:bank/api_requests.dart';

String username = "test1";
String password = "test1";


void main() {
  test("Should return TokenData object", () async {
    var requestor = Requestor();
    TokenData td = await requestor.login(username, password).catchError((Object error, StackTrace st) => {print(st.toString())});
    expect(requestor.tokenData.access.isNotEmpty, true);
    expect(requestor.tokenData.refresh.isNotEmpty, true);
  });

  test("Should return true in case token is valid", () async {
    var requestor = Requestor();
    TokenData td = await requestor.login(username, password).catchError((Object error, StackTrace st) => {print(st.toString())});

    bool validToken = await requestor.isValidAccessToken();
    expect(validToken, true);
  });

  test("Acess token should change after successful refresh", () async {
    var requestor = Requestor();
    TokenData td = await requestor.login(username, password).catchError((Object error, StackTrace st) => {print(st.toString())});
    String oldAccess = td.access;
    TokenData refreshedTd = await requestor.refreshAccessToken();
    expect(refreshedTd.access == oldAccess, false);
  });

  test("Should return created user's subaccount", () async {
    var requestor = Requestor();
    TokenData td = await requestor.login(username, password).catchError((Object error, StackTrace st) => {print(st.toString())});

    var sa = await requestor.createSubaccount("BTC");
    expect(sa.owner, username);
  });

  test("Should fetch and return UserProfile", () async {
    var requestor = Requestor();
    TokenData td = await requestor.login(username, password).catchError((Object error, StackTrace st) => {print(st.toString())});
    UserProfile up = await requestor.fetchUser(username);
    expect(up.username == "test1", true);
  });

  test("Should create and return UserProfile", () async {
    var requestor = Requestor();
    UserProfile up = await requestor.createUser("uname", "unameqazxswedc", "uname@c.com");
    expect(up.username == "uname", true);
    TokenData td = await requestor.login("uname", "unameqazxswedc").catchError((Object error, StackTrace st) => {print(st.toString())});
  });

  test("Should update and return UserProfile", () async {
    var requestor = Requestor();
    TokenData td = await requestor.login("uname", "unameqazxswedc").catchError((Object error, StackTrace st) => {print(st.toString())});
    UserProfile up = await requestor.updateUser("uname", email: "new@mail.com");
    expect(up.username == "uname", true);
    expect(up.email == "new@mail.com", true);
  });
}