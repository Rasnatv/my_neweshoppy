

import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import '../../merchant_home/views/merchant_home.dart';


class MerchantRegController extends GetxController {

  final ownerNameController = TextEditingController();
  final shopNameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final phoneNo1Controller = TextEditingController();
  final phoneNo2Controller = TextEditingController();
  final whatsappController = TextEditingController();
  final facebookController = TextEditingController();
  final instagramController = TextEditingController();
  final websiteController = TextEditingController();

  // ------------------ REACTIVE VARIABLES ------------------
  var storeImage = Rx<File?>(null);
  var isLoading = false.obs;
  var isLoadingStates = false.obs;
  var isLoadingDistricts = false.obs;
  var isLoadingLocations = false.obs;
  var isGettingCurrentLocation = false.obs;

  // Location variables
  var shopLat = 0.0.obs;
  var shopLng = 0.0.obs;
  var pickedLocation = "Tap to pick location or use current location".obs;

  // Dropdown variables
  var selectedState = "".obs;
  var selectedDistrict = "".obs;
  var selectedLocation = "".obs;

  // Data from API
  var states = <String>[].obs;
  var districts = <String>[].obs;
  var locations = <String>[].obs;
  final box = GetStorage();


  // ------------------ API URLs ------------------
  static const String signupApiUrl =
      "https://rasma.astradevelops.in/e_shoppyy/public/api/merchant/signup";
  static const String statesApi =
      "https://rasma.astradevelops.in/e_shoppyy/public/api/merchant/states";
  static const String districtsApi =
      "https://rasma.astradevelops.in/e_shoppyy/public/api/merchant/districts";
  static const String locationsApi =
      "https://rasma.astradevelops.in/e_shoppyy/public/api/merchant/locations";

  @override
  void onInit() {
    super.onInit();
    fetchStates();
  }

