import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'contact.dart';
import 'main.dart';
import 'settings.dart';
import 'transfer.dart';
import 'deposit.dart';
import 'history.dart';
import 'subaccounts.dart';
import 'receivers.dart';
import 'security_events.dart';
import 'models.dart';
import 'globals.dart';

void main() => runApp(LoggedInApp());

class LoggedInApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      title: 'Wirtualny Bank Bitcoinów',
      theme: ThemeData(
        visualDensity: VisualDensity.adaptivePlatformDensity,
		brightness: light_theme ? Brightness.light : Brightness.dark,
      ),
      routes: {
        '/': (context) => LoggedInPage(),
		'/main': (context) => MainApp(),
        '/contact': (context) => ContactApp(),
		'/settings': (context) => SettingsApp(),
		'/loggedin': (context) => LoggedInApp(),
		'/transfer': (context) => TransferApp(),
		'/deposit': (context) => DepositApp(),
		'/history': (context) => HistoryApp(),
		'/subaccounts': (context) => SubaccountsApp(),
		'/receivers': (context) => ReceiversApp(),
		'/securityevents': (context) => SecurityEventsApp(),
      },
    );
  }
}

class LoggedInPage extends StatefulWidget {
  @override
  _LoggedInPageState createState() => _LoggedInPageState();
}

class DataTables
{
	List<SubAccount> subAccounts;
	List<BankDeposit> deposits;
	List<Transaction> transactions;
	List<LoginRecord> loginRecords;
  bool noLogins = true;
	Map sums = {"subaccounts": 0, 'transactions': 0, 'deposits': 0};
	Wallet wallet;
}

Future<DataTables> getDataTables() async {
	DataTables d = new DataTables();
	

	d.subAccounts = await requestor.fetchSubaccounts();
	d.subAccounts = d.subAccounts.length < 5 ? d.subAccounts.take(5).toList() : d.subAccounts;
	for(final subaccount in d.subAccounts)
		d.sums["subaccounts"] += double.parse(subaccount.balance);

	d.transactions = await requestor.fetchTransactions();
	d.transactions = d.transactions.length < 5 ? d.transactions.take(5).toList() : d.transactions;
	for(final transaction in d.transactions)
	{
		transaction.amount = d.subAccounts.any((subaccount) => subaccount.subAddress == transaction.target) ? '${transaction.amount}' : '-${transaction.amount}';
		d.sums["transactions"] += double.parse(transaction.amount);
	}

	d.deposits = await requestor.fetchDeposits();
	d.deposits = d.deposits.length < 5 ? d.deposits.take(5).toList() : d.deposits;
	//for(final deposit in d.deposits)
	//{
		//d.sums["deposits"] += double.parse(d.subAccounts.where((subaccount) => subaccount.subAddress == deposit.account.toString()).toList()[0].balance);			
	//}

	d.wallet = await requestor.fetchWallet();

  // Get last login:
  d.loginRecords = await requestor.fetchLoginRecords();


	//d.loginRecords = await requestor.fetchLoginRecords();
	return d;
}

class _LoggedInPageState extends State<LoggedInPage> {
  
  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
	var futureDataTables = getDataTables();

