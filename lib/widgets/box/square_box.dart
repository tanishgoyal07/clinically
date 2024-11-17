import 'package:flutter/material.dart';
import 'package:scaitica/utils/constant.dart';

class SquareBox extends StatelessWidget {
  double width;
  final String title;
  final String subTitle;
  SquareBox(
      {super.key,
      required this.title,
      required this.subTitle,
      this.width = 100});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        width: width,
        height: 55,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(
            20,
          ),
          color: Colors.grey[100],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(
              height: 3,
            ),
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: color1,
              ),
            ),
            const SizedBox(
              height: 5,
            ),
            Text(
              subTitle,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: color10,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
