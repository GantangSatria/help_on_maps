import 'dart:async';
import 'package:get/get.dart';
import 'package:help_on_maps/services/chat/chat_service.dart';
import 'package:timeago/timeago.dart' as timeago;
import '../../../data/models/chat_model.dart';

class ChatController extends GetxController {
  ChatController(this._service);

  final ChatService _service;

  final chats    = <Map<String, dynamic>>[].obs;
  final messages = <ChatMessage>[].obs;

  late final StreamSubscription _chatSub;

  @override
  void onInit() {
    super.onInit();
    _chatSub = _service.chats().listen(chats.assignAll);
  }

  void listenMessages(String chatId) {
    messages.clear();
    _service.messages(chatId).listen(messages.assignAll);
  }

  Future<void> send(String chatId, String text) =>
      _service.sendMessage(chatId, text);

  Future<String> userName(String uid) => _service.userName(uid);

  String timeAgo(DateTime? ts) => ts == null ? '' : timeago.format(ts);

  Future<String> getOrCreateChatId(String otherUid) =>
    _service.getOrCreateChatId(otherUid);

  @override
  void onClose() {
    _chatSub.cancel();
    super.onClose();
  }
}