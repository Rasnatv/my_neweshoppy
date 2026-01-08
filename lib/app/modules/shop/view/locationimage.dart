import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:get/get.dart';

class LocationPickerPage extends StatefulWidget {
  const LocationPickerPage({super.key});

  @override
  State<LocationPickerPage> createState() => _LocationPickerPageState();
}

class _LocationPickerPageState extends State<LocationPickerPage> {
  LatLng? selectedPoint;
  GoogleMapController? mapController;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Pick Location")),
      body: GoogleMap(
        initialCameraPosition: const CameraPosition(
          target: LatLng(11.2588, 75.7804),
          zoom: 14,
        ),
        onMapCreated: (controller) => mapController = controller,
        onTap: (LatLng pos) {
          setState(() => selectedPoint = pos);
        },
        markers: selectedPoint == null
            ? {}
            : {
          Marker(
            markerId: const MarkerId("selected"),
            position: selectedPoint!,
          ),
        },
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (selectedPoint != null) {
            Get.back(result: selectedPoint);
          } else {
            Get.snackbar("Select a point", "Tap on map to choose location");
          }
        },
        child: const Icon(Icons.check),
      ),
    );
  }
}
