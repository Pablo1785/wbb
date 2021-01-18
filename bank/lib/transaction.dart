import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:email_validator/email_validator.dart';
import 'main.dart';
import 'logged_in.dart';
import 'globals.dart';

void main() => runApp(TransactionApp());

class TransactionApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Wirtualny Bank Bitcoinów',
      theme: ThemeData(
        visualDensity: VisualDensity.adaptivePlatformDensity,
        brightness: light_theme ? Brightness.light : Brightness.dark,
      ),
      routes: {
        '/': (context) => SettingsPage(),
        '/main': (context) => HomeApp(),
        '/settings': (context) => TransactionApp(),
        '/loggedin': (context) => LoggedInApp(),
      },
    );
  }
}

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;

    return Scaffold(
        //extendBodyBehindAppBar: true,
        appBar: PreferredSize(
          preferredSize: Size(screenSize.width, 1000),
          child: Menu(),
        ),
        body: FormSettings());
  }
}

class Transaction {
  static const String target = 'email';
  static const String Password = 'password';
  static const String Light_theme = 'theme';
  static const String Notif_incoming = 'notif_incoming';
  static const String Notif_login = 'notif_login';
  static const String Notif_transfer = 'notif_transfer';
  static const String Notif_summary = 'notif_summary';

  Map data = {};

  User() {
    read();
  }

  // read data from backend and fill the map
  read() {
    print('reading user preferences from backend');
  }

  // send data to backend
  send() {
    print('sending modified user to backend');
  }
}

class FormSettings extends StatefulWidget {
  @override
  _FormSettingsState createState() => _FormSettingsState();
}

class _FormSettingsState extends State<FormSettings> {
  final _formKey = GlobalKey<FormState>();
  final _transaction = Transaction;

  final _targetController = TextEditingController();
  final _titleController = TextEditingController();
  final _amount = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Form(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('Daj nam pieniądze',
              style: Theme.of(context).textTheme.headline4),
          Padding(
            padding: EdgeInsets.all(8.0),
            child: TextFormField(
              controller: _targetController,
              decoration: InputDecoration(hintText: 'Adres docelowy'),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(8.0),
            child: TextFormField(
              controller: _titleController,
              decoration: InputDecoration(hintText: 'Tytuł przelewu'),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(8.0),
            child: TextFormField(
              controller: _amount,
              decoration: InputDecoration(hintText: 'Kwota'),
            ),
          ),
          TextButton(
            style: ButtonStyle(
              foregroundColor:
                  MaterialStateColor.resolveWith((Set<MaterialState> states) {
                return states.contains(MaterialState.disabled)
                    ? null
                    : Colors.white;
              }),
              backgroundColor:
                  MaterialStateColor.resolveWith((Set<MaterialState> states) {
                return states.contains(MaterialState.disabled)
                    ? null
                    : Colors.blue;
              }),
            ),
            onPressed: () {
              showPopup(context);
            },
            child: Text('Wyślij'),
          )
        ],
      ),
    );
  }
}

void showPopup(BuildContext context) {
  showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Stack(
            overflow: Overflow.visible,
            children: <Widget>[
              Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text('Czy na pewno chcesz wysłać przelew?',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold)),
                  ),
                  Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            RaisedButton(
                              child: Text("Potwierdź"),
                              color: Colors.red,
                              onPressed: () {
                                Navigator.of(context).pop();
                                showPopup3(context);
                              },
                            ),
                            RaisedButton(
                              child: Text("Anuluj"),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            ),
                          ]))
                ],
              ),
            ],
          ),
        );
      });
}

void showPopup3(BuildContext context) {
  showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Stack(
            overflow: Overflow.visible,
            children: <Widget>[
              Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text('Wysłano',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold)),
                  ),
                  Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            TextButton(
                              child: Text("Zamknij"),
                              onPressed: () {
                                Navigator.of(context).pushNamed('/loggedin');
                              },
                            ),
                          ]))
                ],
              ),
            ],
          ),
        );
      });
}
