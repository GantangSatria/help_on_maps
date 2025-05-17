import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:help_on_maps/modules/chat/controllers/chat_controller.dart';
import 'package:help_on_maps/modules/chat/widgets/chat_buble.dart';

class ChatDetailPage extends StatelessWidget {
  // final String chatId;
  // final String otherUserId;
  final ChatController controller = Get.find();

  ChatDetailPage({super.key});

  final TextEditingController _msgController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final args = Get.arguments as Map<String, dynamic>;
    final chatId = args['chatId'] as String;
    final otherUserId = args['otherUserId'] as String;

    controller.fetchMessages(chatId);

    return Scaffold(
      appBar: AppBar(title: Text('Chat with $otherUserId')),
      body: Padding(
        padding: EdgeInsets.only(left: 8, right: 8, bottom: 16),
        // const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        child: Column(
          children: [
            Expanded(
              child: Obx(
                () => ListView.builder(
                  itemCount: controller.messages.length,
                  itemBuilder: (context, index) {
                    final msg = controller.messages[index];
                    return ChatBubble(
                      text: msg.text,
                      isMe:
                      msg.senderId == FirebaseAuth.instance.currentUser?.uid,
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
                        controller.sendMessage(
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
