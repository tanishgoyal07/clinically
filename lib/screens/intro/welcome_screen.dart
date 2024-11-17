import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:scaitica/screens/intro/intro_screen.dart';
import 'package:scaitica/utils/constant.dart';

class WelcomeScreen extends StatelessWidget{
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AnimatedSplashScreen(
        splash: appLogo,
        nextScreen: const IntroScreen(),
      splashTransition: SplashTransition.fadeTransition,
      backgroundColor: white,
      splashIconSize: 240,
      duration: 2500,
    );
  }
}