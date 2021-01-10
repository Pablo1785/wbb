import 'package:bank/signin.dart';
import 'package:bank/signup.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'contact.dart';

void main() => runApp(HomeApp());

class HomeApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Wirtualny Bank Bitcoinów',
      theme: ThemeData(
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      routes: {
        '/': (context) => HomePage(),
        '/signin': (context) => SignInApp(),
        '/signup': (context) => SignUpApp(),
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
      appBar: AppBar(
        //  preferredSize: Size(screenSize.width, 1000),
        title: const Text('Witrualny Bank Bitcoinów'),
        actions: [
          Padding(
            padding: EdgeInsets.all(20),
            child: Center(
              child: InkWell(
                onTap: () {
                  Navigator.of(context).pushNamed('/signin');
                },
                child: Text('Zaloguj się',
                    style: GoogleFonts.montserrat(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                        color: Colors.white)),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(20),
            child: Center(
              child: InkWell(
                onTap: () {
                  Navigator.of(context).pushNamed('/signup');
                },
                child: Text('Zarejestruj się',
                    style: GoogleFonts.montserrat(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                        color: Colors.white)),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(20),
            child: Center(
              child: InkWell(
                onTap: () {
                  Navigator.of(context).pushNamed('/contact');
                },
                child: Text('kontakt',
                    style: GoogleFonts.montserrat(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                        color: Colors.white)),
              ),
            ),
          ),
        ],
      ),
      body: Center(
        child: Text(
          'Witamy w naszym banku Bitcoinów! ',
          style: TextStyle(fontSize: 30),
        ),
      ),
      backgroundColor: Colors.grey[200],
    );
  }
}
