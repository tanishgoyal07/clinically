import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:scaitica/screens/auth/signUp_screen.dart';
import 'package:scaitica/screens/home/homePage.dart';
import 'package:scaitica/services/auth_services.dart';
import 'package:scaitica/utils/constant.dart';
import 'package:scaitica/widgets/buttons/loader_button.dart';
import 'package:scaitica/widgets/buttons/rectangular_button.dart';
import 'package:scaitica/widgets/textformfields/email_field.dart';
import 'package:scaitica/widgets/textformfields/password_field.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({Key? key}) : super(key: key);

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  bool isLoading = false;

  final _formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            color: white,
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  const Image(
                    image: AssetImage(appLogo),
                    width: 210,
                    height: 210,
                  ),
                  // const CircleAvatar(
                  //   radius: 100,
                  //   backgroundColor: color4,
                  //   backgroundImage: AssetImage("assets/logo.png"),
                  // ),
                  const SizedBox(height: 15),
                  const Padding(
                    padding: const EdgeInsets.only(left: 12.0),
                    child: Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        "Login User",
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  EmailField(emailController: emailController),
                  PasswordField(passwordController: passwordController),
                  InkWell(
                    onTap: () {
                      AuthServices().signInWithGoogle(context);
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8.0,
                        vertical: 8.0,
                      ),
                      child: SizedBox(
                        width: double.infinity,
                        height: 60,
                        child: Card(
                          color: white,
                          elevation: 0.0,
                          shape: RoundedRectangleBorder(
                            side: const BorderSide(width: 1.0),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image(
                                image: AssetImage("assets/google.png"),
                                width: 40,
                                height: 40,
                              ),
                              SizedBox(width: 5),
                              Text(
                                'Login with Google',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  isLoading
                      ? const Loader()
                      : RectangularButton(
                          text: "Login",
                          onpress: () {
                            setState(() {
                              isLoading = true;
                            });
                            AuthServices().signIn(emailController.text,
                                passwordController.text, _formKey, context);
                            setState(() {
                              isLoading = false;
                            });
                          },
                          color: black,
                        ),
                  const SizedBox(height: 15),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        const Text("Don't have an account? "),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const SignUpScreen(),
                              ),
                            );
                          },
                          child: const Text(
                            "Create new",
                            style: TextStyle(
                                color: color1,
                                fontWeight: FontWeight.bold,
                                fontSize: 15),
                          ),
                        )
                      ])
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
