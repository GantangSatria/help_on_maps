import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:help_on_maps/modules/map/controllers/map_controller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:help_on_maps/data/models/help_request.dart';
import 'package:get/get.dart';

class MapPage extends StatelessWidget {
  MapPage({super.key});

  final mapPageController = Get.put(MapPageController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() {
        final currentLoc = mapPageController.currentLocation.value;
        if (currentLoc == null) {
          return Center(child: CircularProgressIndicator());
        }
        return StreamBuilder<QuerySnapshot>(
          stream:
              FirebaseFirestore.instance
                  .collection('help_requests')
                  .where('status', isNotEqualTo: 'completed')
                  .snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) return Center(child: CircularProgressIndicator());
            final markers = <Marker>[
              Marker(
                point: currentLoc,
                width: 40,
                height: 40,
                child: Icon(Icons.location_on, color: Colors.blue, size: 40),
              ),
              ...snapshot.data!.docs.map((doc) {
                final request = HelpRequest.fromFirestore(doc);
                return Marker(
                  point: request.location,
                  width: 40,
                  height: 40,
                  child: GestureDetector(
                    onTap: () => _showHelpRequestDetails(context, request),
                    child: Icon(Icons.location_on, color: Colors.red, size: 40),
                  ),
                );
              }),
            ];

            return FlutterMap(
              options: MapOptions(
                initialCenter: currentLoc,
                // initialCenter: LatLng(-7.9480831, 112.6198023),
                initialZoom: 15.2,
                onTap: (_, __) {},
              ),
              children: [
                TileLayer(
                  urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                  userAgentPackageName: 'com.example.app',
                ),
                MarkerLayer(markers: markers),
                  Obx(() => mapPageController.routePoints.isNotEmpty
                    ? PolylineLayer(
                        polylines: [
                          Polyline(
                            points: mapPageController.routePoints,
                            color: Colors.blue,
                            strokeWidth: 4.0,
                          ),
                        ],
                      )
                    : SizedBox.shrink()),
              ],
            );
          },
        );
      }),
    );
  }

  void _showHelpRequestDetails(BuildContext context, HelpRequest request) {
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
                Navigator.of(context).pop();
                mapPageController.getRoute(request.location);
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
            Text('Status: ${request.status}'),
          ],
        ),
      ),
    );
  }
}
