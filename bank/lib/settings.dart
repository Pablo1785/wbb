import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:email_validator/email_validator.dart';
import 'contact.dart';
import 'main.dart';
import 'logged_in.dart';
import 'transfer.dart';
import 'deposit.dart';
import 'history.dart';
import 'subaccounts.dart';
import 'receivers.dart';
import 'security_events.dart';
import 'models.dart';
import 'globals.dart';

void main() => runApp(SettingsApp());

class SettingsApp extends StatelessWidget {
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
        '/main': (context) => MainApp(),
        '/settings': (context) => SettingsApp(),
        '/loggedin': (context) => LoggedInApp(),
        '/transfer': (context) => TransferApp(),
        '/deposit': (context) => DepositApp(),
        '/history': (context) => HistoryApp(),
        '/contact': (context) => ContactApp(),
        '/subaccounts': (context) => SubaccountsApp(),
        '/receivers': (context) => ReceiversApp(),
        '/securityevents': (context) => SecurityEventsApp(),
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

class User {
  static const String Email = 'email';
  static const String Password = 'password';
  static const String NewPassword = 'newpassword';
  static const String Light_theme = 'theme';
  static const String Notif_incoming = 'notif_incoming';
  static const String Notif_login = 'notif_login';
  static const String Notif_transfer = 'notif_transfer';
  static const String Notif_summary = 'notif_summary';