    return Scaffold(
        //extendBodyBehindAppBar: true,
        appBar: PreferredSize(
          preferredSize: Size(screenSize.width, 1000),
          child: Menu(),
        ),
        body: Center(
          child: 
		  
		  
		  FutureBuilder<DataTables>(
		  future: futureDataTables,
		  builder: (context, snapshot) {
			if (snapshot.hasData) {					
			  return 		  Container(
            //color: Colors.white,
            //height: 520,
            margin: const EdgeInsets.only(top: 50.0),
            child: Column(children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Column(children: [
                    Text(
                      'Konta',
                      textAlign: TextAlign.left,
                      style: GoogleFonts.montserrat(
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      '${snapshot.data.sums["subaccounts"]} BTC',
                      textAlign: TextAlign.left,
                      style: GoogleFonts.montserrat(
                        fontSize: 30,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Container(width: screenSize.width/4, child: SingleChildScrollView(scrollDirection: Axis.horizontal, child: DataTable(
                      columns: <DataColumn>[
                        DataColumn(
                          label: Text('Adres'),
                        ),
                        DataColumn(
                          label: Text('Saldo'),
                        ),
                        DataColumn(
                          label: Text('Waluta'),
                        ),
                      ],
                      rows: snapshot.data.subAccounts.map((subAccount) => DataRow(
						cells: [
						  DataCell(
							Text(subAccount.subAddress),
						  ),
						  DataCell(
							Text(subAccount.balance),
						  ),
						  DataCell(
							Text("BTC"),
						  ),
						]),
						).toList(),
                    ))),
                    SizedBox(
                        width: 285,
                        child: OutlinedButton(
                          onPressed: () {Navigator.of(context).pushNamed('/subaccounts');},
                          child: Text('Zobacz więcej',
                              style: TextStyle(color: Colors.black)),
                        ))
                  ]),
                  SizedBox(
                    width: screenSize.width / 20,
                  ),
                  Column(children: [
                    Text(
                      'Ostatnie operacje',
                      textAlign: TextAlign.left,
                      style: GoogleFonts.montserrat(
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      '${snapshot.data.sums["transactions"]} BTC',
                      textAlign: TextAlign.left,
                      style: GoogleFonts.montserrat(
                        fontSize: 30,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Container(width: screenSize.width/4, child: SingleChildScrollView(scrollDirection: Axis.horizontal, child: DataTable(
                      columns: <DataColumn>[
                        DataColumn(
                          label: Text('Nazwa'),
                        ),
                        DataColumn(
                          label: Text('Kwota'),
                        ),
                        DataColumn(
                          label: Text('Data wysłania'),
                        ),

                      ],
                      rows: snapshot.data.transactions.map((transfer) => DataRow(
						cells: [
						  DataCell(
							Text(transfer.title),
						  ),
						  DataCell(
							Text(transfer.amount),
						  ),
						  DataCell(
							Text(transfer.sendTime.toIso8601String()),
						  ),

						]),
						).toList(),
                    ))),
                    SizedBox(
                        width: 285,
                        child: OutlinedButton(
                          onPressed: () {Navigator.of(context).pushNamed('/history');},
                          child: Text('Zobacz więcej',
                              style: TextStyle(color: Colors.black)),
                        ))
                  ]),
                  SizedBox(
                    width: screenSize.width / 20,
                  ),
                  Column(children: [
                    Text(
                      'Lokaty',
                      textAlign: TextAlign.left,
                      style: GoogleFonts.montserrat(
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      //'${snapshot.data.sums["deposits"]} BTC',
					  '~ BTC',
                      textAlign: TextAlign.left,
                      style: GoogleFonts.montserrat(
                        fontSize: 30,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Container(width: screenSize.width/4, child: SingleChildScrollView(scrollDirection: Axis.horizontal, child: DataTable(
                      columns: <DataColumn>[
                        DataColumn(
                          label: Text('Nazwa'),
                        ),
                        DataColumn(
                          label: Text('Od'),
                        ),
                        DataColumn(
                          label: Text('Czas trwania'),
                        ),
                      ],
                      rows: snapshot.data.deposits.map((deposit) => DataRow(
						cells: [
						  DataCell(
							Text(deposit.title),
						  ),
						  DataCell(
							Text(deposit.startDate.toIso8601String()),
						  ),
						  DataCell(
							Text(deposit.depositPeriod),
						  ),

						]),
						).toList(),
                    ))),
                    SizedBox(
                        width: 285,
                        child: OutlinedButton(
                          onPressed: () {Navigator.of(context).pushNamed('/history');},
                          child: Text('Zobacz więcej',
                              style: TextStyle(color: Colors.black)),
                        ))
                  ]),
                ],
              ),
              Container(
                margin: const EdgeInsets.only(top: 50.0),
                child: Column(children: [
                  Text(
                    'Adres portfela',
                    textAlign: TextAlign.left,
                    style: GoogleFonts.montserrat(
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SelectableText(
                    snapshot.data.wallet.walletAddress,
                    textAlign: TextAlign.left,
                    style: GoogleFonts.montserrat(
                      fontSize: 30,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(
                    height: screenSize.height / 15,
                  ),
                  Text(
                    'Ostatnie logowanie',
                    textAlign: TextAlign.left,
                    style: GoogleFonts.montserrat(
                      fontSize: 30,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    snapshot.data.loginRecords is List<LoginRecord> && snapshot.data.loginRecords.length > 0 ? snapshot.data.loginRecords.last.date.toIso8601String() : "Witaj po raz pierwszy!", //endpoint moze zwrocic No previous logins to display
                    textAlign: TextAlign.left,
                    style: GoogleFonts.montserrat(
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ]),
              )
            ]),
          );
			} else if (snapshot.hasError) {
			  return Text("Nie udało się pobrać danych", style: Theme.of(context).textTheme.headline2);
			}

			return CircularProgressIndicator();
		  },
		),
		  
		  

        ));
  }
}
