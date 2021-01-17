import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

// Model ALL dataclasses like this one, so they can easily be deserialized from http responses
class SubAccount {
    SubAccount({
        this.owner,
        this.balance,
        this.currency,
        this.subAddress,
    });

    String owner;
    String balance;
    String currency;
    String subAddress;

    factory SubAccount.fromRawJson(String str) => SubAccount.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory SubAccount.fromJson(Map<String, dynamic> json) => SubAccount(
        owner: json["owner"],
        balance: json["balance"],
        currency: json["currency"],
        subAddress: json["sub_address"],
    );

    Map<String, dynamic> toJson() => {
        "owner": owner,
        "balance": balance,
        "currency": currency,
        "sub_address": subAddress,
    };
}


class UserProfile {
    UserProfile({
        this.username,
        this.email,
        this.firstName,
        this.lastName,
        this.privateKey,
        this.walletAddress,
    });

    String username;
    String email;
    String firstName;
    String lastName;
    String privateKey;
    String walletAddress;

    factory UserProfile.fromRawJson(String str) => UserProfile.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory UserProfile.fromJson(Map<String, dynamic> json) => UserProfile(
        username: json["username"] == null ? null : json["username"],
        email: json["email"] == null ? null : json["email"],
        firstName: json["first_name"] == null ? null : json["first_name"],
        lastName: json["last_name"] == null ? null : json["last_name"],
        privateKey: json["private_key"] == null ? null : json["private_key"],
        walletAddress: json["wallet_address"] == null ? null : json["wallet_address"],
    );

    Map<String, dynamic> toJson() => {
        "username": username == null ? null : username,
        "email": email == null ? null : email,
        "first_name": firstName == null ? null : firstName,
        "last_name": lastName == null ? null : lastName,
        "private_key": privateKey == null ? null : privateKey,
        "wallet_address": walletAddress == null ? null : walletAddress,
    };
}


class BankDeposit {
    BankDeposit({
        this.account,
        this.interestRate,
        this.startDate,
        this.depositPeriod,
        this.capitalizationPeriod,
        this.lastCapitalization,
        this.title,
    });

    int account;
    String interestRate;
    DateTime startDate;
    String depositPeriod;
    String capitalizationPeriod;
    DateTime lastCapitalization;
    String title;

    factory BankDeposit.fromRawJson(String str) => BankDeposit.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory BankDeposit.fromJson(Map<String, dynamic> json) => BankDeposit(
        account: json["account"] == null ? null : json["account"],
        interestRate: json["interest_rate"] == null ? null : json["interest_rate"],
        startDate: json["start_date"] == null ? null : DateTime.parse(json["start_date"]),
        depositPeriod: json["deposit_period"] == null ? null : json["deposit_period"],
        capitalizationPeriod: json["capitalization_period"] == null ? null : json["capitalization_period"],
        lastCapitalization: json["last_capitalization"] == null ? null : DateTime.parse(json["last_capitalization"]),
        title: json["title"] == null ? null : json["title"],
    );

    Map<String, dynamic> toJson() => {
        "account": account == null ? null : account,
        "interest_rate": interestRate == null ? null : interestRate,
        "start_date": startDate == null ? null : startDate.toIso8601String(),
        "deposit_period": depositPeriod == null ? null : depositPeriod,
        "capitalization_period": capitalizationPeriod == null ? null : capitalizationPeriod,
        "last_capitalization": lastCapitalization == null ? null : lastCapitalization.toIso8601String(),
        "title": title == null ? null : title,
    };
}


class Transaction {
    Transaction({
        this.source,
        this.target,
        this.amount,
        this.currency,
        this.sendTime,
        this.confirmationTime,
        this.title,
        this.fee,
        this.transactionHash,
    });

    int source;
    int target;
    String amount;
    String currency;
    DateTime sendTime;
    DateTime confirmationTime;
    String title;
    double fee;
    String transactionHash;

