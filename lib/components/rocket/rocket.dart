import 'package:cleaner/constants.dart';
import 'package:flutter/material.dart';
import 'package:rive/rive.dart';

class Rocket extends StatelessWidget {
  const Rocket({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: BackgroundColor,
      body: Container(
        child: Center(
          child: RiveAnimation.asset('assets/animations/rocket.riv'),
        ),
      ),
    );
  }
}
