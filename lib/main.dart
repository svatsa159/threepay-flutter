import 'dart:async';

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:ionicons/ionicons.dart';
import 'package:threepay/components/BackButton.dart';
import 'package:threepay/pages/TaxPage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      name: '3pay App',
      options: const FirebaseOptions(
          apiKey: 'AIzaSyDPeEDBVteZVEuomdlhQ1qHJS-4bX99Txc',
          appId: '1:469194955754:android:d65ec6df98f948f38e3093',
          messagingSenderId: '469194955754',
          projectId: 'pay-firebase-auth'));
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Three Pay',
      initialRoute: '/home',
      routes: {
        // When navigating to the "/" route, build the FirstScreen widget.
        '/home': (context) => const Wrapper(),
        '/threepaycard': ((context) => const ThreePayCard()),
        '/tax': (context) => const TaxPage()
        // '/dash': (context) => const Dashboard(),
      },
      theme:
          ThemeData(primarySwatch: Colors.blue, backgroundColor: Colors.black),
    );
  }
}

class Wrapper extends StatefulWidget {
  const Wrapper({Key? key}) : super(key: key);

  @override
  _WrapperState createState() => _WrapperState();
}

class _WrapperState extends State<Wrapper> {
  User? user;
  @override
  void initState() {
    super.initState();
    //Listen to Auth State changes
    FirebaseAuth.instance
        .authStateChanges()
        .listen((event) => updateUserState(event));
  }

