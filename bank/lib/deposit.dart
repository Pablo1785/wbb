import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:email_validator/email_validator.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'main.dart';
import 'logged_in.dart';
import 'settings.dart';
import 'transfer.dart';
import 'history.dart';
import 'contact.dart';
import 'globals.dart';

void main() => runApp(DepositApp());

class DepositApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Wirtualny Bank Bitcoinów',
      theme: ThemeData(
        visualDensity: VisualDensity.adaptivePlatformDensity,
        brightness: light_theme ? Brightness.light : Brightness.dark,
      ),
      routes: {
        '/': (context) => DepositPage(),
        '/main': (context) => MainApp(),
        '/settings': (context) => SettingsApp(),
        '/loggedin': (context) => LoggedInApp(),
        '/transfer': (context) => TransferApp(),
        '/deposit': (context) => DepositApp(),
		'/history': (context) => HistoryApp(),
        '/contact': (context) => ContactApp(),
      },
      localizationsDelegates: [GlobalMaterialLocalizations.delegate],
      supportedLocales: [
        const Locale('pl'),
      ],
    );
  }
}

class DepositPage extends StatefulWidget {
  @override
  _DepositPageState createState() => _DepositPageState();
}

class _DepositPageState extends State<DepositPage> {
  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;

    return Scaffold(
        //extendBodyBehindAppBar: true,
        appBar: PreferredSize(
          preferredSize: Size(screenSize.width, 1000),
          child: Menu(),
        ),
        body: FormDeposit());
  }
}

class Deposit {
  static const String Amount = 'amount';
  static const String Title = 'title';
  static const String Account = 'account';
  static const String TimeStamp = 'start_date';
  static const String Id = 'id';

  var account_names = ["Główne", "Dodatkowe", "Dodatkowe2"];
  int choice = 1;

  var data = new Map();

  Map D1 = {
    "interest_rate": '3,2%',
    "deposit_period": '3 dni',
    "capitalization_period": '1 dzień',
  };

  Map D2 = {
    "interest_rate": '3,8%',
    "deposit_period": '6 dni',
    "capitalization_period": '1 dzień',
  };

  Map D3 = {
    "interest_rate": '4,2%',
    "deposit_period": '14 dni',
    "capitalization_period": '1 dzień',
  };

  var deposit_options = new List();

  Deposit() {
    read();
  }

  // read data from backend and fill the map
  read() {
    print('reading available deposit options from backend');
    deposit_options.add(D1);
    deposit_options.add(D2);
    deposit_options.add(D3);

    for (var i = 0; i < deposit_options.length; i++) {
      print(deposit_options[i]);
    }
  }

  // send data to backend
  send() {
    print('sending deposit data to backend');
    data.forEach((k, v) => print('${k}: ${v}'));
  }
}

class FormDeposit extends StatefulWidget {
  @override
  _FormDepositState createState() => _FormDepositState();
}

class _FormDepositState extends State<FormDeposit> {
  final _formKey = GlobalKey<FormState>();
  final _deposit = Deposit();
  var txtDate = TextEditingController();
  var txtTime = TextEditingController();
  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedTime = TimeOfDay.now();

