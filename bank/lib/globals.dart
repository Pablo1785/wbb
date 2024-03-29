import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'api_requests.dart';

String auth_token = "empty";
Requestor requestor = new Requestor();

bool light_theme = true;

class Menu extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;

    return Container(
      color: light_theme ? Colors.blue : Colors.black,
      child: Padding(
        padding: EdgeInsets.all(20),
        child: Row(
          children: [
            InkWell(
              onTap: () {
                Navigator.of(context).pushNamed('/loggedin');
              },
              child: Text('WBB',
                  style: GoogleFonts.montserrat(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      color: Colors.white)),
            ),
            //SizedBox(width: screenSize.width / 50),
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  InkWell(
                    onTap: () {
                      Navigator.of(context).pushNamed('/transfer');
                    },
                    child: Text('Przelew',
                        style: GoogleFonts.montserrat(
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                            color: Colors.white)),
                  ),
                  SizedBox(width: screenSize.width / 50),
                  InkWell(
                    onTap: () {
                      Navigator.of(context).pushNamed('/deposit');
                    },
                    child: Text('Lokata',
                        style: GoogleFonts.montserrat(
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                            color: Colors.white)),
                  ),
                  SizedBox(width: screenSize.width / 50),
                  InkWell(
                    onTap: () {
                      Navigator.of(context).pushNamed('/subaccounts');
                    },
                    child: Text('Konta',
                        style: GoogleFonts.montserrat(
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                            color: Colors.white)),
                  ),
                  SizedBox(width: screenSize.width / 50),
                  InkWell(
                    onTap: () {
                      Navigator.of(context).pushNamed('/receivers');
                    },
                    child: Text('Odbiorcy',
                        style: GoogleFonts.montserrat(
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                            color: Colors.white)),
                  ),
                  SizedBox(width: screenSize.width / 50),
                  InkWell(
                    onTap: () {
                      Navigator.of(context).pushNamed('/history');
                    },
                    child: Text('Historia',
                        style: GoogleFonts.montserrat(
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                            color: Colors.white)),
                  ),
                  SizedBox(width: screenSize.width / 50),
                  InkWell(
                    onTap: () {
                      Navigator.of(context).pushNamed('/securityevents');
                    },
                    child: Text('Zdarzenia',
                        style: GoogleFonts.montserrat(
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                            color: Colors.white)),
                  ),
                ],
              ),
            ),
            InkWell(
              onTap: () {
                Navigator.of(context).pushNamed('/settings');
              },
              child: Text('Ustawienia',
                  style: GoogleFonts.montserrat(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      color: Colors.white)),
            ),
            SizedBox(width: screenSize.width / 50),
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
            SizedBox(
              width: screenSize.width / 50,
            ),
            InkWell(
              onTap: () {
                http.post('${requestor.serverAddress}:${requestor.serverPort}/auth/token/logout',
                    headers: <String, String>{
                      'Authorization': 'JWT ${requestor.tokenData.access}',
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
    );
  }
}

class MenuNotLogged extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    
    return Container(
      color: light_theme ? Colors.blue : Colors.black,
      child: Padding(
        padding: EdgeInsets.all(20),
        child: Row(
          children: [
            InkWell(
              onTap: () { 
                Navigator.of(context).pushNamed('/main');
              },
              child: Text('WBB',
                  style: GoogleFonts.montserrat(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      color: Colors.white)),
            ),
            //SizedBox(width: screenSize.width / 50),
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [],
              ),
            ),
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
            SizedBox(
              width: screenSize.width / 50,
            ),
            InkWell(
              onTap: () {
                Navigator.of(context).pushNamed('/signin');
              },
              child: Text('Zaloguj się',
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
                Navigator.of(context).pushNamed('/signup');
              },
              child: Text('Zarejestruj się',
                  style: GoogleFonts.montserrat(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }
}
