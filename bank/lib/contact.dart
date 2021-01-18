import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'main.dart';
import 'logged_in.dart';
import 'settings.dart';
import 'transfer.dart';
import 'deposit.dart';
import 'contact.dart';
import 'signin.dart';
import 'signup.dart';
import 'history.dart';
import 'subaccounts.dart';
import 'receivers.dart';
import 'security_events.dart';
import 'globals.dart';

void main() => runApp(ContactApp());

class ContactApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Wirtualny Bank Bitcoinów- kontakt',
      theme: ThemeData(
        visualDensity: VisualDensity.adaptivePlatformDensity,
        brightness: light_theme ? Brightness.light : Brightness.dark,
      ),
      routes: {
        '/': (context) => ContactScreen(),
        '/main': (context) => MainApp(),
        '/settings': (context) => SettingsApp(),
        '/loggedin': (context) => LoggedInApp(),
        '/transfer': (context) => TransferApp(),
        '/deposit': (context) => DepositApp(),
		'/history': (context) => HistoryApp(),
		'/contact': (context) => ContactApp(),
        '/signin': (context) => SignInApp(),
        '/signup': (context) => SignUpApp(),
		'/subaccounts': (context) => SubaccountsApp(),
		'/receivers': (context) => ReceiversApp(),
		'/securityevents': (context) => SecurityEventsApp(),
      },
    );
  }
}

class ContactScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
	  var screenSize = MediaQuery.of(context).size;
	  
    return Scaffold(
      backgroundColor: Colors.black38,
	  appBar: PreferredSize(
	  preferredSize: Size(screenSize.width, 1000),
	  child: auth_token == "empty" ? MenuNotLogged() : Menu(),
	),
      body: Center(
        child: SizedBox(
          width: 400,
          child: Card(
            child: ContactForm(),
          ),
        ),
      ),
    );
  }
}

class ContactForm extends StatefulWidget {
  @override
  _ContactFormState createState() => _ContactFormState();
}

class _ContactFormState extends State<ContactForm> {
  final _messageController = TextEditingController();
  final _emailTextController = TextEditingController();

  double _formProgress = 0;

  void _updateFormProgress() {
    var progress = 0.0;
    var controllers = [_messageController, _emailTextController];

    for (var controller in controllers) {
      if (controller.value.text.isNotEmpty) {
        progress += 1 / controllers.length;
      }
    }

    setState(() {
      _formProgress = progress;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      onChanged: _updateFormProgress,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AnimatedProgressIndicator(value: _formProgress),
          Text('Skontaktuj się z nami',
              style: Theme.of(context).textTheme.headline4),
          Padding(
            padding: EdgeInsets.all(8.0),
            child: TextFormField(
              controller: _messageController,
              decoration: InputDecoration(hintText: 'Wiadomość'),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(8.0),
            child: TextFormField(
              controller: _emailTextController,
              decoration: InputDecoration(hintText: 'Adres e-mail'),
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
                    : Colors.black;
              }),
            ),
            onPressed: _formProgress == 1
                ? () {
                    _showWelcomeScreen(
                        _messageController.text, _emailTextController.text);
                  }
                : null,
            child: Text('Wyślij'),
          ),
        ],
      ),
    );
  }
  
  void _showWelcomeScreen(String message, String email) {
  if (auth_token == "empty")
	  Navigator.of(context).pushNamed('/main');
  else
	  Navigator.of(context).pushNamed('/loggedin');
}

}

class AnimatedProgressIndicator extends StatefulWidget {
  final double value;

  AnimatedProgressIndicator({
    @required this.value,
  });

  @override
  State<StatefulWidget> createState() {
    return _AnimatedProgressIndicatorState();
  }
}

class _AnimatedProgressIndicatorState extends State<AnimatedProgressIndicator>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;
  Animation<Color> _colorAnimation;
  Animation<double> _curveAnimation;

  void initState() {
    super.initState();
    _controller = AnimationController(
        duration: Duration(milliseconds: 1200), vsync: this);

    var colorTween = TweenSequence([
      TweenSequenceItem(
        tween: ColorTween(begin: Colors.red, end: Colors.black),
        weight: 1,
      ),
      TweenSequenceItem(
        tween: ColorTween(begin: Colors.orange, end: Colors.yellow),
        weight: 1,
      ),
      TweenSequenceItem(
        tween: ColorTween(begin: Colors.yellow, end: Colors.green),
        weight: 1,
      ),
    ]);

    _colorAnimation = _controller.drive(colorTween);
    _curveAnimation = _controller.drive(CurveTween(curve: Curves.easeIn));
  }

  void didUpdateWidget(oldWidget) {
    super.didUpdateWidget(oldWidget);
    _controller.animateTo(widget.value);
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) => LinearProgressIndicator(
        value: _curveAnimation.value,
        valueColor: _colorAnimation,
        backgroundColor: _colorAnimation.value.withOpacity(0.4),
      ),
    );
  }
}
