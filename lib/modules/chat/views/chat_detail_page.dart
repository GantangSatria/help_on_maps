import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:help_on_maps/modules/chat/controllers/chat_controller.dart';
import 'package:help_on_maps/modules/chat/widgets/chat_buble.dart';

class ChatDetailPage extends StatelessWidget {
  // final String chatId;
  // final String otherUserId;
  final chatController = Get.put(ChatController());

  ChatDetailPage({super.key});

  final TextEditingController _msgController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final args = Get.arguments as Map<String, dynamic>;
    final chatId = args['chatId'] as String;
    final otherUserId = args['otherUserId'] as String;

    chatController.fetchMessages(chatId);

    return Scaffold(
      appBar: AppBar(
        title: FutureBuilder<String>(
          future: chatController.getUserName(
            otherUserId,
          ),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Text('Loading...');
            }
            return Text('Chat with ${snapshot.data ?? 'Unknown'}');
          },
        ),
      ),
      body: Padding(
        padding: EdgeInsets.only(left: 8, right: 8, bottom: 16),
        child: Column(
          children: [
            Expanded(
              child: Obx(
                () => ListView.builder(
                  itemCount: chatController.messages.length,
                  itemBuilder: (context, index) {
                    final msg = chatController.messages[index];
                    return ChatBubble(
                      text: msg.text,
                      isMe:
                          msg.senderId ==
                          FirebaseAuth.instance.currentUser?.uid,
                    );
                  },
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _msgController,
                      decoration: InputDecoration(hintText: 'Type a message'),
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.send),
                    onPressed: () {
                      if (_msgController.text.trim().isNotEmpty) {
                        chatController.sendMessage(
                          chatId,
                          _msgController.text.trim(),
                        );
                        _msgController.clear();
                      }
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
