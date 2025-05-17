import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:help_on_maps/modules/chat/controllers/chat_controller.dart';
import 'package:help_on_maps/routes/app_pages.dart';

class ChatPage extends StatelessWidget {
  final ChatController controller = Get.put(ChatController());

  ChatPage({super.key}) {
    controller.fetchChatUsers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Chats')),
      body: Obx(() {
        if (controller.chatUsers.isEmpty) {
          return Center(child: Text('No chats yet.'));
        }
        return ListView.builder(
          itemCount: controller.chatUsers.length,
          itemBuilder: (context, index) {
            final chat = controller.chatUsers[index];
            return ListTile(
              title: Text(
                'User: ${chat['otherUserId']}',
              ),
              onTap: () {
                Get.toNamed(
                  AppPages.chatPageDetail,
                  arguments: {'chatId': chat['chatId'], 'otherUserId': chat['otherUserId']},
                );
              },
            );
          },
        );
      }),
    );
  }
}
