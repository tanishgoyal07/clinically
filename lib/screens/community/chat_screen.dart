import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:scaitica/model/message_model.dart';
import 'dart:io';
import 'package:scaitica/providers/chat_provider.dart';
import 'package:scaitica/screens/bottom_bar.dart';
import 'package:scaitica/services/chat_service.dart';
import 'package:scaitica/utils/message_bubble.dart';

class ChatScreen extends StatelessWidget {
  final String roomName;
  ChatScreen({required this.roomName});

  @override
  Widget build(BuildContext context) {
    final chatProvider = Provider.of<ChatProvider>(context, listen: false);
    final user = loggedInUser.uid; // Replace with actual logged-in user ID
    final userName = loggedInUser.name; // Replace with actual logged-in user name

    return Scaffold(
      appBar: AppBar(title: Text(roomName)),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder(
              stream: chatProvider.getMessages(roomName, user),
              builder: (context, AsyncSnapshot<List<Message>> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text("No messages yet"));
                }
                return ListView.builder(
                  reverse: true,
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    return MessageBubble(snapshot.data![index]);
                  },
                );
              },
            ),
          ),
          _buildMessageInput(context, chatProvider, userName, user),
        ],
      ),
    );
  }

  Widget _buildMessageInput(BuildContext context, ChatProvider chatProvider, String userName, String userId) {
    final TextEditingController messageController = TextEditingController();
    
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.image),
            onPressed: () async {
              final picker = ImagePicker();
              final pickedFile = await picker.pickImage(source: ImageSource.gallery);
              if (pickedFile != null) {
                String imageUrl = await ChatService.uploadImage(File(pickedFile.path));
                chatProvider.sendImage(roomName, imageUrl, userName, userId);
              }
            },
          ),
          Expanded(
            child: TextField(
              controller: messageController,
              decoration: const InputDecoration(hintText: 'Type a message...'),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.send),
            onPressed: () {
              if (messageController.text.isNotEmpty) {
                chatProvider.sendMessage(roomName, messageController.text, userName, userId);
                messageController.clear();
              }
            },
          ),
        ],
      ),
    );
  }
}