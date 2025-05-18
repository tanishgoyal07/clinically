class Message {
  final String text;
  final String senderName;
  final String? imageUrl;
  final bool isMe;
  
  Message({
    required this.text,
    required this.senderName,
    this.imageUrl,
    required this.isMe,
  });
  
  factory Message.fromMap(Map<String, dynamic> data, String currentUser) {
    return Message(
      text: data['text'] ?? '',
      senderName: data['senderName'] ?? 'Unknown',
      imageUrl: data['imageUrl'],
      isMe: data['senderId'] == currentUser,
    );
  }
}