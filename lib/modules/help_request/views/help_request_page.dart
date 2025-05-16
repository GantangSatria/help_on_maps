import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:help_on_maps/data/models/help_request.dart';

class HelpRequestPage extends StatelessWidget {
  const HelpRequestPage({super.key});
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('help_requests')
              .where('status', isEqualTo: 'active')
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
                    subtitle: Text(request.description),
                    trailing: ElevatedButton(
                      onPressed: () => _offerHelp(request),
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
        onPressed: () => Get.toNamed('/create-help-request'),
        child: Icon(Icons.add),
      ),
    );
  }

  void _offerHelp(HelpRequest request) {
    // Update the help request with the helper's ID
    FirebaseFirestore.instance
        .collection('help_requests')
        .doc(request.id)
        .update({
      'helperId': FirebaseAuth.instance.currentUser?.uid,
      'status': 'in_progress',
    });

    // Navigate to chat with the user
    Get.toNamed('/chat', arguments: request.userId);
  }
}