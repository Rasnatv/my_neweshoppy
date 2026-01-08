import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

class ShopMapPicker extends StatefulWidget {
  final double initialLat;
  final double initialLng;
  final String initialAddress;

  const ShopMapPicker({
    Key? key,
    required this.initialLat,
    required this.initialLng,
    required this.initialAddress,
  }) : super(key: key);

  @override
  State<ShopMapPicker> createState() => _ShopMapPickerState();
}

class _ShopMapPickerState extends State<ShopMapPicker> {
  late GoogleMapController mapController;
  LatLng? selectedLocation;
  String address = "";
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    if (widget.initialLat != 0.0 && widget.initialLng != 0.0) {
      selectedLocation = LatLng(widget.initialLat, widget.initialLng);
      address = widget.initialAddress;
    }
  }

  Future<void> getCurrentLocation() async {
    setState(() => isLoading = true);

    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      setState(() => isLoading = false);
      return;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        setState(() => isLoading = false);
        return;
      }
    }

    Position position = await Geolocator.getCurrentPosition();
    LatLng currentPos = LatLng(position.latitude, position.longitude);

    setState(() {
      selectedLocation = currentPos;
      isLoading = false;
    });

    mapController.animateCamera(CameraUpdate.newLatLng(currentPos));
    await getAddressFromLatLng(currentPos);
  }

  Future<void> getAddressFromLatLng(LatLng position) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      if (placemarks.isNotEmpty) {
        Placemark place = placemarks[0];
        setState(() {
          address = "${place.street}, ${place.locality}, ${place.administrativeArea}";
        });
      }
    } catch (e) {
      print("Error getting address: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Pick Shop Location"),
        actions: [
          IconButton(
            icon: const Icon(Icons.check),
            onPressed: () {
              if (selectedLocation != null) {
                Navigator.pop(context, {
                  "lat": selectedLocation!.latitude,
                  "lng": selectedLocation!.longitude,
                  "address": address,
                });
              }
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: CameraPosition(
              target: selectedLocation ?? const LatLng(11.016844, 76.955832),
              zoom: 15,
            ),
            onMapCreated: (controller) => mapController = controller,
            onTap: (position) {
              setState(() => selectedLocation = position);
              getAddressFromLatLng(position);
            },
            markers: selectedLocation != null
                ? {
              Marker(
                markerId: const MarkerId("shop"),
                position: selectedLocation!,
              )
            }
                : {},
          ),
          if (isLoading)
            const Center(child: CircularProgressIndicator()),
          Positioned(
            bottom: 20,
            left: 20,
            right: 20,
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(address.isEmpty ? "Tap on map to select" : address),
                    const SizedBox(height: 10),
                    ElevatedButton.icon(
                      onPressed: getCurrentLocation,
                      icon: const Icon(Icons.my_location),
                      label: const Text("Use Current Location"),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}