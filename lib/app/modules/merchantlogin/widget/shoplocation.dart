import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geocoding/geocoding.dart';

class ShopMapPicker extends StatefulWidget {
  final double initialLat;
  final double initialLng;
  final String initialAddress;

  const ShopMapPicker({
    super.key,
    required this.initialLat,
    required this.initialLng,
    required this.initialAddress,
  });

  @override
  State<ShopMapPicker> createState() => _ShopMapPickerState();
}

class _ShopMapPickerState extends State<ShopMapPicker> {
  late GoogleMapController mapController;
  LatLng currentPos = const LatLng(10.1632, 76.6413);
  String pickedAddress = "Move the map to pick location";

  @override
  void initState() {
    super.initState();
    if (widget.initialLat != 0) {
      currentPos = LatLng(widget.initialLat, widget.initialLng);
      pickedAddress = widget.initialAddress;
    }
  }

  Future getAddress(LatLng pos) async {
    try {
      List<Placemark> placemarks =
      await placemarkFromCoordinates(pos.latitude, pos.longitude);

      if (placemarks.isNotEmpty) {
        Placemark pc = placemarks.first;
        setState(() {
          pickedAddress =
          "${pc.name}, ${pc.locality}, ${pc.subAdministrativeArea}";
        });
      }
    } catch (e) {
      setState(() {
        pickedAddress = "Address not found";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Pick Shop Location")),
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition:
            CameraPosition(target: currentPos, zoom: 15),
            onMapCreated: (controller) => mapController = controller,
            onCameraMove: (position) {
              setState(() => currentPos = position.target);
            },
            onCameraIdle: () {
              getAddress(currentPos);
            },
            markers: {
              Marker(markerId: const MarkerId("shop"), position: currentPos)
            },
          ),
          Center(
            child: Icon(Icons.location_pin, size: 50, color: Colors.red),
          ),
          Positioned(
            bottom: 130,
            left: 20,
            right: 20,
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Text(
                pickedAddress,
                style:
                const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
              ),
            ),
          ),
          Positioned(
            bottom: 40,
            left: 20,
            right: 20,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(padding: const EdgeInsets.all(16)),
              onPressed: () {
                Get.back(result: {
                  "lat": currentPos.latitude,
                  "lng": currentPos.longitude,
                  "address": pickedAddress
                });
              },
              child: const Text("Select This Location"),
            ),
          ),
        ],
      ),
    );
  }
}
