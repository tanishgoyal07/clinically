import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:provider/provider.dart';
import 'package:scaitica/firebase_options.dart';

import 'package:scaitica/screens/intro/splash_screen.dart';
import 'package:scaitica/screens/intro/welcome_screen.dart';
import 'package:scaitica/utils/constant.dart';

import 'providers/chat_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform);
  } catch (e) {
    print('Error during Firebase initialization: $e');
  }
  // await Firebase.initializeApp();
  Gemini.init(
    apiKey: GEMINI_API_KEY,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ChatProvider()),
      ],
      child: MaterialApp(
        title: 'BackPain Sciatica',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        // home : const SplashScreen(),
        home: StreamBuilder<User?>(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.hasError) {
              return Text(snapshot.error.toString());
            }
      
            if (snapshot.connectionState == ConnectionState.active) {
              if (snapshot.data == null) {
                return const WelcomeScreen();
              } else {
                return const SplashScreen();
              }
            }
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(
                  color: color4,
                ),
              );
            } else {
              return const Text("No Error");
            }
          },
        ),
      ),
    );
  }
}
