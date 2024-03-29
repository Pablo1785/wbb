import 'package:bank/models.dart';
import 'package:http/http.dart';
import 'package:test/test.dart';
import 'package:bank/api_requests.dart';

String username = "UserTest233";
String password = "wbb12345";


void main() {
  test("Should create and return UserProfile", () async {
    var requestor = Requestor();
    UserProfile up = await requestor.createUser(username, password, "uname@c.com");
    expect(up.username == username, true);
    TokenData td = await requestor.login(username, password).catchError((Object error, StackTrace st) => {print(st.toString())});
  });

  test("Should return TokenData object", () async {
    var requestor = Requestor();
    TokenData td = await requestor.login(username, password).catchError((Object error, StackTrace st) => {print(st.toString())});
    expect(requestor.tokenData.access.isNotEmpty, true);
    expect(requestor.tokenData.refresh.isNotEmpty, true);
  });

  test("Notify server about user login", () async {
    var requestor = Requestor();
    var loginSuccess = await requestor.loginNotify(username, password).catchError((Object error, StackTrace st) => {print(st.toString())});
    expect(loginSuccess, true);
  });

  test("Create access tokens && notify server about login", () async {
    var requestor = Requestor();
    TokenData td = await requestor.login(username, password).catchError((Object error, StackTrace st) => {print(st.toString())});
    var loginSuccess = await requestor.loginNotify(username, password).catchError((Object error, StackTrace st) => {print(st.toString())});
    expect(loginSuccess, true);
    expect(requestor.tokenData.access.isNotEmpty, true);
    expect(requestor.tokenData.refresh.isNotEmpty, true);
  });

  test("REVERSED: Create access tokens && notify server about login", () async {
    var requestor = Requestor();
    var loginSuccess = await requestor.loginNotify(username, password).catchError((Object error, StackTrace st) => {print(st.toString())});
    TokenData td = await requestor.login(username, password).catchError((Object error, StackTrace st) => {print(st.toString())});
    expect(loginSuccess, true);
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

    var sa = await requestor.createSubaccount();
    expect(sa.owner, username);
  });

  test("Should fetch and return UserProfile", () async {
    var requestor = Requestor();
    TokenData td = await requestor.login(username, password).catchError((Object error, StackTrace st) => {print(st.toString())});
    UserProfile up = await requestor.fetchUser(username);
    expect(up.username == username, true);
  });

  test("Should update and return UserProfile", () async {
    var requestor = Requestor();
    TokenData td = await requestor.login(username, password).catchError((Object error, StackTrace st) => {print(st.toString())});
    UserProfile up = await requestor.updateUser(username, email: "new@mail.com");
    expect(up.username == username, true);
    expect(up.email == "new@mail.com", true);
  });

  // test("Should fetch and return Wallet", () async {
  //   var requestor = Requestor();
  //   TokenData td = await requestor.login(username, password).catchError((Object error, StackTrace st) => {print(st.toString())});
  //   Wallet w = await requestor.fetchWallet();
  //   expect(w.walletAddress.isNotEmpty, true);
  // });

  // test("Should create and return Wallet", () async {
  //   var requestor = Requestor();
  //   TokenData td = await requestor.login("uname", "unameqazxswedc").catchError((Object error, StackTrace st) => {print(st.toString())});
  //   Wallet w = await requestor.createWallet("testprivatekey");
  //   expect(w.walletAddress.isNotEmpty, true);
  // });

  test("Should return BTC exchange rate in given currency", () async {
    var requestor = Requestor();
    var be = await requestor.fetchBtcExchangePrice("EUR");

    expect(requestor.lastResponse.statusCode, 200);
    expect(be is BtcExchange, true);
  });
}