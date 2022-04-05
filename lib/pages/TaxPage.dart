import 'dart:async';
import 'dart:io';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:intl/intl.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:path/path.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:story_view/story_view.dart';
import 'package:threepay/adapters/ThreeTaxAdapter.dart';
import 'package:collection/collection.dart';
import 'package:threepay/components/BackButton.dart';
import 'package:threepay/pages/StoryPageView.dart';

class TaxPageArgs {
  final String uid;

  TaxPageArgs(this.uid);
}

class TaxPage extends StatefulWidget {
  const TaxPage({Key? key}) : super(key: key);
  @override
  State<TaxPage> createState() => _TaxPageState();
}

class _TaxPageState extends State<TaxPage> {
  Color background = const Color.fromARGB(255, 41, 45, 50);
  Color gold = const Color.fromARGB(255, 255, 203, 116);

  bool fileUploadClicked = false;

  bool fileUploading = false;

  bool isClearClicked = false;

  File? selectedFile = null;

  // clearGeneration() {
  //   setState(() {
  //     isClearClicked = true;
  //   });
  //   Timer(Duration(milliseconds: 500), () async {
  //     setState(() {
  //       taxGenerated = false;
  //       isClearClicked = false;
  //       fileUploading = false;
  //       selectedFile = null;
  //       allTaxes = [];
  //     });
  //   });
  // }

