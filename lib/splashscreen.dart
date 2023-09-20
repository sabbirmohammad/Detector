import 'package:flutter/material.dart';
import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:detector/home.dart';

class MySplash extends StatefulWidget {
  const MySplash({Key? key}) : super(key: key);

  @override
  State<MySplash> createState() => _MySplashState();
}

class _MySplashState extends State<MySplash> {
  @override
  Widget build(BuildContext context) {
    return AnimatedSplashScreen(
      duration: 3,
      nextScreen: const Home(),
      splash: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'DETECTOR',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 60,
              ),
            ),
            Image.asset('assets/logo.jpg'),
          ],
        ),
      ),
      backgroundColor: Colors.white,
      splashIconSize: 450,
      splashTransition: SplashTransition.fadeTransition,
      animationDuration: const Duration(seconds: 3),
    );
  }
}