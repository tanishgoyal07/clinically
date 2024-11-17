import 'package:flutter/material.dart';
import 'package:scaitica/utils/constant.dart';

class RectangularButton extends StatelessWidget {
  final String text;
  final VoidCallback onpress;
  final Color color;
  const RectangularButton(
      {super.key, required this.text, required this.onpress, required this.color});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0),
      child: Material(
        elevation: 5,
        borderRadius: BorderRadius.circular(20),
        color: color,
        child: MaterialButton(
            padding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
            minWidth: MediaQuery.of(context).size.width,
            onPressed: onpress,
            child: Text(
              text,
              textAlign: TextAlign.center,
              style: const TextStyle(
                  fontSize: 20, color: white, fontWeight: FontWeight.bold),
            )),
      ),
    );
  }
}
