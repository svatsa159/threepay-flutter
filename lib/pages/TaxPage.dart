import 'dart:async';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:path/path.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:story_view/story_view.dart';

import 'package:threepay/components/BackButton.dart';
import 'package:threepay/pages/StoryPageView.dart';

class TaxPage extends StatefulWidget {
  const TaxPage({Key? key}) : super(key: key);

  @override
  State<TaxPage> createState() => _TaxPageState();
}

class _TaxPageState extends State<TaxPage> {
  Color background = const Color.fromARGB(255, 41, 45, 50);
  Color gold = const Color.fromARGB(255, 255, 203, 116);

  bool fileUploadClicked = false;

  File? selectedFile = null;

  @override
  Widget build(BuildContext context) {
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
                Row(
                  children: [
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
                                            await FilePicker.platform
                                                .pickFiles();
                                        if (result != null) {
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
                                : SizedBox(
                                    width: (MediaQuery.of(context).size.width -
                                        92),
                                    child: Column(children: [
                                      const Spacer(),
                                      SizedBox(
                                        height: 158,
                                        child: Flex(
                                          direction: Axis.horizontal,
                                          children: [
                                            Expanded(
                                              flex: 1,
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
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
                                                    basename(selectedFile!.path)
                                                                .length >
                                                            10
                                                        ? basename(selectedFile!
                                                                    .path)
                                                                .substring(
                                                                    0, 10) +
                                                            '...' +
                                                            basename(
                                                                    selectedFile!
                                                                        .path)
                                                                .substring(basename(selectedFile!
                                                                            .path)
                                                                        .length -
                                                                    10)
                                                        : basename(
                                                            selectedFile!.path),
                                                    style:
                                                        GoogleFonts.montserrat(
                                                      fontWeight:
                                                          FontWeight.w300,
                                                      fontSize: 14,
                                                      color: Colors.white,
                                                    ),
                                                    textAlign: TextAlign.center,
                                                  )
                                                ],
                                              ),
                                            ),
                                            Expanded(
                                                flex: 1,
                                                child: Column(
                                                  children: [
                                                    const Spacer(),
                                                    Container(
                                                      height: 40,
                                                      width: 90,
                                                      padding:
                                                          const EdgeInsets.all(
                                                              4),
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10),
                                                        color: const Color
                                                                .fromARGB(
                                                            255, 41, 45, 50),
                                                        boxShadow: [
                                                          BoxShadow(
                                                            color: Colors.white
                                                                .withOpacity(
                                                                    0.2),
                                                            offset:
                                                                const Offset(
                                                                    -2, -2),
                                                            blurRadius: 3.0,
                                                          ),
                                                          BoxShadow(
                                                            color: Colors.black
                                                                .withOpacity(
                                                                    0.5),
                                                            offset:
                                                                const Offset(
                                                                    3.0, 3.0),
                                                            blurRadius: 3.0,
                                                          ),
                                                        ],
                                                      ),
                                                      child: Container(
                                                        height: 32,
                                                        decoration:
                                                            BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(10),
                                                          color: const Color
                                                                  .fromARGB(
                                                              255, 39, 129, 99),
                                                          boxShadow: [
                                                            BoxShadow(
                                                              color: Colors
                                                                  .white
                                                                  .withOpacity(
                                                                      0.2),
                                                              offset:
                                                                  const Offset(
                                                                      2, 2),
                                                              blurRadius: 3.0,
                                                            ),
                                                            BoxShadow(
                                                              color: Colors
                                                                  .black
                                                                  .withOpacity(
                                                                      0.5),
                                                              offset:
                                                                  const Offset(
                                                                      -3.0,
                                                                      -3.0),
                                                              blurRadius: 3.0,
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
                                                              color:
                                                                  Colors.white,
                                                            ),
                                                          ],
                                                        ),
                                                      ),
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
                                                                  .circular(10),
                                                          color: const Color
                                                                  .fromARGB(
                                                              255, 41, 45, 50),
                                                          boxShadow: [
                                                            BoxShadow(
                                                              color: Colors
                                                                  .white
                                                                  .withOpacity(
                                                                      0.2),
                                                              offset:
                                                                  const Offset(
                                                                      -2, -2),
                                                              blurRadius: 3.0,
                                                            ),
                                                            BoxShadow(
                                                              color: Colors
                                                                  .black
                                                                  .withOpacity(
                                                                      0.5),
                                                              offset:
                                                                  const Offset(
                                                                      3.0, 3.0),
                                                              blurRadius: 3.0,
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
                                                                        2, 2),
                                                                blurRadius: 3.0,
                                                              ),
                                                              BoxShadow(
                                                                color: Colors
                                                                    .black
                                                                    .withOpacity(
                                                                        0.5),
                                                                offset:
                                                                    const Offset(
                                                                        -3.0,
                                                                        -3.0),
                                                                blurRadius: 3.0,
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
                                        ),
                                      )
                                    ])),
                          ),
                        ),
                      ),
                    )
                  ],
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
                                sizeOfExchangeLogo: 65),
                          ]),
                    ),
                  ),
                )
              ]),
            ),
          ),
        ),
      ),
    );
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