  uploadFile(String uid, BuildContext context) {
    setState(() {
      fileUploading = true;
    });
    Timer(Duration(milliseconds: 500), () async {
      UploadTaxResponse res =
          ((await ThreeTaxAdapter().uploadTax(selectedFile!, uid)));
      print(res.pdfUrl);
      // print(res.capitalGains);
      double taxes = 0;
      double profits = 0;
      res.capitalGains.forEach((e) => {
            taxes += e.totalTax,
            // print(e.totalProfit),
            profits += e.totalProfit
          });
      if (res.success) {
        setState(() {
          fileUploading = false;
          selectedFile = null;
        });
        Navigator.pushNamed(context, '/tax-generated',
            arguments: TaxExtractedArgs(
                allTaxes: res.capitalGains,
                totalProfits: profits,
                totalTax: taxes,
                pdfUrl: res.pdfUrl));
      } else {
        setState(() {
          fileUploading = false;
          selectedFile = null;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as TaxPageArgs;
    return Material(
      color: background,
      child: SafeArea(
        child: Container(
          decoration: BoxDecoration(color: background),
          child: SingleChildScrollView(
            child: Container(
                padding: const EdgeInsets.all(25),
                width: MediaQuery.of(context).size.width - 50,
                child: Column(children: [
                  Row(
                    children: const [BackNeuButton()],
                  ),
                  Row(
                    children: [
                      Container(
                        margin: const EdgeInsets.only(top: 30),
                        width: MediaQuery.of(context).size.width - 50,
                        child: Text(
                          'Compute Crypto Taxes',
                          style: GoogleFonts.montserrat(
                            fontWeight: FontWeight.w900,
                            fontSize: 35,
                            color: gold,
                          ),
                        ),
                      )
                    ],
                  ),
                  Row(
                    children: [
                      Container(
                        margin: const EdgeInsets.only(top: 5),
                        width: MediaQuery.of(context).size.width - 50,
                        child: Text(
                          'with zero hassle',
                          style: GoogleFonts.montserrat(
                            fontWeight: FontWeight.w200,
                            fontSize: 20,
                            color: Colors.white,
                          ),
                        ),
                      )
                    ],
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 20),
                    width: MediaQuery.of(context).size.width - 50,
                    height: 200,
                    padding: const EdgeInsets.all(10),
                    child: Container(
                      padding: const EdgeInsets.all(5),
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
                        padding: fileUploadClicked
                            ? const EdgeInsets.all(6)
                            : const EdgeInsets.fromLTRB(7, 7, 5, 5),
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 51, 149, 161),
                          borderRadius: BorderRadius.circular(9.0),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.white.withOpacity(0.2),
                              offset: const Offset(2.0, 2.0),
                              blurRadius: 7.0,
                            ),
                            BoxShadow(
                              color: Colors.black.withOpacity(0.5),
                              offset: const Offset(-3.0, -3.0),
                              blurRadius: 7.0,
                            ),
                          ],
                        ),
                        child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: const Color.fromARGB(255, 41, 45, 50),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.white.withOpacity(0.2),
                                  offset: fileUploadClicked
                                      ? const Offset(2.0, 2.0)
                                      : const Offset(-2, -2),
                                  blurRadius: 3.0,
                                ),
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.5),
                                  offset: fileUploadClicked
                                      ? const Offset(-3.0, -3.0)
                                      : const Offset(3.0, 3.0),
                                  blurRadius: 3.0,
                                ),
                              ],
                            ),
                            child: selectedFile == null
                                ? InkWell(
                                    child: SizedBox(
                                      width:
                                          (MediaQuery.of(context).size.width -
                                              92),
                                      child: Column(
                                        children: [
                                          const Spacer(),
                                          const Icon(
                                            CupertinoIcons.arrow_up_doc,
                                            size: 40,
                                            color: Colors.white,
                                          ),
                                          const Spacer(),
                                          Text(
                                            'click to',
                                            style: GoogleFonts.montserrat(
                                              fontWeight: FontWeight.w300,
                                              fontSize: 14,
                                              color: Colors.white,
                                            ),
                                          ),
                                          Text(
                                              'upload transaction statement from exchange',
                                              style: GoogleFonts.montserrat(
                                                fontWeight: FontWeight.w300,
                                                fontSize: 14,
                                                color: Colors.white,
                                              ),
                                              textAlign: TextAlign.center),
                                          const Spacer()
                                        ],
                                      ),
                                    ),
                                    onTap: () => {
                                      setState(() {
                                        fileUploadClicked = true;
                                      }),
                                      Timer(const Duration(milliseconds: 150),
                                          () async {
                                        setState(() {
                                          fileUploadClicked = false;
                                        });
                                        FilePickerResult? result =
                                            await FilePicker.platform.pickFiles(
                                                allowMultiple: false,
                                                type: FileType.custom,
                                                allowedExtensions: [
                                              "xlsx",
                                              "csv"
                                            ]);
                                        if (result != null) {
                                          print('hi');
                                          File file =
                                              File(result.files.single.path!);
                                          setState(() {
                                            selectedFile = file;
                                          });
                                        } else {
                                          // User canceled the picker
                                        }
                                      })
                                    },
                                  )
                                : !fileUploading
                                    ? Container(
                                        padding: EdgeInsets.all(5),
                                        width:
                                            (MediaQuery.of(context).size.width -
                                                92),
                                        child: Column(children: [
                                          const Spacer(),
                                          SizedBox(
                                              height: 148,
                                              child: Flex(
                                                direction: Axis.horizontal,
                                                children: [
                                                  Expanded(
                                                    flex: 1,
                                                    child: Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        const Icon(
                                                          CupertinoIcons
                                                              .doc_checkmark,
                                                          color: Colors.white,
                                                        ),
                                                        const SizedBox(
                                                          height: 10,
                                                        ),
                                                        Text(
                                                          basename(selectedFile!
                                                                          .path)
                                                                      .length >
                                                                  10
                                                              ? basename(selectedFile!
                                                                          .path)
                                                                      .substring(
                                                                          0,
                                                                          10) +
                                                                  '...' +
                                                                  basename(selectedFile!
                                                                          .path)
                                                                      .substring(
                                                                          basename(selectedFile!.path).length -
                                                                              10)
                                                              : basename(
                                                                  selectedFile!
                                                                      .path),
                                                          style: GoogleFonts
                                                              .montserrat(
                                                            fontWeight:
                                                                FontWeight.w300,
                                                            fontSize: 14,
                                                            color: Colors.white,
                                                          ),
                                                          textAlign:
                                                              TextAlign.center,
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                  Expanded(
                                                      flex: 1,
                                                      child: Column(
                                                        children: [
                                                          const Spacer(),
                                                          InkWell(
                                                            child: Container(
                                                              height: 40,
                                                              width: 90,
                                                              padding:
                                                                  const EdgeInsets
                                                                      .all(4),
                                                              decoration:
                                                                  BoxDecoration(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            10),
                                                                color: const Color
                                                                        .fromARGB(
                                                                    255,
                                                                    41,
                                                                    45,
                                                                    50),
                                                                boxShadow: [
                                                                  BoxShadow(
                                                                    color: Colors
                                                                        .white
                                                                        .withOpacity(
                                                                            0.2),
                                                                    offset:
                                                                        const Offset(
                                                                            -2,
                                                                            -2),
                                                                    blurRadius:
                                                                        3.0,
                                                                  ),
                                                                  BoxShadow(
                                                                    color: Colors
                                                                        .black
                                                                        .withOpacity(
                                                                            0.5),
                                                                    offset:
                                                                        const Offset(
                                                                            3.0,
                                                                            3.0),
                                                                    blurRadius:
                                                                        3.0,
                                                                  ),
                                                                ],
                                                              ),
                                                              child: Container(
                                                                height: 32,
                                                                decoration:
                                                                    BoxDecoration(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              10),
                                                                  color: const Color
                                                                          .fromARGB(
                                                                      255,
                                                                      39,
                                                                      129,
                                                                      99),
                                                                  boxShadow: [
                                                                    BoxShadow(
                                                                      color: Colors
                                                                          .white
                                                                          .withOpacity(
                                                                              0.2),
                                                                      offset:
                                                                          const Offset(
                                                                              2,
                                                                              2),
                                                                      blurRadius:
                                                                          3.0,
                                                                    ),
                                                                    BoxShadow(
                                                                      color: Colors
                                                                          .black
                                                                          .withOpacity(
                                                                              0.5),
                                                                      offset: const Offset(
                                                                          -3.0,
                                                                          -3.0),
                                                                      blurRadius:
                                                                          3.0,
                                                                    ),
                                                                  ],
                                                                ),
                                                                child: Column(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .center,
                                                                  children: const [
                                                                    Icon(
                                                                      CupertinoIcons
                                                                          .checkmark_alt,
                                                                      color: Colors
                                                                          .white,
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                            ),
                                                            onTap: () => {
                                                              uploadFile(
                                                                  args.uid,
                                                                  context)
                                                            },
                                                          ),
                                                          const SizedBox(
                                                            height: 20,
                                                          ),
                                                          InkWell(
                                                            child: Container(
                                                              height: 40,
                                                              width: 90,
                                                              padding:
                                                                  const EdgeInsets
                                                                      .all(4),
                                                              decoration:
                                                                  BoxDecoration(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            10),
                                                                color: const Color
                                                                        .fromARGB(
                                                                    255,
                                                                    41,
                                                                    45,
                                                                    50),
                                                                boxShadow: [
                                                                  BoxShadow(
                                                                    color: Colors
                                                                        .white
                                                                        .withOpacity(
                                                                            0.2),
                                                                    offset:
                                                                        const Offset(
                                                                            -2,
                                                                            -2),
                                                                    blurRadius:
                                                                        3.0,
                                                                  ),
                                                                  BoxShadow(
                                                                    color: Colors
                                                                        .black
                                                                        .withOpacity(
                                                                            0.5),
                                                                    offset:
                                                                        const Offset(
                                                                            3.0,
                                                                            3.0),
                                                                    blurRadius:
                                                                        3.0,
                                                                  ),
                                                                ],
                                                              ),
                                                              child: Container(
                                                                height: 32,
                                                                decoration:
                                                                    BoxDecoration(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              10),
                                                                  color: const Color
                                                                          .fromARGB(
                                                                      220,
                                                                      179,
                                                                      71,
                                                                      89),
                                                                  boxShadow: [
                                                                    BoxShadow(
                                                                      color: Colors
                                                                          .white
                                                                          .withOpacity(
                                                                              0.2),
                                                                      offset:
                                                                          const Offset(
                                                                              2,
                                                                              2),
                                                                      blurRadius:
                                                                          3.0,
                                                                    ),
                                                                    BoxShadow(
                                                                      color: Colors
                                                                          .black
                                                                          .withOpacity(
                                                                              0.5),
                                                                      offset: const Offset(
                                                                          -3.0,
                                                                          -3.0),
                                                                      blurRadius:
                                                                          3.0,
                                                                    ),
                                                                  ],
                                                                ),
                                                                child: Column(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .center,
                                                                  children: const [
                                                                    Icon(
                                                                      CupertinoIcons
                                                                          .trash,
                                                                      color: Colors
                                                                          .white,
                                                                      size: 15,
                                                                    )
                                                                  ],
                                                                ),
                                                              ),
                                                            ),
                                                            onTap: () => {
                                                              setState(() => {
                                                                    selectedFile =
                                                                        null
                                                                  })
                                                            },
                                                          ),
                                                          const Spacer(),
                                                        ],
                                                      )),
                                                ],
                                              ))
                                        ]))
                                    : Center(
                                        child: Column(
                                          children: [
                                            Spacer(),
                                            SpinKitRipple(
                                              color: Colors.white,
                                              size: 50.0,
                                            ),
                                            SizedBox(height: 10),
                                            Text(
                                                'going to moon to calculate your taxes',
                                                style: GoogleFonts.montserrat(
                                                  fontWeight: FontWeight.w300,
                                                  fontSize: 14,
                                                  color: Colors.white,
                                                ),
                                                textAlign: TextAlign.center),
                                            Spacer()
                                          ],
                                        ),
                                      )),
                      ),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 25),
                    child: Row(
                      children: [
                        SizedBox(
                          width: MediaQuery.of(context).size.width - 50,
                          child: Text(
                            'Unable to find transaction statement of your exchange?',
                            style: GoogleFonts.montserrat(
                              fontWeight: FontWeight.w300,
                              fontSize: 20,
                              color: gold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 10),
                    child: Row(
                      children: [
                        Text(
                          'Choose your exchange below and know how :',
                          style: GoogleFonts.montserrat(
                            fontWeight: FontWeight.w300,
                            fontSize: 12,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 20),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Container(
                        height: 120,
                        width: MediaQuery.of(context).size.width - 50,
                        padding: const EdgeInsets.all(5),
                        alignment: Alignment.centerLeft,
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: const [
                              ExchangeStoryPill(
                                  exchangeLogoUrl:
                                      'assets/images/vauld/vauld_logo_light.png',
                                  nameOfExchange: 'vauld',
                                  numberOfSteps: 5,
                                  sizeOfExchangeLogo: 30),
                              SizedBox(width: 15),
                              ExchangeStoryPill(
                                  exchangeLogoUrl:
                                      'assets/images/wazirx/Wazirx.png',
                                  nameOfExchange: 'wazirx',
                                  numberOfSteps: 6,
                                  sizeOfExchangeLogo: 30),
                              SizedBox(width: 15),
                              ExchangeStoryPill(
                                  exchangeLogoUrl:
                                      'assets/images/zebpay/zebpay.png',
                                  nameOfExchange: 'zebpay',
                                  numberOfSteps: 4,
                                  sizeOfExchangeLogo: 30),
                            ]),
                      ),
                    ),
                  )
                ])),
          ),
        ),
      ),
    );
  }
}

