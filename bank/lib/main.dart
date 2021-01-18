import 'package:bank/signin.dart';
import 'package:bank/signup.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'globals.dart';
import 'contact.dart';

void main() => runApp(MainApp());

class MainApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Wirtualny Bank Bitcoinów',
      theme: ThemeData(
        visualDensity: VisualDensity.adaptivePlatformDensity,
		brightness: light_theme ? Brightness.light : Brightness.dark,
      ),
      routes: {
        '/': (context) => MainPage(),
        '/signin': (context) => SignInApp(),
        '/signup': (context) => SignUpApp(),
		'/main': (context) => MainApp(),
        '/contact': (context) => ContactApp(),
      },
    );
  }
}

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;

    return Scaffold(
        //extendBodyBehindAppBar: true,
        appBar: PreferredSize(
          preferredSize: Size(screenSize.width, 1000),
          child: MenuNotLogged(),
        ),
        body: Scrollbar(
            child: SingleChildScrollView(
                child: Column(children: [
          Functions(screenSize: screenSize),
          FunctionsTiles(screenSize: screenSize),
          Example(screenSize: screenSize),
          ExampleCarousel(),
        ]))));
  }
}

class Functions extends StatelessWidget {
  const Functions({
    Key key,
    this.screenSize,
  }) : super(key: key);

  final Size screenSize;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        top: screenSize.height * 0.06,
        left: screenSize.width / 15,
        right: screenSize.width / 15,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            'Funkcje',
            style: GoogleFonts.montserrat(
              fontSize: 40,
              fontWeight: FontWeight.w500,
            ),
          ),
          Expanded(
            child: Text(
              'Najważniejsze opcje dostępne w aplikacji',
              textAlign: TextAlign.end,
            ),
          ),
        ],
      ),
    );
  }
}

class FunctionsTiles extends StatelessWidget {
  FunctionsTiles({
    Key key,
    this.screenSize,
  }) : super(key: key);

  final Size screenSize;

  // https://graphicsurf.com/item/banking-vector-free-icon-set/
  final List<String> assets = [
    'images/bank.png',
    'images/bank2.png',
    'images/bank3.png',
  ];

  final List<String> title = [
    'Odbieraj przelewy',
    'Wysyłaj przelewy',
    'Zakładaj lokaty'
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        top: screenSize.height * 0.06,
        left: screenSize.width / 15,
        right: screenSize.width / 15,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          ...Iterable<int>.generate(assets.length).map(
            (int pageIndex) => Column(
              children: [
                SizedBox(
                  height: screenSize.width / 6,
                  width: screenSize.width / 3.8,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(5.0),
                    child: Image.asset(
                      assets[pageIndex],
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                    top: screenSize.height / 70,
                  ),
                  child: Text(
                    title[pageIndex],
                    style: GoogleFonts.montserrat(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class Example extends StatelessWidget {
  const Example({
    Key key,
    this.screenSize,
  }) : super(key: key);

  final Size screenSize;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        top: screenSize.height * 0.12,
        left: screenSize.width / 15,
        right: screenSize.width / 15,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'W praktyce',
            style: GoogleFonts.montserrat(
              fontSize: 40,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

class ExampleCarousel extends StatefulWidget {
  @override
  _ExampleCarouselState createState() => _ExampleCarouselState();
}

class _ExampleCarouselState extends State<ExampleCarousel> {
  final CarouselController _controller = CarouselController();

  List _isHovering = [false, false, false, false, false, false, false];
  List _isSelected = [true, false, false, false, false, false, false];

  int _current = 0;

  final List<String> images = [
    'images/screen_loggedin.jpg',
    'images/screen_transfer.jpg',
    'images/screen_deposit.jpg',
    'images/screen_subaccounts.jpg',
    'images/screen_history.jpg',
    'images/screen_events.jpg',
  ];

  final List<String> titles = [
    'EKRAN GŁÓWNY',
    'PRZELEW',
    'LOKATA',
    'RACHUNKI',
    'HISTORIA',
    'ZDARZENIA',
  ];

  List<Widget> generateImageTiles(screenSize) {
    return images
        .map(
          (element) => ClipRRect(
            borderRadius: BorderRadius.circular(8.0),
            child: Image.asset(
              element,
              fit: BoxFit.cover,
            ),
          ),
        )
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    var imageSliders = generateImageTiles(screenSize);

    return Padding(
        padding: EdgeInsets.only(
          top: screenSize.height * 0.06,
          left: screenSize.width / 15,
          right: screenSize.width / 15,
          bottom: screenSize.height * 0.06,
        ),
        child: Stack(
          children: [
            CarouselSlider(
              items: imageSliders,
              options: CarouselOptions(
                  scrollPhysics: NeverScrollableScrollPhysics(),
                  enlargeCenterPage: true,
                  aspectRatio: 18 / 8,
                  autoPlay: true,
                  onPageChanged: (index, reason) {
                    setState(() {
                      _current = index;
                      for (int i = 0; i < imageSliders.length; i++) {
                        if (i == index) {
                          _isSelected[i] = true;
                        } else {
                          _isSelected[i] = false;
                        }
                      }
                    });
                  }),
              carouselController: _controller,
            ),
            AspectRatio(
              aspectRatio: 18 / 8,
              child: Center(
                child: Text(
                  titles[_current],
                  style: TextStyle(
                    letterSpacing: 8,
                    fontSize: screenSize.width / 25,
                    color: Colors.blue,
                  ),
                ),
              ),
            ),
            AspectRatio(
              aspectRatio: 17 / 8,
              child: Center(
                heightFactor: 1,
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: EdgeInsets.only(
                      left: screenSize.width / 8,
                      right: screenSize.width / 8,
                    ),
                    child: Card(
                      elevation: 5,
                      child: Padding(
                        padding: EdgeInsets.only(
                          top: screenSize.height / 50,
                          bottom: screenSize.height / 50,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            for (int i = 0; i < titles.length; i++)
                              Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  InkWell(
                                    splashColor: Colors.transparent,
                                    hoverColor: Colors.transparent,
                                    onHover: (value) {
                                      setState(() {
                                        value
                                            ? _isHovering[i] = true
                                            : _isHovering[i] = false;
                                      });
                                    },
                                    onTap: () {
                                      _controller.animateToPage(i);
                                    },
                                    child: Padding(
                                      padding: EdgeInsets.only(
                                          top: screenSize.height / 80,
                                          bottom: screenSize.height / 90),
                                      child: Text(
                                        titles[i],
                                        style: TextStyle(
                                          color: _isHovering[i]
                                              ? Colors.blue
                                              : Colors.black,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Visibility(
                                    maintainSize: true,
                                    maintainAnimation: true,
                                    maintainState: true,
                                    visible: _isSelected[i],
                                    child: AnimatedOpacity(
                                      duration: Duration(milliseconds: 400),
                                      opacity: _isSelected[i] ? 1 : 0,
                                      child: Container(
                                        height: 5,
                                        decoration: BoxDecoration(
                                          color: Colors.blueGrey,
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(10),
                                          ),
                                        ),
                                        width: screenSize.width / 10,
                                      ),
                                    ),
                                  )
                                ],
                              ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ));
  }
}
