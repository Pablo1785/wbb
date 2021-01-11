import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:email_validator/email_validator.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'main.dart';
import 'contact.dart';
import 'logged_in.dart';
import 'settings.dart';
import 'deposit.dart';
import 'globals.dart';

void main() => runApp(TransferApp());

class TransferApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Wirtualny Bank Bitcoinów',
      theme: ThemeData(
        visualDensity: VisualDensity.adaptivePlatformDensity,
        brightness: light_theme ? Brightness.light : Brightness.dark,
      ),
      routes: {
        '/': (context) => TransferPage(),
        '/main': (context) => MainApp(),
        '/settings': (context) => SettingsApp(),
        '/loggedin': (context) => LoggedInApp(),
        '/transfer': (context) => TransferApp(),
		'/deposit': (context) => DepositApp(),
		'/contact': (context) => ContactApp(),
      },
      localizationsDelegates: [GlobalMaterialLocalizations.delegate],
      supportedLocales: [
        const Locale('pl'),
      ],
    );
  }
}

class TransferPage extends StatefulWidget {
  @override
  _TransferPageState createState() => _TransferPageState();
}

class _TransferPageState extends State<TransferPage> {
  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;

    return Scaffold(
        //extendBodyBehindAppBar: true,
        appBar: PreferredSize(
          preferredSize: Size(screenSize.width, 1000),
          child: Menu(),
        ),
        body: FormTransfer());
  }
}

class Transfer {
  static const String Amount = 'amount';
  static const String TargetAddress = 'targetAddress';
  static const String Title = 'title';
  static const String TimeStamp = 'timestamp';
  static const String Account = 'account';
  static const String Fee = 'fee';

  var account_names = ["Główne", "Dodatkowe", "Dodatkowe2"];
  double _currentSliderValue = 20;

  var data = new Map();

  // send data to backend
  send() {
    print('sending transfer data to backend');
    data.forEach((k, v) => print('${k}: ${v}'));
  }
}

class FormTransfer extends StatefulWidget {
  @override
  _FormTransferState createState() => _FormTransferState();
}

