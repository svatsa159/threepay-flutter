import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class BackNeuButton extends StatefulWidget {
  const BackNeuButton({
    Key? key,
  }) : super(key: key);

  @override
  State<BackNeuButton> createState() => _BackNeuButtonState();
}

class _BackNeuButtonState extends State<BackNeuButton> {
  bool isBackClicked = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      child: Container(
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 41, 45, 50),
          borderRadius: BorderRadius.circular(8.0),
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
          padding: const EdgeInsets.all(3),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8.0),
              color: const Color.fromARGB(255, 41, 45, 50),
              boxShadow: isBackClicked
                  ? [
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
                    ]
                  : [],
            ),
            padding: const EdgeInsets.all(10.0),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.0),
                color: const Color.fromARGB(255, 41, 45, 50),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                child: const Icon(
                  CupertinoIcons.arrow_left,
                  size: 20,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
        // Image.asset('assets/images/3PayCard.png')
      ),
      onTap: () => {
        setState(() {
          isBackClicked = true;
          Timer(const Duration(milliseconds: 150), () {
            setState(() {
              isBackClicked = false;
            });
            Navigator.pop(context);
          });
        })
      },
    );
  }
}
