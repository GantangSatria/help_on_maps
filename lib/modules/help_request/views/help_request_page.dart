import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:help_on_maps/data/models/help_request.dart';
import 'package:help_on_maps/modules/chat/controllers/chat_controller.dart';
import 'package:help_on_maps/modules/help_request/controllers/help_request_controller.dart';
import 'package:help_on_maps/modules/home/controllers/home_controller.dart';
import 'package:help_on_maps/routes/app_pages.dart';
import 'package:help_on_maps/services/chat/chat_service.dart';

class HelpRequestPage extends StatelessWidget {
  HelpRequestPage({super.key});

  final controller = Get.put(HelpRequestController());
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
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.teal.shade100,
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(24),
                  bottomRight: Radius.circular(24),
                ),
              ),
            child: Column(
                children: [
                  Image.asset(
                    'assets/images/HelpMap.png',
                    height: 120,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'People Need Help',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          color: Colors.teal.shade900,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Browse requests nearby and offer your help',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: Colors.teal.shade700,
                        ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    'Request List',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                ),
              ],
            ),

            Expanded(
              child: StreamBuilder<List<HelpRequest>>(
                stream: controller.requestsStream,
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  }

                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }

                  final list = snapshot.data!;
                  if (list.isEmpty) {
                    return const Center(child: Text('No active requests.'));
                  }
                  return ListView.builder(
                    padding: EdgeInsets.all(16),
                    itemCount: list.length,
                    itemBuilder: (context, index) {
                      final request = list[index];
                      final isOwnRequest = request.userId == currentUserId;
                      return Card(
                        color: Colors.teal.shade100,
                        elevation: 3,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
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
                                            controller.offerHelp(request.id, request.userId),
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
                                          () => controller.completeRequest(request.id),
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
        backgroundColor: Colors.teal.shade100,
        child: Icon(Icons.add),
      ),
    );
  }
}
