import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'main.dart';
import 'globals.dart';

void main() => runApp(LoggedInApp());

String auth_token;

class LoggedInApp extends StatelessWidget {
  
  @override
  Widget build(BuildContext context) {
	  auth_token = ModalRoute.of(context).settings.arguments;
	  
    return MaterialApp(
      title: 'Wirtualny Bank Bitcoinów',
      theme: ThemeData(
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
	  routes: {
        '/': (context) => HomePage(),
        '/main': (context) => HomeApp(),
      },
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;

    return Scaffold(
        //extendBodyBehindAppBar: true,
        appBar: PreferredSize(
          preferredSize: Size(screenSize.width, 1000),
          child: Menu(auth_token: auth_token),
        ),
        body: Center(
          child: Container(
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
                      '17.41 BTC',
                      textAlign: TextAlign.left,
                      style: GoogleFonts.montserrat(
                        fontSize: 30,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    DataTable(
                      columns: <DataColumn>[
                        DataColumn(
                          label: Text('Nazwa'),
                        ),
                        DataColumn(
                          label: Text('Numer'),
                        ),
                        DataColumn(
                          label: Text('Saldo'),
                        ),
                      ],
                      rows: <DataRow>[
                        DataRow(
                          cells: <DataCell>[
                            DataCell(Text('Data')),
                            DataCell(Text('Data')),
                            DataCell(Text('Data')),
                          ],
                        ),
                        DataRow(
                          cells: <DataCell>[
                            DataCell(Text('Data')),
                            DataCell(Text('Data')),
                            DataCell(Text('Data')),
                          ],
                        ),
                        DataRow(
                          cells: <DataCell>[
                            DataCell(Text('Data')),
                            DataCell(Text('Data')),
                            DataCell(Text('Data')),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(
                        width: 285,
                        child: OutlinedButton(
                          onPressed: () {},
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
                      '18.26 BTC',
                      textAlign: TextAlign.left,
                      style: GoogleFonts.montserrat(
                        fontSize: 30,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    DataTable(
                      columns: <DataColumn>[
                        DataColumn(
                          label: Text('Nazwa'),
                        ),
                        DataColumn(
                          label: Text('Data'),
                        ),
                        DataColumn(
                          label: Text('Kwota'),
                        ),
                      ],
                      rows: <DataRow>[
                        DataRow(
                          cells: <DataCell>[
                            DataCell(Text('Data')),
                            DataCell(Text('Data')),
                            DataCell(Text('Data')),
                          ],
                        ),
                        DataRow(
                          cells: <DataCell>[
                            DataCell(Text('Data')),
                            DataCell(Text('Data')),
                            DataCell(Text('Data')),
                          ],
                        ),
                        DataRow(
                          cells: <DataCell>[
                            DataCell(Text('Data')),
                            DataCell(Text('Data')),
                            DataCell(Text('Data')),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(
                        width: 285,
                        child: OutlinedButton(
                          onPressed: () {},
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
                      '16.03 BTC',
                      textAlign: TextAlign.left,
                      style: GoogleFonts.montserrat(
                        fontSize: 30,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    DataTable(
                      columns: <DataColumn>[
                        DataColumn(
                          label: Text('Nazwa'),
                        ),
                        DataColumn(
                          label: Text('Do końca'),
                        ),
                        DataColumn(
                          label: Text('Kwota'),
                        ),
                      ],
                      rows: <DataRow>[
                        DataRow(
                          cells: <DataCell>[
                            DataCell(Text('Data')),
                            DataCell(Text('Data')),
                            DataCell(Text('Data')),
                          ],
                        ),
                        DataRow(
                          cells: <DataCell>[
                            DataCell(Text('Data')),
                            DataCell(Text('Data')),
                            DataCell(Text('Data')),
                          ],
                        ),
                        DataRow(
                          cells: <DataCell>[
                            DataCell(Text('Data')),
                            DataCell(Text('Data')),
                            DataCell(Text('Data')),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(
                        width: 285,
                        child: OutlinedButton(
                          onPressed: () {},
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
                    //'1F1tAaz5x1HUXrCNLbtMDqcw6o5GNn4xqX',
					auth_token,
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
                    '10.12.2020 19:17',
                    textAlign: TextAlign.left,
                    style: GoogleFonts.montserrat(
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ]),
              )
            ]),
          ),
        ));
  }
}