  //Updates state when user state changes in the app
  updateUserState(event) {
    setState(() {
      user = event;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (user == null) {
      return const ThreeHome();
    } else {
      return Dashboard(
        user: (user!),
      );
    }
  }
}

class DashboardArgs {
  final User user;

  DashboardArgs(this.user);
}

class Dashboard extends StatefulWidget {
  final User user;

  const Dashboard({Key? key, required this.user}) : super(key: key);

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  logout() {
    setState(() {
      isLogoutClicked = true;
      Timer(Duration(milliseconds: 100), () {
        setState(() {
          isLogoutClicked = false;
        });
        FirebaseAuth.instance.signOut();
      });
    });
  }

  buttonClick(Function function) {
    setState(() {
      isClicked = true;
      Timer(Duration(milliseconds: 100), () {
        setState(() {
          isClicked = false;
        });
        function();
      });
    });
  }

  buttonComputeClick(Function function) {
    setState(() {
      isComputeClicked = true;
      Timer(Duration(milliseconds: 100), () {
        setState(() {
          isComputeClicked = false;
        });
        function();
      });
    });
  }

  buttonTaxClick(Function function) {
    setState(() {
      isTaxClicked = true;
    });
    Timer(Duration(milliseconds: 200), () {
      setState(() {
        isTaxClicked = false;
      });
      function();
    });
  }

  bool isComputeClicked = false;
  bool isLogoutClicked = false;
  bool isClicked = false;
  bool isTaxClicked = false;

  Color gold = const Color.fromARGB(255, 255, 203, 116);
  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        decoration: const BoxDecoration(color: Color.fromARGB(255, 41, 45, 50)),
        child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: SafeArea(
              child: Column(children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 41, 45, 50),
                        borderRadius: BorderRadius.circular(8.0),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.white.withOpacity(0.3),
                            offset: const Offset(-4.0, -4.0),
                            blurRadius: 13.0,
                          ),
                          BoxShadow(
                            color: Colors.black.withOpacity(0.8),
                            offset: const Offset(6.0, 6.0),
                            blurRadius: 13.0,
                          ),
                        ],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8.0),
                            border: Border.all(
                                color: gold,
                                width: 1.0,
                                style: BorderStyle.solid),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.white.withOpacity(0.3),
                                offset: const Offset(2.0, 2.0),
                                blurRadius: 3.0,
                              ),
                              BoxShadow(
                                color: Colors.black.withOpacity(0.8),
                                offset: const Offset(-2.0, -2.0),
                                blurRadius: 3.0,
                              ),
                            ],
                          ),
                          child: ClipRRect(
                              borderRadius: BorderRadius.circular(8.0),
                              child: Image.network(
                                widget.user.photoURL!,
                                width: 50,
                              )),
                        ),
                      ),
                    ),
                    const Spacer(),
                    InkWell(
                      child: Container(
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 41, 45, 50),
                          borderRadius: BorderRadius.circular(8.0),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.white.withOpacity(0.3),
                              offset: const Offset(-4.0, -4.0),
                              blurRadius: 13.0,
                            ),
                            BoxShadow(
                              color: Colors.black.withOpacity(0.8),
                              offset: const Offset(6.0, 6.0),
                              blurRadius: 13.0,
                            ),
                          ],
                        ),
                        child: Padding(
                          padding: EdgeInsets.all(isLogoutClicked ? 2.0 : 4.0),
                          child: Container(
                              decoration: BoxDecoration(
                                color: const Color.fromARGB(220, 179, 71, 89),
                                borderRadius: BorderRadius.circular(8.0),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.white.withOpacity(
                                        isLogoutClicked ? 0.5 : 0.3),
                                    offset: const Offset(2.0, 2.0),
                                    blurRadius: 3.0,
                                  ),
                                  BoxShadow(
                                    color: Colors.black.withOpacity(
                                        isLogoutClicked ? 1.0 : 0.8),
                                    offset: const Offset(-2.0, -2.0),
                                    blurRadius: 3.0,
                                  ),
                                ],
                              ),
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                    vertical: isLogoutClicked ? 12 : 10,
                                    horizontal: isLogoutClicked ? 22 : 20),
                                child: Text(
                                  'Log out',
                                  style: GoogleFonts.montserrat(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 10,
                                    color: Colors.white,
                                  ),
                                ),
                              )),
                        ),
                      ),
                      onTap: () => {logout()},
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(top: 25),
                      child: RichText(
                        text: TextSpan(
                            style: GoogleFonts.montserrat(
                              fontWeight: FontWeight.w200,
                              fontSize: 20,
                              color: const Color.fromARGB(234, 255, 255, 255),
                            ),
                            children: [
                              const TextSpan(text: 'Hey '),
                              TextSpan(
                                  text: widget.user.displayName!.split(' ')[0],
                                  style: GoogleFonts.montserrat(
                                      fontWeight: FontWeight.w700,
                                      fontSize: 20,
                                      color: gold)),
                              const TextSpan(text: ',')
                            ]),
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width - 40,
                      margin: const EdgeInsets.only(top: 5),
                      child: Text(
                        'What\'s on your mind today?',
                        // overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.montserrat(
                          fontWeight: FontWeight.w600,
                          fontSize: 22,
                          color: const Color.fromARGB(234, 255, 255, 255),
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width - 40,
                      height: 235,
                      margin: const EdgeInsets.only(top: 50),
                      padding: const EdgeInsets.all(30),
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 41, 45, 50),
                        borderRadius: BorderRadius.circular(8.0),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.white.withOpacity(0.3),
                            offset: const Offset(-4.0, -4.0),
                            blurRadius: 10.0,
                          ),
                          BoxShadow(
                            color: Colors.black.withOpacity(0.8),
                            offset: const Offset(6.0, 6.0),
                            blurRadius: 10.0,
                          ),
                        ],
                      ),
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '3Tax',
                              // overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.montserrat(
                                fontWeight: FontWeight.w900,
                                fontSize: 35,
                                color: gold,
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Text(
                              'Compute Crypto Taxes based on your investments in leading Exchanges',
                              // overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.montserrat(
                                fontWeight: FontWeight.w400,
                                fontSize: 15,
                                color: const Color.fromARGB(234, 255, 255, 255),
                              ),
                            ),
                            const Spacer(),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Container(
                                  margin: const EdgeInsets.only(top: 30),
                                  padding: EdgeInsets.all(isTaxClicked ? 2 : 4),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8.0),
                                    color:
                                        const Color.fromARGB(255, 41, 45, 50),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.white.withOpacity(0.4),
                                        offset: const Offset(-2.0, -2.0),
                                        blurRadius: 13.0,
                                      ),
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.9),
                                        offset: const Offset(4.0, 4.0),
                                        blurRadius: 13.0,
                                      ),
                                    ],
                                  ),
                                  child: InkWell(
                                    child: Container(
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(8.0),
                                        color: const Color.fromARGB(
                                            255, 60, 98, 174),
                                        boxShadow: [
                                          BoxShadow(
                                            color:
                                                Colors.white.withOpacity(0.4),
                                            offset: const Offset(2.0, 2.0),
                                            blurRadius: 13.0,
                                          ),
                                          BoxShadow(
                                            color:
                                                Colors.black.withOpacity(0.9),
                                            offset: const Offset(-4.0, -4.0),
                                            blurRadius: 13.0,
                                          ),
                                        ],
                                      ),
                                      padding: EdgeInsets.symmetric(
                                          vertical: isTaxClicked ? 12 : 10,
                                          horizontal: isTaxClicked ? 22 : 20),
                                      child: Row(
                                        children: [
                                          Text('Compute now',
                                              style: GoogleFonts.montserrat(
                                                fontWeight: FontWeight.w400,
                                                fontSize: 12,
                                                color: Colors.white,
                                              )),
                                          Container(
                                            margin:
                                                const EdgeInsets.only(left: 10),
                                            child: const Icon(
                                              Ionicons
                                                  .arrow_forward_circle_outline,
                                              color: Colors.white,
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                    onTap: () => buttonTaxClick(() {
                                      Navigator.pushNamed(context, '/tax');
                                    }),
                                  ),
                                )
                              ],
                            )
                          ]),
                    )
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width - 40,
                      height: 225,
                      margin: const EdgeInsets.only(top: 50),
                      padding: const EdgeInsets.all(30),
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 41, 45, 50),
                        borderRadius: BorderRadius.circular(8.0),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.white.withOpacity(0.3),
                            offset: const Offset(-4.0, -4.0),
                            blurRadius: 10.0,
                          ),
                          BoxShadow(
                            color: Colors.black.withOpacity(0.8),
                            offset: const Offset(6.0, 6.0),
                            blurRadius: 10.0,
                          ),
                        ],
                      ),
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '3Pay Card',
                              // overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.montserrat(
                                fontWeight: FontWeight.w900,
                                fontSize: 35,
                                color: gold,
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Text(
                              'India\'s First Crypto backed Credit Card',
                              // overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.montserrat(
                                fontWeight: FontWeight.w400,
                                fontSize: 15,
                                color: const Color.fromARGB(234, 255, 255, 255),
                              ),
                            ),
                            const Spacer(),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                InkWell(
                                  child: Container(
                                    margin: const EdgeInsets.only(top: 30),
                                    padding: const EdgeInsets.all(4),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8.0),
                                      color:
                                          const Color.fromARGB(255, 41, 45, 50),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.white.withOpacity(0.4),
                                          offset: const Offset(-2.0, -2.0),
                                          blurRadius: 13.0,
                                        ),
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.9),
                                          offset: const Offset(4.0, 4.0),
                                          blurRadius: 13.0,
                                        ),
                                      ],
                                    ),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(8.0),
                                        color: const Color.fromARGB(
                                            255, 41, 45, 50),
                                        boxShadow: isClicked
                                            ? [
                                                BoxShadow(
                                                  color: Colors.white
                                                      .withOpacity(0.4),
                                                  offset:
                                                      const Offset(2.0, 2.0),
                                                  blurRadius: 13.0,
                                                ),
                                                BoxShadow(
                                                  color: Colors.black
                                                      .withOpacity(0.9),
                                                  offset:
                                                      const Offset(-4.0, -4.0),
                                                  blurRadius: 13.0,
                                                ),
                                              ]
                                            : [],
                                      ),
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 10, horizontal: 20),
                                      child: Row(
                                        children: [
                                          Text('Know more',
                                              style: GoogleFonts.montserrat(
                                                fontWeight: FontWeight.w400,
                                                fontSize: 12,
                                                color: gold,
                                              )),
                                          Container(
                                            margin:
                                                const EdgeInsets.only(left: 10),
                                            child: Icon(
                                              Ionicons
                                                  .arrow_forward_circle_outline,
                                              color: gold,
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                  onTap: () => {
                                    buttonClick(() => {
                                          Navigator.pushNamed(
                                              context, '/threepaycard')
                                        })
                                  },
                                )
                              ],
                            )
                          ]),
                    )
                  ],
                ),
              ]),
            )),
      ),
    );
  }
}

