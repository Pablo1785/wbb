import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'package:bank/models.dart';

const String server_port = '8000';
const String server_address = 'http://127.0.0.1';

//Sending data to server and getting response:

class Requestor {
  final String serverAddress;
  final String serverPort;

  TokenData tokenData;

  // Last response obtained with one of this Requestor's methods
  http.Response lastResponse;

  Requestor(
      {this.tokenData,
      this.serverAddress = server_address,
      this.serverPort = server_port});

  Future<TokenData> login(String username, String password) async {
    final http.Response response = await http.post(
      '${this.serverAddress}:${this.serverPort}/auth/jwt/create',
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8'
      },
      body: jsonEncode(<String, String>{
        'username': username,
        'password': password,
      }),
    );

    this.lastResponse = response;

    if (response.statusCode == 200) {
      this.tokenData = TokenData.fromJson(json.decode(response.body));
      return this.tokenData;
    } else {
      throw Exception('Błąd przy logowaniu.\n\n${response.body}');
    }
  }
  
  Future<bool> isValidAccessToken() async {
    final http.Response response = await http.post(
      '${this.serverAddress}:${this.serverPort}/auth/jwt/verify',
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8'
      },
      body: jsonEncode(<String, String>{
        'token': this.tokenData.access,
      }),
    );

    this.lastResponse = response;

    if (response.statusCode == 200) return true;
    return false;
  }

  Future<TokenData> refreshAccessToken() async {
    // On success return modified tokenData object, on failure throw "log in again" exception
    final http.Response response = await http.post(
      '${this.serverAddress}:${this.serverPort}/auth/jwt/refresh',
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'refresh': this.tokenData.refresh,
      }),
    );

    this.lastResponse = response;

    if (response.statusCode == 200) {
      var tokenData = TokenData.fromJson(jsonDecode(response.body));
      this.tokenData.access = tokenData.access;
      return this.tokenData;
    } else {
      throw Exception("Tokens expired. Log in again.");
    }
  }

  // SubAccount REQUESTS:
  Future<SubAccount> createSubaccount() async {
    final http.Response response = await http.post(
      '${this.serverAddress}:${this.serverPort}/api/subacc/',
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'JWT ${this.tokenData.access}'
      },
    );

    this.lastResponse = response;

    if (response.statusCode == 201) {
      return SubAccount.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Błąd przy tworzeniu rachunku.\n\n${response.body}');
    }
  }

  Future<List<SubAccount>> fetchSubaccounts() async {
    final http.Response response = await http.get(
      '${this.serverAddress}:${this.serverPort}/api/subacc/',
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'JWT ${this.tokenData.access}'
      },
    );

    this.lastResponse = response;

    if (response.statusCode == 200 || response.statusCode == 204) {
      return List<SubAccount>.from(json
          .decode(response.body)
          .map((model) => SubAccount.fromJson(model)));
    } else {
      throw Exception('Błąd przy pobieraniu rachunków.\n\n${response.body}');
    }
  }

  Future<List<BankDeposit>> fetchDeposits() async {
    final http.Response response = await http.get(
      '${this.serverAddress}:${this.serverPort}/api/deposit/',
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'JWT ${this.tokenData.access}'
      },
    );

    this.lastResponse = response;

    if (response.statusCode == 200 || response.statusCode == 204) {
      return List<BankDeposit>.from(json
          .decode(response.body)
          .map((model) => BankDeposit.fromJson(model)));
    } else {
      throw Exception('Błąd przy pobieraniu rachunków.\n\n${response.body}');
    }
  }  
  
  Future<List<LoginRecord>> fetchLoginRecords() async {
    final http.Response response = await http.get(
      '${this.serverAddress}:${this.serverPort}/api/login_history/',
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'JWT ${this.tokenData.access}'
      },
    );

    this.lastResponse = response;

    if (response.statusCode == 200) {
      return List<LoginRecord>.from(json
          .decode(response.body)
          .map((model) => LoginRecord.fromJson(model)));
    } else {
		if(response.statusCode == 204)
		{
			List<LoginRecord> emptyLogins = [LoginRecord(user:"null",action:"null",date:DateTime.parse("1970-01-01 00:00:00.000"),ipAddress:"null")];
			return emptyLogins;			
		}

		else
      throw Exception(
          'Błąd przy pobieraniu historii logowania.\n\n${response.body}');
    }
  }

  Future<Transaction> createTransaction(
      String source, String target, String amount, String title, String fee) async {
    final http.Response response = await http.post(
      '${this.serverAddress}:${this.serverPort}/api/trans/',
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'JWT ${this.tokenData.access}'
      },
      body: jsonEncode(<String, dynamic>{
        'source': source,
        'target': target,
        'amount': amount,
        // 'currency': currency,
        'title': title,
        'fee': fee,
      }),
    );

    this.lastResponse = response;

    if (response.statusCode == 201) {
      return Transaction.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Błąd przy tworzeniu transakcji.\n\n${response.body}');
    }
  }

   Future<BankDeposit> createDeposit(
      String account, String interestRate, String title) async {
    final http.Response response = await http.post(
      '${this.serverAddress}:${this.serverPort}/api/deposit/',
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'JWT ${this.tokenData.access}'
      },
      body: jsonEncode(<String, dynamic>{
        'account': account,
        'interestRate': interestRate,
        'title': title,
      }),
    );

    this.lastResponse = response;

    if (response.statusCode == 201) {
      return BankDeposit.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Błąd przy tworzeniu depozytu.\n\n${response.body}');
    }
  }
 
  Future<List<Transaction>> fetchTransactions() async {
    final http.Response response = await http.get(
      '${this.serverAddress}:${this.serverPort}/api/trans/',
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'JWT ${this.tokenData.access}'
      },
    );

    this.lastResponse = response;

    if (response.statusCode == 200 || response.statusCode == 204) {
      return List<Transaction>.from(json
          .decode(response.body)
          .map((model) => Transaction.fromJson(model)));
    } else {
      throw Exception(
          'Błąd przy pobieraniu historii transakcji.\n\n${response.body}');
    }
  }

  Future<List<Transaction>> fetchTransactionsIn() async {
    final http.Response response = await http.get(
      '${this.serverAddress}:${this.serverPort}/api/trans/in/',
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'JWT ${this.tokenData.access}'
      },
    );

    this.lastResponse = response;

    if (response.statusCode == 200 || response.statusCode == 204) {
      return List<Transaction>.from(json
          .decode(response.body)
          .map((model) => Transaction.fromJson(model)));
    } else {
      throw Exception(
          'Błąd przy pobieraniu historii transakcji.\n\n${response.body}');
    }
  }
  
  Future<List<Transaction>> fetchTransactionsOut() async {
    final http.Response response = await http.get(
      '${this.serverAddress}:${this.serverPort}/api/trans/out/',
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'JWT ${this.tokenData.access}'
      },
    );

    this.lastResponse = response;

    if (response.statusCode == 200 || response.statusCode == 204) {
      return List<Transaction>.from(json
          .decode(response.body)
          .map((model) => Transaction.fromJson(model)));
    } else {
      throw Exception(
          'Błąd przy pobieraniu historii transakcji.\n\n${response.body}');
    }
  }
  
  Future<UserProfile> createUser(
      String username, String password, String email) async {
    final http.Response response = await http.post(
      '${this.serverAddress}:${this.serverPort}/auth/users/',
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8'
      },
      body: jsonEncode(<String, String>{
        'username': username,
        'password': password,
        'email': email,
      }),
    );

    this.lastResponse = response;

    if (response.statusCode == 201) {
      return UserProfile.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Błąd przy tworzeniu konta.\n\n${response.body}');
    }
  }

  Future<UserProfile> fetchUser(String username) async {
    final http.Response response = await http.get(
      '${this.serverAddress}:${this.serverPort}/api/user/$username',
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'JWT ${this.tokenData.access}'
      },
    );

    this.lastResponse = response;

    if (response.statusCode == 200) {
      return UserProfile.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Błąd przy pobieraniu konta.\n\n${response.body}');
    }
  }

  Future<UserProfile> updateUser(String username,
      {String email, String firstname, String lastname}) async {
    Map<String, dynamic> body = {
      username == null ? "" : "username": username == null ? "" : username,
      email == null ? "" : "email": email == null ? "" : email,
      firstname == null ? "" : "first_name": firstname == null ? "" : firstname,
      lastname == null ? "" : "last_name": lastname == null ? "" : lastname,
    };
    final http.Response response = await http.put(
      '${this.serverAddress}:${this.serverPort}/api/user/$username/',
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'JWT ${this.tokenData.access}'
      },
      body: jsonEncode(body),
    );

    this.lastResponse = response;

    if (response.statusCode == 200) {
      return UserProfile.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Błąd przy aktualizacji konta.\n\n${response.body}');
    }
  }

  Future<Wallet> createWallet([String privateKey]) async {
    Map<String, dynamic> body = new Map();
    if (privateKey != null) body["private_key"] = privateKey;
    final http.Response response = await http.post(
      '${this.serverAddress}:${this.serverPort}/api/wallet/',
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'JWT ${this.tokenData.access}'
      },
      body: jsonEncode(body),
    );

    this.lastResponse = response;

    if (response.statusCode == 201) {
      return Wallet.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Błąd przy tworzeniu portfela.\n\n${response.body}');
    }
  }

  Future<Wallet> fetchWallet() async {
    final http.Response response = await http.get(
      '${this.serverAddress}:${this.serverPort}/api/wallet/',
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'JWT ${this.tokenData.access}'
      },
    );

    this.lastResponse = response;

    if (response.statusCode == 200) {
      return Wallet.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Błąd przy pobieraniu portfela.\n\n${response.body}');
    }
  }

  Future<BtcExchange> fetchBtcExchangePrice(String currency) async {
    final http.Response response = await http.get(
      'https://api.blockchain.com/v3/exchange/tickers/BTC-' + currency,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8'
      },
    );

    this.lastResponse = response;

    if (response.statusCode == 200) {
      return BtcExchange.fromJson(json.decode(response.body));
    } else {
      throw Exception('Błąd przy pobieraniu danych walut.\n\n${response.body}');
    }
  }

  // BankDeposit REQUESTS:
  Future<BankDeposit> createBankDeposit(String currency) async {
    final http.Response response = await http.post(
      '${this.serverAddress}:${this.serverPort}/api/deposit/',
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'JWT ${this.tokenData.access}'
      },
      body: jsonEncode(<String, String>{
        'currency': currency,
      }),
    );

    this.lastResponse = response;

    if (response.statusCode == 201) {
      return BankDeposit.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Błąd przy tworzeniu rachunku.\n\n${response.body}');
    }
  }

  Future<List<BankDeposit>> fetchBankDeposits() async {
    final http.Response response = await http.get(
      '${this.serverAddress}:${this.serverPort}/api/deposit/',
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'JWT ${this.tokenData.access}'
      },
    );

    this.lastResponse = response;

    if (response.statusCode == 200 || response.statusCode == 204) {
      return List<BankDeposit>.from(json
          .decode(response.body)
          .map((model) => BankDeposit.fromJson(model)));
    } else {
      throw Exception('Błąd przy pobieraniu rachunków.\n\n${response.body}');
    }
  }

}
