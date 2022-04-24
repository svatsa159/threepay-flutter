import 'dart:async';

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:ionicons/ionicons.dart';
import 'package:lottie/lottie.dart';
import 'package:share_plus/share_plus.dart';
import 'package:threepay/adapters/UserAdapter.dart';
import 'package:threepay/components/BackButton.dart';
import 'package:threepay/pages/TaxPage.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:appsflyer_sdk/appsflyer_sdk.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      name: '3pay App',
      options: const FirebaseOptions(
          apiKey: 'AIzaSyDPeEDBVteZVEuomdlhQ1qHJS-4bX99Txc',
          appId: '1:469194955754:android:d65ec6df98f948f38e3093',
          messagingSenderId: '469194955754',
          projectId: 'pay-firebase-auth'));

  Map appsFlyerOptions = {
    "afDevKey": 'sAg5ASkYowm89xrmbR98NF',
    "afAppId": 'pay-firebase-auth',
    "isDebug": true
  };

  AppsflyerSdk appsflyerSdk = AppsflyerSdk(appsFlyerOptions);

  appsflyerSdk.initSdk(
      registerConversionDataCallback: true,
      registerOnAppOpenAttributionCallback: true,
      registerOnDeepLinkingCallback: true);
  // await appsflyerSdk.logEvent('hi', {'hi': 'hi'});
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '3Pay',
      initialRoute: '/home',
      routes: {
        // When navigating to the "/" route, build the FirstScreen widget.
        '/home': (context) => const Wrapper(),
        '/threepaycard': ((context) => const ThreePayCard()),
        '/tax': (context) => const TaxPage(),
        '/tax-generated': (context) => const TaxExtracted()
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
      UserAdapter().createUser(user?.displayName ?? "", user?.phoneNumber ?? "",
          user?.photoURL ?? "", user?.email ?? "", user?.uid ?? "");
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
      Timer(const Duration(milliseconds: 100), () {
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
      Timer(const Duration(milliseconds: 100), () {
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
      Timer(const Duration(milliseconds: 100), () {
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
    Timer(const Duration(milliseconds: 200), () {
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

  Color gold = Color.fromARGB(255, 255, 203, 116);
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
                              child: FadeInImage(
                                  image: NetworkImage(widget.user.photoURL!),
                                  width: 50,
                                  imageErrorBuilder: (context, o, e) =>
                                      Image.asset(
                                        "assets/images/default-image.png",
                                        width: 50,
                                      ),
                                  placeholder: const AssetImage(
                                      "assets/images/default-image.png"))),
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
                        'here\'s what we have for you',
                        // overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.montserrat(
                          fontWeight: FontWeight.w600,
                          fontSize: 18,
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
                      height: 250,
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
                              'Get a clear overview of your tax liabilities along with a detailed report, generated within seconds.',
                              overflow: TextOverflow.ellipsis,
                              maxLines: 3,
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
                                      Navigator.pushNamed(context, '/tax',
                                          arguments:
                                              TaxPageArgs(widget.user.uid));
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
                      height: 250,
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
                              'Bringing utility to crypto, with India\'s first Crypto Rewards Card.',
                              overflow: TextOverflow.ellipsis,
                              maxLines: 3,
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
                                              context, '/threepaycard',
                                              arguments: ThreePayCardArgs(
                                                  uid: widget.user.uid))
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
  openUrl(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw "Could not launch $url";
    }
  }

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
          child: Stack(
            children: [
              Positioned(
                top: 100,
                right: -200,
                child: ClipRRect(
                  child: Container(
                      child: Opacity(
                    opacity: 0.7,
                    child: Image.asset(
                      'assets/images/3.png',
                      width: 500,
                    ),
                  )),
                ),
              ),
              Column(mainAxisAlignment: MainAxisAlignment.start, children: [
                Row(
                  children: [
                    Container(
                      height: 600,
                      width: MediaQuery.of(context).size.width - 40,
                      margin: const EdgeInsets.symmetric(
                          vertical: 100, horizontal: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // SizedBox(
                          //   height: 50,
                          //   child: DefaultTextStyle(
                          //       style: GoogleFonts.montserrat(
                          //           fontWeight: FontWeight.w200,
                          //           fontSize: 30,
                          //           color: const Color.fromARGB(
                          //               234, 255, 255, 255)),
                          //       child: AnimatedTextKit(
                          //         isRepeatingAnimation: false,
                          //         animatedTexts: [
                          //           TypewriterAnimatedText(
                          //             'Welcome to',
                          //             speed: const Duration(milliseconds: 100),
                          //           ),
                          //         ],
                          //       )),
                          // ),
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
                                // pause: const Duration(milliseconds: 1000),
                                animatedTexts: [
                                  // TypewriterAnimatedText('', cursor: ''),
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
                          // const SizedBox(height: 50),
                          SizedBox(
                            height: 100,
                            width: (MediaQuery.of(context).size.width - 40) / 2,
                            child: DefaultTextStyle(
                                style: GoogleFonts.montserrat(
                                  fontWeight: FontWeight.w200,
                                  fontSize: 20,
                                  color: gold,
                                ),
                                child: Text(
                                    "the exclusive community of top 1% crypto hodlers in India.")),
                          ),
                          const SizedBox(height: 200),
                          FutureBuilder(
                              future:
                                  Future.delayed(const Duration(seconds: 0)),
                              builder: (c, s) =>
                                  s.connectionState == ConnectionState.done
                                      ? const GSignIn()
                                      : const Text("")),
                          const SizedBox(height: 20),
                          Container(
                            width: MediaQuery.of(context).size.width - 40,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  "by logging in, you agree to our",
                                  style: GoogleFonts.montserrat(
                                    fontWeight: FontWeight.w200,
                                    fontSize: 16,
                                    color: gold,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                InkWell(
                                    child: Container(
                                      padding: EdgeInsets.all(2),
                                      decoration: BoxDecoration(
                                        border: Border(
                                          bottom: BorderSide(
                                              width: 1.5, color: gold),
                                        ),
                                      ),
                                      child: Text(
                                        "terms and conditions",
                                        style: GoogleFonts.montserrat(
                                          fontWeight: FontWeight.w200,
                                          fontSize: 16,
                                          color: gold,
                                          // decorationThickness: 3,
                                          // decoration: TextDecoration.underline,
                                          // decorationColor: Colors.white
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                    onTap: () => {
                                          openUrl(
                                              'https://3pay.club/terms.html')
                                        }),
                              ],
                            ),
                          )
                        ],
                      ),
                    )
                  ],
                )
              ]),
            ],
          ),
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
                          : const Padding(
                              padding: EdgeInsets.all(8.0),
                              child: CircularProgressIndicator(
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

class ThreePayCardArgs {
  final String uid;

  ThreePayCardArgs({required this.uid});
}

class ThreePayCard extends StatefulWidget {
  const ThreePayCard({Key? key}) : super(key: key);

  @override
  State<ThreePayCard> createState() => _ThreePayCardState();
}

class _ThreePayCardState extends State<ThreePayCard> {
  Color gold = const Color.fromARGB(255, 255, 203, 116);
  Color green = const Color.fromARGB(255, 60, 184, 111);
  Color goldDark = const Color.fromARGB(255, 223, 172, 91);
  Color greenDark = const Color.fromARGB(255, 53, 150, 93);

  backClick(Function function) {}

  bool isBackClicked = false;

  bool isWaitlistClicked = false;

  bool isWaitlisted = false;

  bool isWaitlistLoading = false;

  bool isShareClicked = false;

  bool isAnimated = false;

  joinWaitlist(String uid) {
    UserAdapter()
        .toggleWaitlist(uid)
        .then((done) => {
              if (done)
                {
                  setState(() => {isWaitlistLoading = false, isAnimated = true})
                }
              else
                {
                  setState(() => {isWaitlistLoading = false})
                }
            })
        .catchError(() => {
              setState(() => {isWaitlistLoading = false}),
              // throw Error()
            });
  }

  @override
  Widget build(BuildContext context) {
    ThreePayCardArgs args =
        ModalRoute.of(context)!.settings.arguments as ThreePayCardArgs;
    return Material(
      color: const Color.fromARGB(255, 41, 45, 50),
      child: Stack(
        children: [
          Column(
            children: [
              Expanded(
                child: Container(
                    decoration: const BoxDecoration(
                        color: Color.fromARGB(255, 41, 45, 50)),
                    child: SingleChildScrollView(
                      child: Container(
                        padding: const EdgeInsets.all(25),
                        child: SafeArea(
                          child: Column(children: [
                            SizedBox(
                              width: MediaQuery.of(context).size.width - 50,
                              height:
                                  (MediaQuery.of(context).size.width - 100) *
                                      1.2,
                              child: Stack(
                                children: [
                                  Positioned(
                                    left: 25,
                                    child: Image.asset(
                                      'assets/images/3PayCard.png',
                                      width: MediaQuery.of(context).size.width -
                                          100,
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
                              margin: const EdgeInsets.only(top: 20),
                              // child: Text(
                              //   '3Pay Card - India\'s First Crypto Rewards Card for hodlers that believe in a decentralised future. Get 3Pay Card backed by the crypto lying around lazily in your exchanges.',
                              //   style: GoogleFonts.montserrat(
                              //     fontWeight: FontWeight.w300,
                              //     fontSize: 20,
                              //     color: Colors.white,
                              //   ),

                              // ),
                              child: RichText(
                                text: TextSpan(
                                    style: GoogleFonts.montserrat(
                                      fontWeight: FontWeight.w300,
                                      fontSize: 20,
                                      color: Colors.white,
                                    ),
                                    children: [
                                      const TextSpan(
                                          text:
                                              '3Pay Card - India\'s First Crypto Rewards Card for '),
                                      TextSpan(
                                          text: 'hodlers',
                                          style: GoogleFonts.montserrat(
                                              fontWeight: FontWeight.w700,
                                              fontSize: 20,
                                              color: gold)),
                                      const TextSpan(
                                          text: ' that believe in a '),
                                      const TextSpan(
                                          text: 'decentralised',
                                          style: TextStyle(
                                              decoration:
                                                  TextDecoration.underline,
                                              decorationColor:
                                                  const Color.fromARGB(
                                                      255, 255, 203, 116),
                                              decorationStyle:
                                                  TextDecorationStyle.wavy,
                                              decorationThickness: 2)),
                                      const TextSpan(
                                          text:
                                              ' future. \n\nGet 3Pay Card, supported by the crypto lying around lazily in your exchanges.')
                                    ]),
                              ),
                            )
                          ]),
                        ),
                      ),
                    )),
              ),
              Container(
                  height: 100,
                  padding:
                      const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                  decoration: const BoxDecoration(
                    color: Colors.transparent,
                  ),
                  child: FutureBuilder<bool>(
                      future: UserAdapter().getIsWaitlist(args.uid),
                      builder: (context, snapshot) {
                        switch (snapshot.connectionState) {
                          case ConnectionState.none:
                            return Container();
                          case ConnectionState.waiting:
                            return SpinKitThreeBounce(
                              color: Colors.white,
                              size: 20.0,
                            );
                            break;
                          case ConnectionState.active:
                            return SpinKitThreeBounce(
                              color: Colors.white,
                              size: 20.0,
                            );
                            break;
                          case ConnectionState.done:
                            return snapshot.data!
                                ? Row(
                                    children: [
                                      Expanded(
                                        flex: 1,
                                        child: Text(
                                          'You have joined the elite',
                                          style: GoogleFonts.montserrat(
                                            fontWeight: FontWeight.w600,
                                            fontSize: 14,
                                            color: gold,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                      InkWell(
                                        child: Container(
                                          decoration: BoxDecoration(
                                            color: const Color.fromARGB(
                                                255, 41, 45, 50),
                                            borderRadius:
                                                BorderRadius.circular(8.0),
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.white
                                                    .withOpacity(0.3),
                                                offset:
                                                    const Offset(-4.0, -4.0),
                                                blurRadius: 13.0,
                                              ),
                                              BoxShadow(
                                                color: Colors.black
                                                    .withOpacity(0.8),
                                                offset: const Offset(6.0, 6.0),
                                                blurRadius: 13.0,
                                              ),
                                            ],
                                          ),
                                          child: Padding(
                                            padding: EdgeInsets.all(
                                                isShareClicked ? 2.0 : 4.0),
                                            child: Container(
                                                decoration: BoxDecoration(
                                                  color: const Color.fromARGB(
                                                      255, 41, 45, 50),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          8.0),
                                                  boxShadow: [
                                                    BoxShadow(
                                                      color: Colors.white
                                                          .withOpacity(
                                                              isShareClicked
                                                                  ? 0.5
                                                                  : 0.3),
                                                      offset: const Offset(
                                                          2.0, 2.0),
                                                      blurRadius: 3.0,
                                                    ),
                                                    BoxShadow(
                                                      color: Colors.black
                                                          .withOpacity(
                                                              isShareClicked
                                                                  ? 1.0
                                                                  : 0.8),
                                                      offset: const Offset(
                                                          -2.0, -2.0),
                                                      blurRadius: 3.0,
                                                    ),
                                                  ],
                                                ),
                                                child: Container(
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            vertical:
                                                                isShareClicked
                                                                    ? 12
                                                                    : 10,
                                                            horizontal:
                                                                isShareClicked
                                                                    ? 22
                                                                    : 20),
                                                    child: Icon(
                                                      Ionicons
                                                          .share_social_outline,
                                                      color: gold,
                                                    ))),
                                          ),
                                        ),
                                        onTap: () => {
                                          Share.share(
                                            'Hey! Checkout how I am calculating my crypto taxes with a single click on 3Pay. Check them out on https://3pay.club',
                                          )
                                        },
                                      ),
                                    ],
                                  )
                                : InkWell(
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: const Color.fromARGB(
                                            255, 41, 45, 50),
                                        borderRadius:
                                            BorderRadius.circular(8.0),
                                        boxShadow: [
                                          BoxShadow(
                                            color:
                                                Colors.white.withOpacity(0.3),
                                            offset: const Offset(-4.0, -4.0),
                                            blurRadius: 13.0,
                                          ),
                                          BoxShadow(
                                            color:
                                                Colors.black.withOpacity(0.8),
                                            offset: const Offset(6.0, 6.0),
                                            blurRadius: 13.0,
                                          ),
                                        ],
                                      ),
                                      child: Padding(
                                        padding: EdgeInsets.all(
                                            isWaitlistClicked ? 2.0 : 4.0),
                                        child: Container(
                                            alignment: Alignment.center,
                                            decoration: BoxDecoration(
                                              color: const Color.fromARGB(
                                                  255, 255, 203, 116),
                                              borderRadius:
                                                  BorderRadius.circular(8.0),
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Colors.white
                                                      .withOpacity(
                                                          isWaitlistClicked
                                                              ? 0.5
                                                              : 0.3),
                                                  offset:
                                                      const Offset(2.0, 2.0),
                                                  blurRadius: 3.0,
                                                ),
                                                BoxShadow(
                                                  color: Colors.black
                                                      .withOpacity(
                                                          isWaitlistClicked
                                                              ? 1.0
                                                              : 0.8),
                                                  offset:
                                                      const Offset(-2.0, -2.0),
                                                  blurRadius: 3.0,
                                                ),
                                              ],
                                            ),
                                            child: Container(
                                              padding: EdgeInsets.symmetric(
                                                  vertical: isWaitlistClicked
                                                      ? 12
                                                      : 10,
                                                  horizontal: isWaitlistClicked
                                                      ? 22
                                                      : 20),
                                              child: !isWaitlistLoading
                                                  ? Text(
                                                      'Join Waitlist',
                                                      style: GoogleFonts
                                                          .montserrat(
                                                        fontWeight:
                                                            FontWeight.w200,
                                                        fontSize: 25,
                                                        color: Colors.black,
                                                      ),
                                                    )
                                                  : SpinKitThreeBounce(
                                                      color: Colors.black,
                                                      size: 20.0,
                                                    ),
                                            )),
                                      ),
                                    ),
                                    onTap: () => {
                                      setState(() => {
                                            isWaitlistClicked = true,
                                            isWaitlistLoading = true
                                          }),
                                      Timer(
                                          Duration(milliseconds: 400),
                                          () => {
                                                setState(() => {
                                                      isWaitlistClicked = false,
                                                    }),
                                                joinWaitlist(args.uid)
                                              })
                                    },
                                  );
                        }
                      }))
            ],
          ),
          Positioned(
            bottom: 80,
            right: 0,
            child: Lottie.asset('assets/images/success.json',
                repeat: false,
                animate: isAnimated,
                width: MediaQuery.of(context).size.width),
          )
        ],
      ),
    );
  }
}
