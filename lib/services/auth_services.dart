import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:scaitica/screens/bottom_bar.dart';
import 'package:scaitica/screens/intro/onboarding_screen.dart';
import 'package:scaitica/model/user_model.dart';
import 'package:scaitica/screens/auth/signIn_screen.dart';
import 'package:scaitica/services/storageMethods.dart';

String? displayName = "";
String? userUid = "";
String? userEmail = "";

class AuthServices {
  void signIn(String email, String password, GlobalKey<FormState> formKey,
      BuildContext context) async {
    final auth = FirebaseAuth.instance;
    String? errorMessage;

    if (formKey.currentState!.validate()) {
      try {
        await auth
            .signInWithEmailAndPassword(email: email, password: password)
            .then((uid) => {
                  Fluttertoast.showToast(msg: "Login Successful"),
                  Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (context) => BottomBar())),
                });
      } on FirebaseAuthException catch (error) {
        switch (error.code) {
          case "invalid-email":
            errorMessage = "Your email address appears to be malformed.";

            break;
          case "wrong-password":
            errorMessage = "Your password is wrong.";
            break;
          case "user-not-found":
            errorMessage = "User with this email doesn't exist.";
            break;
          case "user-disabled":
            errorMessage = "User with this email has been disabled.";
            break;
          case "too-many-requests":
            errorMessage = "Too many requests";
            break;
          case "operation-not-allowed":
            errorMessage = "Signing in with Email and Password is not enabled.";
            break;
          default:
            errorMessage = "An undefined Error happened.";
        }
        Fluttertoast.showToast(msg: errorMessage);
        print(error.code);
      }
    }
  }

  void signInWithGoogle(BuildContext context) async {
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    final GoogleSignInAuthentication googleAuth =
        await googleUser!.authentication;

    final AuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    UserCredential userCredential =
        await FirebaseAuth.instance.signInWithCredential(credential);
    userUid = userCredential.user?.uid; //to store user Id
    displayName = userCredential.user?.displayName; // to store user name
    userEmail = userCredential.user?.email;
    print(displayName);
    print(userUid);
    Navigator.of(context)
        .pushReplacement(MaterialPageRoute(builder: (context) => BottomBar()));

    // final FirebaseAuth _auth = FirebaseAuth.instance;
    // final GoogleSignIn googleSignIn = GoogleSignIn();
    // FirebaseFirestore _firestore = FirebaseFirestore.instance;

    // try {
    //   GoogleSignInAccount? googleSignInAccount = await googleSignIn.signIn();
    //   GoogleSignInAuthentication googleSignInAuthentication =
    //       await googleSignInAccount!.authentication;

    //   AuthCredential credential = GoogleAuthProvider.credential(
    //     accessToken: googleSignInAuthentication.accessToken,
    //     idToken: googleSignInAuthentication.idToken,
    //   );

    //   // AuthResult authResult = await _auth.signInWithCredential(credential);
    //   UserCredential authResult =
    //     await FirebaseAuth.instance.signInWithCredential(credential);
    //   User? user = authResult.user;

    //   // Check if the user's email is registered in the database
    //   QuerySnapshot result = await _firestore
    //       .collection('users')
    //       .where('email', isEqualTo: user?.email)
    //       .get();

    //   if (result.docs.isNotEmpty) {
    //     // User is registered in the database, allow sign-in
    //     Fluttertoast.showToast(msg: 'User signed in with Google: ${user?.displayName}');
    //     Navigator.of(context).pushReplacement(
    //     MaterialPageRoute(builder: (context) => BottomBar()));
    //   } else {
    //     // User not registered in the database, show an error message or take appropriate action
    //     Fluttertoast.showToast(msg: 'User not registered. Please sign up first.');
    //   }
    // } catch (error) {
    //   Fluttertoast.showToast(msg: 'Error signing in with Google');
    //   print('Error signing in with Google: $error');
    // }
  }

  void signUp(String email, String password, String name,
      GlobalKey<FormState> formKey, BuildContext context) async {
    final auth = FirebaseAuth.instance;
    String? errorMessage;

    if (formKey.currentState!.validate()) {
      try {
        await auth
            .createUserWithEmailAndPassword(email: email, password: password)
            .then(
              (value) => {
                Navigator.pushAndRemoveUntil(
                    (context),
                    MaterialPageRoute(
                        builder: (context) => OnBoardingScreen(
                              name: name,
                            )),
                    (route) => false),
                // postDetailsToFirestore(context, name),
              },
            )
            .catchError((e) {
          Fluttertoast.showToast(msg: e!.message);
        });
      } on FirebaseAuthException catch (error) {
        switch (error.code) {
          case "invalid-email":
            errorMessage = "Your email address appears to be malformed.";
            break;
          case "wrong-password":
            errorMessage = "Your password is wrong.";
            break;
          case "user-not-found":
            errorMessage = "User with this email doesn't exist.";
            break;
          case "user-disabled":
            errorMessage = "User with this email has been disabled.";
            break;
          case "too-many-requests":
            errorMessage = "Too many requests";
            break;
          case "operation-not-allowed":
            errorMessage = "Signing in with Email and Password is not enabled.";
            break;
          default:
            errorMessage = "An undefined Error happened.";
        }
        Fluttertoast.showToast(msg: errorMessage);
        print(error.code);
      }
    }
  }

  postDetailsToDatabase(BuildContext context, String age, String height,
      String gender, String weight, String name, Uint8List image) async {
    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    final auth = FirebaseAuth.instance;
    User? user = auth.currentUser;

    String photoUrl = await StorageMethods()
        .uploadImageToStorage('profilePics', image);

    print(photoUrl);

    UserModel userModel = UserModel(
      uid: user!.uid,
      email: user.email!,
      name: name,
      gender: gender,
      age: age,
      height: height,
      weight: weight,
      image: photoUrl,
    );

    await firebaseFirestore
        .collection("users")
        .doc(user.uid)
        .set(userModel.toMap());
    Fluttertoast.showToast(msg: "Profile completed successfully :) ");

    Navigator.pushAndRemoveUntil((context),
        MaterialPageRoute(builder: (context) => BottomBar()), (route) => false);
  }

  // postDetailsToFirestore(BuildContext context, String name) async {
  //   // calling our firestore
  //   // calling our user model
  //   // sedning these values

  //   FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  //   final _auth = FirebaseAuth.instance;
  //   User? user = _auth.currentUser;

  //   UserModel userModel = UserModel();

  //   // writing all the values
  //   userModel.email = user!.email;
  //   userModel.uid = user.uid;
  //   userModel.name = name;
  //   displayName = name;

  //   await firebaseFirestore
  //       .collection("users")
  //       .doc(user.uid)
  //       .set(userModel.toMap());
  //   Fluttertoast.showToast(msg: "Account created successfully :) ");

  //   Navigator.pushAndRemoveUntil(
  //       (context),
  //       MaterialPageRoute(builder: (context) => OnBoardingScreen(name: name,)),
  //       (route) => false);
  // }

  Future<void> logout(BuildContext context) async {
    if (GoogleSignIn().currentUser != null) {
      await FirebaseAuth.instance.signOut();
      await GoogleSignIn().signOut();
    }

    try {
      await FirebaseAuth.instance.signOut();
      await GoogleSignIn().disconnect();
    } catch (e) {
      print('failed to disconnect on signout');
    }
    // await FirebaseAuth.instance.signOut();
    Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const SignInScreen()));
  }
}
