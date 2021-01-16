import 'package:bank/models.dart';
import 'package:test/test.dart';
import 'package:bank/api_requests.dart';


void main() {
  test("Should return TokenData object", () async {
    var requestor = Requestor();
    TokenData td = await requestor.login("UserTest", "wbb12345").catchError((Object error, StackTrace st) => {print(st.toString())});
    expect(requestor.tokenData.access.isNotEmpty, true);
    expect(requestor.tokenData.refresh.isNotEmpty, true);
  });

  test("Should return true in case token is valid", () async {
    var requestor = Requestor();
    TokenData td = await requestor.login("UserTest", "wbb12345").catchError((Object error, StackTrace st) => {print(st.toString())});

    bool validToken = await requestor.isValidAccessToken();
    expect(validToken, true);
  });

  test("Acess token should change after successful refresh", () async {
    var requestor = Requestor();
    TokenData td = await requestor.login("UserTest", "wbb12345").catchError((Object error, StackTrace st) => {print(st.toString())});
    String oldAccess = td.access;
    TokenData refreshedTd = await requestor.refreshAccessToken();
    expect(refreshedTd.access == oldAccess, false);
  });

  test("Should return created user's subaccount", () async {
    var requestor = Requestor();
    TokenData td = await requestor.login("UserTest", "wbb12345").catchError((Object error, StackTrace st) => {print(st.toString())});

    var sa = await requestor.createSubaccount("BTC");
    expect(sa.owner, "UserTest");
  });

  test("Should return created user's subaccount", () async {
    var requestor = Requestor();
    TokenData td = await requestor.login("UserTest", "wbb12345").catchError((Object error, StackTrace st) => {print(st.toString())});

    var sa = await requestor.fetchSubaccounts();
    expect(sa is List<SubAccount>, true);
  });
}