class TaxExtractedArgs {
  final List<TokenTax> allTaxes;

  final double totalTax;
  final double totalProfits;

  final String pdfUrl;

  TaxExtractedArgs(
      {required this.allTaxes,
      required this.totalProfits,
      required this.totalTax,
      required this.pdfUrl});
}

class TaxExtracted extends StatefulWidget {
  const TaxExtracted({Key? key}) : super(key: key);

  @override
  State<TaxExtracted> createState() => _TaxExtractedState();
}

class _TaxExtractedState extends State<TaxExtracted> {
  Color background = const Color.fromARGB(255, 41, 45, 50);
  Color gold = const Color.fromARGB(255, 255, 203, 116);
  bool fileGenerationClicked = false;
  bool isContactClicked = false;

  final formatCurrency = NumberFormat.currency(
      name: "INR", locale: "HI", symbol: "₹ ", decimalDigits: 2);

  openUrl(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw "Could not launch $url";
    }
  }

  sendEmail() async {
    final Email email = Email(
      subject: 'Contacting Support for 3Tax Calculation',
      recipients: ['help@3pay.club'],
      isHTML: false,
    );

    await FlutterEmailSender.send(email);
  }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as TaxExtractedArgs;
    List<TokenTax> allTaxes = args.allTaxes;

    double totalTax = args.totalTax;
    double totalProfits = args.totalProfits;
    return Material(
        color: background,
        child: SafeArea(
            child: Container(
                decoration: BoxDecoration(color: background),
                child: SingleChildScrollView(
                    child: Container(
                  padding: const EdgeInsets.all(25),
                  width: MediaQuery.of(context).size.width - 50,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          BackNeuButton(),
                          Spacer(),
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
                                padding: EdgeInsets.all(
                                    isContactClicked ? 2.0 : 4.0),
                                child: Container(
                                    decoration: BoxDecoration(
                                      color: Color.fromARGB(220, 64, 148, 165),
                                      borderRadius: BorderRadius.circular(8.0),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.white.withOpacity(
                                              isContactClicked ? 0.5 : 0.3),
                                          offset: const Offset(2.0, 2.0),
                                          blurRadius: 3.0,
                                        ),
                                        BoxShadow(
                                          color: Colors.black.withOpacity(
                                              isContactClicked ? 1.0 : 0.8),
                                          offset: const Offset(-2.0, -2.0),
                                          blurRadius: 3.0,
                                        ),
                                      ],
                                    ),
                                    child: Container(
                                      padding: EdgeInsets.symmetric(
                                          vertical: isContactClicked ? 12 : 10,
                                          horizontal:
                                              isContactClicked ? 22 : 20),
                                      child: Text(
                                        'contact us',
                                        style: GoogleFonts.montserrat(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 10,
                                          color: Colors.white,
                                        ),
                                      ),
                                    )),
                              ),
                            ),
                            onTap: () => {
                              setState(() {
                                isContactClicked = true;
                              }),
                              Timer(
                                  Duration(milliseconds: 400),
                                  () => {
                                        setState(() {
                                          isContactClicked = false;
                                        })
                                      }),
                              sendEmail()
                            },
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Container(
                            margin: const EdgeInsets.only(top: 30),
                            width: MediaQuery.of(context).size.width - 50,
                            child: Row(
                              children: [
                                Text(
                                  'such profits',
                                  style: GoogleFonts.montserrat(
                                    fontWeight: FontWeight.w900,
                                    fontSize: 35,
                                    color: gold,
                                  ),
                                ),
                                Image.asset(
                                  'assets/images/doge.png',
                                  width: 35,
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                      Row(
                        children: [
                          Container(
                            margin: const EdgeInsets.only(top: 5),
                            width: MediaQuery.of(context).size.width - 50,
                            child: Text(
                              'much wow',
                              style: GoogleFonts.montserrat(
                                fontWeight: FontWeight.w200,
                                fontSize: 20,
                                color: Colors.white,
                              ),
                            ),
                          )
                        ],
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 40),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: EdgeInsets.all(2),
                              child: Text(
                                formatCurrency.format(totalTax),
                                style: GoogleFonts.montserrat(
                                  fontWeight: FontWeight.w800,
                                  fontSize: 30,
                                  color: gold,
                                ),
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.all(2),
                              child: Text(
                                "total tax",
                                style: GoogleFonts.montserrat(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 16,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 10),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: EdgeInsets.all(2),
                              child: Text(
                                formatCurrency.format(totalProfits),
                                style: GoogleFonts.montserrat(
                                  fontWeight: FontWeight.w800,
                                  fontSize: 30,
                                  color: gold,
                                ),
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.all(2),
                              child: Text(
                                "total profits",
                                style: GoogleFonts.montserrat(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 16,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          InkWell(
                            child: Container(
                              margin: EdgeInsets.only(top: 60),
                              decoration: BoxDecoration(
                                color: const Color.fromARGB(255, 41, 45, 50),
                                borderRadius: BorderRadius.circular(8.0),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.white.withOpacity(0.3),
                                    offset: fileGenerationClicked
                                        ? const Offset(4.0, 4.0)
                                        : const Offset(-4.0, -4.0),
                                    blurRadius: 13.0,
                                  ),
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.8),
                                    offset: fileGenerationClicked
                                        ? const Offset(-6.0, -6.0)
                                        : const Offset(6.0, 6.0),
                                    blurRadius: 13.0,
                                  ),
                                ],
                              ),
                              child: Padding(
                                padding: EdgeInsets.all(4.0),
                                child: Container(
                                    decoration: BoxDecoration(
                                      color: gold,
                                      borderRadius: BorderRadius.circular(8.0),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.white.withOpacity(0.3),
                                          offset: fileGenerationClicked
                                              ? const Offset(-2.0, -2.0)
                                              : const Offset(2.0, 2.0),
                                          blurRadius: 3.0,
                                        ),
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.8),
                                          offset: fileGenerationClicked
                                              ? const Offset(2.0, 2.0)
                                              : const Offset(-2.0, -2.0),
                                          blurRadius: 3.0,
                                        ),
                                      ],
                                    ),
                                    child: Container(
                                      padding: EdgeInsets.symmetric(
                                          vertical: 15, horizontal: 30),
                                      child: Text(
                                        'download 3tax report',
                                        style: GoogleFonts.montserrat(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 13,
                                          color: Colors.black,
                                        ),
                                      ),
                                    )),
                              ),
                            ),
                            onTap: () => {
                              setState(() => {
                                    fileGenerationClicked = true,
                                    Timer(
                                        Duration(milliseconds: 400),
                                        () => {
                                              setState(() => {
                                                    fileGenerationClicked =
                                                        false
                                                  }),
                                              openUrl(args.pdfUrl)
                                            })
                                  })
                            },
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Container(
                            margin: const EdgeInsets.only(top: 60),
                            width: MediaQuery.of(context).size.width - 50,
                            child: Text(
                              'coin specific profits',
                              style: GoogleFonts.montserrat(
                                fontWeight: FontWeight.w900,
                                fontSize: 25,
                                color: Colors.white,
                              ),
                              textAlign: TextAlign.right,
                            ),
                          )
                        ],
                      ),
                      SizedBox(
                        height: 25,
                      ),
                      Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: allTaxes
                              .mapIndexed((index, coin) => Container(
                                    width:
                                        MediaQuery.of(context).size.width - 50,
                                    margin: EdgeInsets.only(top: 10),
                                    padding: EdgeInsets.all(5),
                                    child: Column(
                                      crossAxisAlignment: index % 2 == 0
                                          ? CrossAxisAlignment.end
                                          : CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          coin.token.toLowerCase(),
                                          style: GoogleFonts.montserrat(
                                            fontWeight: FontWeight.w900,
                                            fontSize: 30,
                                            color: gold,
                                          ),
                                        ),
                                        Text(
                                          "profits - " +
                                              formatCurrency
                                                  .format(coin.totalProfit),
                                          style: GoogleFonts.montserrat(
                                            fontWeight: FontWeight.w400,
                                            fontSize: 18,
                                            color: Colors.white,
                                          ),
                                        ),
                                        Text(
                                          "tax - " +
                                              formatCurrency
                                                  .format(coin.totalTax),
                                          style: GoogleFonts.montserrat(
                                            fontWeight: FontWeight.w400,
                                            fontSize: 18,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ))
                              .toList())
                    ],
                  ),
                )))));
  }
}

