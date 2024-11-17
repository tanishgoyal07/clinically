import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart' as launcher;

import 'package:scaitica/screens/bottom_bar.dart';
import 'package:scaitica/services/auth_services.dart';
import 'package:scaitica/utils/constant.dart';
import 'package:scaitica/utils/gauge_indicator.dart';
import 'package:scaitica/widgets/box/square_box.dart';

class MyRPofileScreen extends StatefulWidget {
  const MyRPofileScreen({super.key});

  @override
  State<MyRPofileScreen> createState() => _MyRPofileScreenState();
}

class _MyRPofileScreenState extends State<MyRPofileScreen> {
  bool isNotification = true;

  @override
  void initState() {
    super.initState();
  }

  signingOutDialogBox() {
    return showDialog(
      context: context,
      builder: (context) {
        return SimpleDialog(
          elevation: 0,
          alignment: Alignment.center,
          title: const Text(
            "Are you sure to logout?",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          children: [
            SimpleDialogOption(
              padding: const EdgeInsets.all(15),
              child: const Text(
                "Yes, Logout",
                style: TextStyle(
                  fontSize: 14,
                ),
              ),
              onPressed: () => AuthServices().logout(context),
            ),
            SimpleDialogOption(
              padding: const EdgeInsets.all(15),
              child: const Text(
                "No, take me back!",
                style: TextStyle(
                  fontSize: 14,
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> sendEmail() async {

    final Uri emailUri = Uri(
      scheme: 'mailto',
      path: 'goyaltanish789@gmail.com',
    );

    launcher.launchUrl(emailUri);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: white,
        centerTitle: true,
        title: const Text(
          "My Profile",
          style: TextStyle(
            color: black,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        physics: const NeverScrollableScrollPhysics(),
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(
                  top: 10.0,
                  left: 8.0,
                  right: 8.0,
                  bottom: 10.0,
                ),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Colors.white,
                    backgroundImage: NetworkImage(
                      loggedInUser.image,
                    ),
                    radius: 30,
                  ),
                  title: Text(
                    loggedInUser.name,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  subtitle: Text(
                    loggedInUser.email,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  trailing: TextButton(
                    onPressed: () {},
                    child: Container(
                      width: 40,
                      height: 20,
                      decoration: BoxDecoration(
                        color: color4,
                        borderRadius: BorderRadius.circular(
                          20,
                        ),
                      ),
                      child: const Center(
                        child: Text(
                          "Edit",
                          style: TextStyle(
                            color: white,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Row(
                children: [
                  SquareBox(
                    title: loggedInUser.gender,
                    subTitle: "Gender",
                    width: 224,
                  ),
                  SquareBox(
                    title: "${loggedInUser.age}yo",
                    subTitle: "Age",
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  SquareBox(
                    title: "${loggedInUser.height} cm",
                    subTitle: "Height",
                  ),
                  SquareBox(
                    title: "${loggedInUser.weight} kg",
                    subTitle: "Weight",
                  ),
                  SquareBox(
                    title: bmi.round().toString(),
                    subTitle: "BMI",
                  ),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  // height: 100,
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(
                      20,
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Padding(
                        padding: EdgeInsets.only(
                          left: 12.0,
                          top: 8.0,
                        ),
                        child: Text(
                          "Notification",
                          style: TextStyle(
                            fontSize: 24,
                            color: black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Padding(
                        padding:
                            const EdgeInsets.only(left: 12.0, bottom: 10.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Row(
                              children: [
                                Icon(
                                  Icons.notifications_outlined,
                                  color: color1,
                                  size: 30,
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  "Pop-up Notification",
                                  style: TextStyle(
                                    color: color10,
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.only(right: 8.0),
                              child: Switch(
                                value: isNotification,
                                activeColor: color14,
                                onChanged: (bool value) {
                                  setState(() {
                                    isNotification = value;
                                  });
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 8,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  // height: 200,
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(
                      20,
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Padding(
                        padding: EdgeInsets.only(
                          left: 12.0,
                          top: 8.0,
                        ),
                        child: Text(
                          "Other",
                          style: TextStyle(
                            fontSize: 24,
                            color: black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 12.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Row(
                              children: [
                                Icon(
                                  Icons.mail_outline_rounded,
                                  color: color1,
                                  size: 30,
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  "Contact Us",
                                  style: TextStyle(
                                    color: color10,
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.only(right: 8.0),
                              child: IconButton(
                                onPressed: sendEmail,
                                icon: const Icon(
                                    Icons.keyboard_arrow_right_rounded),
                                color: color1,
                                iconSize: 30,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 12.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Row(
                              children: [
                                Icon(
                                  Icons.settings,
                                  color: color1,
                                  size: 30,
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  "Settings",
                                  style: TextStyle(
                                    color: color10,
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.only(right: 8.0),
                              child: IconButton(
                                onPressed: () {},
                                icon: const Icon(
                                    Icons.keyboard_arrow_right_rounded),
                                color: color1,
                                iconSize: 30,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding:
                            const EdgeInsets.only(left: 12.0, bottom: 10.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Row(
                              children: [
                                Icon(
                                  Icons.logout,
                                  color: color1,
                                  size: 30,
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  "Logout",
                                  style: TextStyle(
                                    color: color10,
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.only(right: 8.0),
                              child: IconButton(
                                onPressed: signingOutDialogBox,
                                icon: const Icon(
                                    Icons.keyboard_arrow_right_rounded),
                                color: color1,
                                iconSize: 30,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
