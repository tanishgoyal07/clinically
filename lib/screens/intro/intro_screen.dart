import 'package:flutter/material.dart';
import 'package:scaitica/screens/auth/signIn_screen.dart';
import 'package:scaitica/utils/constant.dart';
import 'package:scaitica/widgets/buttons/rectangular_button.dart';

class IntroScreen extends StatelessWidget {
  const IntroScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: color8,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(
              "assets/pic2.png",
              width: 400,
              height: 400,
            ),
            const SizedBox(height: 35),
            const Text(
              "Welcome To $appName",
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 15),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                "Your dedicated partner in health and well-being! Let's embark on a path to a healthier, happier you together!",
                style: TextStyle(
                  fontSize: 16,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 35),
            RectangularButton(
              text: "Next >",
              onpress: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const SignInScreen(),
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
