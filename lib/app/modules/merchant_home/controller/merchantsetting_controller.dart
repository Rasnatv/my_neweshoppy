//
// import 'dart:convert';
// import 'dart:io';
//
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:get_storage/get_storage.dart';
// import 'package:http/http.dart' as http;
// import 'package:image_picker/image_picker.dart';
//
// class MerchantUpdateController extends GetxController {
//   final box = GetStorage();
//
//   // ---------- FORM CONTROLLERS ----------
//   final ownerCtrl = TextEditingController();
//   final shopCtrl = TextEditingController();
//   final emailCtrl = TextEditingController();
//   final phone1Ctrl = TextEditingController();
//   final phone2Ctrl = TextEditingController();
//   final whatsappCtrl = TextEditingController();
//   final facebookCtrl = TextEditingController();
//   final instagramCtrl = TextEditingController();
//   final websiteCtrl = TextEditingController();
//
//   // ---------- LOCATION ----------
//   final latitude = 0.0.obs;
//   final longitude = 0.0.obs;
//
//   // ---------- DROPDOWN VARIABLES ----------
//   var selectedState = "".obs;
//   var selectedDistrict = "".obs;
//   var selectedLocation = "".obs;
//
//   var states = <String>[].obs;
//   var districts = <String>[].obs;
//   var locations = <String>[].obs;
//
//   var isLoadingStates = false.obs;
//   var isLoadingDistricts = false.obs;
//   var isLoadingLocations = false.obs;
//
//   // ---------- IMAGE ----------
//   final picker = ImagePicker();
//   File? pickedImage;
//   String networkImage = "";
//
//   // ---------- STATE ----------
//   final isLoading = false.obs;
//   final isUpdating = false.obs;
//   late String authToken;
//
//   // ---------- API URLs ----------
//   static const String statesApi =
//       "https://rasma.astradevelops.in/e_shoppyy/public/api/merchant/states";
//   static const String districtsApi =
//       "https://rasma.astradevelops.in/e_shoppyy/public/api/merchant/districts";
//   static const String locationsApi =
//       "https://rasma.astradevelops.in/e_shoppyy/public/api/merchant/locations";
//   static const String updateApi =
//       "https://rasma.astradevelops.in/e_shoppyy/public/api/merchant/updatereg";
//
//   // ---------- INIT ----------
//   @override
//   void onInit() {
//     super.onInit();
//
//     authToken = box.read("auth_token") ?? "";
//
//     if (authToken.isEmpty) {
//       Get.snackbar(
//         "Session Expired",
//         "Please login again",
//         backgroundColor: Colors.red,
//         colorText: Colors.white,
//       );
//       return;
//     }
//
//     fetchStates();
//     fetchMerchantData();
//   }
//
//   // ---------- FETCH STATES ----------
//   Future<void> fetchStates() async {
//     try {
//       isLoadingStates.value = true;
//
//       final response = await http.get(
//         Uri.parse(statesApi),
//         headers: {
//           "Content-Type": "application/json",
//           "Accept": "application/json",
//         },
//       );
//
//       if (response.statusCode == 200) {
//         final data = jsonDecode(response.body);
//
//         if (data['status'] == 1) {
//           List<String> statesList = List<String>.from(data['data']);
//           List<String> uniqueStates = statesList.toSet().toList();
//           states.assignAll(uniqueStates);
//         }
//       }
//     } catch (e) {
//       print("Error fetching states: $e");
//     } finally {
//       isLoadingStates.value = false;
//     }
//   }
//
//   // ---------- FETCH DISTRICTS ----------
//   Future<void> fetchDistricts(String state) async {
//     try {
//       isLoadingDistricts.value = true;
//
//       districts.clear();
//       locations.clear();
//       selectedDistrict.value = "";
//       selectedLocation.value = "";
//
//       final response = await http.post(
//         Uri.parse(districtsApi),
//         headers: {
//           "Content-Type": "application/json",
//           "Accept": "application/json",
//         },
//         body: jsonEncode({"state": state}),
//       );
//
//       if (response.statusCode == 200) {
//         final data = jsonDecode(response.body);
//
//         if (data['status'] == 1) {
//           List<String> districtsList = List<String>.from(data['data']);
//           List<String> uniqueDistricts = districtsList.toSet().toList();
//           districts.assignAll(uniqueDistricts);
//         }
//       }
//     } catch (e) {
//       print("Error fetching districts: $e");
//     } finally {
//       isLoadingDistricts.value = false;
//     }
//   }
//
//   // ---------- FETCH LOCATIONS ----------
//   Future<void> fetchLocations(String state, String district) async {
//     try {
//       isLoadingLocations.value = true;
//
//       locations.clear();
//       selectedLocation.value = "";
//
//       final response = await http.post(
//         Uri.parse(locationsApi),
//         headers: {
//           "Content-Type": "application/json",
//           "Accept": "application/json",
//         },
//         body: jsonEncode({
//           "state": state,
//           "district": district,
//         }),
//       );
//
//       if (response.statusCode == 200) {
//         final data = jsonDecode(response.body);
//
//         if (data['status'] == 1) {
//           List<String> locationsList = List<String>.from(data['data']);
//           List<String> uniqueLocations = locationsList.toSet().toList();
//           locations.assignAll(uniqueLocations);
//         }
//       }
//     } catch (e) {
//       print("Error fetching locations: $e");
//     } finally {
//       isLoadingLocations.value = false;
//     }
//   }
//
//   // ---------- GET MERCHANT DATA ----------
//   Future<void> fetchMerchantData() async {
//     isLoading.value = true;
//
//     try {
//       final response = await http.get(
//         Uri.parse(
//           "https://rasma.astradevelops.in/e_shoppyy/public/api/merchantgetreg",
//         ),
//         headers: {
//           "Authorization": "Bearer $authToken",
//           "Accept": "application/json",
//         },
//       );
//
//       final body = jsonDecode(response.body);
//
//       if (body['status'] != true || body['data'] == null) return;
//
//       final m = body['data'];
//
//       ownerCtrl.text = m['owner_name']?.toString() ?? "";
//       shopCtrl.text = m['shop_name']?.toString() ?? "";
//       emailCtrl.text = m['email']?.toString() ?? "";
//       phone1Ctrl.text = m['phone_no_1']?.toString() ?? "";
//       phone2Ctrl.text = m['phone_no_2']?.toString() ?? "";
//       whatsappCtrl.text = m['whatsapp_no']?.toString() ?? "";
//       facebookCtrl.text = m['facebook_link']?.toString() ?? "";
//       instagramCtrl.text = m['instagram_link']?.toString() ?? "";
//       websiteCtrl.text = m['website_link']?.toString() ?? "";
//
//       // Set dropdown values
//       String state = m['state']?.toString() ?? "";
//       String district = m['district']?.toString() ?? "";
//       String location = m['main_location']?.toString() ?? "";
//
//       if (state.isNotEmpty) {
//         selectedState.value = state;
//         await fetchDistricts(state);
//       }
//
//       if (district.isNotEmpty) {
//         selectedDistrict.value = district;
//         await fetchLocations(state, district);
//       }
//
//       if (location.isNotEmpty) {
//         selectedLocation.value = location;
//       }
//
//       latitude.value =
//           double.tryParse(m['latitude']?.toString() ?? "0") ?? 0.0;
//       longitude.value =
//           double.tryParse(m['longitude']?.toString() ?? "0") ?? 0.0;
//
//       networkImage = m['store_image']?.toString() ?? "";
//     } finally {
//       isLoading.value = false;
//     }
//   }
//
//   // ---------- PICK IMAGE ----------
//   Future<void> pickImage() async {
//     final XFile? image =
//     await picker.pickImage(source: ImageSource.gallery);
//
//     if (image != null) {
//       pickedImage = File(image.path);
//       update();
//     }
//   }
//
//   // ---------- CONVERT IMAGE TO BASE64 ----------
//   Future<String> convertImageToBase64(File imageFile) async {
//     List<int> imageBytes = await imageFile.readAsBytes();
//     String base64Image = base64Encode(imageBytes);
//     return "data:image/jpeg;base64,$base64Image";
//   }
//
//   // ---------- UPDATE MERCHANT ----------
//   Future<void> updateMerchant() async {
//     // Validation
//     if (ownerCtrl.text.trim().isEmpty) {
//       Get.snackbar(
//         "Validation Error",
//         "Please enter owner name",
//         backgroundColor: Colors.orange,
//         colorText: Colors.white,
//       );
//       return;
//     }
//
//     if (shopCtrl.text.trim().isEmpty) {
//       Get.snackbar(
//         "Validation Error",
//         "Please enter shop name",
//         backgroundColor: Colors.orange,
//         colorText: Colors.white,
//       );
//       return;
//     }
//
//     if (selectedState.value.isEmpty) {
//       Get.snackbar(
//         "Validation Error",
//         "Please select state",
//         backgroundColor: Colors.orange,
//         colorText: Colors.white,
//       );
//       return;
//     }
//
//     if (selectedDistrict.value.isEmpty) {
//       Get.snackbar(
//         "Validation Error",
//         "Please select district",
//         backgroundColor: Colors.orange,
//         colorText: Colors.white,
//       );
//       return;
//     }
//
//     if (selectedLocation.value.isEmpty) {
//       Get.snackbar(
//         "Validation Error",
//         "Please select location",
//         backgroundColor: Colors.orange,
//         colorText: Colors.white,
//       );
//       return;
//     }
//
//     try {
//       isUpdating.value = true;
//
//       // Prepare request body
//       final Map<String, dynamic> requestBody = {
//         "owner_name": ownerCtrl.text.trim(),
//         "shop_name": shopCtrl.text.trim(),
//         "email": emailCtrl.text.trim(),
//         "phone_no_1": phone1Ctrl.text.trim(),
//         "phone_no_2": phone2Ctrl.text.trim(),
//         "state": selectedState.value,
//         "district": selectedDistrict.value,
//         "main_location": selectedLocation.value,
//         "latitude": latitude.value,
//         "longitude": longitude.value,
//         "whatsapp_no": whatsappCtrl.text.trim(),
//         "facebook_link": facebookCtrl.text.trim(),
//         "instagram_link": instagramCtrl.text.trim(),
//         "website_link": websiteCtrl.text.trim(),
//         "user_type": "merchant"
//       };
//
//       // Add image if changed
//       if (pickedImage != null) {
//         String base64Image = await convertImageToBase64(pickedImage!);
//         requestBody["store_image"] = base64Image;
//       }
//
//       print("Update Request: ${jsonEncode(requestBody)}");
//
//       final response = await http.post(
//         Uri.parse(updateApi),
//         headers: {
//           "Authorization": "Bearer $authToken",
//           "Content-Type": "application/json",
//           "Accept": "application/json",
//         },
//         body: jsonEncode(requestBody),
//       );
//
//       print("Update Response: ${response.body}");
//
//       final data = jsonDecode(response.body);
//
//       if (response.statusCode == 200 && data['status'] == true) {
//         Get.snackbar(
//           "Success",
//           data['message'] ?? "Profile updated successfully",
//           backgroundColor: Colors.green,
//           colorText: Colors.white,
//           snackPosition: SnackPosition.BOTTOM,
//           margin: const EdgeInsets.all(16),
//           borderRadius: 12,
//           icon: const Icon(Icons.check_circle, color: Colors.white),
//         );
//
//         // Refresh data
//         await fetchMerchantData();
//       } else {
//         Get.snackbar(
//           "Error",
//           data['message'] ?? "Failed to update profile",
//           backgroundColor: Colors.red,
//           colorText: Colors.white,
//           snackPosition: SnackPosition.BOTTOM,
//           margin: const EdgeInsets.all(16),
//           borderRadius: 12,
//         );
//       }
//     } catch (e) {
//       print("Error updating merchant: $e");
//       Get.snackbar(
//         "Error",
//         "Something went wrong: ${e.toString()}",
//         backgroundColor: Colors.red,
//         colorText: Colors.white,
//         snackPosition: SnackPosition.BOTTOM,
//         margin: const EdgeInsets.all(16),
//         borderRadius: 12,
//       );
//     } finally {
//       isUpdating.value = false;
//     }
//   }
//
//   // ---------- DISPOSE ----------
//   @override
//   void onClose() {
//     ownerCtrl.dispose();
//     shopCtrl.dispose();
//     emailCtrl.dispose();
//     phone1Ctrl.dispose();
//     phone2Ctrl.dispose();
//     whatsappCtrl.dispose();
//     facebookCtrl.dispose();
//     instagramCtrl.dispose();
//     websiteCtrl.dispose();
//     super.onClose();
//   }
// // }
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