  @override
  Widget build(BuildContext context) {
    return Scrollbar(
        child: SingleChildScrollView(
      child: Card(
        elevation: 2,
        margin: EdgeInsets.fromLTRB(64, 50, 64, 64),
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Container(
              padding:
                  const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
              child: Builder(
                  builder: (context) => Form(
                      key: _formKey,
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Container(
                              padding: const EdgeInsets.fromLTRB(0, 50, 0, 20),
                              child: Text(
                                'Typ lokaty',
                                style: TextStyle(
                                  fontSize: 24,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'HelveticaNeue',
                                ),
                              ),
                            ),
                            DepositButtons(deposit: _deposit),
                            Container(
                              padding: const EdgeInsets.fromLTRB(0, 50, 0, 20),
                              child: Text(
                                'Parametry',
                                style: TextStyle(
                                  fontSize: 24,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'HelveticaNeue',
                                ),
                              ),
                            ),
                            TextFormField(
                              decoration: InputDecoration(
                                labelText: 'Nazwa',
                                hintText: 'wpisz nazwę lokaty',
                                floatingLabelBehavior:
                                    FloatingLabelBehavior.always,
                                labelStyle: TextStyle(
                                  fontSize: 24,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'HelveticaNeue',
                                ),
                              ),
                              validator: (value) {
                                if (value.isEmpty) {
                                  return 'Proszę wprowadzić poprawną nazwę.';
                                }
                              },
                              onSaved: (val) => setState(
                                  () => _deposit.data[Deposit.Title] = val),
                            ),
                            TextFormField(
                              decoration: InputDecoration(
                                labelText: 'Kwota',
                                hintText: 'wpisz kwotę',
                                floatingLabelBehavior:
                                    FloatingLabelBehavior.always,
                                labelStyle: TextStyle(
                                  fontSize: 24,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'HelveticaNeue',
                                ),
                              ),
                              validator: (value) {
                                if (value.isEmpty) {
                                  return 'Proszę wprowadzić poprawną kwotę.';
                                }
                              },
                              onSaved: (val) => setState(
                                  () => _deposit.data[Deposit.Amount] = val),
                            ),
                            DropDownList(deposit: _deposit),
                            Container(
                              padding: const EdgeInsets.fromLTRB(0, 50, 0, 20),
                              child: Text(
                                'Czas rozpoczęcia lokaty',
                                style: TextStyle(
                                  fontSize: 24,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'HelveticaNeue',
                                ),
                              ),
                            ),
                            TextFormField(
                              decoration: InputDecoration(
                                labelText: 'Data',
                                hintText: 'wybierz datę operacji',
                                floatingLabelBehavior:
                                    FloatingLabelBehavior.always,
                                labelStyle: TextStyle(
                                  fontSize: 24,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'HelveticaNeue',
                                ),
                                suffixIcon: IconButton(
                                  onPressed: () => _selectDate(context),
                                  icon: Icon(Icons.date_range),
                                ),
                              ),
                              controller: txtDate,
                              readOnly: true,
                              validator: (value) {
                                if (value.isEmpty) {
                                  return 'Proszę wybrać poprawną datę.';
                                }
                              },
                              onSaved: (val) => setState(() =>
                                  _deposit.data[Deposit.TimeStamp] =
                                      txtDate.text + " " + txtTime.text),
                            ),
                            TextFormField(
                              decoration: InputDecoration(
                                labelText: 'Godzina',
                                hintText: 'wybierz godzinę operacji',
                                floatingLabelBehavior:
                                    FloatingLabelBehavior.always,
                                labelStyle: TextStyle(
                                  fontSize: 24,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'HelveticaNeue',
                                ),
                                suffixIcon: IconButton(
                                  onPressed: () => _selectTime(context),
                                  icon: Icon(Icons.access_time),
                                ),
                              ),
                              controller: txtTime,
                              readOnly: true,
                              validator: (value) {
                                if (value.isEmpty) {
                                  return 'Proszę wybrać poprawną godzinę.';
                                }
                              },
                              onSaved: (val) => setState(() =>
                                  _deposit.data[Deposit.TimeStamp] =
                                      txtDate.text + " " + txtTime.text),
                            ),
                            SizedBox(
                              height: 50,
                            ),
                            Container(
                                height: 80,
                                // margin: EdgeInsets.only(left: 200, right: 200),
                                padding: const EdgeInsets.symmetric(
                                    vertical: 16.0, horizontal: 16.0),
                                child: RaisedButton(
                                    color: Colors.blue,
                                    onPressed: () {
                                      if (_formKey.currentState.validate()) {
                                        _formKey.currentState.save();
                                        showPopup(context);
                                      }
                                    },
                                    child: Text(
                                      'Wyślij',
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontFamily: 'HelveticaNeue',
                                      ),
                                    ))),
                            Container(
                                height: 80,
                                // margin: EdgeInsets.only(left: 200, right: 200),
                                padding: const EdgeInsets.symmetric(
                                    vertical: 16.0, horizontal: 16.0),
                                child: RaisedButton(
                                    color: Colors.red,
                                    onPressed: () {
                                      Navigator.of(context)
                                          .pushNamed('/loggedin');
                                    },
                                    child: Text(
                                      'Anuluj',
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontFamily: 'HelveticaNeue',
                                      ),
                                    ))),
                          ])))),
        ),
      ),
    ));
  }

  _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(Duration(days: 10)),
      locale: const Locale("pl", "PL"),
    );
    if (picked != null) {
      selectedDate = picked;
      txtDate.text =
          "${selectedDate.year.toString()}-${selectedDate.month.toString().padLeft(2, '0')}-${selectedDate.day.toString().padLeft(2, '0')}";
    }
  }

  _selectTime(BuildContext context) async {
    final TimeOfDay picked = await showTimePicker(
      context: context,
      initialTime: selectedTime,
    );
    if (picked != null) {
      selectedTime = picked;
      txtTime.text = selectedTime.format(context);
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
                      child: Text('Czy na pewno chcesz utworzyć lokatę?',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold)),
                    ),
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                          'Jeżeli wybrano termin w przyszłości, pamiętaj aby zapewnić wystarczające środki.',
                          style: TextStyle(fontSize: 14)),
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
                                  _deposit.data[Deposit.Id] = _deposit.choice;
                                  _deposit.send();
                                  showPopup2(context);
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

  void showPopup2(BuildContext context) {
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
                      child: Text('Rezultat',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold)),
                    ),
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: SelectableText('Miejsce na rezultat',
                          style: TextStyle(fontSize: 14)),
                    ),
                    Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              RaisedButton(
                                child: Text("Zamknij okno"),
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
}

