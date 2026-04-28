
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import '../../../../data/errors/api_error.dart';
import '../../../merchantlogin/widget/successwidget.dart';  // ← adjust path

class AdminAddMerchantController extends GetxController {
  final box = GetStorage();

  // ─── Text Controllers ─────────────────────────────────────────────────────
  final ownerNameController  = TextEditingController();
  final shopNameController   = TextEditingController();
  final emailController      = TextEditingController();
  final phoneNo1Controller   = TextEditingController();
  final phoneNo2Controller   = TextEditingController();
  final whatsappController   = TextEditingController();
  final facebookController   = TextEditingController();
  final instagramController  = TextEditingController();
  final websiteController    = TextEditingController();

  // ─── Observables ──────────────────────────────────────────────────────────
  final storeImage                = Rx<File?>(null);
  final isLoading                 = false.obs;
  final isLoadingStates           = false.obs;
  final isLoadingDistricts        = false.obs;
  final isLoadingLocations        = false.obs;
  final isGettingCurrentLocation  = false.obs;

  // Location
  final shopLat        = 0.0.obs;
  final shopLng        = 0.0.obs;
  final pickedLocation =
      'Tap to pick location or use current location'.obs;

  // Dropdowns
  final selectedState    = ''.obs;
  final selectedDistrict = ''.obs;
  final selectedLocation = ''.obs;

  // Dropdown data
  final states    = <String>[].obs;
  final districts = <String>[].obs;
  final locations = <String>[].obs;

  // ─── API URLs ─────────────────────────────────────────────────────────────
  static const String _adminAddMerchantUrl =
      'https://eshoppy.co.in/api/admin/register-merchant';
  static const String _statesUrl =
      'https://eshoppy.co.in/api/merchant/states';
  static const String _districtsUrl =
      'https://eshoppy.co.in/api/merchant/districts';
  static const String _locationsUrl =
      'https://eshoppy.co.in/api/merchant/locations';

  // ─── Auth ─────────────────────────────────────────────────────────────────
  String get _authToken => box.read('auth_token') ?? '';

  Map<String, String> get _headers => {
    'Content-Type' : 'application/json',
    'Accept'       : 'application/json',
    'Authorization': 'Bearer $_authToken',
  };

  // ─── Lifecycle ────────────────────────────────────────────────────────────
  @override
  void onInit() {
    super.onInit();
    fetchStates();
  }

  @override
  void onClose() {
    ownerNameController.dispose();
    shopNameController.dispose();
    emailController.dispose();
    phoneNo1Controller.dispose();
    phoneNo2Controller.dispose();
    whatsappController.dispose();
    facebookController.dispose();
    instagramController.dispose();
    websiteController.dispose();
    super.onClose();
  }

