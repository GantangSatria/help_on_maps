import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:help_on_maps/modules/map/controllers/map_controller.dart';
import 'package:help_on_maps/data/models/help_request.dart';
import 'package:get/get.dart';
import 'package:help_on_maps/services/map/map_service.dart';

class MapPage extends StatelessWidget {
  MapPage({super.key});

  final MapService _mapService = Get.put<MapService>(
    MapService(),
  );

  late final MapPageController controller = Get.put<MapPageController>(
    MapPageController(_mapService),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() {
        final currentLoc = controller.currentLocation.value;
        if (currentLoc == null) {
          return const Center(child: CircularProgressIndicator());
        }
        final highlightId = controller.homeController.highlightRequestId.value;

        final markers = <Marker>[
          Marker(
            point: currentLoc,
            width: 40,
            height: 40,
            child: const Icon(Icons.my_location, color: Colors.blue, size: 40),
          ),
          ...controller.requests.map((r) {
            final isHighlighted = r.id == highlightId;
            return Marker(
              point: r.location,
              width: isHighlighted ? 50 : 40,
              height: isHighlighted ? 50 : 40,
              child: GestureDetector(
                onTap: () {
                  _showRequest(context, r);
                },
                child: Icon(
                  Icons.location_on,
                  color: isHighlighted ? Colors.green : Colors.red,
                  size: isHighlighted ? 50 : 40,
                ),
              ),
            );
          }),
        ];

        return FlutterMap(
          options: MapOptions(initialCenter: currentLoc, initialZoom: 15),
          children: [
            TileLayer(
              urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
              userAgentPackageName: 'com.example.app',
            ),
            MarkerLayer(markers: markers),
            if (controller.routePoints.isNotEmpty)
              PolylineLayer(
                polylines: [
                  Polyline(
                    points: controller.routePoints,
                    strokeWidth: 4,
                    color: Colors.blue,
                  ),
                ],
              ),
          ],
        );
      }),
    );
  }

  void _showRequest(BuildContext context, HelpRequest request) {
    Get.dialog(
      AlertDialog(
        title: Text(request.title),
        content: Text(request.description),
        actions: [
          TextButton(
            onPressed: () {
              Get.back();
              controller.buildRouteTo(request.location);
            },
            child: const Text('Route'),
          ),
        ],
      ),
    );
  }
}
