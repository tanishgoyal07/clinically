import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:scaitica/model/user_model.dart';
import 'package:scaitica/screens/pose_detection/pose_selection_screen.dart';
import 'package:scaitica/screens/community/community_screen.dart';
import 'package:scaitica/screens/home/homePage.dart';
import 'package:scaitica/screens/profile/myProfile_screen.dart';
import 'package:scaitica/utils/gauge_indicator.dart';

class BottomBar extends StatefulWidget {
  int passedIndex;
  BottomBar({
    Key? key,
    this.passedIndex = 0,
  }) : super(key: key);

  @override
  State<BottomBar> createState() => _BottomBarState();
}

UserModel loggedInUser = UserModel(
  uid: '',
  email: '',
  name: '',
  gender: '',
  age: '',
  height: '',
  weight: '',
  image: '',
);

class _BottomBarState extends State<BottomBar> {
  User? user = FirebaseAuth.instance.currentUser;
  int selectedIndex = 0;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    selectedIndex = widget.passedIndex;
    getData();
  }

  getData() async {
    setState(() {
      isLoading = true;
    });
    await FirebaseFirestore.instance
        .collection("users")
        .doc(user!.uid)
        .get()
        .then((value) {
      loggedInUser = UserModel.fromMap(value.data());
      print(loggedInUser);
      setState(() {});
      calculate();
    });
    setState(() {
      isLoading = false;
    });
  }

  void calculate() async {
    double _bmi = 0.0;
    double height = double.parse(loggedInUser.height);
    double weight = double.parse(loggedInUser.weight);

    _bmi = (weight / height / height) * 10000;

    if (_bmi >= 25) {
      setState(() {
        result = "You are Overweight";
      });
    } else if (_bmi >= 18.5) {
      setState(() {
        result = "You have a normal weight";
      });
    } else {
      setState(() {
        result = "You are Underweight";
      });
    }
    setState(() {
      bmi = _bmi;
    });
  }

  void onTapped(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  static final List<Widget> _screens = <Widget>[
    const HomePage(),
    PoseSelectionScreen(),
    const CommunityScreen(),
    const MyRPofileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : Scaffold(
            body: IndexedStack(
              index: selectedIndex,
              children: _screens,
            ),
            bottomNavigationBar: BottomNavigationBar(
              elevation: 0.0,
              items: const <BottomNavigationBarItem>[
                BottomNavigationBarItem(
                  icon: Icon(
                    Icons.home,
                    color: Colors.black,
                  ),
                  label: 'Home',
                ),
                BottomNavigationBarItem(
                  icon: Icon(
                    Icons.sports_gymnastics,
                    color: Colors.black,
                  ),
                  label: 'Workout',
                ),
                BottomNavigationBarItem(
                  icon: Icon(
                    Icons.group_add_rounded,
                    color: Colors.black,
                  ),
                  label: 'Community',
                ),
                BottomNavigationBarItem(
                  icon: Icon(
                    Icons.person,
                    color: Colors.black,
                  ),
                  label: 'My Profile',
                ),
              ],
              currentIndex: selectedIndex,
              selectedItemColor: Colors.black,
              onTap: onTapped,
            ),
          );
  }
}