class _FormTransferState extends State<FormTransfer> {
  final _formKey = GlobalKey<FormState>();
  final _transfer = Transfer();
  bool type_btc = true;
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
                                'Typ przelewu',
                                style: TextStyle(
                                  fontSize: 24,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'HelveticaNeue',
                                ),
                              ),
                            ),
                            Row(children: [
                              Container(
                                  height: 80,
                                  // margin: EdgeInsets.only(left: 200, right: 200),
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 16.0, horizontal: 16.0),
                                  child: RaisedButton(
                                      color: type_btc
                                          ? Colors.blue
                                          : Theme.of(context).buttonColor,
                                      onPressed: () {
                                        setState(() => type_btc = !type_btc);
                                      },
                                      child: Text(
                                        'Na adres BTC',
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
                                      color: type_btc
                                          ? Theme.of(context).buttonColor
                                          : Colors.blue,
                                      onPressed: () {
                                        setState(() => type_btc = !type_btc);
                                      },
                                      child: Text(
                                        'Na adres e-mail',
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontFamily: 'HelveticaNeue',
                                        ),
                                      ))),
                            ]),
                            Container(
                              padding: const EdgeInsets.fromLTRB(0, 50, 0, 20),
                              child: Text(
                                'Dane odbiorcy',
                                style: TextStyle(
                                  fontSize: 24,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'HelveticaNeue',
                                ),
                              ),
                            ),
                            (() {
                              if (type_btc) {
                                return TextFormField(
                                  decoration: InputDecoration(
                                    labelText: 'Adres BTC',
                                    hintText: 'wpisz adres BTC odbiorcy',
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
                                      return 'Proszę wprowadzić poprawny adres BTC.';
                                    }
                                  },
                                  onSaved: (val) => setState(() => _transfer
                                      .data[Transfer.TargetAddress] = val),
                                );
                              } else {
                                return TextFormField(
                                  decoration: InputDecoration(
                                    labelText: 'Adres e-mail',
                                    hintText: 'wpisz adres e-mail odbiorcy',
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
                                      return 'Proszę wprowadzić poprawny adres email.';
                                    }
                                  },
                                  onSaved: (val) => setState(() => _transfer
                                      .data[Transfer.TargetAddress] = val),
                                );
                              }
                            }()),
                            TextFormField(
                              decoration: InputDecoration(
                                labelText: 'Tytuł',
                                hintText:
                                    'wpisz tytuł (zostanie zignorowany przy przelewie zewnętrznym)',
                                floatingLabelBehavior:
                                    FloatingLabelBehavior.always,
                                labelStyle: TextStyle(
                                  fontSize: 24,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'HelveticaNeue',
                                ),
                              ),
                              validator: (value) {},
                              onSaved: (val) => setState(
                                  () => _transfer.data[Transfer.Title] = val),
                            ),
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
                                  () => _transfer.data[Transfer.Amount] = val),
                            ),
                            DropDownList(transfer: _transfer),
                            Container(
                              padding: const EdgeInsets.fromLTRB(0, 50, 0, 20),
                              child: Text(
                                'Czas przelewu',
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
                                  _transfer.data[Transfer.TimeStamp] =
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
                                  _transfer.data[Transfer.TimeStamp] =
                                      txtDate.text + " " + txtTime.text),
                            ),
                            Container(
                              padding: const EdgeInsets.fromLTRB(0, 50, 0, 20),
                              child: Text(
                                'Regulowanie fee',
                                style: TextStyle(
                                  fontSize: 24,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'HelveticaNeue',
                                ),
                              ),
                            ),
                            FeeSlider(transfer: _transfer),
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
                      child: Text('Czy na pewno chcesz wysłać przelew?',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold)),
                    ),
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                          'W zależności od ustawień może być konieczne potwierdzenie operacji na mailu',
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
                                  _transfer.data[Transfer.Fee] = _transfer
                                      ._currentSliderValue
                                      .toStringAsFixed(2);
                                  _transfer.send();
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
    this.transfer,
  });

  final Transfer transfer;

  @override
  _DropDownListState createState() => _DropDownListState(transfer: transfer);
}

class _DropDownListState extends State<DropDownList> {
  String dropdownValue;

  _DropDownListState({
    this.transfer,
  });

  final Transfer transfer;

  @override
  Widget build(BuildContext context) {
    dropdownValue = transfer.account_names[0];

    return DropdownButtonFormField<String>(
      decoration: InputDecoration(
        labelText: 'Konto',
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
      onSaved: (val) => setState(() => transfer.data[Transfer.Account] = val),
      value: dropdownValue,
      icon: Icon(Icons.arrow_downward),
      iconSize: 24,
      onChanged: (String newValue) {
        setState(() {
          dropdownValue = newValue;
        });
      },
      items:
          transfer.account_names.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  }
}

class FeeSlider extends StatefulWidget {
  FeeSlider({Key key, this.transfer}) : super(key: key);

  final Transfer transfer;

  @override
  _FeeSliderState createState() => _FeeSliderState(transfer: transfer);
}

class _FeeSliderState extends State<FeeSlider> {
  _FeeSliderState({this.transfer});

  final Transfer transfer;

  @override
  Widget build(BuildContext context) {
    return Slider(
      value: transfer._currentSliderValue,
      min: 0,
      max: 100,
      divisions: 5,
      label: transfer._currentSliderValue.round().toString() +
          'BTC' +
          ', szacowany czas: ' +
          (1 / transfer._currentSliderValue).toStringAsFixed(2) +
          ' h',
      onChanged: (double value) {
        setState(() {
          transfer._currentSliderValue = value;
        });
      },
    );
  }
}
