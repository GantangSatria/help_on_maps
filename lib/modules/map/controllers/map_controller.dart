import 'dart:convert';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';
import 'package:http/http.dart' as http;
import 'package:location/location.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class MapPageController extends GetxController {
  final orsApiKey = dotenv.env['ORS_API_KEY'];
  var currentLocation = Rxn<LatLng>();
  var routePoints = <LatLng>[].obs;
  late final Location _location;
  // late final Stream<LocationData> _locationStream;
  LatLng? _destination;

  @override
  void onInit() {
    super.onInit();
    // getCurrentLocation();
    _location = Location();
    _listenToLocation();
  }

  void _listenToLocation() async {
    bool serviceEnabled = await _location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await _location.requestService();
      if (!serviceEnabled) return;
    }

    PermissionStatus permissionGranted = await _location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await _location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) return;
    }

    // _locationStream = _location.onLocationChanged;
    // _locationStream.listen((locData) {
    //   if (locData.latitude != null && locData.longitude != null) {
    //     currentLocation.value = LatLng(locData.latitude!, locData.longitude!);
    //   }
    // });

    _location.onLocationChanged.listen((locData) {
      if (locData.latitude != null && locData.longitude != null) {
        currentLocation.value = LatLng(locData.latitude!, locData.longitude!);
        if (_destination != null) {
          getRoute(_destination!);
        }
      }
    });
  }

  Future<void> getCurrentLocation() async {
    final location = Location();
    final locData = await location.getLocation();
    currentLocation.value = LatLng(locData.latitude!, locData.longitude!);
  }

  Future<void> getRoute(LatLng destination) async {
    final start = currentLocation.value;
    if (start == null) return;
    _destination = destination;
    final url =
        'https://api.openrouteservice.org/v2/directions/driving-car?api_key=$orsApiKey&start=${start.longitude},${start.latitude}&end=${destination.longitude},${destination.latitude}';

    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final coords = data['features'][0]['geometry']['coordinates'] as List;
      routePoints.value =
          coords
              .map<LatLng>((c) => LatLng(c[1] as double, c[0] as double))
              .toList();
    } else {
      Get.snackbar('Error', 'Failed to get route');
    }
  }
}
