import 'package:flutter/material.dart';
import 'package:scaitica/utils/constant.dart';

class CommunityScreen extends StatefulWidget {
  const CommunityScreen({super.key});

  @override
  State<CommunityScreen> createState() => _CommunityScreenState();
}

class _CommunityScreenState extends State<CommunityScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: black,
        centerTitle: true,
        title: const Text(
          "Community",
          style: TextStyle(
            color: white,
            fontSize: 24,
          ),
        ),
      ),
      body: const Center(
        child: Text("User Community"),
      ),
    );
  }
}