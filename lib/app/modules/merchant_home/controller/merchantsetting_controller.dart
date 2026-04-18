
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

import '../../../data/errors/api_error.dart';
import '../../merchantlogin/widget/successwidget.dart';

class MerchantUpdateController extends GetxController {
  final box = GetStorage();

  final ownerCtrl     = TextEditingController();
  final shopCtrl      = TextEditingController();
  final emailCtrl     = TextEditingController();
  final phone1Ctrl    = TextEditingController();
  final phone2Ctrl    = TextEditingController();
  final whatsappCtrl  = TextEditingController();
  final facebookCtrl  = TextEditingController();
  final instagramCtrl = TextEditingController();
  final websiteCtrl   = TextEditingController();

  var latitude                 = 0.0.obs;
  var longitude                = 0.0.obs;
  var pickedLocation           = "Tap to pick location or use current location".obs;
  var isGettingCurrentLocation = false.obs;

  var selectedState    = "".obs;
  var selectedDistrict = "".obs;
  var selectedLocation = "".obs;
  var states           = <String>[].obs;
  var districts        = <String>[].obs;
  var locations        = <String>[].obs;
  var isLoadingStates    = false.obs;
  var isLoadingDistricts = false.obs;
  var isLoadingLocations = false.obs;

  final picker = ImagePicker();
  File?  pickedImage;
  String networkImage = "";

  final isLoading   = false.obs;
  final isUpdating  = false.obs;

  String get authToken => box.read<String?>('auth_token') ?? "";

  static const String statesApi    = "https://rasma.astradevelops.in/e_shoppyy/public/api/merchant/states";
  static const String districtsApi = "https://rasma.astradevelops.in/e_shoppyy/public/api/merchant/districts";
  static const String locationsApi = "https://rasma.astradevelops.in/e_shoppyy/public/api/merchant/locations";
  static const String updateApi    = "https://rasma.astradevelops.in/e_shoppyy/public/api/merchant/updatereg";

  @override
  void onInit() {
    super.onInit();
    fetchStates();
    fetchMerchantData();
  }

  bool isValidUrl(String url) {
    if (url.trim().isEmpty) return true;
    final uri = Uri.tryParse(url.trim());
    return uri != null &&
        (uri.scheme == 'http' || uri.scheme == 'https') &&
        uri.host.isNotEmpty;
  }

