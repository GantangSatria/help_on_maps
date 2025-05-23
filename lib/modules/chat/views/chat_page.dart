import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:help_on_maps/modules/chat/controllers/chat_controller.dart';
import 'package:help_on_maps/routes/app_pages.dart';

class ChatPage extends StatelessWidget {
  final chatController = Get.find<ChatController>();

  ChatPage({super.key});


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Chats')),
      body: Obx(() {
        if (chatController.chats.isEmpty) {
          return Center(child: Text('No chats yet.'));
        }
        return ListView.builder(
          itemCount: chatController.chats.length,
          itemBuilder: (context, index) {
            final chat = chatController.chats[index];
            final lastMessageText = chat['lastMessageText'] as String;
            final lastMessageTimestamp = chat['lastMessageTimestamp'] as DateTime?;
            return ListTile(
              leading: CircleAvatar(radius: 32),
              title: FutureBuilder<String>(
                future: chatController.userName(chat['otherUserId']),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Text('Loading...');
                  }
                  return Text(snapshot.data ?? 'Unknown', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold));
                },
              ),
              subtitle: Text(
                lastMessageText,
                style: TextStyle(color: Colors.grey[600]),
                maxLines: 1, 
                overflow: TextOverflow.ellipsis,
              ),
              trailing: Text(
                chatController.timeAgo(lastMessageTimestamp), 
                 style: TextStyle(fontSize: 12, color: Colors.grey),
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
