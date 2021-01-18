import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'logged_in.dart';
import 'signup.dart';
import 'contact.dart';
import 'main.dart';
import 'models.dart';
import 'globals.dart';

void main() => runApp(SignInApp());

class SignInApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Wirtualny Bank Bitcoinów- zaloguj',
      theme: ThemeData(
        visualDensity: VisualDensity.adaptivePlatformDensity,
		brightness: light_theme ? Brightness.light : Brightness.dark,
        ),
      routes: {
        '/': (context) => SignInScreen(),
		'/welcome': (context) => WelcomeScreen(),
		'/loggedin': (context) => LoggedInApp(),
		'/signin': (context) => SignInApp(),
        '/signup': (context) => SignUpApp(),
		'/main': (context) => MainApp(),
		'/contact': (context) => ContactApp(),
      },
    );
  }
}

class SignInScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
	  var screenSize = MediaQuery.of(context).size;
	  
          return Scaffold(
      backgroundColor: Colors.black38,
	  appBar: PreferredSize(
          preferredSize: Size(screenSize.width, 1000),
          child: MenuNotLogged(),
        ),
      body: Center(
        child: SizedBox(
          width: 400,
          //height: 400,
          child: Card(
            child: SignIpForm(),
          ),
        ),
      ),
    );
        
  }
}

class WelcomeScreen extends StatefulWidget {
  WelcomeScreen({Key key}) : super(key: key);

  @override
  _WelcomeScreenState createState() {
    return _WelcomeScreenState();
  }
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  @override
  Widget build(BuildContext context) {
    Future<TokenData> futureToken = ModalRoute.of(context).settings.arguments;

    return Scaffold(
      body: Center(
      child: 		
		FutureBuilder<TokenData>(
		  future: futureToken,
		  builder: (context, snapshot) {
			if (snapshot.hasData) {
				Timer(const Duration(seconds: 2), () {
				Navigator.of(context).pushNamed('/loggedin');});
					
			  return Text("Witaj w Wirtualnym Banku Bitcoinów!", style: Theme.of(context).textTheme.headline2);
			} else if (snapshot.hasError) {
				Timer(const Duration(seconds: 2), () {
				Navigator.of(context).pushNamed('/');});
				
        var userMessage = "Błąd logowania...";
        if (requestor.lastResponse.statusCode == 401) userMessage = "Niepoprawna nazwa użytkownika lub hasło...";

			  return Text(userMessage, style: Theme.of(context).textTheme.headline2);
			}

			return CircularProgressIndicator();
		  },
		),
      ),
    );
  }
}

class SignIpForm extends StatefulWidget {
  @override
  _SignIpFormState createState() => _SignIpFormState();
}

class _SignIpFormState extends State<SignIpForm> {
  final _usernameTextController = TextEditingController();
  final _passwordController = TextEditingController();

  double _formProgress = 0;

  void _updateFormProgress() {
    var progress = 0.0;
    var controllers = [
      _usernameTextController,
      _passwordController,
    ];

    for (var controller in controllers) {
      if (controller.value.text.isNotEmpty) {
        progress += 1 / controllers.length;
      }
    }

    setState(() {
      _formProgress = progress;
    });
  }

  void _showWelcomeScreen(String username, String password) {
    Navigator.of(context).pushNamed('/welcome', arguments: requestor.login(username,password));
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      onChanged: _updateFormProgress,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AnimatedProgressIndicator(value: _formProgress),
          Text('Zaloguj się', style: Theme.of(context).textTheme.headline4),
          Padding(
            padding: EdgeInsets.all(8.0),
            child: TextFormField(
              controller: _usernameTextController,
              decoration: InputDecoration(hintText: 'Nazwa użytkownika'),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(8.0),
            child: TextFormField(
              controller: _passwordController,
              decoration: InputDecoration(hintText: 'Hasło'),
              obscureText: true,
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
            onPressed: _formProgress == 1
                ? () {
                    _showWelcomeScreen(
                        _usernameTextController.text, _passwordController.text);
                  }
                : null,
            child: Text('Zaloguj'),
          ),
        ],
      ),
    );
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
        tween: ColorTween(begin: Colors.red, end: Colors.orange),
        weight: 1,
      ),
      // TweenSequenceItem(
      // tween: ColorTween(begin: Colors.orange, end: Colors.yellow),
      // weight: 1,
      //),
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
