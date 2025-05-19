import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:help_on_maps/data/models/help_request.dart';
import 'package:help_on_maps/routes/app_pages.dart';
import 'package:help_on_maps/services/chat/chat_service.dart';
import 'package:help_on_maps/services/help_request/help_request_service.dart';

class HelpRequestController extends GetxController {
  final service = HelpRequestService();

  var isLoading = false.obs;
  Stream<List<HelpRequest>> get requestsStream => service.watchActive();

  Future<void> createHelpRequest({
    required String title,
    required String description,
  }) async {
    isLoading.value = true;
    try {
      await service.create(title: title, description: description);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> completeRequest(String requestId) {
    return service.complete(requestId);
  }

  Future<void> offerHelp(String requestId, String requestUserId) async {
    final helperId = FirebaseAuth.instance.currentUser!.uid;

  await service.offerHelp(requestId, helperId);

  final chatId = await Get.find<ChatService>().getOrCreateChatId(requestUserId);

  Get.toNamed(AppPages.chatPageDetail, arguments: {
    'chatId': chatId,
    'otherUserId': requestUserId,
  });
  }
}
