import 'package:bank/models.dart';
import 'package:test/test.dart';
import 'package:bank/api_requests.dart';


void main() {
  test("Return type should be List<SubAccount>", () async {
    var requestor = Requestor();
    TokenData td = await requestor.login("UserTest", "wbb12345");
  });
}