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
  GoogleMapController? mapController;
  LatLng? selectedLocation;
  String address = "";
  bool isLoading = false;

  final TextEditingController _searchController = TextEditingController();
  List<Location> _searchResults = [];
  List<String> _searchAddresses = [];
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    if (widget.initialLat != 0.0 && widget.initialLng != 0.0) {
      selectedLocation = LatLng(widget.initialLat, widget.initialLng);
      address = widget.initialAddress;
    } else {
      getCurrentLocation();
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  // ─── Search by address ───────────────────────────────────────────────────────
  Future<void> _searchAddress(String query) async {
    if (query.trim().isEmpty) {
      setState(() {
        _searchResults = [];
        _searchAddresses = [];
      });
      return;
    }

    setState(() => _isSearching = true);

    try {
      List<Location> locations = await locationFromAddress(query);
      List<String> addresses = [];

      for (Location loc in locations) {
        List<Placemark> placemarks = await placemarkFromCoordinates(
          loc.latitude,
          loc.longitude,
        );
        if (placemarks.isNotEmpty) {
          Placemark p = placemarks[0];
          addresses.add(
            "${p.name}, ${p.locality}, ${p.administrativeArea}, ${p.country}",
          );
        } else {
          addresses.add("${loc.latitude}, ${loc.longitude}");
        }
      }

      setState(() {
        _searchResults = locations;
        _searchAddresses = addresses;
        _isSearching = false;
      });
    } catch (e) {
      setState(() => _isSearching = false);
      _showSnackBar("No results found for \"$query\"");
    }
  }

  void _selectSearchResult(int index) {
    final loc = _searchResults[index];
    final addr = _searchAddresses[index];
    final latLng = LatLng(loc.latitude, loc.longitude);

    setState(() {
      selectedLocation = latLng;
      address = addr;
      _searchController.text = addr;
      _searchResults = [];
      _searchAddresses = [];
    });

    mapController?.animateCamera(CameraUpdate.newLatLngZoom(latLng, 15));
    FocusScope.of(context).unfocus();
  }

  // ─── Current location ────────────────────────────────────────────────────────
  Future<void> getCurrentLocation() async {
    setState(() => isLoading = true);

    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        _showSnackBar("Location services are disabled. Please enable GPS.");
        setState(() => isLoading = false);
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          _showSnackBar("Location permission denied.");
          setState(() => isLoading = false);
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        _showSnackBar(
          "Location permission permanently denied. Enable from settings.",
        );
        setState(() => isLoading = false);
        return;
      }

      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      LatLng currentPos = LatLng(position.latitude, position.longitude);

      setState(() {
        selectedLocation = currentPos;
        isLoading = false;
      });

      mapController?.animateCamera(CameraUpdate.newLatLngZoom(currentPos, 15));
      await getAddressFromLatLng(currentPos);
    } catch (e) {
      setState(() => isLoading = false);
      _showSnackBar("Failed to get location: $e");
    }
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
          address =
          "${place.street}, ${place.locality}, ${place.administrativeArea}";
          _searchController.text = address; // ✅ Sync search field with address
        });
      }
    } catch (e) {
      debugPrint("Error getting address: $e");
    }
  }

  void _showSnackBar(String message) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message)),
      );
    }
  }

  // ─── Build ───────────────────────────────────────────────────────────────────
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
              } else {
                _showSnackBar("Please select a location first.");
              }
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          // ── Map ──────────────────────────────────────────────────────────────
          GoogleMap(
            initialCameraPosition: CameraPosition(
              target: selectedLocation ?? const LatLng(20.5937, 78.9629),
              zoom: selectedLocation != null ? 15 : 5,
            ),
            onMapCreated: (controller) {
              mapController = controller;
              if (selectedLocation != null) {
                controller.animateCamera(
                  CameraUpdate.newLatLngZoom(selectedLocation!, 15),
                );
              }
            },
            onTap: (position) {
              setState(() {
                selectedLocation = position;
                _searchResults = []; // close dropdown on map tap
                _searchAddresses = [];
              });
              getAddressFromLatLng(position);
              FocusScope.of(context).unfocus();
            },
            myLocationEnabled: true,
            myLocationButtonEnabled: false,
            markers: selectedLocation != null
                ? {
              Marker(
                markerId: const MarkerId("shop"),
                position: selectedLocation!,
              ),
            }
                : {},
          ),

          // ── Loading indicator ─────────────────────────────────────────────────
          if (isLoading) const Center(child: CircularProgressIndicator()),

          // ── Search bar + dropdown ─────────────────────────────────────────────
          Positioned(
            top: 12,
            left: 12,
            right: 12,
            child: Column(
              children: [
                // Search field
                Material(
                  elevation: 4,
                  borderRadius: BorderRadius.circular(12),
                  child: TextField(
                    controller: _searchController,
                    textInputAction: TextInputAction.search,
                    onSubmitted: _searchAddress,
                    onChanged: (value) {
                      if (value.isEmpty) {
                        setState(() {
                          _searchResults = [];
                          _searchAddresses = [];
                        });
                      }
                    },
                    decoration: InputDecoration(
                      hintText: "Search location...",
                      prefixIcon: const Icon(Icons.search),
                      suffixIcon: _isSearching
                          ? const Padding(
                        padding: EdgeInsets.all(12),
                        child: SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                          ),
                        ),
                      )
                          : _searchController.text.isNotEmpty
                          ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          setState(() {
                            _searchResults = [];
                            _searchAddresses = [];
                          });
                        },
                      )
                          : null,
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        vertical: 14,
                        horizontal: 16,
                      ),
                    ),
                  ),
                ),

                // Dropdown results
                if (_searchResults.isNotEmpty)
                  Material(
                    elevation: 4,
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      constraints: const BoxConstraints(maxHeight: 220),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: ListView.separated(
                        shrinkWrap: true,
                        padding: const EdgeInsets.symmetric(vertical: 6),
                        itemCount: _searchResults.length,
                        separatorBuilder: (_, __) =>
                        const Divider(height: 1, indent: 16),
                        itemBuilder: (context, index) {
                          return ListTile(
                            dense: true,
                            leading: const Icon(
                              Icons.location_on_outlined,
                              color: Colors.redAccent,
                            ),
                            title: Text(
                              _searchAddresses[index],
                              style: const TextStyle(fontSize: 13),
                            ),
                            onTap: () => _selectSearchResult(index),
                          );
                        },
                      ),
                    ),
                  ),
              ],
            ),
          ),

          // ── Bottom card ───────────────────────────────────────────────────────
          Positioned(
            bottom: 20,
            left: 20,
            right: 20,
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 6,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      children: [
                        const Icon(
                          Icons.location_on,
                          color: Colors.redAccent,
                          size: 18,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            address.isEmpty
                                ? "Tap on map to select location"
                                : address,
                            style: TextStyle(
                              fontSize: 13,
                              color: address.isEmpty
                                  ? Colors.grey
                                  : Colors.black87,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: getCurrentLocation,
                        icon: const Icon(Icons.my_location, size: 18),
                        label: const Text("Use Current Location"),
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
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