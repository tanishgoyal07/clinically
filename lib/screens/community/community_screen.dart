import 'package:flutter/material.dart';
import 'package:scaitica/screens/community/chat_screen.dart';
import 'package:scaitica/utils/constant.dart';

class CommunityScreen extends StatefulWidget {
  const CommunityScreen({super.key});

  @override
  State<CommunityScreen> createState() => _CommunityScreenState();
}

class _CommunityScreenState extends State<CommunityScreen> {
  final List<String> chatRooms = ['Yoga Room', 'BackPain Room', 'General Room'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: white,
        centerTitle: true,
        title: const Text(
          "Community",
          style: TextStyle(
            color: black,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(14.0),
        child: ListView.builder(
          itemCount: chatRooms.length,
          itemBuilder: (context, index) {
            return Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              margin: const EdgeInsets.symmetric(vertical: 14),
              child: ListTile(
                contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                leading: CircleAvatar(
                  backgroundColor: Colors.blueAccent.withOpacity(0.8),
                  child: const Icon(Icons.chat, color: Colors.white),
                ),
                title: Text(
                  chatRooms[index],
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                trailing: Icon(Icons.arrow_forward_ios, color: Colors.grey.shade600),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ChatScreen(roomName: chatRooms[index]),
                    ),
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }
}