class ThreeHome extends StatefulWidget {
  const ThreeHome({Key? key}) : super(key: key);

  @override
  State<ThreeHome> createState() => _ThreeHomeState();
}

class _ThreeHomeState extends State<ThreeHome> {
  Color gold = const Color.fromARGB(255, 255, 203, 116);
  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        padding: EdgeInsets.zero,
        decoration: const BoxDecoration(color: Color.fromARGB(255, 41, 45, 50)),
        child: SafeArea(
          bottom: false,
          right: false,
          left: false,
          child: Column(mainAxisAlignment: MainAxisAlignment.start, children: [
            Row(
              children: [
                Container(
                  height: 600,
                  width: MediaQuery.of(context).size.width - 40,
                  margin:
                      const EdgeInsets.symmetric(vertical: 100, horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 50,
                        child: DefaultTextStyle(
                            style: GoogleFonts.montserrat(
                                fontWeight: FontWeight.w200,
                                fontSize: 30,
                                color:
                                    const Color.fromARGB(234, 255, 255, 255)),
                            child: AnimatedTextKit(
                              isRepeatingAnimation: false,
                              animatedTexts: [
                                TypewriterAnimatedText(
                                  'Welcome to',
                                  speed: const Duration(milliseconds: 100),
                                ),
                              ],
                            )),
                      ),
                      SizedBox(
                        height: 100,
                        child: DefaultTextStyle(
                          style: GoogleFonts.montserrat(
                            fontWeight: FontWeight.w200,
                            fontSize: 30,
                            color: gold,
                          ),
                          child: AnimatedTextKit(
                            isRepeatingAnimation: false,
                            pause: const Duration(milliseconds: 1000),
                            animatedTexts: [
                              TypewriterAnimatedText('', cursor: ''),
                              TypewriterAnimatedText(
                                '3Pay',
                                speed: const Duration(milliseconds: 100),
                                cursor: '\$',
                                textStyle: GoogleFonts.montserrat(
                                  fontWeight: FontWeight.w900,
                                  fontSize: 70,
                                  color: gold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 300),
                      FutureBuilder(
                          future: Future.delayed(const Duration(seconds: 0)),
                          builder: (c, s) =>
                              s.connectionState == ConnectionState.done
                                  ? const GSignIn()
                                  : const Text(""))
                    ],
                  ),
                )
              ],
            )
          ]),
        ),
      ),
    );
  }
}

