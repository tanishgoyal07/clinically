import 'package:flutter/material.dart';
import 'package:scaitica/model/message_model.dart';

class MessageBubble extends StatelessWidget {
  final Message message;

  const MessageBubble(this.message, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isImageMessage = message.imageUrl != null;

    return Align(
      alignment: message.isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: message.isMe ? Colors.blue[200] : Colors.grey[300],
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment:
              message.isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            Text(
              message.senderName,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.black54,
              ),
            ),
            const SizedBox(height: 5),
            isImageMessage
                ? Image.network(
                    message.imageUrl!,
                    width: 200,
                    height: 200,
                    fit: BoxFit.cover,
                  )
                : Text(
                    message.text,
                    style: TextStyle(fontSize: 16),
                  ),
          ],
        ),
      ),
    );
  }
}
