import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:help_on_maps/data/models/chat_model.dart';

class ChatService {
  final _firestore = FirebaseFirestore.instance;
  final _auth      = FirebaseAuth.instance;

  String get _uid => _auth.currentUser!.uid;

  Stream<List<Map<String, dynamic>>> chats() async* {
    yield* _firestore
        .collection('chats')
        .where('participants', arrayContains: _uid)
        .snapshots()
        .asyncMap((snap) async {
      final list = <Map<String, dynamic>>[];
      for (final doc in snap.docs) {
        final data = doc.data();
        final other = (data['participants'] as List)
            .firstWhere((id) => id != _uid);

        list.add({
          'chatId'            : doc.id,
          'otherUserId'       : other,
          'lastMessageText'   : data['lastMessageText']   ?? 'Start chatting…',
          'lastMessageTimestamp':
              (data['lastMessageTimestamp'] as Timestamp?)?.toDate(),
        });
      }
      return list;
    });
  }

  Stream<List<ChatMessage>> messages(String chatId) {
    return _firestore
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .orderBy('timestamp')
        .snapshots()
        .map((s) => s.docs.map(ChatMessage.fromFirestore).toList());
  }

  Future<void> sendMessage(String chatId, String text) async {
    final msg = ChatMessage(
      id: '',
      chatId: chatId,
      senderId: _uid,
      text: text,
      timestamp: DateTime.now(),
    );

    final chatRef = _firestore.collection('chats').doc(chatId);
    final batch   = _firestore.batch();

    final msgRef  = chatRef.collection('messages').doc();
    batch.set(msgRef, msg.toMap());

    batch.update(chatRef, {
      'lastMessageText'      : text,
      'lastMessageTimestamp' : FieldValue.serverTimestamp(),
    });

    await batch.commit();
  }

  Future<String> getOrCreateChatId(String otherUid) async {
    final existing = await _firestore
        .collection('chats')
        .where('participants', arrayContains: _uid)
        .get();

    for (final doc in existing.docs) {
      final parts = List<String>.from(doc['participants']);
      if (parts.contains(otherUid)) return doc.id;
    }

    final ref = await _firestore.collection('chats').add({
      'participants'        : [_uid, otherUid],
      'lastMessageText'     : 'Start chatting…',
      'lastMessageTimestamp': FieldValue.serverTimestamp(),
    });
    return ref.id;
  }

Future<String> userName(String uid) async {
  if (uid.isEmpty) {
    return 'Unknown User';
  }
  final doc = await _firestore.collection('users').doc(uid).get();
  if (doc.exists && doc.data() != null) {
    return doc.data()!['name'] ?? 'Unknown User';
  } else {
    return 'Unknown User';
  }
}
}