class GSignIn extends StatefulWidget {
  const GSignIn({Key? key}) : super(key: key);

  @override
  State<GSignIn> createState() => _GSignInState();
}

class _GSignInState extends State<GSignIn> {
  bool isLoading = false;

  Color gold = const Color.fromARGB(255, 255, 203, 116);

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  Future<User> signInWithGoogle() async {
    setState(() {
      isLoading = true;
    });
    GoogleSignInAccount? googleSignInAccount = await _googleSignIn.signIn();
    GoogleSignInAuthentication? googleSignInAuthentication =
        await googleSignInAccount?.authentication;
    AuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleSignInAuthentication?.accessToken,
      idToken: googleSignInAuthentication?.idToken,
    );
    UserCredential authResult = await _auth.signInWithCredential(credential);
    var _user = authResult.user;
    assert(await _user?.getIdToken() != null);
    User currentUser = _auth.currentUser!;
    assert(_user?.uid == currentUser.uid);
    // print("User Name: ${_user?.displayName}");
    // print("User Email ${_user?.email}");
    setState(() {
      isLoading = false;
    });
    return currentUser;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InkWell(
            child: Center(
                child: Container(
                    width: 90,
                    height: 90,
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 41, 45, 50),
                      borderRadius: BorderRadius.circular(90.0),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.white.withOpacity(0.1),
                          offset: const Offset(-6.0, -6.0),
                          blurRadius: 16.0,
                        ),
                        BoxShadow(
                          color: Colors.black.withOpacity(0.4),
                          offset: const Offset(6.0, 6.0),
                          blurRadius: 16.0,
                        ),
                      ],
                    ),
                    padding: EdgeInsets.all(isLoading ? 10 : 4),
                    child: Container(
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 41, 45, 50),
                        borderRadius: BorderRadius.circular(90.0),
                        boxShadow: isLoading
                            ? [
                                BoxShadow(
                                  color: Colors.white.withOpacity(0.1),
                                  offset: const Offset(6.0, 6.0),
                                  blurRadius: 16.0,
                                ),
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.4),
                                  offset: const Offset(-6.0, -6.0),
                                  blurRadius: 16.0,
                                ),
                              ]
                            : [],
                      ),
                      child: !isLoading
                          ? Icon(
                              Ionicons.logo_google,
                              color: gold,
                              size: 60,
                            )
                          : Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: const CircularProgressIndicator(
                                color: Colors.white,
                              ),
                            ),
                    ))),
            onTap: () async {
              signInWithGoogle().then(
                (User user) {},
              );
            }),
      ],
    );
  }
}

