import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:help_on_maps/data/models/help_request.dart';
import 'package:help_on_maps/modules/chat/controllers/chat_controller.dart';
import 'package:help_on_maps/modules/home/controllers/home_controller.dart';
import 'package:help_on_maps/routes/app_pages.dart';
import 'package:help_on_maps/services/chat/chat_service.dart';

class HelpRequestPage extends StatelessWidget {
  HelpRequestPage({super.key});

  final ChatService chatService = Get.put(ChatService());
  final chatController = Get.put(ChatController(Get.find()));
  final homeController = Get.find<HomeController>();

  @override
  Widget build(BuildContext context) {
    final currentUserId = FirebaseAuth.instance.currentUser?.uid;
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    'Peoples Need Help',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                ),
              ],
            ),

            SizedBox(height: 8),

            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream:
                    FirebaseFirestore.instance
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
                      HelpRequest request = HelpRequest.fromFirestore(
                        snapshot.data!.docs[index],
                      );
                      final isOwnRequest = request.userId == currentUserId;
                      return Card(
                        margin: EdgeInsets.only(bottom: 16),
                        child: ListTile(
                          title: Text(
                            request.title,
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(request.description),
                              SizedBox(height: 4),
                              FutureBuilder<String>(
                                future: chatController.userName(
                                  request.userId,
                                ),
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return Text('Requester: Loading...');
                                  }
                                  return Text(
                                    'Requester: ${snapshot.data ?? 'Unknown'}',
                                  );
                                },
                              ),
                              SizedBox(height: 4),
                              Text(
                                'Status: ${request.status}',
                                style: TextStyle(fontStyle: FontStyle.italic),
                              ),
                              SizedBox(height: 8),
                              Wrap(
                                spacing: 8,
                                runSpacing: 4,
                                children: [
                                  ElevatedButton(
                                    onPressed:
                                        () =>
                                            _offerHelp(request, currentUserId!),
                                    child: Text('Offer Help'),
                                  ),
                                  ElevatedButton(
                                    onPressed: () {
                                      homeController.focusOnRequest(
                                        request.location,
                                        request.id,
                                      );
                                    },
                                    child: Text('Get Location'),
                                  ),
                                  if (isOwnRequest)
                                    ElevatedButton(
                                      onPressed:
                                          () => _completeRequest(request),
                                      child: Text('Request Completed'),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
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
        .update({'helperId': currentUserId, 'status': 'in_progress'});

    final chatId = await chatController.getOrCreateChatId(request.userId);

    Get.toNamed(
      AppPages.chatPageDetail,
      arguments: {'chatId': chatId, 'otherUserId': request.userId},
    );
  }

  Future<void> _completeRequest(request) async {
    try {
      await FirebaseFirestore.instance
          .collection('help_requests')
          .doc(request.id)
          .update({'status': 'completed'});
      Get.snackbar('Success', 'Request marked as completed');
    } catch (e) {
      Get.snackbar('Error', 'Failed to mark request as completed.');
    }
  }
}
