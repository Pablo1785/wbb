import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'signin.dart';
import 'contact.dart';
import 'main.dart';
import 'models.dart';
import 'globals.dart';

void main() => runApp(SignUpApp());

class SignUpApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Wirtualny Bank Bitcoinów- zarejestruj się',
      theme: ThemeData(
        visualDensity: VisualDensity.adaptivePlatformDensity,
		brightness: light_theme ? Brightness.light : Brightness.dark,
        ),
      routes: {
        '/': (context) => SignUpScreen(),
        '/welcome': (context) => WelcomeScreen(),
		'/signin': (context) => SignInApp(),
		'/signup': (context) => SignUpApp(),
		'/main': (context) => MainApp(),
		'/contact': (context) => ContactApp(),
      },
    );
  }
}

class SignUpScreen extends StatelessWidget {
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
          child: Card(
            child: SignUpForm(),
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
    Future<UserProfile> futureUser = ModalRoute.of(context).settings.arguments;

    return Scaffold(
      body: Center(
        child: 		
		FutureBuilder<UserProfile>(
                  future: futureUser,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
						Timer(const Duration(seconds: 5), () {
						Navigator.of(context).pushNamed('/signin');});
							
                      return Text("Założono konto użytkownika: ${snapshot.data.username}", style: Theme.of(context).textTheme.headline2);
                    } else if (snapshot.hasError) {
						Timer(const Duration(seconds: 5), () {
						Navigator.of(context).pushNamed('/');});
						
                      return Text("${snapshot.error}", style: Theme.of(context).textTheme.headline2);
                    }

                    return CircularProgressIndicator();
                  },
                ),
      ),
    );
  }
}

class SignUpForm extends StatefulWidget {
  @override
  _SignUpFormState createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  final _usernameTextController = TextEditingController();
  final _passwordController = TextEditingController();
  final _emailTextController = TextEditingController();

  double _formProgress = 0;

  void _updateFormProgress() {
    var progress = 0.0;
    var controllers = [
      _usernameTextController,
      _passwordController,
      _emailTextController
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

  void _showWelcomeScreen(String username, String password, String email) {
    Navigator.of(context).pushNamed('/welcome', arguments: requestor.createUser(username,password,email));
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      onChanged: _updateFormProgress,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AnimatedProgressIndicator(value: _formProgress),
          Text('Utwórz konto', style: Theme.of(context).textTheme.headline4),
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
                    _showWelcomeScreen(_usernameTextController.text,
                        _passwordController.text, _emailTextController.text);
                  }
                : null,
            child: Text('Utwórz konto'),
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
