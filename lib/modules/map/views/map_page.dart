import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:help_on_maps/data/models/help_request.dart';
import 'package:get/get.dart';

class MapPage extends StatelessWidget {
  const MapPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('help_requests')
            .where('status', isNotEqualTo: 'completed')
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          return FlutterMap(
            options: MapOptions(
              initialCenter: LatLng(-7.9480831, 112.6198023),
              initialZoom: 15.2,
              onTap: (_, __) {
              },
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.example.app',
              ),
              MarkerLayer(
                markers: snapshot.data?.docs.map((doc) {
                  HelpRequest request = HelpRequest.fromFirestore(doc);
                  return Marker(
                    point: request.location,
                    width: 40,
                    height: 40,
                    child: GestureDetector(
                      onTap: () {
                        _showHelpRequestDetails(request);
                      },
                      child: Icon(
                        Icons.location_on,
                        color: Colors.red,
                        size: 40,
                      ),
                    ),
                  );
                }).toList() ?? [],
              ),
            ],
          );
        },
      ),
    );
  }

  void _showHelpRequestDetails(HelpRequest request) {
    Get.dialog(
      AlertDialog(
        title: Text(request.title),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(request.description),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                Get.back();
                Get.toNamed('/directions', arguments: request.location);
              },
              child: Text('Get Directions'),
            ),
            ElevatedButton(
              onPressed: () {
                Get.back();
                Get.toNamed('/chat', arguments: request.userId);
              },
              child: Text('Chat with User'),
            ),
            SizedBox(height: 16),
            Text('Status: ${request.status}')
          ],
        ),
      ),
    );
  }
}
