import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:latlong2/latlong.dart';
import 'package:location/location.dart';
import 'package:help_on_maps/data/models/help_request.dart';

class HelpRequestService {
  final _col = FirebaseFirestore.instance.collection('help_requests');
  final _auth = FirebaseAuth.instance;
  final _loc = Location();

  Future<void> create({
    required String title,
    required String description,
  }) async {
    final user = _auth.currentUser;
    if (user == null) {
      throw Exception("Must be logged in to create a request");
    }

    final locData = await _loc.getLocation();
    final lat = locData.latitude;
    final lng = locData.longitude;
    if (lat == null || lng == null) {
      throw Exception("Could not determine location");
    }

    final request = HelpRequest(
      id: '',
      userId: user.uid,
      title: title,
      description: description,
      location: LatLng(lat, lng),
      createdAt: DateTime.now(),
      status: 'active',
      helperId: null,
    );

    await _col.add(request.toMap());
  }

  Stream<List<HelpRequest>> watchActive() {
    return _col
      .where('status', isNotEqualTo: 'completed')
      .orderBy('createdAt', descending: true)
      .snapshots()
      .map((snap) => snap.docs
        .map((doc) => HelpRequest.fromFirestore(doc))
        .toList());
  }

  Future<void> complete(String requestId) {
    return _col.doc(requestId).update({'status': 'completed'});
  }

  Future<void> offerHelp(String requestId, String helperId) {
    return _col.doc(requestId).update({
      'helperId': helperId,
      'status': 'in_progress',
    });
  }
}
