import 'package:bank/models.dart';
import 'package:test/test.dart';
import 'package:bank/api_requests.dart';


void main() {
  test("Should return TokenData object", () async {
    var requestor = Requestor();
    TokenData td = await requestor.login("UserTest", "wbb12345").catchError((Object error, StackTrace st) => {expect(true, false)});
    expect(requestor.tokenData.access.isNotEmpty, true);
    expect(requestor.tokenData.refresh.isNotEmpty, true);
  });

  test("Should return List<SubAccount>", () async {
    var requestor = Requestor();
    TokenData td = await requestor.login("UserTest", "wbb12345").catchError((Object error, StackTrace st) => {expect(true, false)});

    bool validToken = await requestor.isValidAccessToken();
    expect(validToken, true);
  });
}