import 'package:get/get.dart';
import 'package:help_on_maps/modules/chat/controllers/chat_controller.dart';
import 'package:help_on_maps/services/chat/chat_service.dart';

class ChatBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ChatService());
    Get.lazyPut(() => ChatController(Get.find()));
  }
}