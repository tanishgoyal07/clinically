import 'package:flutter/material.dart';
import 'package:scaitica/services/auth_services.dart';
import 'package:scaitica/utils/constant.dart';
import 'package:scaitica/widgets/buttons/loader_button.dart';
import 'package:scaitica/widgets/buttons/rectangular_button.dart';
import 'package:scaitica/widgets/textformfields/email_field.dart';
import 'package:scaitica/widgets/textformfields/name_field.dart';
import 'package:scaitica/widgets/textformfields/password_field.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  bool isLoading = false;
  final _formKey = GlobalKey<FormState>();
  // editing Controller
  final nameEditingController = TextEditingController();
  final emailEditingController = TextEditingController();
  final passwordEditingController = TextEditingController();
  final confirmPasswordEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final confirmPasswordField = Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 12.0,
        vertical: 8.0,
      ),
      child: TextFormField(
          autofocus: false,
          controller: confirmPasswordEditingController,
          obscureText: true,
          validator: (value) {
            if (confirmPasswordEditingController.text !=
                passwordEditingController.text) {
              return "Password don't match";
            }
            return null;
          },
          onSaved: (value) {
            confirmPasswordEditingController.text = value!;
          },
          textInputAction: TextInputAction.done,
          decoration: InputDecoration(
            prefixIcon: Icon(Icons.vpn_key),
            contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
            hintText: "Confirm Password",
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          )),
    );

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: black),
          onPressed: () {
            // passing this to our root
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            color: white,
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
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
                  const SizedBox(height: 10),
                  const Padding(
                    padding: EdgeInsets.only(left: 12.0),
                    child: Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        "Create an Account",
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  NameField(nameController: nameEditingController, text: "Name",),
                  EmailField(emailController: emailEditingController),
                  PasswordField(passwordController: passwordEditingController),
                  confirmPasswordField,
                  const SizedBox(
                    height: 10,
                  ),
                  isLoading
                      ? const Loader()
                      : RectangularButton(
                          text: "Register",
                          onpress: () {
                            setState(() {
                              isLoading = true;
                            });
                            AuthServices().signUp(
                                emailEditingController.text,
                                passwordEditingController.text,
                                nameEditingController.text,
                                _formKey,
                                context);
                            setState(() {
                              isLoading = false;
                            });
                          },
                          color: black,
                        ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
