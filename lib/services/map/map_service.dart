import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:help_on_maps/data/models/help_request.dart';
import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart';
import 'package:location/location.dart';

class MapService {
  final _location  = Location();
  final _helpCol   = FirebaseFirestore.instance.collection('help_requests');
  final _orsKey    = dotenv.env['ORS_API_KEY'];


  Stream<LatLng> get location$ async* {
    if (!await _ensurePerms()) return;
    yield* _location.onLocationChanged.map(
      (locData) => LatLng(locData.latitude!, locData.longitude!),
    );
  }

  Future<LatLng?> getCurrent() async {
    if (!await _ensurePerms()) return null;
    final locData = await _location.getLocation();
    return LatLng(locData.latitude!, locData.longitude!);
  }

  Future<bool> _ensurePerms() async {
    if (!await _location.serviceEnabled()) {
      if (!await _location.requestService()) return false;
    }
    var perm = await _location.hasPermission();
    if (perm == PermissionStatus.denied) {
      perm = await _location.requestPermission();
    }
    return perm == PermissionStatus.granted;
  }

    // _locationStream = _location.onLocationChanged;
    // _locationStream.listen((locData) {
    //   if (locData.latitude != null && locData.longitude != null) {
    //     currentLocation.value = LatLng(locData.latitude!, locData.longitude!);
    //   }
    // });


  Stream<List<HelpRequest>> get activeRequests$ {
    return _helpCol
        .where('status', isNotEqualTo: 'completed')
        .snapshots()
        .map((s) => s.docs.map(HelpRequest.fromFirestore).toList());
  }


  Future<List<LatLng>> route(LatLng start, LatLng end) async {
    final url =
        'https://api.openrouteservice.org/v2/directions/driving-car'
        '?api_key=$_orsKey&start=${start.longitude},${start.latitude}'
        '&end=${end.longitude},${end.latitude}';

    final res = await http.get(Uri.parse(url));
    if (res.statusCode != 200) throw Exception('ORS error ${res.statusCode}');
    final coords = jsonDecode(res.body)['features'][0]['geometry']['coordinates'];
    return (coords as List)
        .map<LatLng>((c) => LatLng(c[1] as double, c[0] as double))
        .toList();
  }
}
