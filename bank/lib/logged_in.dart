import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'contact.dart';
import 'main.dart';

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
        '/contact': (context) => ContactApp(),
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
          child: Container(
            color: Colors.blue,
            child: Padding(
              padding: EdgeInsets.all(20),
              child: Row(
                children: [
                  Text('Wirtualny Bank Bitcoinów',
                      style: GoogleFonts.montserrat(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                          color: Colors.white)),
                  //SizedBox(width: screenSize.width / 50),
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        InkWell(
                          onTap: () {},
                          child: Text('Przelew',
                              style: GoogleFonts.montserrat(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white)),
                        ),
                        SizedBox(width: screenSize.width / 20),
                        InkWell(
                          onTap: () {},
                          child: Text('Lokata',
                              style: GoogleFonts.montserrat(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white)),
                        ),
                        SizedBox(width: screenSize.width / 20),
                        InkWell(
                          onTap: () {},
                          child: Text('Rachunki',
                              style: GoogleFonts.montserrat(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white)),
                        ),
                        SizedBox(width: screenSize.width / 20),
                        InkWell(
                          onTap: () {},
                          child: Text('Odbiorcy',
                              style: GoogleFonts.montserrat(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white)),
                        ),
                        SizedBox(width: screenSize.width / 20),
                        InkWell(
                          onTap: () {},
                          child: Text('Historia',
                              style: GoogleFonts.montserrat(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white)),
                        ),
                        SizedBox(width: screenSize.width / 20),
                        InkWell(
                          onTap: () {
                            Navigator.of(context).pushNamed('/contact');
                          },
                          child: Text('Kontakt',
                              style: GoogleFonts.montserrat(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white)),
                        ),
                        SizedBox(width: screenSize.width / 20),
                      ],
                    ),
                  ),
                  InkWell(
                    onTap: () {},
                    child: Text('Ustawienia',
                        style: GoogleFonts.montserrat(
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                            color: Colors.white)),
                  ),
                  SizedBox(
                    width: screenSize.width / 50,
                  ),
                  InkWell(
                    onTap: () {
                      http.post('http://localhost:8000/auth/token/logout',
                          headers: <String, String>{
                            'Authorization': 'Token ${auth_token}',
                          });
                      Navigator.of(context).pushNamed('/main');
                    },
                    child: Text('Wyloguj',
                        style: GoogleFonts.montserrat(
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                            color: Colors.white)),
                  ),
                ],
              ),
            ),
          ),
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