    factory Transaction.fromRawJson(String str) => Transaction.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory Transaction.fromJson(Map<String, dynamic> json) => Transaction(
        source: json["source"] == null ? null : json["source"],
        target: json["target"] == null ? null : json["target"],
        amount: json["amount"] == null ? null : json["amount"],
        currency: json["currency"] == null ? null : json["currency"],
        sendTime: json["send_time"] == null ? null : DateTime.parse(json["send_time"]),
        confirmationTime: json["confirmation_time"] == null ? null : DateTime.parse(json["confirmation_time"]),
        title: json["title"] == null ? null : json["title"],
        fee: json["fee"] == null ? null : json["fee"],
        transactionHash: json["transaction_hash"] == null ? null : json["transaction_hash"],
    );

    Map<String, dynamic> toJson() => {
        "source": source == null ? null : source,
        "target": target == null ? null : target,
        "amount": amount == null ? null : amount,
        "currency": currency == null ? null : currency,
        "send_time": sendTime == null ? null : sendTime.toIso8601String(),
        "confirmation_time": confirmationTime == null ? null : confirmationTime.toIso8601String(),
        "title": title == null ? null : title,
        "fee": fee == null ? null : fee,
        "transaction_hash": transactionHash == null ? null : transactionHash,
    };
}

class LoginRecord {
    LoginRecord({
        this.user,
        this.action,
        this.date,
        this.ipAddress,
    });

    String user;
    String action;
    DateTime date;
    String ipAddress;

    factory LoginRecord.fromRawJson(String str) => LoginRecord.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory LoginRecord.fromJson(Map<String, dynamic> json) => LoginRecord(
        user: json["user"] == null ? null : json["user"],
        action: json["action"] == null ? null : json["action"],
        date: json["date"] == null ? null : DateTime.parse(json["date"]),
        ipAddress: json["ip_address"] == null ? null : json["ip_address"],
    );

    Map<String, dynamic> toJson() => {
        "user": user == null ? null : user,
        "action": action == null ? null : action,
        "date": date == null ? null : date.toIso8601String(),
        "ip_address": ipAddress == null ? null : ipAddress,
    };
}


class TokenData {
    TokenData({
        this.refresh,
        this.access,
    });

    String refresh;
    String access;

    factory TokenData.fromRawJson(String str) => TokenData.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory TokenData.fromJson(Map<String, dynamic> json) => TokenData(
        refresh: json["refresh"] == null ? null : json["refresh"],
        access: json["access"] == null ? null : json["access"],
    );

    Map<String, dynamic> toJson() => {
        "refresh": refresh == null ? null : refresh,
        "access": access == null ? null : access,
    };
}


class Wallet {
    Wallet({
        this.walletAddress,
    });

    String walletAddress;

    factory Wallet.fromRawJson(String str) => Wallet.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory Wallet.fromJson(Map<String, dynamic> json) => Wallet(
        walletAddress: json["wallet_address"] == null ? null : json["wallet_address"],
    );

    Map<String, dynamic> toJson() => {
        "wallet_address": walletAddress == null ? null : walletAddress,
    };
}

// To parse this JSON data, do
//
//     final btcExchange = btcExchangeFromJson(jsonString);

import 'dart:convert';

class BtcExchange {
    BtcExchange({
        this.symbol,
        this.price24H,
        this.volume24H,
        this.lastTradePrice,
    });

    String symbol;
    double price24H;
    double volume24H;
    double lastTradePrice;

    BtcExchange copyWith({
        String symbol,
        double price24H,
        double volume24H,
        double lastTradePrice,
    }) => 
        BtcExchange(
            symbol: symbol ?? this.symbol,
            price24H: price24H ?? this.price24H,
            volume24H: volume24H ?? this.volume24H,
            lastTradePrice: lastTradePrice ?? this.lastTradePrice,
        );

    factory BtcExchange.fromRawJson(String str) => BtcExchange.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory BtcExchange.fromJson(Map<String, dynamic> json) => BtcExchange(
        symbol: json["symbol"] == null ? null : json["symbol"],
        price24H: json["price_24h"] == null ? null : json["price_24h"].toDouble(),
        volume24H: json["volume_24h"] == null ? null : json["volume_24h"].toDouble(),
        lastTradePrice: json["last_trade_price"] == null ? null : json["last_trade_price"].toDouble(),
    );

    Map<String, dynamic> toJson() => {
        "symbol": symbol == null ? null : symbol,
        "price_24h": price24H == null ? null : price24H,
        "volume_24h": volume24H == null ? null : volume24H,
        "last_trade_price": lastTradePrice == null ? null : lastTradePrice,
    };
}
