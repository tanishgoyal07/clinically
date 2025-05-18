import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:scaitica/screens/bottom_bar.dart';
import 'package:scaitica/screens/home/chatbot/chatbot.dart';
import 'package:scaitica/utils/constant.dart';
import 'package:scaitica/utils/gauge_indicator.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => new _HomePageState();
}

String result = "";

class _HomePageState extends State<HomePage> {
  navigateToChatBot() {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => const ChatBot()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: 250,
              width: MediaQuery.of(context).size.width,
              decoration: const BoxDecoration(
                color: color1,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(30.0),
                  bottomRight: Radius.circular(30.0),
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 20.0, right: 15.0, top: 40),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CircleAvatar(
                          radius: 40,
                          backgroundImage: NetworkImage(
                            loggedInUser.image,
                          ),
                        ),
                        Row(
                          children: [
                            IconButton(
                              onPressed: () {},
                              icon: const Icon(
                                Icons.notifications_outlined,
                                color: Colors.white,
                                size: 22,
                              ),
                            ),
                            IconButton(
                              onPressed: navigateToChatBot,
                              icon: const Icon(
                                Icons.question_answer,
                                color: Colors.white,
                                size: 22,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 20.0),
                    child: Text(
                      "Hi, ${loggedInUser.name}",
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 28,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  const Padding(
                    padding: EdgeInsets.only(left: 20.0),
                    child: Text(
                      "Welcome to Clinically",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10,),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Card(
                color: Color.fromRGBO(189, 224, 254, 1),
                elevation: 5,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: const Padding(
                  padding: EdgeInsets.all(12.0),
                  child: Column(
                    children: [
                      Center(
                        child: Text(
                          "What is Clinically?",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        "Clinically is a personal mobile health companion that aims to enhance your well-being through a supportive and innovative digital platform. Designed to integrate mindfulness and technology, the app provides tools to promote holistic health and foster a global community of wellness enthusiasts.",
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.black87,
                        ),
                        textAlign: TextAlign.justify, 
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 5,),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Card(
                color: Color.fromRGBO(252, 218, 202, 1),
                elevation: 5,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: const Padding(
                  padding: EdgeInsets.all(12.0),
                  child: Column(
                    children: [
                      Center(
                        child: Text(
                          "What do we do?",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        "Clinically offers several key features to support your wellness journey. Its Yoga Pose Assistant uses AI-powered analysis and guided instructions to help you perfect your poses. A Community Platform connects you with like-minded individuals for shared inspiration and growth. Additionally, the Personal Chatbot delivers tailored health tips, motivation, and support to keep you on track with your goals.",
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.black87,
                        ),
                        textAlign: TextAlign.justify, 
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 5,),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Card(
                color: Color.fromRGBO(189, 224, 254, 1),
                elevation: 5,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: const Padding(
                  padding: EdgeInsets.all(12.0),
                  child: Column(
                    children: [
                      Center(
                        child: Text(
                          "Our target audience",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        "Clinically is designed to be user-friendly and accessible for all age groups. It caters to individuals who face challenges in maintaining a healthy routine and are looking for a free service that guides them in performing exercises safely and correctly from the comfort of their homes. With a special focus on spreading awareness about the benefits of yoga, Clinically aims to empower its audience to embrace a healthier lifestyle.",
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.black87,
                        ),
                        textAlign: TextAlign.justify, 
                      ),
                    ],
                  ),
                ),
              ),
            ),
            //BMI
            // Padding(
            //   padding: const EdgeInsets.symmetric(vertical: 25.0, horizontal: 20.0),
            //   child: Container(
            //     height: 230,
            //     width: MediaQuery.of(context).size.width,
            //     decoration: BoxDecoration(
            //       borderRadius: BorderRadius.circular(30.0),
            //       color: color12,
            //     ),
            //     child: Column(
            //       children: [
            //         const SizedBox(
            //           height: 20,
            //         ),
            //         const Text(
            //           "BMI (Body Mass Index)",
            //           style: TextStyle(
            //             fontSize: 24,
            //             color: Colors.white,
            //             fontWeight: FontWeight.bold,
            //           ),
            //         ),
            //         const SizedBox(
            //           height: 10,
            //         ),
            //         result == "" ? const CircularProgressIndicator() : Text(
            //           result,
            //           style: const TextStyle(
            //             fontSize: 20,
            //             color: Colors.white,
            //             fontWeight: FontWeight.w500,
            //           ),
            //         ),
            //          const SizedBox(
            //           height: 15,
            //         ),
            //         const GaugeIndicator(),
            //       ],
            //     ),
            //   ),
            // )
          ],
        ),
      ),
    );
  }
}
