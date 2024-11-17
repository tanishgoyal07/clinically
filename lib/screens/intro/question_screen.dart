import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:scaitica/services/auth_services.dart';
import 'package:scaitica/utils/constant.dart';
import 'package:scaitica/utils/pickImage.dart';
import 'package:scaitica/widgets/buttons/loader_button.dart';
import 'package:scaitica/widgets/buttons/rectangular_button.dart';
import 'package:scaitica/widgets/textformfields/name_field.dart';
import 'package:scaitica/widgets/textformfields/numeric_field.dart';

class QuestionScreen extends StatefulWidget {
  final String name;
  const QuestionScreen({Key? key, required this.name}) : super(key: key);

  @override
  State<QuestionScreen> createState() => _QuestionScreenState();
}

class _QuestionScreenState extends State<QuestionScreen> {
  bool isLoading = false;

  final ageEditingController = TextEditingController();
  final heightEditingController = TextEditingController();
  final weightEditingController = TextEditingController();
  final genderEditingController = TextEditingController();

  Uint8List? profileImage;

  void selectImage(BuildContext context) async {
    Uint8List image = await pickImage(ImageSource.gallery);
    setState(() {
      profileImage = image;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: color5,
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 35),
                // Image.asset(
                //   "assets/support_.png",
                //   width: 150,
                //   height: 150,
                // ),
                // const SizedBox(height: 35),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Text(
                    "Share a bit about yourself to enhance your experience with us",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 30),
                Stack(
                  children: [
                    profileImage != null
                        ? CircleAvatar(
                            radius: 60,
                            backgroundImage: MemoryImage(profileImage!),
                          )
                        : const CircleAvatar(
                            radius: 60,
                            backgroundImage: AssetImage("assets/person.png"),
                          ),
                    Positioned(
                      bottom: -10,
                      left: 80,
                      child: IconButton(
                        onPressed: () {
                          selectImage(context);
                        },
                        icon: const Icon(Icons.add_a_photo),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                NameField(
                  nameController: genderEditingController,
                  text: "Gender",
                ),
                NumericField(
                    controller: ageEditingController,
                    text: "Age",
                    iconn: const Icon(Icons.edit_calendar)),
                NumericField(
                  controller: heightEditingController,
                  text: "Height (in cms)",
                  iconn: const Icon(Icons.height),
                ),
                NumericField(
                  controller: weightEditingController,
                  text: "Weight (in kg)",
                  iconn: const Icon(Icons.monitor_weight),
                ),
                const SizedBox(
                  height: 10,
                ),
                isLoading
                    ? const Loader()
                    : RectangularButton(
                        text: "Submit",
                        onpress: () {
                          setState(() {
                            isLoading = true;
                          });
                          AuthServices().postDetailsToDatabase(
                            context,
                            ageEditingController.text,
                            heightEditingController.text,
                            genderEditingController.text,
                            weightEditingController.text,
                            widget.name,
                            profileImage!,
                          );
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
    );
  }
}