class ThreePayCard extends StatefulWidget {
  const ThreePayCard({Key? key}) : super(key: key);

  @override
  State<ThreePayCard> createState() => _ThreePayCardState();
}

class _ThreePayCardState extends State<ThreePayCard> {
  Color gold = const Color.fromARGB(255, 255, 203, 116);
  Color green = Color.fromARGB(255, 60, 184, 111);
  Color goldDark = Color.fromARGB(255, 223, 172, 91);
  Color greenDark = Color.fromARGB(255, 53, 150, 93);

  backClick(Function function) {}

  bool isBackClicked = false;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: const Color.fromARGB(255, 41, 45, 50),
      child: Column(
        children: [
          Expanded(
            child: Container(
                decoration:
                    const BoxDecoration(color: Color.fromARGB(255, 41, 45, 50)),
                child: SingleChildScrollView(
                  child: Container(
                    padding: const EdgeInsets.all(25),
                    child: SafeArea(
                      child: Column(children: [
                        SizedBox(
                          width: MediaQuery.of(context).size.width - 50,
                          height:
                              (MediaQuery.of(context).size.width - 100) * 1.2,
                          child: Stack(
                            children: [
                              Positioned(
                                left: 25,
                                child: Image.asset(
                                  'assets/images/3PayCard.png',
                                  width:
                                      MediaQuery.of(context).size.width - 100,
                                ),
                              ),
                              const Positioned(
                                top: 0,
                                left: 0,
                                height: 50,
                                child: BackNeuButton(),
                              ),
                            ],
                          ),
                        ),
                        Row(children: [
                          Text(
                            '3Pay Card',
                            // overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.montserrat(
                              fontWeight: FontWeight.w900,
                              fontSize: 35,
                              color: gold,
                            ),
                          ),
                        ]),
                        Container(
                          margin: EdgeInsets.only(top: 20),
                          child: Text(
                            '3Pay Card - India\'s First Credit card for crypto holders.\n\nGet a credit card based on your crypto lying around lazily in your exchanges.',
                            style: GoogleFonts.montserrat(
                              fontWeight: FontWeight.w300,
                              fontSize: 20,
                              color: Colors.white,
                            ),
                          ),
                        )
                      ]),
                    ),
                  ),
                )),
          ),
          Container(
            height: 100,
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
            decoration: BoxDecoration(
              color: Colors.transparent,
            ),
            child: Container(
              padding: EdgeInsets.all(5),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.0),
                color: const Color.fromARGB(255, 41, 45, 50),
                boxShadow: [
                  BoxShadow(
                    color: Colors.white.withOpacity(0.3),
                    offset: const Offset(-2.0, -2.0),
                    blurRadius: 7.0,
                  ),
                  BoxShadow(
                    color: Colors.black.withOpacity(0.8),
                    offset: const Offset(3.0, 3.0),
                    blurRadius: 7.0,
                  ),
                ],
              ),
              child: Container(
                width: MediaQuery.of(context).size.width,
                alignment: AlignmentDirectional.center,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4.0),
                  gradient: LinearGradient(
                      begin: Alignment.topLeft, end: Alignment.bottomRight,
                      // colors: [green, greenDark]),
                      colors: [gold, goldDark]),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.white.withOpacity(0.3),
                      offset: const Offset(2.0, 2.0),
                      blurRadius: 7.0,
                    ),
                    BoxShadow(
                      color: Colors.black.withOpacity(0.8),
                      offset: const Offset(-3.0, -3.0),
                      blurRadius: 7.0,
                    ),
                  ],
                ),
                child: Text(
                  'Join Waitlist',
                  style: GoogleFonts.montserrat(
                      fontWeight: FontWeight.w300,
                      fontSize: 20,
                      color: Colors.black,
                      shadows: [
                        // Shadow(
                        //   color: Colors.black.withOpacity(0.8),
                        //   offset: const Offset(1.0, 1.0),
                        //   blurRadius: 7.0,
                        // ),
                      ]),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
