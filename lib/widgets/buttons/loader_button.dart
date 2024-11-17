import 'package:flutter/material.dart';
import 'package:scaitica/utils/constant.dart';

class Loader extends StatelessWidget {
  const Loader({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0),
      child: Material(
        elevation: 5,
        borderRadius: BorderRadius.circular(20),
        color: black,
        child: MaterialButton(
            padding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
            minWidth: MediaQuery.of(context).size.width,
            onPressed: () {},
            child: const CircularProgressIndicator(
              color: white,
            ),
          ),
      ),
    );
  }
}
