import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';

class ChatService {
  static final FirebaseFirestore _db = FirebaseFirestore.instance;
  static final FirebaseStorage _storage = FirebaseStorage.instance;

  static Stream<QuerySnapshot<Map<String, dynamic>>> getMessages(String roomName) {
    return _db.collection('chatRooms').doc(roomName).collection('messages')
        .orderBy('timestamp', descending: true).snapshots();
  }

  static Future<void> sendMessage(String roomName, String text, String senderName, String senderId) async {
    await _db.collection('chatRooms').doc(roomName).collection('messages').add({
      'text': text,
      'senderName': senderName,
      'senderId': senderId,
      'timestamp': FieldValue.serverTimestamp(),
    });
  }

  static Future<void> sendImage(String roomName, String imageUrl, String senderName, String senderId) async {
    await _db.collection('chatRooms').doc(roomName).collection('messages').add({
      'imageUrl': imageUrl,
      'senderName': senderName,
      'senderId': senderId,
      'timestamp': FieldValue.serverTimestamp(),
    });
  }

  static Future<String> uploadImage(File imageFile) async {
    final ref = _storage.ref().child('chat_images/${DateTime.now().toIso8601String()}');
    await ref.putFile(imageFile);
    return await ref.getDownloadURL();
  }
}