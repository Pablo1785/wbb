import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;

String auth_token;

class Menu extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
	var screenSize = MediaQuery.of(context).size;
	  
    return Container(
            color: Colors.blue,
            child: Padding(
              padding: EdgeInsets.all(20),
              child: Row(
                children: [
                  Text('WBB',
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
                        SizedBox(width: screenSize.width / 50),
                        InkWell(
                          onTap: () {},
                          child: Text('Lokata',
                              style: GoogleFonts.montserrat(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white)),
                        ),
                        SizedBox(width: screenSize.width / 50),
                        InkWell(
                          onTap: () {},
                          child: Text('Rachunki',
                              style: GoogleFonts.montserrat(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white)),
                        ),
                        SizedBox(width: screenSize.width / 50),
                        InkWell(
                          onTap: () {},
                          child: Text('Odbiorcy',
                              style: GoogleFonts.montserrat(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white)),
                        ),
                        SizedBox(width: screenSize.width / 50),
                        InkWell(
                          onTap: () {},
                          child: Text('Historia',
                              style: GoogleFonts.montserrat(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white)),
                        ),
                        SizedBox(width: screenSize.width / 50),
                        InkWell(
                          onTap: () {},
                          child: Text('Kontakt',
                              style: GoogleFonts.montserrat(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white)),
                        ),
                        SizedBox(width: screenSize.width / 50),
                        InkWell(
                          onTap: () {},
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
                    onTap: () {Navigator.of(context).pushNamed('/settings');},
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
						http.post(
							'http://localhost:8000/auth/token/logout',
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
        );
  }
}