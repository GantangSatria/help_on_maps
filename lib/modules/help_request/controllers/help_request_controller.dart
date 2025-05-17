import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:latlong2/latlong.dart';
import 'package:location/location.dart';
import 'package:help_on_maps/data/models/help_request.dart';

class HelpRequestController extends GetxController {
  var isLoading = false.obs;

  Future<void> createHelpRequest({
    required String title,
    required String description,
  }) async {
    isLoading.value = true;

    final location = Location();
    final locData = await location.getLocation();

    final user = FirebaseAuth.instance.currentUser;

    final helpRequest = HelpRequest(
      id: '', 
      userId: user?.uid ?? '',
      title: title,
      description: description,
      location: LatLng(locData.latitude!, locData.longitude!),
      createdAt: DateTime.now(),
      status: 'active',
      helperId: null,
    );

    await FirebaseFirestore.instance.collection('help_requests').add(helpRequest.toMap());

    isLoading.value = false;
  }
}