class DropDownList extends StatefulWidget {
  DropDownList({
    this.deposit,
  });

  final Deposit deposit;

  @override
  _DropDownListState createState() => _DropDownListState(deposit: deposit);
}

class _DropDownListState extends State<DropDownList> {
  String dropdownValue;

  _DropDownListState({
    this.deposit,
  });

  final Deposit deposit;

  @override
  Widget build(BuildContext context) {
    dropdownValue = deposit.account_names[0];

    return DropdownButtonFormField<String>(
      decoration: InputDecoration(
        labelText: 'Z Konta',
        floatingLabelBehavior: FloatingLabelBehavior.always,
        labelStyle: TextStyle(
          fontSize: 24,
          color: Colors.black,
          fontWeight: FontWeight.bold,
          fontFamily: 'HelveticaNeue',
        ),
      ),
      validator: (value) {
        if (value.isEmpty) {
          return 'Proszę wybrać poprawne konto.';
        }
      },
      onSaved: (val) => setState(() => deposit.data[Deposit.Account] = val),
      value: dropdownValue,
      icon: Icon(Icons.arrow_downward),
      iconSize: 24,
      onChanged: (String newValue) {
        setState(() {
          dropdownValue = newValue;
        });
      },
      items:
          deposit.account_names.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  }
}

class DepositButtons extends StatefulWidget {
  DepositButtons({Key key, this.deposit}) : super(key: key);

  final Deposit deposit;

  @override
  _DepositButtonsState createState() => _DepositButtonsState(deposit: deposit);
}

class _DepositButtonsState extends State<DepositButtons> {
  _DepositButtonsState({this.deposit});

  final Deposit deposit;

  @override
  Widget build(BuildContext context) {
    return Row(children: fillRow());
  }

  List<Widget> fillRow() {
    List<Widget> options = new List();

    for (var i = 0; i < deposit.deposit_options.length; i++) {
      options.add(Container(
          height: 80,
          // margin: EdgeInsets.only(left: 200, right: 200),
          padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
          child: RaisedButton(
              color: deposit.choice == i
                  ? Colors.blue
                  : Theme.of(context).buttonColor,
              onPressed: () {
                setState(() => deposit.choice = i);
              },
              child: Text(
                '${deposit.deposit_options[i]["interest_rate"]} (czas: ${deposit.deposit_options[i]["deposit_period"]}) (kapitalizacja: ${deposit.deposit_options[i]["capitalization_period"]})',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'HelveticaNeue',
                ),
              ))));
    }

    return options;
  }
}
