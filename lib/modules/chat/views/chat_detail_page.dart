import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:help_on_maps/modules/chat/controllers/chat_controller.dart';
import 'package:help_on_maps/modules/chat/widgets/chat_bubble.dart';

class ChatDetailPage extends StatelessWidget {
  // final String chatId;
  // final String otherUserId;
  ChatDetailPage({super.key});

  final chatController = Get.find<ChatController>();
  final TextEditingController _msgController = TextEditingController();
  final ScrollController _scrollCtrl = ScrollController();

  void _scrollToBottom() {
    if (_scrollCtrl.hasClients) {
      _scrollCtrl.animateTo(
        _scrollCtrl.position.maxScrollExtent,
        duration: Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final args = Get.arguments as Map<String, dynamic>;
    final chatId = args['chatId'] as String;
    final otherUserId = args['otherUserId'] as String;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      chatController.listenMessages(chatId);
      chatController.messages.listen((_) {
        _scrollToBottom();
      });
    });

    return Scaffold(
      appBar: AppBar(
        title: FutureBuilder<String>(
          future: chatController.userName(otherUserId),
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
                  controller: _scrollCtrl,
                  itemCount: chatController.messages.length,
                  itemBuilder: (context, index) {
                    final msg = chatController.messages[index];
                    return ChatBubble(
                      text: msg.text,
                      isMe:
                          msg.senderId ==
                          FirebaseAuth.instance.currentUser?.uid,
                      timestamp: msg.timestamp,
                    );
                  },
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 8.0,
                vertical: 12.0,
              ),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(30.0),
                ),
                child: Row(
                  children: [
                    const SizedBox(width: 16),
                    Expanded(
                      child: TextField(
                        controller: _msgController,
                        decoration: InputDecoration(
                          hintText: 'Send a message...',
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.zero,
                          hintStyle: TextStyle(color: Colors.grey[600]),
                        ),
                        keyboardType: TextInputType.multiline,
                        maxLines: null,
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.send),
                      color: Colors.blueAccent,
                      onPressed: () {
                        if (_msgController.text.trim().isNotEmpty) {
                          chatController.send(
                            chatId,
                            _msgController.text.trim(),
                          );
                          _msgController.clear();
                        }
                      },
                    ),
                    const SizedBox(width: 8),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
