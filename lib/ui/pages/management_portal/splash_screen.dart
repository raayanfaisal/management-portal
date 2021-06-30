import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Padding(
            padding:
                const EdgeInsets.all(32).add(const EdgeInsets.only(bottom: 32)),
            child: Hero(
              tag: 'logo',
              child: SvgPicture.asset('assets/logo-full.svg', height: 240),
            ),
          ),
        ),
      ),
    );
  }
}
