import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:help_on_maps/data/models/help_request.dart';
import 'package:help_on_maps/modules/chat/controllers/chat_controller.dart';
import 'package:help_on_maps/routes/app_pages.dart';

class HelpRequestPage extends StatelessWidget {
  HelpRequestPage({super.key});

  final chatController = Get.put(ChatController());
  
  @override
  Widget build(BuildContext context) {
    final currentUserId = FirebaseAuth.instance.currentUser?.uid;
    return Scaffold(
      body: SafeArea(
        child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('help_requests')
              .where('status', isNotEqualTo: 'completed')
              .orderBy('createdAt', descending: true)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }

            return ListView.builder(
              padding: EdgeInsets.all(16),
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                HelpRequest request = HelpRequest.fromFirestore(snapshot.data!.docs[index]);
                return Card(
                  margin: EdgeInsets.only(bottom: 16),
                  child: ListTile(
                    title: Text(request.title),
                    subtitle: Text('${request.description} \nStatus: ${request.status}' ),
                    trailing: ElevatedButton(
                      onPressed: () => _offerHelp(request, currentUserId!),
                      child: Text('Offer Help'),
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Get.toNamed(AppPages.createHelpRequestPage),
        child: Icon(Icons.add),
      ),
    );
  }

  Future<void> _offerHelp(HelpRequest request, String currentUserId) async {
    await FirebaseFirestore.instance
        .collection('help_requests')
        .doc(request.id)
        .update({
      'helperId': currentUserId,
      'status': 'in_progress',
    });

    final chatId = await chatController.getOrCreateChatId(request.userId);

    Get.toNamed(AppPages.chatPageDetail, arguments: {
      'chatId': chatId,
      'otherUserId': request.userId,
    });
  }
}