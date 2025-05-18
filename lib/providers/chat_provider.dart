import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:scaitica/model/message_model.dart';
import 'package:scaitica/services/chat_service.dart';

class ChatProvider extends ChangeNotifier {
  List<Message> messages = [];

  Stream<List<Message>> getMessages(String roomName, String currentUser) {
    return ChatService.getMessages(roomName).map((snapshot) => snapshot.docs
        .map((doc) => Message.fromMap(doc.data(), currentUser))
        .toList());
  }

  Future<void> sendMessage(String roomName, String text, String senderName, String senderId) async {
    await ChatService.sendMessage(roomName, text, senderName, senderId);
  }

  Future<void> sendImage(String roomName, String imageUrl, String senderName, String senderId) async {
    await ChatService.sendImage(roomName, imageUrl, senderName, senderId);
  }
}