class ExchangeStoryPill extends StatefulWidget {
  const ExchangeStoryPill(
      {Key? key,
      required this.numberOfSteps,
      required this.nameOfExchange,
      required this.exchangeLogoUrl,
      required this.sizeOfExchangeLogo})
      : super(key: key);

  final int numberOfSteps;
  final String nameOfExchange;
  final String exchangeLogoUrl;
  final double sizeOfExchangeLogo;

  @override
  State<ExchangeStoryPill> createState() => _ExchangeStoryPillState();
}

class _ExchangeStoryPillState extends State<ExchangeStoryPill> {
  bool isClicked = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
            width: 80,
            height: 80,
            padding: const EdgeInsets.all(5),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(60.0),
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
            child: InkWell(
              child: Container(
                  height: 70,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(60.0),
                    color: Colors.white,
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
                  child: Stack(children: [
                    Center(
                      child: Image.asset(
                        widget.exchangeLogoUrl,
                        width: widget.sizeOfExchangeLogo,
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(60.0),
                        gradient: RadialGradient(
                            colors: const [
                              // Color.fromARGB(255, 37, 143, 132),
                              // Color.fromARGB(255, 27, 72, 82),
                              Color.fromARGB(0, 0, 0, 0),
                              Color.fromARGB(152, 0, 0, 0)
                            ],
                            radius: isClicked ? 0.8 : 1.3,
                            center: !isClicked
                                ? const Alignment(-1, -0.8)
                                : const Alignment(0.4, 0.6)),
                      ),
                    )
                  ])),
              onTap: () => {
                setState(() {
                  isClicked = true;
                }),
                Timer(const Duration(milliseconds: 150), () {
                  setState(() {
                    isClicked = false;
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => StoryPageView(
                                  storyItems: List.generate(
                                      widget.numberOfSteps, (index) {
                                    return StoryItem.pageProviderImage(
                                      AssetImage('assets/images/' +
                                          widget.nameOfExchange +
                                          '/Step' +
                                          (index + 1).toString() +
                                          '.png'),
                                      imageFit: BoxFit.contain,
                                    );
                                  }),
                                )));
                  });
                })
              },
            )),
        Container(
          margin: const EdgeInsets.only(top: 10),
          child: Text(
            widget.nameOfExchange,
            style: GoogleFonts.montserrat(
              fontWeight: FontWeight.w300,
              fontSize: 12,
              color: Colors.white,
            ),
          ),
        )
      ],
    );
  }
}