class MerchantUpdateController extends GetxController {
  final box = GetStorage();

  // ---------- FORM CONTROLLERS ----------
  final ownerCtrl = TextEditingController();
  final shopCtrl = TextEditingController();
  final emailCtrl = TextEditingController();
  final phone1Ctrl = TextEditingController();
  final phone2Ctrl = TextEditingController();
  final whatsappCtrl = TextEditingController();
  final facebookCtrl = TextEditingController();
  final instagramCtrl = TextEditingController();
  final websiteCtrl = TextEditingController();

  // ---------- LOCATION ----------
  var latitude = 0.0.obs;
  var longitude = 0.0.obs;
  var pickedLocation = "Tap to pick location or use current location".obs;
  var isGettingCurrentLocation = false.obs;

  // ---------- DROPDOWN VARIABLES ----------
  var selectedState = "".obs;
  var selectedDistrict = "".obs;
  var selectedLocation = "".obs;
  var states = <String>[].obs;
  var districts = <String>[].obs;
  var locations = <String>[].obs;
  var isLoadingStates = false.obs;
  var isLoadingDistricts = false.obs;
  var isLoadingLocations = false.obs;

  // ---------- IMAGE ----------
  final picker = ImagePicker();
  File? pickedImage;
  String networkImage = "";

  // ---------- STATE ----------
  final isLoading = false.obs;
  final isUpdating = false.obs;
  late String authToken;

