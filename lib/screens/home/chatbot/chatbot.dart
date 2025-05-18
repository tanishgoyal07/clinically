import 'dart:io';
import 'dart:typed_data';

import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:image_picker/image_picker.dart';

import '../../../utils/constant.dart';

class ChatBot extends StatefulWidget {
  const ChatBot({super.key});

  @override
  State<ChatBot> createState() => _ChatBotState();
}

class _ChatBotState extends State<ChatBot> {
  final Gemini gemini = Gemini.instance;
  List<ChatMessage> messages = [];

  ChatUser currentUser = ChatUser(id: "0", firstName: "User");
  ChatUser geminiUser = ChatUser(
    id: "1",
    firstName: "Gemini",
    profileImage:
        "https://seeklogo.com/images/G/google-gemini-logo-A5787B2669-seeklogo.com.png",
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: white,
        centerTitle: true,
        title: const Text(
          "ChatBot",
          style: TextStyle(
            color: black,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: _buildUI(),
    );
  }

  Widget _buildUI() {
    return DashChat(
      inputOptions: InputOptions(trailing: [
        IconButton(
          onPressed: _sendMediaMessage,
          icon: const Icon(Icons.image),
        ),
      ]),
      currentUser: currentUser,
      onSend: _sendTextMessage,
      messages: messages,
    );
  }

  /// Extracts text response from Candidates
  String _extractTextFromCandidates(Candidates candidates) {
    if (candidates.content?.parts?.isEmpty ?? true) {
      return "No response from Gemini.";
    }

    return candidates.content!.parts!
        .map((part) => part.text ?? "")
        .join("\n\n");
  }

  /// Handles text-only messages
  void _sendTextMessage(ChatMessage chatMessage) {
    setState(() {
      messages = [chatMessage, ...messages];
    });

    String question = chatMessage.text;

    try {
      gemini.streamGenerateContent(question).listen((candidates) {
        String response = _extractTextFromCandidates(candidates);

        if (response.isNotEmpty) {
          ChatMessage message = ChatMessage(
            user: geminiUser,
            createdAt: DateTime.now(),
            text: response,
          );
          setState(() {
            messages = [message, ...messages];
          });
        }
      });
    } catch (e) {
      print("Error: $e");
    }
  }

  /// Handles image-based messages
  void _sendMediaMessage() async {
    ImagePicker picker = ImagePicker();
    XFile? file = await picker.pickImage(source: ImageSource.gallery);

    if (file != null) {
      ChatMessage chatMessage = ChatMessage(
        user: currentUser,
        createdAt: DateTime.now(),
        text: "Describe this picture?",
        medias: [
          ChatMedia(
            url: file.path,
            fileName: "",
            type: MediaType.image,
          )
        ],
      );

      setState(() {
        messages = [chatMessage, ...messages];
      });

      try {
        Uint8List imageBytes = File(file.path).readAsBytesSync();
        gemini.streamGenerateContent("Describe this image", images: [imageBytes]).listen((candidates) {
          String response = _extractTextFromCandidates(candidates);

          if (response.isNotEmpty) {
            ChatMessage message = ChatMessage(
              user: geminiUser,
              createdAt: DateTime.now(),
              text: response,
            );
            setState(() {
              messages = [message, ...messages];
            });
          }
        });
      } catch (e) {
        print("Error: $e");
      }
    }
  }
}
