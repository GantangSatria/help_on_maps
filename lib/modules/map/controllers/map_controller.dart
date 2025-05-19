import 'package:get/get.dart';
import 'package:help_on_maps/modules/home/controllers/home_controller.dart';
import 'package:help_on_maps/services/map/map_service.dart';
import 'package:latlong2/latlong.dart';
import '../../../data/models/help_request.dart';
import 'package:rxdart/rxdart.dart';

class MapPageController extends GetxController {
  MapPageController(this.mapService);

  final MapService mapService;
  final HomeController homeController = Get.find<HomeController>();

  final currentLocation = Rxn<LatLng>();
  final routePoints = <LatLng>[].obs;
  final requests = <HelpRequest>[].obs;
  String? get highlightRequestId => homeController.highlightRequestId.value;

  // ignore: unused_field
  LatLng? _destination;

  @override
  void onInit() {
    super.onInit();
    mapService.location$.debounceTime(Duration(seconds: 1)).listen((loc) {
      currentLocation.value = loc;
      if (_destination != null) {
        buildRouteTo(_destination!);
      }
    });
    mapService.activeRequests$.listen(requests);
  }

  Future<void> buildRouteTo(LatLng destination) async {
    final start = currentLocation.value;
    if (start == null) return;
    _destination = destination;
    routePoints.value = await mapService.route(start, destination);
  }
}
