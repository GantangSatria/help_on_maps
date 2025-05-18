import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:help_on_maps/modules/chat/controllers/chat_controller.dart';
import 'package:help_on_maps/routes/app_pages.dart';

class ChatPage extends StatelessWidget {
  final chatController = Get.put(ChatController());

  ChatPage({super.key}) {
    chatController.fetchChatUsers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Chats')),
      body: Obx(() {
        if (chatController.chatUsers.isEmpty) {
          return Center(child: Text('No chats yet.'));
        }
        return ListView.builder(
          itemCount: chatController.chatUsers.length,
          itemBuilder: (context, index) {
            final chat = chatController.chatUsers[index];
            return ListTile(
              leading: CircleAvatar(),
              title: FutureBuilder<String>(
                future: chatController.getUserName(chat['otherUserId']),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Text('Loading...');
                  }
                  return Text(snapshot.data ?? 'Unknown');
                },
              ),
              onTap: () {
                Get.toNamed(
                  AppPages.chatPageDetail,
                  arguments: {
                    'chatId': chat['chatId'],
                    'otherUserId': chat['otherUserId'],
                  },
                );
              },
            );
          },
        );
      }),
    );
  }
}