  // ─── Fetch States ─────────────────────────────────────────────────────────
  Future<void> fetchStates() async {
    if (_authToken.isEmpty) {
      ApiErrorHandler.handleUnauthorized();
      return;
    }
    try {
      isLoadingStates.value = true;
      final response = await http.get(
        Uri.parse(_statesUrl),
        headers: _headers,
      );
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['status'] == 1) {
          states.assignAll(
            List<String>.from(data['data']).toSet().toList(),
          );
        } else {
          AppSnackbar.error(data['message'] ?? 'Failed to load states');
        }
      } else {
        AppSnackbar.error(ApiErrorHandler.handleResponse(response));
      }
    } on SocketException {
      AppSnackbar.error(ApiErrorHandler.handleException(SocketException('')));
    } catch (e) {
      AppSnackbar.error(ApiErrorHandler.handleException(e));
    } finally {
      isLoadingStates.value = false;
    }
  }

  // ─── Fetch Districts ──────────────────────────────────────────────────────
  Future<void> fetchDistricts(String state) async {
    if (_authToken.isEmpty) {
      ApiErrorHandler.handleUnauthorized();
      return;
    }
    try {
      isLoadingDistricts.value = true;
      districts.clear();
      locations.clear();
      selectedDistrict.value = '';
      selectedLocation.value = '';

      final response = await http.post(
        Uri.parse(_districtsUrl),
        headers: _headers,
        body: jsonEncode({'state': state}),
      );
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['status'] == 1) {
          districts.assignAll(
            List<String>.from(data['data']).toSet().toList(),
          );
        } else {
          AppSnackbar.error(data['message'] ?? 'Failed to load districts');
        }
      } else {
        AppSnackbar.error(ApiErrorHandler.handleResponse(response));
      }
    } on SocketException {
      AppSnackbar.error(ApiErrorHandler.handleException(SocketException('')));
    } catch (e) {
      AppSnackbar.error(ApiErrorHandler.handleException(e));
    } finally {
      isLoadingDistricts.value = false;
    }
  }

  // ─── Fetch Locations ──────────────────────────────────────────────────────
  Future<void> fetchLocations(String state, String district) async {
    if (_authToken.isEmpty) {
      ApiErrorHandler.handleUnauthorized();
      return;
    }
    try {
      isLoadingLocations.value = true;
      locations.clear();
      selectedLocation.value = '';

      final response = await http.post(
        Uri.parse(_locationsUrl),
        headers: _headers,
        body: jsonEncode({'state': state, 'district': district}),
      );
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['status'] == 1) {
          locations.assignAll(
            List<String>.from(data['data']).toSet().toList(),
          );
        } else {
          AppSnackbar.error(data['message'] ?? 'Failed to load locations');
        }
      } else {
        AppSnackbar.error(ApiErrorHandler.handleResponse(response));
      }
    } on SocketException {
      AppSnackbar.error(ApiErrorHandler.handleException(SocketException('')));
    } catch (e) {
      AppSnackbar.error(ApiErrorHandler.handleException(e));
    } finally {
      isLoadingLocations.value = false;
    }
  }

  // ─── Get Current Location ─────────────────────────────────────────────────
  Future<void> getCurrentLocation() async {
    try {
      isGettingCurrentLocation.value = true;

      final serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        AppSnackbar.error('Location services are disabled');
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          AppSnackbar.error('Location permission denied');
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        AppSnackbar.error(
          'Location permission permanently denied. Enable it from settings.',
        );
        return;
      }

      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      shopLat.value = position.latitude;
      shopLng.value = position.longitude;

      try {
        final placemarks = await placemarkFromCoordinates(
          position.latitude,
          position.longitude,
        );
        if (placemarks.isNotEmpty) {
          final place = placemarks.first;
          pickedLocation.value =
          '${place.street ?? ''}, ${place.locality ?? ''}, '
              '${place.administrativeArea ?? ''}, ${place.country ?? ''}';
        } else {
          pickedLocation.value =
          'Lat: ${position.latitude.toStringAsFixed(6)}, '
              'Lng: ${position.longitude.toStringAsFixed(6)}';
        }
      } catch (_) {
        pickedLocation.value =
        'Lat: ${position.latitude.toStringAsFixed(6)}, '
            'Lng: ${position.longitude.toStringAsFixed(6)}';
      }

      AppSnackbar.success('Current location fetched successfully');
    } on SocketException {
      AppSnackbar.error(ApiErrorHandler.handleException(SocketException('')));
    } catch (e) {
      AppSnackbar.error('Failed to get location: ${e.toString()}');
    } finally {
      isGettingCurrentLocation.value = false;
    }
  }

  // ─── Helpers ──────────────────────────────────────────────────────────────
  void setStoreImage(File image) => storeImage.value = image;

  void updateLocation(double lat, double lng, String address) {
    shopLat.value        = lat;
    shopLng.value        = lng;
    pickedLocation.value = address;
  }

  // ─── Validation ───────────────────────────────────────────────────────────
  bool validateInputs() {
    if (storeImage.value == null) {
      AppSnackbar.warning('Please select a store image');
      return false;
    }
    if (ownerNameController.text.trim().isEmpty) {
      AppSnackbar.warning('Please enter owner name');
      return false;
    }
    if (shopNameController.text.trim().isEmpty) {
      AppSnackbar.warning('Please enter shop name');
      return false;
    }
    if (emailController.text.trim().isEmpty) {
      AppSnackbar.warning('Please enter email address');
      return false;
    }
    if (!GetUtils.isEmail(emailController.text.trim())) {
      AppSnackbar.warning('Please enter a valid email address');
      return false;
    }
    if (phoneNo1Controller.text.trim().isEmpty) {
      AppSnackbar.warning('Please enter phone number');
      return false;
    }
    if (phoneNo1Controller.text.trim().length != 10) {
      AppSnackbar.warning('Phone number must be 10 digits');
      return false;
    }
    if (selectedState.value.isEmpty) {
      AppSnackbar.warning('Please select state');
      return false;
    }
    if (selectedDistrict.value.isEmpty) {
      AppSnackbar.warning('Please select district');
      return false;
    }
    if (selectedLocation.value.isEmpty) {
      AppSnackbar.warning('Please select main location');
      return false;
    }
    if (shopLat.value == 0.0 || shopLng.value == 0.0) {
      AppSnackbar.warning('Please set shop location');
      return false;
    }
    return true;
  }

  // ─── Image to Base64 ──────────────────────────────────────────────────────
  Future<String> convertImageToBase64(File imageFile) async {
    final bytes = await imageFile.readAsBytes();
    return 'data:image/jpeg;base64,${base64Encode(bytes)}';
  }

  // ─── Success Dialog ───────────────────────────────────────────────────────
  void _showSuccessDialog(String email) {
    Get.dialog(
      WillPopScope(
        onWillPop: () async => false,
        child: Dialog(
          backgroundColor: const Color(0xFF1E1E1E),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: const Color(0xFF4CAF50).withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.check_circle,
                    color: Color(0xFF4CAF50),
                    size: 64,
                  ),
                ),
                const SizedBox(height: 24),
                const Text(
                  'Merchant Registered Successfully!',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        const Color(0xFF64B5F6).withOpacity(0.15),
                        const Color(0xFF42A5F5).withOpacity(0.1),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: const Color(0xFF64B5F6).withOpacity(0.3),
                    ),
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: const Color(0xFF64B5F6).withOpacity(0.2),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.mark_email_read,
                              color: Color(0xFF64B5F6),
                              size: 28,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Credentials Sent!',
                                  style: TextStyle(
                                    color: Color(0xFF64B5F6),
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  'Login credentials have been sent to:',
                                  style: TextStyle(
                                    color: Colors.grey[400],
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: const Color(0xFF252525),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.email_outlined,
                              color: Colors.white70,
                              size: 18,
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                email,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: Colors.green.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: Colors.green.withOpacity(0.3),
                    ),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.info_outline,
                        color: Colors.green,
                        size: 22,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Email Delivery',
                              style: TextStyle(
                                color: Colors.green,
                                fontWeight: FontWeight.bold,
                                fontSize: 13,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'The merchant should check their inbox and spam folder for the login credentials.',
                              style: TextStyle(
                                color: Colors.grey[400],
                                fontSize: 12,
                                height: 1.3,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton(
                    onPressed: () {
                      Get.back(); // close dialog
                      Get.back(); // go back to previous screen
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF64B5F6),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 0,
                    ),
                    child: const Text(
                      'Done',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      barrierDismissible: false,
    );
  }

  // ─── Add Merchant ─────────────────────────────────────────────────────────
  Future<void> addMerchant() async {
    if (!validateInputs()) return;

    if (_authToken.isEmpty) {
      ApiErrorHandler.handleUnauthorized();
      return;
    }

    final merchantEmail = emailController.text.trim();

    try {
      isLoading.value = true;

      final base64Image = await convertImageToBase64(storeImage.value!);

      final Map<String, dynamic> requestBody = {
        'store_image'  : base64Image,
        'owner_name'   : ownerNameController.text.trim(),
        'shop_name'    : shopNameController.text.trim(),
        'email'        : merchantEmail,
        'phone_no_1'   : phoneNo1Controller.text.trim(),
        'phone_no_2'   : phoneNo2Controller.text.trim(),
        'state'        : selectedState.value,
        'district'     : selectedDistrict.value,
        'main_location': selectedLocation.value,
        'latitude'     : shopLat.value,
        'longitude'    : shopLng.value,
      };

      if (whatsappController.text.trim().isNotEmpty) {
        requestBody['whatsapp_no'] = whatsappController.text.trim();
      }
      if (facebookController.text.trim().isNotEmpty) {
        requestBody['facebook_link'] = facebookController.text.trim();
      }
      if (instagramController.text.trim().isNotEmpty) {
        requestBody['instagram_link'] = instagramController.text.trim();
      }
      if (websiteController.text.trim().isNotEmpty) {
        requestBody['website_link'] = websiteController.text.trim();
      }

      final response = await http.post(
        Uri.parse(_adminAddMerchantUrl),
        headers: _headers,
        body: jsonEncode(requestBody),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = jsonDecode(response.body);
        if (data['status'] == true) {
          _clearAllFields();
          _showSuccessDialog(merchantEmail);
        } else {
          AppSnackbar.error(data['message'] ?? 'Failed to register merchant');
        }
      } else {
        AppSnackbar.error(ApiErrorHandler.handleResponse(response));
      }
    } on SocketException {
      AppSnackbar.error(ApiErrorHandler.handleException(SocketException('')));
    } catch (e) {
      AppSnackbar.error(ApiErrorHandler.handleException(e));
    } finally {
      isLoading.value = false;
    }
  }

  // ─── Clear Fields ─────────────────────────────────────────────────────────
  void _clearAllFields() {
    ownerNameController.clear();
    shopNameController.clear();
    emailController.clear();
    phoneNo1Controller.clear();
    phoneNo2Controller.clear();
    whatsappController.clear();
    facebookController.clear();
    instagramController.clear();
    websiteController.clear();

    storeImage.value       = null;
    selectedState.value    = '';
    selectedDistrict.value = '';
    selectedLocation.value = '';
    shopLat.value          = 0.0;
    shopLng.value          = 0.0;
    pickedLocation.value   = 'Tap to pick location or use current location';

    districts.clear();
    locations.clear();
  }
}