import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ChatBubble extends StatelessWidget {
  final String text;
  final bool isMe;
  final DateTime timestamp;

  const ChatBubble({
    super.key,
    required this.text,
    required this.isMe, 
    required this.timestamp,
  });

  @override
  Widget build(BuildContext context) {
    final formattedTime = DateFormat('hh:mm a').format(timestamp);
    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: isMe ? Colors.blue[200] : Colors.grey[300],
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(16),
            topRight: const Radius.circular(16),
            bottomLeft: Radius.circular(isMe ? 16 : 0),
            bottomRight: Radius.circular(isMe ? 0 : 16),
          ),
        ),
        child: IntrinsicWidth(
          child: Column(
            crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                text,
                style: TextStyle(
                  color: Colors.black87,
                  fontSize: 15,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                formattedTime,
                style: TextStyle(
                  fontSize: 10,
                  color: isMe ? Colors.black54 : Colors.black45, 
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}