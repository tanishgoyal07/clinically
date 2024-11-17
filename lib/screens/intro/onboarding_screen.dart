import 'package:flutter/material.dart';
import 'package:scaitica/screens/intro/question_screen.dart';
import 'package:scaitica/utils/constant.dart';
import 'package:scaitica/widgets/buttons/rectangular_button.dart';

class OnBoardingScreen extends StatelessWidget {
  final String name;
  const OnBoardingScreen({Key? key, required this.name}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: color7,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(
              "assets/pic1.png",
              width: 250,
              height: 250,
            ),
            const SizedBox(height: 35),
            const Text(
              "Let's get started",
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 15),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                "Empower your wellness journey with our app, merging advanced medical insights and user-friendly features, making your health a top priority!",
                style: TextStyle(
                  fontSize: 14,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 35),
            RectangularButton(
              text: "Let's go",
              onpress: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => QuestionScreen(name: name),
                  ),
                );
              },
              color: black,
            ),
          ],
        ),
      ),
    );
  }
}