  // ---------- FETCH STATES ----------
  Future<void> fetchStates() async {
    try {
      isLoadingStates.value = true;
      final response = await http.get(
        Uri.parse(statesApi),
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['status'] == 1) {
          states.assignAll(
            List<String>.from(data['data']).toSet().toList(),
          );
        }
      } else {
        AppSnackbar.error("Failed to load states. Please try again.");
      }
    } on SocketException {
      AppSnackbar.error("No internet connection");
    } catch (e) {
      AppSnackbar.error("Failed to load states");
    } finally {
      isLoadingStates.value = false;
    }
  }

  // ---------- FETCH DISTRICTS ----------
  Future<void> fetchDistricts(String state) async {
    try {
      isLoadingDistricts.value = true;
      districts.clear();
      locations.clear();
      selectedDistrict.value = "";
      selectedLocation.value = "";

      final response = await http.post(
        Uri.parse(districtsApi),
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
        },
        body: jsonEncode({"state": state}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['status'] == 1) {
          districts.assignAll(
            List<String>.from(data['data']).toSet().toList(),
          );
        }
      } else {
        AppSnackbar.error("Failed to load districts. Please try again.");
      }
    } on SocketException {
      AppSnackbar.error("No internet connection");
    } catch (e) {
      AppSnackbar.error("Failed to load districts");
    } finally {
      isLoadingDistricts.value = false;
    }
  }

  // ---------- FETCH LOCATIONS ----------
  Future<void> fetchLocations(String state, String district) async {
    try {
      isLoadingLocations.value = true;
      locations.clear();
      selectedLocation.value = "";

      final response = await http.post(
        Uri.parse(locationsApi),
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
        },
        body: jsonEncode({"state": state, "district": district}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['status'] == 1) {
          locations.assignAll(
            List<String>.from(data['data']).toSet().toList(),
          );
        }
      } else {
        AppSnackbar.error("Failed to load locations. Please try again.");
      }
    } on SocketException {
      AppSnackbar.error("No internet connection");
    } catch (e) {
      AppSnackbar.error("Failed to load locations");
    } finally {
      isLoadingLocations.value = false;
    }
  }

  // ---------- GET CURRENT LOCATION ----------
  Future<void> getCurrentLocation() async {
    try {
      isGettingCurrentLocation.value = true;

      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        AppSnackbar.error("Location services are disabled.");
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          AppSnackbar.error("Location permission denied");
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        AppSnackbar.error("Location permanently denied. Enable in settings.");
        return;
      }

      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      latitude.value  = position.latitude;
      longitude.value = position.longitude;

      try {
        List<Placemark> placemarks = await placemarkFromCoordinates(
          position.latitude,
          position.longitude,
        );
        if (placemarks.isNotEmpty) {
          final place = placemarks.first;
          pickedLocation.value =
          "${place.street ?? ''}, ${place.locality ?? ''}, "
              "${place.administrativeArea ?? ''}, ${place.country ?? ''}";
        } else {
          pickedLocation.value =
          "Lat: ${position.latitude.toStringAsFixed(6)}, "
              "Lng: ${position.longitude.toStringAsFixed(6)}";
        }
      } catch (_) {
        pickedLocation.value =
        "Lat: ${position.latitude.toStringAsFixed(6)}, "
            "Lng: ${position.longitude.toStringAsFixed(6)}";
      }

      AppSnackbar.success("Current location fetched successfully");
    } on SocketException {
      AppSnackbar.error("No internet connection");
    } catch (e) {
      AppSnackbar.error("Failed to get current location: ${e.toString()}");
    } finally {
      isGettingCurrentLocation.value = false;
    }
  }

  // ---------- UPDATE LOCATION FROM MAP ----------
  void updateLocation(double lat, double lng, String address) {
    latitude.value       = lat;
    longitude.value      = lng;
    pickedLocation.value = address;
    AppSnackbar.success("Location updated successfully");
  }

  // ---------- FETCH MERCHANT DATA ----------
  Future<void> fetchMerchantData() async {
    isLoading.value = true;
    try {
      final response = await http.get(
        Uri.parse(
            "https://rasma.astradevelops.in/e_shoppyy/public/api/merchantgetreg"),
        headers: {
          "Authorization": "Bearer $authToken",
          "Accept": "application/json",
        },
      );

      // ✅ Only 401 triggers logout via ApiErrorHandler
      if (response.statusCode == 401) {
        ApiErrorHandler.handleResponse(response);
        return;
      }

      // ✅ Any other non-200 shows plain error — no logout risk
      if (response.statusCode != 200) {
        AppSnackbar.error("Failed to load profile. Please try again.");
        return;
      }

      final body = jsonDecode(response.body);
      if (body['status'] != true || body['data'] == null) return;

      final m = body['data'];

      ownerCtrl.text     = m['owner_name']?.toString()     ?? "";
      shopCtrl.text      = m['shop_name']?.toString()      ?? "";
      emailCtrl.text     = m['email']?.toString()          ?? "";
      phone1Ctrl.text    = m['phone_no_1']?.toString()     ?? "";
      phone2Ctrl.text    = m['phone_no_2']?.toString()     ?? "";
      whatsappCtrl.text  = m['whatsapp_no']?.toString()    ?? "";
      facebookCtrl.text  = m['facebook_link']?.toString()  ?? "";
      instagramCtrl.text = m['instagram_link']?.toString() ?? "";
      websiteCtrl.text   = m['website_link']?.toString()   ?? "";

      final state    = m['state']?.toString()         ?? "";
      final district = m['district']?.toString()      ?? "";
      final location = m['main_location']?.toString() ?? "";

      if (state.isNotEmpty) {
        selectedState.value = state;
        await fetchDistricts(state);
      }
      if (district.isNotEmpty) {
        selectedDistrict.value = district;
        await fetchLocations(state, district);
      }
      if (location.isNotEmpty) selectedLocation.value = location;

      final lat = double.tryParse(m['latitude']?.toString()  ?? "0") ?? 0.0;
      final lng = double.tryParse(m['longitude']?.toString() ?? "0") ?? 0.0;
      latitude.value  = lat;
      longitude.value = lng;

      if (lat != 0.0 && lng != 0.0) {
        try {
          final placemarks = await placemarkFromCoordinates(lat, lng);
          if (placemarks.isNotEmpty) {
            final place = placemarks.first;
            pickedLocation.value =
            "${place.street ?? ''}, ${place.locality ?? ''}, "
                "${place.administrativeArea ?? ''}, ${place.country ?? ''}";
          } else {
            pickedLocation.value =
            "Lat: ${lat.toStringAsFixed(6)}, Lng: ${lng.toStringAsFixed(6)}";
          }
        } catch (_) {
          pickedLocation.value =
          "Lat: ${lat.toStringAsFixed(6)}, Lng: ${lng.toStringAsFixed(6)}";
        }
      }

      networkImage = m['store_image']?.toString() ?? "";
    } on SocketException {
      AppSnackbar.error("No internet connection");
    } catch (e) {
      AppSnackbar.error(ApiErrorHandler.handleException(e));
    } finally {
      isLoading.value = false;
    }
  }

  // ---------- PICK IMAGE ----------
  Future<void> pickImage() async {
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      pickedImage = File(image.path);
      update();
    }
  }

  // ---------- CONVERT IMAGE TO BASE64 ----------
  Future<String> convertImageToBase64(File imageFile) async {
    final bytes = await imageFile.readAsBytes();
    return "data:image/jpeg;base64,${base64Encode(bytes)}";
  }

  // ---------- UPDATE MERCHANT ----------
  Future<void> updateMerchant() async {
    if (ownerCtrl.text.trim().isEmpty) {
      Get.snackbar("Validation Error", "Please enter owner name",
          backgroundColor: Colors.orange, colorText: Colors.white);
      return;
    }
    if (shopCtrl.text.trim().isEmpty) {
      Get.snackbar("Validation Error", "Please enter shop name",
          backgroundColor: Colors.orange, colorText: Colors.white);
      return;
    }
    if (selectedState.value.isEmpty) {
      Get.snackbar("Validation Error", "Please select state",
          backgroundColor: Colors.orange, colorText: Colors.white);
      return;
    }
    if (selectedDistrict.value.isEmpty) {
      Get.snackbar("Validation Error", "Please select district",
          backgroundColor: Colors.orange, colorText: Colors.white);
      return;
    }
    if (selectedLocation.value.isEmpty) {
      Get.snackbar("Validation Error", "Please select location",
          backgroundColor: Colors.orange, colorText: Colors.white);
      return;
    }
    if (latitude.value == 0.0 || longitude.value == 0.0) {
      Get.snackbar("Validation Error",
          "Please set shop location (use map or current location)",
          backgroundColor: Colors.orange, colorText: Colors.white);
      return;
    }
    if (!isValidUrl(facebookCtrl.text)) {
      Get.snackbar("Invalid Facebook URL",
          "Enter a valid URL (e.g. https://facebook.com/yourpage) or leave empty",
          backgroundColor: Colors.orange, colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
          duration: const Duration(seconds: 3));
      return;
    }
    if (!isValidUrl(instagramCtrl.text)) {
      Get.snackbar("Invalid Instagram URL",
          "Enter a valid URL (e.g. https://instagram.com/yourhandle) or leave empty",
          backgroundColor: Colors.orange, colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
          duration: const Duration(seconds: 3));
      return;
    }
    if (!isValidUrl(websiteCtrl.text)) {
      Get.snackbar("Invalid Website URL",
          "Enter a valid URL (e.g. https://yourwebsite.com) or leave empty",
          backgroundColor: Colors.orange, colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
          duration: const Duration(seconds: 3));
      return;
    }

    try {
      isUpdating.value = true;

      final Map<String, dynamic> requestBody = {
        "owner_name"    : ownerCtrl.text.trim(),
        "shop_name"     : shopCtrl.text.trim(),
        "email"         : emailCtrl.text.trim(),
        "phone_no_1"    : phone1Ctrl.text.trim(),
        "phone_no_2"    : phone2Ctrl.text.trim(),
        "state"         : selectedState.value,
        "district"      : selectedDistrict.value,
        "main_location" : selectedLocation.value,
        "latitude"      : latitude.value,
        "longitude"     : longitude.value,
        "whatsapp_no"   : whatsappCtrl.text.trim(),
        "facebook_link" : facebookCtrl.text.trim(),
        "instagram_link": instagramCtrl.text.trim(),
        "website_link"  : websiteCtrl.text.trim(),
        "user_type"     : "merchant",
      };

      if (pickedImage != null) {
        requestBody["store_image"] = await convertImageToBase64(pickedImage!);
      }

      final response = await http.post(
        Uri.parse(updateApi),
        headers: {
          "Authorization": "Bearer $authToken",
          "Content-Type" : "application/json",
          "Accept"       : "application/json",
        },
        body: jsonEncode(requestBody),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['status'] == true) {
          await fetchMerchantData();
          AppSnackbar.success(data['message'] ?? "Profile updated successfully");
        } else {
          AppSnackbar.error(data['message'] ?? "Failed to update profile");
        }
      } else if (response.statusCode == 401) {
        // ✅ Only 401 triggers logout via ApiErrorHandler
        ApiErrorHandler.handleResponse(response);
      } else {
        // ✅ Any other non-200 shows plain error — no logout risk
        AppSnackbar.error("Failed to update profile. Please try again.");
      }
    } on SocketException {
      AppSnackbar.error("No internet connection");
    } catch (e) {
      AppSnackbar.error(ApiErrorHandler.handleException(e));
    } finally {
      isUpdating.value = false;
    }
  }

  // ---------- DISPOSE ----------
  @override
  void onClose() {
    ownerCtrl.dispose();
    shopCtrl.dispose();
    emailCtrl.dispose();
    phone1Ctrl.dispose();
    phone2Ctrl.dispose();
    whatsappCtrl.dispose();
    facebookCtrl.dispose();
    instagramCtrl.dispose();
    websiteCtrl.dispose();
    super.onClose();
  }
}