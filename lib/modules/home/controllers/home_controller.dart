import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';

class HomeController extends GetxController {
  var selectedIndex = 1.obs;

  var focusLocation = Rxn<LatLng>();
  var highlightRequestId = RxnString();

  void changeTab(int index) {
    selectedIndex.value = index;
  }

    void focusOnRequest(LatLng location, String requestId) {
    focusLocation.value = location;
    highlightRequestId.value = requestId;
    changeTab(0);
  }
}
