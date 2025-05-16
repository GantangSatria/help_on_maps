import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:latlong2/latlong.dart';

class UserModel {
  final String id;
  final String name;
  final String email;
  final List<String> roles; 
  final LatLng? location;
  final String? photoUrl;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.roles,
    this.location,
    this.photoUrl,
  });

  factory UserModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    LatLng? loc;
    if (data['location'] != null) {
      loc = LatLng(
        data['location']['latitude'],
        data['location']['longitude'],
      );
    }
    return UserModel(
      id: doc.id,
      name: data['name'],
      email: data['email'],
      roles: List<String>.from(data['roles']),
      location: loc,
      photoUrl: data['photoUrl'],
    );
  }

  Map<String, dynamic> toMap() => {
        'name': name,
        'email': email,
        'roles': roles,
        if (location != null)
          'location': {
            'latitude': location!.latitude,
            'longitude': location!.longitude,
          },
        'photoUrl': photoUrl,
      };
}
