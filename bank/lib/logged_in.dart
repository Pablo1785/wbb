import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

void main() => runApp(LoggedInApp());

class LoggedInApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Wirtualny Bank Bitcoinów',
      theme: ThemeData(
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: HomePage(),
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
      appBar: PreferredSize(
        preferredSize: Size(screenSize.width, 1000),
        child: Container(
		  color: Colors.blue,
          child: Padding(
            padding: EdgeInsets.all(20),
            child: Row(
              children: [
                Text(
					'WBB',
					style: GoogleFonts.montserrat(
					fontSize: 15,
					fontWeight: FontWeight.w500,
					color: Colors.white
					)
				),
				//SizedBox(width: screenSize.width / 50),
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      InkWell(
                        onTap: () {},
                        child: Text(
                          'Przelew',
                          style: GoogleFonts.montserrat(
							fontSize: 15,
							fontWeight: FontWeight.w500,
							color: Colors.white
							)
                        ),
                      ),
                      SizedBox(width: screenSize.width / 50),
                      InkWell(
                        onTap: () {},
                        child: Text(
                          'Lokata',
                          style: GoogleFonts.montserrat(
							fontSize: 15,
							fontWeight: FontWeight.w500,
							color: Colors.white
							)
                        ),
                      ),
					  
					  SizedBox(width: screenSize.width / 50),
                      InkWell(
                        onTap: () {},
                        child: Text(
                          'Rachunki',
                          style: GoogleFonts.montserrat(
							fontSize: 15,
							fontWeight: FontWeight.w500,
							color: Colors.white
							)
                        ),
                      ),
					  					  SizedBox(width: screenSize.width / 50),
                      InkWell(
                        onTap: () {},
                        child: Text(
                          'Odbiorcy',
                          style: GoogleFonts.montserrat(
							fontSize: 15,
							fontWeight: FontWeight.w500,
							color: Colors.white
							)
                        ),
                      ),
					  					  SizedBox(width: screenSize.width / 50),
                      InkWell(
                        onTap: () {},
                        child: Text(
                          'Historia',
                          style: GoogleFonts.montserrat(
							fontSize: 15,
							fontWeight: FontWeight.w500,
							color: Colors.white
							)
                        ),
                      ),
					  					  SizedBox(width: screenSize.width / 50),
                      InkWell(
                        onTap: () {},
                        child: Text(
                          'Kontakt',
                          style: GoogleFonts.montserrat(
							fontSize: 15,
							fontWeight: FontWeight.w500,
							color: Colors.white
							)
                        ),
                      ),
					  					  SizedBox(width: screenSize.width / 50),
                      InkWell(
                        onTap: () {},
                        child: Text(
                          'Zdarzenia',
                          style: GoogleFonts.montserrat(
							fontSize: 15,
							fontWeight: FontWeight.w500,
							color: Colors.white
							)
                        ),
                      ),
					  
					  
					  
                    ],
                  ),
                ),
                InkWell(
                  onTap: () {},
                  child: Text(
                    'Ustawienia',
                    style: GoogleFonts.montserrat(
							fontSize: 15,
							fontWeight: FontWeight.w500,
							color: Colors.white
							)
                  ),
                ),
                SizedBox(
                  width: screenSize.width / 50,
                ),
                InkWell(
                  onTap: () {},
                  child: Text(
                    'Wyloguj',
                    style: GoogleFonts.montserrat(
							fontSize: 15,
							fontWeight: FontWeight.w500,
							color: Colors.white
							)
                  ),
                ),
              ],
            ),
          ),
        ),
      ),

    );
  }
}