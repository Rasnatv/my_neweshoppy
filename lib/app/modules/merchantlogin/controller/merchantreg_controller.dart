
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

import '../../../common/utils/validators.dart';
import '../../merchant_home/views/merchant_home.dart';
import '../../../data/errors/api_error.dart';
import '../widget/successwidget.dart';

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

  var storeImage = Rx<File?>(null);
  var isLoading = false.obs;
  var isLoadingStates = false.obs;
  var isLoadingDistricts = false.obs;
  var isLoadingLocations = false.obs;
  var isGettingCurrentLocation = false.obs;


  // Add this observable
  var isPasswordVisible = false.obs;
  final confirmPasswordController = TextEditingController();
  var isConfirmPasswordVisible = false.obs;

  void toggleConfirmPasswordVisibility() => isConfirmPasswordVisible.toggle();

// Add this method
  void togglePasswordVisibility() => isPasswordVisible.toggle();

  var shopLat = 0.0.obs;
  var shopLng = 0.0.obs;
  var pickedLocation = "Tap to pick location or use current location".obs;

  var selectedState = "".obs;
  var selectedDistrict = "".obs;
  var selectedLocation = "".obs;

  var states = <String>[].obs;
  var districts = <String>[].obs;
  var locations = <String>[].obs;

  final box = GetStorage();

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
          states.assignAll(
              List<String>.from(data['data']).toSet().toList());
        } else {
          AppSnackbar.error(
              data['message'] ?? "Failed to load states");
        }
      } else {
        AppSnackbar.error(ApiErrorHandler.handleResponse(response));
      }

    } catch (e) {
      AppSnackbar.error(ApiErrorHandler.handleException(e));
    } finally {
      isLoadingStates.value = false;
    }
  }

  // ------------------ FETCH DISTRICTS ------------------
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
              List<String>.from(data['data']).toSet().toList());

          if (districts.isEmpty) {
            AppSnackbar.warning("No districts found for $state");
          }
        } else {
          AppSnackbar.error(
              data['message'] ?? "Failed to load districts");
        }
      } else {
        AppSnackbar.error(ApiErrorHandler.handleResponse(response));
      }

    } catch (e) {
      AppSnackbar.error(ApiErrorHandler.handleException(e));
    } finally {
      isLoadingDistricts.value = false;
    }
  }

  // ------------------ FETCH LOCATIONS ------------------
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
              List<String>.from(data['data']).toSet().toList());

          if (locations.isEmpty) {
            AppSnackbar.warning("No locations found for $district");
          }
        } else {
          AppSnackbar.error(
              data['message'] ?? "Failed to load locations");
        }
      } else {
        AppSnackbar.error(ApiErrorHandler.handleResponse(response));
      }

    } catch (e) {
      AppSnackbar.error(ApiErrorHandler.handleException(e));
    } finally {
      isLoadingLocations.value = false;
    }
  }

  // ------------------ GET CURRENT LOCATION ------------------
  Future<void> getCurrentLocation() async {
    try {
      isGettingCurrentLocation.value = true;

      bool serviceEnabled =
      await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        AppSnackbar.error("Location services are disabled");
        return;
      }

      LocationPermission permission =
      await Geolocator.checkPermission();

      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          AppSnackbar.error("Location permission denied");
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        AppSnackbar.error(
            "Enable location permission from settings");
        return;
      }

      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      shopLat.value = position.latitude;
      shopLng.value = position.longitude;

      try {
        List<Placemark> placemarks =
        await placemarkFromCoordinates(
          position.latitude,
          position.longitude,
        );

        if (placemarks.isNotEmpty) {
          final place = placemarks.first;
          pickedLocation.value =
          "${place.street ?? ''}, ${place.locality ?? ''}, ${place.administrativeArea ?? ''}, ${place.country ?? ''}";
        }
      } catch (_) {}

      AppSnackbar.success("Current location fetched successfully");

    } catch (e) {
      AppSnackbar.error(ApiErrorHandler.handleException(e));
    } finally {
      isGettingCurrentLocation.value = false;
    }
  }

  // ------------------ METHODS ------------------
  void setStoreImage(File image) => storeImage.value = image;

  void updateLocation(double lat, double lng, String address) {
    shopLat.value = lat;
    shopLng.value = lng;
    pickedLocation.value = address;
  }

  bool validateInputs() {
    // existing checks...
    if (storeImage.value == null) {
      AppSnackbar.error("Please select a store image");
      return false;
    }

    // ✅ Add these new checks
    if (ownerNameController.text.trim().isEmpty) {
      AppSnackbar.error("Owner name is required");
      return false;
    }
    if (shopNameController.text.trim().isEmpty) {
      AppSnackbar.error("Shop name is required");
      return false;
    }

    final emailError = DValidator.validateEmail(emailController.text.trim());
    if (emailError != null) {
      AppSnackbar.error(emailError);
      return false;
    }

    final passwordError = DValidator.validatePassword(passwordController.text.trim());
    if (passwordError != null) {
      AppSnackbar.error(passwordError);
      return false;
    }

    final phoneError = DValidator.validatePhoneNumber(phoneNo1Controller.text.trim());
    if (phoneError != null) {
      AppSnackbar.error(phoneError);
      return false;
    }
    if (confirmPasswordController.text.trim() != passwordController.text.trim()) {
      AppSnackbar.error("Passwords do not match");
      return false;
    }

    if (selectedState.value.isEmpty) {
      AppSnackbar.error("Please select state");
      return false;
    }
    if (selectedDistrict.value.isEmpty) {
      AppSnackbar.error("Please select district");
      return false;
    }
    if (selectedLocation.value.isEmpty) {
      AppSnackbar.error("Please select main location");
      return false;
    }
    if (shopLat.value == 0.0 || shopLng.value == 0.0) {
      AppSnackbar.error("Please set shop location");
      return false;

    }

    return true;
  }

  // ------------------ CONVERT IMAGE ------------------
  Future<String> convertImageToBase64(File imageFile) async {
    return "data:image/jpeg;base64,${base64Encode(await imageFile.readAsBytes())}";
  }

  // ------------------ REGISTER ------------------
  Future<void> registerMerchant() async {
    if (!validateInputs()) return;

    try {
      isLoading.value = true;

      String base64Image =
      await convertImageToBase64(storeImage.value!);

      final requestBody = {
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
        "user_type": "merchant",
      };

      final response = await http.post(
        Uri.parse(signupApiUrl),
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
        },
        body: jsonEncode(requestBody),
      );

      if (response.statusCode == 200 ||
          response.statusCode == 201) {

        final responseData = jsonDecode(response.body);

        if (responseData['status'] == true) {
          box.write("auth_token", responseData['data']['auth_token']);
          box.write("is_logged_in", true);
          box.write("role", 2);

          AppSnackbar.success(
              responseData['message'] ??
                  "Merchant registered successfully!");

          Get.offAll(() => MerchantDashboardPage());
        } else {
          AppSnackbar.error(
              responseData['message'] ?? "Registration failed");
        }

      } else {
        AppSnackbar.error(ApiErrorHandler.handleResponse(response));
      }

    } catch (e) {
      AppSnackbar.error(ApiErrorHandler.handleException(e));
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
    confirmPasswordController.dispose();
    super.onClose();
  }
}