  // ---------- API URLs ----------
  static const String statesApi = "https://rasma.astradevelops.in/e_shoppyy/public/api/merchant/states";
  static const String districtsApi = "https://rasma.astradevelops.in/e_shoppyy/public/api/merchant/districts";
  static const String locationsApi = "https://rasma.astradevelops.in/e_shoppyy/public/api/merchant/locations";
  static const String updateApi = "https://rasma.astradevelops.in/e_shoppyy/public/api/merchant/updatereg";

  // ---------- INIT ----------
  @override
  void onInit() {
    super.onInit();
    authToken = box.read("auth_token") ?? "";
    if (authToken.isEmpty) {
      Get.snackbar(
        "Session Expired",
        "Please login again",
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }
    fetchStates();
    fetchMerchantData();
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
          List<String> statesList = List<String>.from(data['data']);
          List<String> uniqueStates = statesList.toSet().toList();
          states.assignAll(uniqueStates);
        }
      }
    } catch (e) {
      print("Error fetching states: $e");
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
          List<String> districtsList = List<String>.from(data['data']);
          List<String> uniqueDistricts = districtsList.toSet().toList();
          districts.assignAll(uniqueDistricts);
        }
      }
    } catch (e) {
      print("Error fetching districts: $e");
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
        body: jsonEncode({
          "state": state,
          "district": district,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['status'] == 1) {
          List<String> locationsList = List<String>.from(data['data']);
          List<String> uniqueLocations = locationsList.toSet().toList();
          locations.assignAll(uniqueLocations);
        }
      }
    } catch (e) {
      print("Error fetching locations: $e");
    } finally {
      isLoadingLocations.value = false;
    }
  }

  // ---------- GET CURRENT LOCATION ----------
  Future<void> getCurrentLocation() async {
    try {
      isGettingCurrentLocation.value = true;

      // Check if location services are enabled
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        Get.snackbar(
          "Error",
          "Location services are disabled. Please enable location services.",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        isGettingCurrentLocation.value = false;
        return;
      }

      // Check location permission
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          Get.snackbar(
            "Error",
            "Location permission denied",
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.red,
            colorText: Colors.white,
          );
          isGettingCurrentLocation.value = false;
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        Get.snackbar(
          "Error",
          "Location permissions are permanently denied. Please enable in settings.",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        isGettingCurrentLocation.value = false;
        return;
      }

      // Get current position
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      latitude.value = position.latitude;
      longitude.value = position.longitude;

      print("Current Location: ${position.latitude}, ${position.longitude}");

      // Get address from coordinates
      try {
        List<Placemark> placemarks = await placemarkFromCoordinates(
          position.latitude,
          position.longitude,
        );

        if (placemarks.isNotEmpty) {
          Placemark place = placemarks.first;
          pickedLocation.value = "${place.street ?? ''}, ${place.locality ?? ''}, ${place.administrativeArea ?? ''}, ${place.country ?? ''}";
          print("Address: ${pickedLocation.value}");
        } else {
          pickedLocation.value = "Lat: ${position.latitude.toStringAsFixed(6)}, Lng: ${position.longitude.toStringAsFixed(6)}";
        }
      } catch (e) {
        print("Error getting address: $e");
        pickedLocation.value = "Lat: ${position.latitude.toStringAsFixed(6)}, Lng: ${position.longitude.toStringAsFixed(6)}";
      }

      Get.snackbar(
        "Success",
        "Current location fetched successfully",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } catch (e) {
      print("Error getting current location: $e");
      Get.snackbar(
        "Error",
        "Failed to get current location: ${e.toString()}",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isGettingCurrentLocation.value = false;
    }
  }

  // ---------- UPDATE LOCATION FROM MAP ----------
  void updateLocation(double lat, double lng, String address) {
    latitude.value = lat;
    longitude.value = lng;
    pickedLocation.value = address;

    Get.snackbar(
      "Success",
      "Location updated successfully",
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.green,
      colorText: Colors.white,
      duration: const Duration(seconds: 2),
    );
  }

  // ---------- GET MERCHANT DATA ----------
  Future<void> fetchMerchantData() async {
    isLoading.value = true;
    try {
      final response = await http.get(
        Uri.parse(
          "https://rasma.astradevelops.in/e_shoppyy/public/api/merchantgetreg",
        ),
        headers: {
          "Authorization": "Bearer $authToken",
          "Accept": "application/json",
        },
      );

      final body = jsonDecode(response.body);
      if (body['status'] != true || body['data'] == null) return;

      final m = body['data'];

      ownerCtrl.text = m['owner_name']?.toString() ?? "";
      shopCtrl.text = m['shop_name']?.toString() ?? "";
      emailCtrl.text = m['email']?.toString() ?? "";
      phone1Ctrl.text = m['phone_no_1']?.toString() ?? "";
      phone2Ctrl.text = m['phone_no_2']?.toString() ?? "";
      whatsappCtrl.text = m['whatsapp_no']?.toString() ?? "";
      facebookCtrl.text = m['facebook_link']?.toString() ?? "";
      instagramCtrl.text = m['instagram_link']?.toString() ?? "";
      websiteCtrl.text = m['website_link']?.toString() ?? "";

      // Set dropdown values
      String state = m['state']?.toString() ?? "";
      String district = m['district']?.toString() ?? "";
      String location = m['main_location']?.toString() ?? "";

      if (state.isNotEmpty) {
        selectedState.value = state;
        await fetchDistricts(state);
      }

      if (district.isNotEmpty) {
        selectedDistrict.value = district;
        await fetchLocations(state, district);
      }

      if (location.isNotEmpty) {
        selectedLocation.value = location;
      }

      // Set location data
      double lat = double.tryParse(m['latitude']?.toString() ?? "0") ?? 0.0;
      double lng = double.tryParse(m['longitude']?.toString() ?? "0") ?? 0.0;

      latitude.value = lat;
      longitude.value = lng;

      // Get address from coordinates if location exists
      if (lat != 0.0 && lng != 0.0) {
        try {
          List<Placemark> placemarks = await placemarkFromCoordinates(lat, lng);
          if (placemarks.isNotEmpty) {
            Placemark place = placemarks.first;
            pickedLocation.value = "${place.street ?? ''}, ${place.locality ?? ''}, ${place.administrativeArea ?? ''}, ${place.country ?? ''}";
          } else {
            pickedLocation.value = "Lat: ${lat.toStringAsFixed(6)}, Lng: ${lng.toStringAsFixed(6)}";
          }
        } catch (e) {
          pickedLocation.value = "Lat: ${lat.toStringAsFixed(6)}, Lng: ${lng.toStringAsFixed(6)}";
        }
      }

      networkImage = m['store_image']?.toString() ?? "";
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
    List<int> imageBytes = await imageFile.readAsBytes();
    String base64Image = base64Encode(imageBytes);
    return "data:image/jpeg;base64,$base64Image";
  }

  // ---------- UPDATE MERCHANT ----------
  Future<void> updateMerchant() async {
    // Validation
    if (ownerCtrl.text.trim().isEmpty) {
      Get.snackbar(
        "Validation Error",
        "Please enter owner name",
        backgroundColor: Colors.orange,
        colorText: Colors.white,
      );
      return;
    }

    if (shopCtrl.text.trim().isEmpty) {
      Get.snackbar(
        "Validation Error",
        "Please enter shop name",
        backgroundColor: Colors.orange,
        colorText: Colors.white,
      );
      return;
    }

    if (selectedState.value.isEmpty) {
      Get.snackbar(
        "Validation Error",
        "Please select state",
        backgroundColor: Colors.orange,
        colorText: Colors.white,
      );
      return;
    }

    if (selectedDistrict.value.isEmpty) {
      Get.snackbar(
        "Validation Error",
        "Please select district",
        backgroundColor: Colors.orange,
        colorText: Colors.white,
      );
      return;
    }

    if (selectedLocation.value.isEmpty) {
      Get.snackbar(
        "Validation Error",
        "Please select location",
        backgroundColor: Colors.orange,
        colorText: Colors.white,
      );
      return;
    }

    if (latitude.value == 0.0 || longitude.value == 0.0) {
      Get.snackbar(
        "Validation Error",
        "Please set shop location (use map or current location)",
        backgroundColor: Colors.orange,
        colorText: Colors.white,
      );
      return;
    }

    try {
      isUpdating.value = true;

      // Prepare request body
      final Map<String, dynamic> requestBody = {
        "owner_name": ownerCtrl.text.trim(),
        "shop_name": shopCtrl.text.trim(),
        "email": emailCtrl.text.trim(),
        "phone_no_1": phone1Ctrl.text.trim(),
        "phone_no_2": phone2Ctrl.text.trim(),
        "state": selectedState.value,
        "district": selectedDistrict.value,
        "main_location": selectedLocation.value,
        "latitude": latitude.value,
        "longitude": longitude.value,
        "whatsapp_no": whatsappCtrl.text.trim(),
        "facebook_link": facebookCtrl.text.trim(),
        "instagram_link": instagramCtrl.text.trim(),
        "website_link": websiteCtrl.text.trim(),
        "user_type": "merchant"
      };

      // Add image if changed
      if (pickedImage != null) {
        String base64Image = await convertImageToBase64(pickedImage!);
        requestBody["store_image"] = base64Image;
      }

      print("Update Request: ${jsonEncode(requestBody)}");

      final response = await http.post(
        Uri.parse(updateApi),
        headers: {
          "Authorization": "Bearer $authToken",
          "Content-Type": "application/json",
          "Accept": "application/json",
        },
        body: jsonEncode(requestBody),
      );

      print("Update Response: ${response.body}");

      final data = jsonDecode(response.body);

      if (response.statusCode == 200 && data['status'] == true) {
        Get.snackbar(
          "Success",
          data['message'] ?? "Profile updated successfully",
          backgroundColor: Colors.green,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
          margin: const EdgeInsets.all(16),
          borderRadius: 12,
          icon: const Icon(Icons.check_circle, color: Colors.white),
        );

        // Refresh data
        await fetchMerchantData();
      } else {
        Get.snackbar(
          "Error",
          data['message'] ?? "Failed to update profile",
          backgroundColor: Colors.red,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
          margin: const EdgeInsets.all(16),
          borderRadius: 12,
        );
      }
    } catch (e) {
      print("Error updating merchant: $e");
      Get.snackbar(
        "Error",
        "Something went wrong: ${e.toString()}",
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.all(16),
        borderRadius: 12,
      );
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