  // ------------------ FETCH STATES ------------------
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
          // Extract states list from response and remove duplicates
          List<String> statesList = List<String>.from(data['data']);
          // Remove duplicates by converting to Set and back to List
          List<String> uniqueStates = statesList.toSet().toList();
          states.assignAll(uniqueStates);
        } else {
          throw Exception("API returned status: ${data['status']}");
        }
      } else {
        throw Exception("Failed to load states. Status: ${response.statusCode}");
      }
    } catch (e) {

      Get.snackbar(
        "Error",
        "Failed to load states: $e",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: const Duration(seconds: 3),
      );
    } finally {
      isLoadingStates.value = false;
    }
  }

  // ------------------ FETCH DISTRICTS ------------------
  Future<void> fetchDistricts(String state) async {
    try {
      isLoadingDistricts.value = true;

      // Clear dependent dropdowns
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
          // Extract districts list from response and remove duplicates
          List<String> districtsList = List<String>.from(data['data']);
          // Remove duplicates by converting to Set and back to List
          List<String> uniqueDistricts = districtsList.toSet().toList();
          districts.assignAll(uniqueDistricts);

          print("✅ Loaded ${districts.length} districts for $state: $uniqueDistricts");

          if (districts.isEmpty) {
            Get.snackbar(
              "Notice",
              "No districts found for $state",
              snackPosition: SnackPosition.BOTTOM,
              backgroundColor: Colors.orange,
              colorText: Colors.white,
              duration: const Duration(seconds: 2),
            );
          }
        } else {
          throw Exception("API returned status: ${data['status']}");
        }
      } else {
        throw Exception("Failed to load districts. Status: ${response.statusCode}");
      }
    } catch (e) {

      Get.snackbar(
        "Error",
        "Failed to load districts: $e",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: const Duration(seconds: 3),
      );
    } finally {
      isLoadingDistricts.value = false;
    }
  }

  // ------------------ FETCH LOCATIONS ------------------
  Future<void> fetchLocations(String state, String district) async {
    try {
      isLoadingLocations.value = true;

      // Clear dependent dropdown
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
          // Extract locations list from response and remove duplicates
          List<String> locationsList = List<String>.from(data['data']);
          // Remove duplicates by converting to Set and back to List
          List<String> uniqueLocations = locationsList.toSet().toList();
          locations.assignAll(uniqueLocations);

          print("✅ Loaded ${locations.length} locations for $state > $district: $uniqueLocations");

          if (locations.isEmpty) {
            Get.snackbar(
              "Notice",
              "No locations found for $district",
              snackPosition: SnackPosition.BOTTOM,
              backgroundColor: Colors.orange,
              colorText: Colors.white,
              duration: const Duration(seconds: 2),
            );
          }
        } else {
          throw Exception("API returned status: ${data['status']}");
        }
      } else {
        throw Exception("Failed to load locations. Status: ${response.statusCode}");
      }
    } catch (e) {

      Get.snackbar(
        "Error",
        "Failed to load locations: $e",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: const Duration(seconds: 3),
      );
    } finally {
      isLoadingLocations.value = false;
    }
  }

  // ------------------ GET CURRENT LOCATION ------------------
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

      shopLat.value = position.latitude;
      shopLng.value = position.longitude;

      print("Current Location: ${position.latitude}, ${position.longitude}");

      // Get address from coordinates
      try {
        List<Placemark> placemarks = await placemarkFromCoordinates(
          position.latitude,
          position.longitude,
        );

        if (placemarks.isNotEmpty) {
          Placemark place = placemarks.first;
          pickedLocation.value =
          "${place.street ?? ''}, ${place.locality ?? ''}, ${place.administrativeArea ?? ''}, ${place.country ?? ''}";

          print("Address: ${pickedLocation.value}");
        } else {
          pickedLocation.value =
          "Lat: ${position.latitude.toStringAsFixed(6)}, Lng: ${position.longitude.toStringAsFixed(6)}";
        }
      } catch (e) {
        print("Error getting address: $e");
        pickedLocation.value =
        "Lat: ${position.latitude.toStringAsFixed(6)}, Lng: ${position.longitude.toStringAsFixed(6)}";
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

  // ------------------ METHODS ------------------
  void setStoreImage(File image) {
    storeImage.value = image;
  }

  void updateLocation(double lat, double lng, String address) {
    shopLat.value = lat;
    shopLng.value = lng;
    pickedLocation.value = address;
  }

  // ------------------ VALIDATION (MANDATORY FIELDS ONLY) ------------------
  bool validateInputs() {
    if (storeImage.value == null) {
      Get.snackbar(
        "Error",
        "Please select a store image",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return false;
    }

    if (ownerNameController.text.trim().isEmpty) {
      Get.snackbar(
        "Error",
        "Please enter owner name",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return false;
    }

    if (shopNameController.text.trim().isEmpty) {
      Get.snackbar(
        "Error",
        "Please enter shop name",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return false;
    }

    if (emailController.text.trim().isEmpty) {
      Get.snackbar(
        "Error",
        "Please enter email",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return false;
    }

    if (!GetUtils.isEmail(emailController.text.trim())) {
      Get.snackbar(
        "Error",
        "Please enter a valid email",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return false;
    }

    if (passwordController.text.trim().isEmpty) {
      Get.snackbar(
        "Error",
        "Please enter password",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return false;
    }

    if (passwordController.text.trim().length < 6) {
      Get.snackbar(
        "Error",
        "Password must be at least 6 characters",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return false;
    }

    if (phoneNo1Controller.text.trim().isEmpty) {
      Get.snackbar(
        "Error",
        "Please enter phone number",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return false;
    }

    if (phoneNo1Controller.text.trim().length != 10) {
      Get.snackbar(
        "Error",
        "Phone number must be 10 digits",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return false;
    }

    if (selectedState.value.isEmpty) {
      Get.snackbar(
        "Error",
        "Please select state",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return false;
    }

    if (selectedDistrict.value.isEmpty) {
      Get.snackbar(
        "Error",
        "Please select district",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return false;
    }

    if (selectedLocation.value.isEmpty) {
      Get.snackbar(
        "Error",
        "Please select main location",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return false;
    }

    if (shopLat.value == 0.0 || shopLng.value == 0.0) {
      Get.snackbar(
        "Error",
        "Please set shop location (use map or current location)",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return false;
    }

    return true;
  }

  // ------------------ CONVERT IMAGE TO BASE64 ------------------
  Future<String> convertImageToBase64(File imageFile) async {
    List<int> imageBytes = await imageFile.readAsBytes();
    String base64Image = base64Encode(imageBytes);
    return "data:image/jpeg;base64,$base64Image";
  }

  // ------------------ REGISTER MERCHANT API CALL ------------------
  Future<void> registerMerchant() async {
    if (!validateInputs()) return;

    try {
      isLoading.value = true;

      // Convert image to base64
      String base64Image = await convertImageToBase64(storeImage.value!);

      // Prepare request body (optional fields only included if not empty)
      final Map<String, dynamic> requestBody = {
        "store_image": base64Image,
        "owner_name": ownerNameController.text.trim(),
        "shop_name": shopNameController.text.trim(),
        "email": emailController.text.trim(),
        "password": passwordController.text.trim(),
        "phone_no_1": phoneNo1Controller.text.trim(),
        "phone_no_2": phoneNo2Controller.text.trim(),
        "state": selectedState.value,
        "district": selectedDistrict.value,
        "main_location": selectedLocation.value,
        "latitude": shopLat.value,
        "longitude": shopLng.value,
        "user_type": "merchant"
      };

      // Add optional fields only if they're not empty
      if (whatsappController.text.trim().isNotEmpty) {
        requestBody["whatsapp_no"] = whatsappController.text.trim();
      }
      if (facebookController.text.trim().isNotEmpty) {
        requestBody["facebook_link"] = facebookController.text.trim();
      }
      if (instagramController.text.trim().isNotEmpty) {
        requestBody["instagram_link"] = instagramController.text.trim();
      }
      if (websiteController.text.trim().isNotEmpty) {
        requestBody["website_link"] = websiteController.text.trim();
      }

      // Make API call
      final response = await http.post(
        Uri.parse(signupApiUrl),
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
        },
        body: jsonEncode(requestBody),
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        final responseData = jsonDecode(response.body);

        if (responseData['status'] == true) {
          // Save auth token if needed
          String authToken = responseData['data']['auth_token'];
          box.write("auth_token", authToken);
          box.write("is_logged_in", true);
          box.write("role", 2);
          // You can save this token using GetStorage or SharedPreferences
          // Example: GetStorage().write('auth_token', authToken);

          Get.snackbar(
            "Success",
            responseData['message'] ?? "Merchant registered successfully!",
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.green,
            colorText: Colors.white,
            duration: const Duration(seconds: 3),
          );

          // Navigate to merchant dashboard
          Get.offAll(() => MerchantDashboardPage());
        } else {
          Get.snackbar(
            "Error",
            responseData['message'] ?? "Registration failed",
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.red,
            colorText: Colors.white,
          );
        }
      } else {
        final errorData = jsonDecode(response.body);
        Get.snackbar(
          "Error",
          errorData['message'] ?? "Registration failed. Please try again.",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      print("Error during registration: $e");
      Get.snackbar(
        "Error",
        "An error occurred: ${e.toString()}",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    ownerNameController.dispose();
    shopNameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    phoneNo1Controller.dispose();
    phoneNo2Controller.dispose();
    whatsappController.dispose();
    facebookController.dispose();
    instagramController.dispose();
    websiteController.dispose();
    super.onClose();
  }
}
