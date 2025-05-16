import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:latlong2/latlong.dart';

class HelpRequest {
  final String id;
  final String userId;
  final String title;
  final String description;
  final LatLng location;
  final DateTime createdAt;
  final String status;
  final String? helperId;

  HelpRequest({
    required this.id,
    required this.userId,
    required this.title,
    required this.description,
    required this.location,
    required this.createdAt,
    required this.status,
    this.helperId,
  });

  factory HelpRequest.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return HelpRequest(
      id: doc.id,
      userId: data['userId'],
      title: data['title'],
      description: data['description'],
      location: LatLng(
        data['location']['latitude'],
        data['location']['longitude'],
      ),
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      status: data['status'],
      helperId: data['helperId'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'title': title,
      'description': description,
      'location': {
        'latitude': location.latitude,
        'longitude': location.longitude,
      },
      'createdAt': Timestamp.fromDate(createdAt),
      'status': status,
      'helperId': helperId,
    };
  }
} 