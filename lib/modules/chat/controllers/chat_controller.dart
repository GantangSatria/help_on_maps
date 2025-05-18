import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:help_on_maps/data/models/chat_model.dart';

class ChatController extends GetxController {
  final currentUser = FirebaseAuth.instance.currentUser;
  var chatUsers = <Map<String, dynamic>>[].obs;
  var messages = <ChatMessage>[].obs;

  void fetchChatUsers() {
    FirebaseFirestore.instance
        .collection('chats')
        .where('participants', arrayContains: currentUser!.uid)
        .snapshots()
        .listen((snapshot) {
      chatUsers.value = snapshot.docs.map((doc) {
        final data = doc.data();
        final otherUserId = (data['participants'] as List)
            .firstWhere((id) => id != currentUser!.uid);
        return {
          'chatId': doc.id,
          'otherUserId': otherUserId,
        };
      }).toList();
    });
  }

  void fetchMessages(String chatId) {
    FirebaseFirestore.instance
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .orderBy('timestamp')
        .snapshots()
        .listen((snapshot) {
      messages.value =
          snapshot.docs.map((doc) => ChatMessage.fromFirestore(doc)).toList();
    });
  }

  Future<void> sendMessage(String chatId, String text) async {
    final msg = ChatMessage(
      id: '',
      chatId: chatId,
      senderId: currentUser!.uid,
      text: text,
      timestamp: DateTime.now(),
    );
    await FirebaseFirestore.instance
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .add(msg.toMap());
  }

  Future<String> getOrCreateChatId(String otherUserId) async {
    final chats = await FirebaseFirestore.instance
        .collection('chats')
        .where('participants', arrayContains: currentUser!.uid)
        .get();

    for (var doc in chats.docs) {
      final participants = List<String>.from(doc['participants']);
      if (participants.contains(otherUserId)) {
        return doc.id;
      }
    }

    final doc = await FirebaseFirestore.instance.collection('chats').add({
      'participants': [currentUser!.uid, otherUserId],
    });
    return doc.id;
  }

  Future<String> getUserName(String userId) async {
  final doc = await FirebaseFirestore.instance.collection('users').doc(userId).get();
  return doc.data()?['name'] ?? 'Unknown';
  }
}