  Map data = {
    //Email: 'przykladowyemail@gmail.com',
    //Password: 'przykladowehaslo',
    Light_theme: true,
    Notif_incoming: false,
    Notif_login: true,
    Notif_transfer: false,
    Notif_summary: false,
  };

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
  final _passwordFormKey = GlobalKey<FormState>();
  final _emailFormKey = GlobalKey<FormState>();
  final _user = User();
  var futureProfile = requestor.fetchCurrentUser();
  var profile;

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
                builder: (context) => FutureBuilder<UserProfile>(
                  future: futureProfile,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      //_user.data[User.Email] = snapshot.data.email;
                      profile = snapshot.data;
                      return Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Form(
                          key: _emailFormKey,
                          child: TextFormField(
                                  decoration: InputDecoration(
                                    labelText: 'E-mail',
                                    hintText: profile.email,
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
                                    if (!EmailValidator.validate(value)) {
                                      return 'Proszę wprowadzić poprawny adres email.';
                                    }
                                  },
                                  onSaved: (val) => setState(() =>
                                      _user.data[User.Email] = val),
                                ),),
                                Form(
                          key: _passwordFormKey,
                          child: Column(children:[TextFormField(
                                  decoration: InputDecoration(
                                    labelText: 'Obecne hasło',
                                    hintText:
                                        'Pozostaw puste, jeśli chcesz zostać przy aktualnym',
                                    floatingLabelBehavior:
                                        FloatingLabelBehavior.always,
                                    labelStyle: TextStyle(
                                      fontSize: 24,
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'HelveticaNeue',
                                    ),
                                  ),
                                  obscureText: true,
                                  validator: (value) {
                                    if (value.length < 8) {
                                      return 'Proszę wprowadzić hasło o długości co najmniej 8 znaków.';
                                    }
                                  },
                                  onSaved: (val) => setState(() =>
                                      _user.data[User.Password] = val),
                                ),
                                TextFormField(
                                    decoration: InputDecoration(
                                      labelText: 'Nowe hasło',
                                      hintText:
                                          'Pozostaw puste, jeśli chcesz zostać przy aktualnym',
                                      floatingLabelBehavior:
                                          FloatingLabelBehavior.always,
                                      labelStyle: TextStyle(
                                        fontSize: 24,
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                        fontFamily: 'HelveticaNeue',
                                      ),
                                    ),
                                    obscureText: true,
                                    validator: (value) {
                                      if (value.length < 8) {
                                        return 'Proszę wprowadzić hasło o długości co najmniej 8 znaków.';
                                      }
                                    },
                                    onSaved: (val) => setState(() => _user
                                            .data[User.NewPassword] = val)),
											])),
                                Container(
                                  padding:
                                      const EdgeInsets.fromLTRB(0, 50, 0, 20),
                                  child: Text(
                                    'Personalizacja',
                                    style: TextStyle(
                                      fontSize: 24,
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'HelveticaNeue',
                                    ),
                                  ),
                                ),
                                SwitchListTile(
                                    title: const Text(
                                      'Jasny motyw',
                                      style: TextStyle(
                                        fontSize: 18,
                                        color: Colors.black,
                                        fontFamily: 'HelveticaNeue',
                                      ),
                                    ),
                                    value: light_theme,
                                    onChanged: (bool val) {
                                      setState(() {
                                        _user.data[User.Light_theme] = val;
                                        light_theme = val;
                                      });
                                      Navigator.of(context)
                                          .popAndPushNamed('/settings');
                                    }),
                                Container(
                                  padding:
                                      const EdgeInsets.fromLTRB(0, 50, 0, 20),
                                  child: Text(
                                    'Powiadomienia e-mail',
                                    style: TextStyle(
                                      fontSize: 24,
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'HelveticaNeue',
                                    ),
                                  ),
                                ),
                                SwitchListTile(
                                    title: const Text(
                                      'Przelew przychodzący',
                                      style: TextStyle(
                                        fontSize: 18,
                                        color: Colors.black,
                                        fontFamily: 'HelveticaNeue',
                                      ),
                                    ),
                                    value: _user.data[User.Notif_incoming],
                                    onChanged: (bool val) => setState(() =>
                                        _user.data[User.Notif_incoming] = val)),
                                SwitchListTile(
                                    title: const Text(
                                      'Nieudane logowanie',
                                      style: TextStyle(
                                        fontSize: 18,
                                        color: Colors.black,
                                        fontFamily: 'HelveticaNeue',
                                      ),
                                    ),
                                    value: _user.data[User.Notif_login],
                                    onChanged: (bool val) => setState(() =>
                                        _user.data[User.Notif_login] = val)),
                                Container(
                                  padding:
                                      const EdgeInsets.fromLTRB(0, 50, 0, 20),
                                  child: Text(
                                    'Bezpieczeństwo',
                                    style: TextStyle(
                                      fontSize: 24,
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'HelveticaNeue',
                                    ),
                                  ),
                                ),
                                SwitchListTile(
                                    title: const Text(
                                      'Zatwierdzanie przelewów e-mailem',
                                      style: TextStyle(
                                        fontSize: 18,
                                        color: Colors.black,
                                        fontFamily: 'HelveticaNeue',
                                      ),
                                    ),
                                    value: _user.data[User.Notif_transfer],
                                    onChanged: (bool val) => setState(() =>
                                        _user.data[User.Notif_transfer] = val)),
                                SwitchListTile(
                                    title: const Text(
                                      'Przesyłanie wyciągów e-mailem',
                                      style: TextStyle(
                                        fontSize: 18,
                                        color: Colors.black,
                                        fontFamily: 'HelveticaNeue',
                                      ),
                                    ),
                                    value: _user.data[User.Notif_summary],
                                    onChanged: (bool val) => setState(() =>
                                        _user.data[User.Notif_summary] = val)),
                                Container(
                                    height: 80,
                                    // margin: EdgeInsets.only(left: 200, right: 200),
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 16.0, horizontal: 16.0),
                                    child: RaisedButton(
                                        color: Colors.blue,
                                        onPressed: () {
                                          if (_emailFormKey.currentState
                                              .validate()) {
                                            _emailFormKey.currentState.save();
                                            _user.send();
                                            showPopup3(context);
                                          }
                                        },
                                        child: Text(
                                          'Zmień e-mail',
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
                                        color: Colors.blue,
                                        onPressed: () {
                                          if (_passwordFormKey.currentState
                                              .validate()) {
                                            _passwordFormKey.currentState.save();
                                            _user.send();
                                            showPopup4(context);
                                          }
                                        },
                                        child: Text(
                                          'Zmień hasło',
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
                                          showPopup(context);
                                        },
                                        child: Text(
                                          'Zamknij konto',
                                          style: TextStyle(
                                            fontSize: 16,
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontFamily: 'HelveticaNeue',
                                          ),
                                        ))),
                              ]);
                    } else if (snapshot.hasError) {
                      return Text(
                          "Błąd przy pobieraniu danych użytkownika. ${snapshot.error}",
                          style: Theme.of(context).textTheme.headline2);
                    }

                    return CircularProgressIndicator();
                  },
                ),
              )),
        ),
      ),
    ));
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
                      child: Text('Czy na pewno chcesz zamknąć konto?',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold)),
                    ),
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text('Po potwierdzeniu pojawi się klucz prywatny',
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
                      child: Text('Twój klucz prywatny',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold)),
                    ),
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: FutureBuilder<WalletFull>(
                        future: requestor.fetchWalletFull(),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            return SelectableText(snapshot.data.privateKey,
                                style: TextStyle(fontSize: 14));
                          } else if (snapshot.hasError) {
                            return Text(
                                "Nie udało się podbrać klucza prywatnego",
                                style: Theme.of(context).textTheme.headline2);
                          }

                          return CircularProgressIndicator();
                        },
                      ),
                    ),
                    Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              RaisedButton(
                                child: Text("Zapisano klucz, zamknij okno"),
                                color: Colors.red,
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
                      child: Text('Rezultat',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold)),
                    ),
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: FutureBuilder<UserProfile>(
                        future: requestor.updateUser(profile.username,
                            email: _user.data[User.Email]),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            return Text("Email zmieniony",
                                style: Theme.of(context).textTheme.headline2);
                          } else if (snapshot.hasError) {
                            return Text("Nie udało się zmienić emaila",
                                style: Theme.of(context).textTheme.headline2);
                          }

                          return CircularProgressIndicator();
                        },
                      ),
                    ),
                    Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
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

  void showPopup4(BuildContext context) {
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
                      child: FutureBuilder<bool>(
                        future: requestor.changePassword(
                            _user.data[User.NewPassword],
                            _user.data[User.Password]),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            if (snapshot.data == true)
                              return Text("Hasło zmienione",
                                  style: Theme.of(context).textTheme.headline2);
                            else
                              return Text("Nie udało się zmienić hasła.",
                                  style: Theme.of(context).textTheme.headline2);
                          } else if (snapshot.hasError) {
                            return Text("Nie udało się zmienić hasła",
                                style: Theme.of(context).textTheme.headline2);
                          }

                          return CircularProgressIndicator();
                        },
                      ),
                    ),
                    Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
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
}
