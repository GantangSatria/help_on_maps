import 'package:get/get.dart';
import 'package:help_on_maps/modules/map/controllers/map_controller.dart';
import 'package:help_on_maps/services/map/map_service.dart';

class MapBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => MapService());
    Get.put(MapPageController(Get.find<MapService>()));
  }
}
