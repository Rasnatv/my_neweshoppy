//
// import 'dart:convert';
// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:get_storage/get_storage.dart';
// import 'package:http/http.dart' as http;
// import 'package:geolocator/geolocator.dart';
// import 'package:geocoding/geocoding.dart';
//
// class AdminAddMerchantController extends GetxController {
//   final box = GetStorage();
//
//   // ------------------ TEXT CONTROLLERS ------------------
//   final ownerNameController = TextEditingController();
//   final shopNameController = TextEditingController();
//   final emailController = TextEditingController();
//   final passwordController = TextEditingController();
//   final phoneNo1Controller = TextEditingController();
//   final phoneNo2Controller = TextEditingController();
//   final whatsappController = TextEditingController();
//   final facebookController = TextEditingController();
//   final instagramController = TextEditingController();
//   final websiteController = TextEditingController();
//
//   // ------------------ REACTIVE VARIABLES ------------------
//   var storeImage = Rx<File?>(null);
//   var isLoading = false.obs;
//   var isLoadingStates = false.obs;
//   var isLoadingDistricts = false.obs;
//   var isLoadingLocations = false.obs;
//   var isGettingCurrentLocation = false.obs;
//
//   // Location variables
//   var shopLat = 0.0.obs;
//   var shopLng = 0.0.obs;
//   var pickedLocation = "Tap to pick location or use current location".obs;
//
//   // Dropdown variables
//   var selectedState = "".obs;
//   var selectedDistrict = "".obs;
//   var selectedLocation = "".obs;
//
//   // Data from API
//   var states = <String>[].obs;
//   var districts = <String>[].obs;
//   var locations = <String>[].obs;
//
//   // ------------------ API URLs ------------------
//   static const String adminAddMerchantApiUrl =
//       "https://rasma.astradevelops.in/e_shoppyy/public/api/admin/register-merchant";
//   static const String statesApi =
//       "https://rasma.astradevelops.in/e_shoppyy/public/api/merchant/states";
//   static const String districtsApi =
//       "https://rasma.astradevelops.in/e_shoppyy/public/api/merchant/districts";
//   static const String locationsApi =
//       "https://rasma.astradevelops.in/e_shoppyy/public/api/merchant/locations";
//
//   @override
//   void onInit() {
//     super.onInit();
//     fetchStates();
//   }
//
//   // ------------------ FETCH STATES ------------------
//   Future<void> fetchStates() async {
//     try {
//       isLoadingStates.value = true;
//       final authToken = box.read('auth_token') ?? '';
//
//       print("════════════════════════════════════════");
//       print("Fetching States from: $statesApi");
//       print("Auth Token: $authToken");
//       print("════════════════════════════════════════");
//
//       final response = await http.get(
//         Uri.parse(statesApi),
//         headers: {
//           "Content-Type": "application/json",
//           "Accept": "application/json",
//           "Authorization": "Bearer $authToken",
//         },
//       );
//
//       print("════════════════════════════════════════");
//       print("States API Response Status: ${response.statusCode}");
//       print("States API Response Body: ${response.body}");
//       print("════════════════════════════════════════");
//
//       if (response.statusCode == 200) {
//         final data = jsonDecode(response.body);
//
//         if (data['status'] == 1) {
//           List<String> statesList = List<String>.from(data['data']);
//           List<String> uniqueStates = statesList.toSet().toList();
//           states.assignAll(uniqueStates);
//
//           print("✅ Loaded ${states.length} states: $uniqueStates");
//         } else {
//           throw Exception("API returned status: ${data['status']}");
//         }
//       } else {
//         throw Exception("Failed to load states. Status: ${response.statusCode}");
//       }
//     } catch (e) {
//       print("════════════════════════════════════════");
//       print("❌ Error fetching states: $e");
//       print("════════════════════════════════════════");
//
//       Get.snackbar(
//         "Error",
//         "Failed to load states: $e",
//         snackPosition: SnackPosition.BOTTOM,
//         backgroundColor: Colors.red,
//         colorText: Colors.white,
//         duration: const Duration(seconds: 3),
//       );
//     } finally {
//       isLoadingStates.value = false;
//     }
//   }
//
//   // ------------------ FETCH DISTRICTS ------------------
//   Future<void> fetchDistricts(String state) async {
//     try {
//       isLoadingDistricts.value = true;
//       districts.clear();
//       locations.clear();
//       selectedDistrict.value = "";
//       selectedLocation.value = "";
//
//       final authToken = box.read('auth_token') ?? '';
//
//       print("════════════════════════════════════════");
//       print("Fetching Districts for State: $state");
//       print("API: $districtsApi");
//       print("Auth Token: $authToken");
//       print("════════════════════════════════════════");
//
//       final response = await http.post(
//         Uri.parse(districtsApi),
//         headers: {
//           "Content-Type": "application/json",
//           "Accept": "application/json",
//           "Authorization": "Bearer $authToken",
//         },
//         body: jsonEncode({"state": state}),
//       );
//
//       print("════════════════════════════════════════");
//       print("Districts API Response Status: ${response.statusCode}");
//       print("Districts API Response Body: ${response.body}");
//       print("════════════════════════════════════════");
//
//       if (response.statusCode == 200) {
//         final data = jsonDecode(response.body);
//
//         if (data['status'] == 1) {
//           List<String> districtsList = List<String>.from(data['data']);
//           List<String> uniqueDistricts = districtsList.toSet().toList();
//           districts.assignAll(uniqueDistricts);
//
//           print("✅ Loaded ${districts.length} districts for $state: $uniqueDistricts");
//
//           if (districts.isEmpty) {
//             Get.snackbar(
//               "Notice",
//               "No districts found for $state",
//               snackPosition: SnackPosition.BOTTOM,
//               backgroundColor: Colors.orange,
//               colorText: Colors.white,
//               duration: const Duration(seconds: 2),
//             );
//           }
//         } else {
//           throw Exception("API returned status: ${data['status']}");
//         }
//       } else {
//         throw Exception("Failed to load districts. Status: ${response.statusCode}");
//       }
//     } catch (e) {
//       print("════════════════════════════════════════");
//       print("❌ Error fetching districts: $e");
//       print("════════════════════════════════════════");
//
//       Get.snackbar(
//         "Error",
//         "Failed to load districts: $e",
//         snackPosition: SnackPosition.BOTTOM,
//         backgroundColor: Colors.red,
//         colorText: Colors.white,
//         duration: const Duration(seconds: 3),
//       );
//     } finally {
//       isLoadingDistricts.value = false;
//     }
//   }
//
//   // ------------------ FETCH LOCATIONS ------------------
//   Future<void> fetchLocations(String state, String district) async {
//     try {
//       isLoadingLocations.value = true;
//       locations.clear();
//       selectedLocation.value = "";
//
//       final authToken = box.read('auth_token') ?? '';
//
//       print("════════════════════════════════════════");
//       print("Fetching Locations for:");
//       print("State: $state");
//       print("District: $district");
//       print("API: $locationsApi");
//       print("Auth Token: $authToken");
//       print("════════════════════════════════════════");
//
//       final response = await http.post(
//         Uri.parse(locationsApi),
//         headers: {
//           "Content-Type": "application/json",
//           "Accept": "application/json",
//           "Authorization": "Bearer $authToken",
//         },
//         body: jsonEncode({
//           "state": state,
//           "district": district,
//         }),
//       );
//
//       print("════════════════════════════════════════");
//       print("Locations API Response Status: ${response.statusCode}");
//       print("Locations API Response Body: ${response.body}");
//       print("════════════════════════════════════════");
//
//       if (response.statusCode == 200) {
//         final data = jsonDecode(response.body);
//
//         if (data['status'] == 1) {
//           List<String> locationsList = List<String>.from(data['data']);
//           List<String> uniqueLocations = locationsList.toSet().toList();
//           locations.assignAll(uniqueLocations);
//
//           print("✅ Loaded ${locations.length} locations for $state > $district: $uniqueLocations");
//
//           if (locations.isEmpty) {
//             Get.snackbar(
//               "Notice",
//               "No locations found for $district",
//               snackPosition: SnackPosition.BOTTOM,
//               backgroundColor: Colors.orange,
//               colorText: Colors.white,
//               duration: const Duration(seconds: 2),
//             );
//           }
//         } else {
//           throw Exception("API returned status: ${data['status']}");
//         }
//       } else {
//         throw Exception("Failed to load locations. Status: ${response.statusCode}");
//       }
//     } catch (e) {
//       print("════════════════════════════════════════");
//       print("❌ Error fetching locations: $e");
//       print("════════════════════════════════════════");
//
//       Get.snackbar(
//         "Error",
//         "Failed to load locations: $e",
//         snackPosition: SnackPosition.BOTTOM,
//         backgroundColor: Colors.red,
//         colorText: Colors.white,
//         duration: const Duration(seconds: 3),
//       );
//     } finally {
//       isLoadingLocations.value = false;
//     }
//   }
//
//   // ------------------ GET CURRENT LOCATION ------------------
//   Future<void> getCurrentLocation() async {
//     try {
//       isGettingCurrentLocation.value = true;
//
//       bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
//       if (!serviceEnabled) {
//         Get.snackbar(
//           "Error",
//           "Location services are disabled. Please enable location services.",
//           snackPosition: SnackPosition.BOTTOM,
//           backgroundColor: Colors.red,
//           colorText: Colors.white,
//         );
//         isGettingCurrentLocation.value = false;
//         return;
//       }
//
//       LocationPermission permission = await Geolocator.checkPermission();
//       if (permission == LocationPermission.denied) {
//         permission = await Geolocator.requestPermission();
//         if (permission == LocationPermission.denied) {
//           Get.snackbar(
//             "Error",
//             "Location permission denied",
//             snackPosition: SnackPosition.BOTTOM,
//             backgroundColor: Colors.red,
//             colorText: Colors.white,
//           );
//           isGettingCurrentLocation.value = false;
//           return;
//         }
//       }
//
//       if (permission == LocationPermission.deniedForever) {
//         Get.snackbar(
//           "Error",
//           "Location permissions are permanently denied. Please enable in settings.",
//           snackPosition: SnackPosition.BOTTOM,
//           backgroundColor: Colors.red,
//           colorText: Colors.white,
//         );
//         isGettingCurrentLocation.value = false;
//         return;
//       }
//
//       Position position = await Geolocator.getCurrentPosition(
//         desiredAccuracy: LocationAccuracy.high,
//       );
//
//       shopLat.value = position.latitude;
//       shopLng.value = position.longitude;
//
//       print("Current Location: ${position.latitude}, ${position.longitude}");
//
//       try {
//         List<Placemark> placemarks = await placemarkFromCoordinates(
//           position.latitude,
//           position.longitude,
//         );
//
//         if (placemarks.isNotEmpty) {
//           Placemark place = placemarks.first;
//           pickedLocation.value =
//           "${place.street ?? ''}, ${place.locality ?? ''}, ${place.administrativeArea ?? ''}, ${place.country ?? ''}";
//
//           print("Address: ${pickedLocation.value}");
//         } else {
//           pickedLocation.value =
//           "Lat: ${position.latitude.toStringAsFixed(6)}, Lng: ${position.longitude.toStringAsFixed(6)}";
//         }
//       } catch (e) {
//         print("Error getting address: $e");
//         pickedLocation.value =
//         "Lat: ${position.latitude.toStringAsFixed(6)}, Lng: ${position.longitude.toStringAsFixed(6)}";
//       }
//
//       Get.snackbar(
//         "Success",
//         "Current location fetched successfully",
//         snackPosition: SnackPosition.BOTTOM,
//         backgroundColor: Colors.green,
//         colorText: Colors.white,
//       );
//     } catch (e) {
//       print("Error getting current location: $e");
//       Get.snackbar(
//         "Error",
//         "Failed to get current location: ${e.toString()}",
//         snackPosition: SnackPosition.BOTTOM,
//         backgroundColor: Colors.red,
//         colorText: Colors.white,
//       );
//     } finally {
//       isGettingCurrentLocation.value = false;
//     }
//   }
//
//   // ------------------ METHODS ------------------
//   void setStoreImage(File image) {
//     storeImage.value = image;
//   }
//
//   void updateLocation(double lat, double lng, String address) {
//     shopLat.value = lat;
//     shopLng.value = lng;
//     pickedLocation.value = address;
//   }
//
//   // ------------------ VALIDATION ------------------
//   bool validateInputs() {
//     if (storeImage.value == null) {
//       Get.snackbar(
//         "Validation Error",
//         "Please select a store image",
//         snackPosition: SnackPosition.BOTTOM,
//         backgroundColor: Colors.orange,
//         colorText: Colors.white,
//         icon: const Icon(Icons.warning, color: Colors.white),
//       );
//       return false;
//     }
//
//     if (ownerNameController.text.trim().isEmpty) {
//       Get.snackbar(
//         "Validation Error",
//         "Please enter owner name",
//         snackPosition: SnackPosition.BOTTOM,
//         backgroundColor: Colors.orange,
//         colorText: Colors.white,
//         icon: const Icon(Icons.warning, color: Colors.white),
//       );
//       return false;
//     }
//
//     if (shopNameController.text.trim().isEmpty) {
//       Get.snackbar(
//         "Validation Error",
//         "Please enter shop name",
//         snackPosition: SnackPosition.BOTTOM,
//         backgroundColor: Colors.orange,
//         colorText: Colors.white,
//         icon: const Icon(Icons.warning, color: Colors.white),
//       );
//       return false;
//     }
//
//     if (emailController.text.trim().isEmpty) {
//       Get.snackbar(
//         "Validation Error",
//         "Please enter email address",
//         snackPosition: SnackPosition.BOTTOM,
//         backgroundColor: Colors.orange,
//         colorText: Colors.white,
//         icon: const Icon(Icons.warning, color: Colors.white),
//       );
//       return false;
//     }
//
//     if (!GetUtils.isEmail(emailController.text.trim())) {
//       Get.snackbar(
//         "Validation Error",
//         "Please enter a valid email address",
//         snackPosition: SnackPosition.BOTTOM,
//         backgroundColor: Colors.orange,
//         colorText: Colors.white,
//         icon: const Icon(Icons.warning, color: Colors.white),
//       );
//       return false;
//     }
//
//     if (passwordController.text.trim().isEmpty) {
//       Get.snackbar(
//         "Validation Error",
//         "Please enter password",
//         snackPosition: SnackPosition.BOTTOM,
//         backgroundColor: Colors.orange,
//         colorText: Colors.white,
//         icon: const Icon(Icons.warning, color: Colors.white),
//       );
//       return false;
//     }
//
//     if (passwordController.text.trim().length < 6) {
//       Get.snackbar(
//         "Validation Error",
//         "Password must be at least 6 characters",
//         snackPosition: SnackPosition.BOTTOM,
//         backgroundColor: Colors.orange,
//         colorText: Colors.white,
//         icon: const Icon(Icons.warning, color: Colors.white),
//       );
//       return false;
//     }
//
//     if (phoneNo1Controller.text.trim().isEmpty) {
//       Get.snackbar(
//         "Validation Error",
//         "Please enter phone number",
//         snackPosition: SnackPosition.BOTTOM,
//         backgroundColor: Colors.orange,
//         colorText: Colors.white,
//         icon: const Icon(Icons.warning, color: Colors.white),
//       );
//       return false;
//     }
//
//     if (phoneNo1Controller.text.trim().length != 10) {
//       Get.snackbar(
//         "Validation Error",
//         "Phone number must be 10 digits",
//         snackPosition: SnackPosition.BOTTOM,
//         backgroundColor: Colors.orange,
//         colorText: Colors.white,
//         icon: const Icon(Icons.warning, color: Colors.white),
//       );
//       return false;
//     }
//
//     if (selectedState.value.isEmpty) {
//       Get.snackbar(
//         "Validation Error",
//         "Please select state",
//         snackPosition: SnackPosition.BOTTOM,
//         backgroundColor: Colors.orange,
//         colorText: Colors.white,
//         icon: const Icon(Icons.warning, color: Colors.white),
//       );
//       return false;
//     }
//
//     if (selectedDistrict.value.isEmpty) {
//       Get.snackbar(
//         "Validation Error",
//         "Please select district",
//         snackPosition: SnackPosition.BOTTOM,
//         backgroundColor: Colors.orange,
//         colorText: Colors.white,
//         icon: const Icon(Icons.warning, color: Colors.white),
//       );
//       return false;
//     }
//
//     if (selectedLocation.value.isEmpty) {
//       Get.snackbar(
//         "Validation Error",
//         "Please select main location",
//         snackPosition: SnackPosition.BOTTOM,
//         backgroundColor: Colors.orange,
//         colorText: Colors.white,
//         icon: const Icon(Icons.warning, color: Colors.white),
//       );
//       return false;
//     }
//
//     if (shopLat.value == 0.0 || shopLng.value == 0.0) {
//       Get.snackbar(
//         "Validation Error",
//         "Please set shop location (use map or current location)",
//         snackPosition: SnackPosition.BOTTOM,
//         backgroundColor: Colors.orange,
//         colorText: Colors.white,
//         icon: const Icon(Icons.warning, color: Colors.white),
//       );
//       return false;
//     }
//
//     return true;
//   }
//
//   // ------------------ CONVERT IMAGE TO BASE64 ------------------
//   Future<String> convertImageToBase64(File imageFile) async {
//     List<int> imageBytes = await imageFile.readAsBytes();
//     String base64Image = base64Encode(imageBytes);
//     return "data:image/jpeg;base64,$base64Image";
//   }
//
//   // ------------------ ADD MERCHANT API CALL ------------------
//   Future<void> addMerchant() async {
//     if (!validateInputs()) return;
//
//     try {
//       isLoading.value = true;
//
//       final authToken = box.read('auth_token') ?? '';
//
//       if (authToken.isEmpty) {
//         Get.snackbar(
//           "Authentication Error",
//           "Authentication token not found. Please login again.",
//           snackPosition: SnackPosition.BOTTOM,
//           backgroundColor: Colors.red,
//           colorText: Colors.white,
//           icon: const Icon(Icons.error, color: Colors.white),
//         );
//         isLoading.value = false;
//         return;
//       }
//
//       // Convert image to base64
//       String base64Image = await convertImageToBase64(storeImage.value!);
//
//       // Prepare request body
//       final Map<String, dynamic> requestBody = {
//         "store_image": base64Image,
//         "owner_name": ownerNameController.text.trim(),
//         "shop_name": shopNameController.text.trim(),
//         "email": emailController.text.trim(),
//         "password": passwordController.text.trim(),
//         "phone_no_1": phoneNo1Controller.text.trim(),
//         "phone_no_2": phoneNo2Controller.text.trim(),
//         "state": selectedState.value,
//         "district": selectedDistrict.value,
//         "main_location": selectedLocation.value,
//         "latitude": shopLat.value,
//         "longitude": shopLng.value,
//       };
//
//       // Add optional fields only if they're not empty
//       if (whatsappController.text.trim().isNotEmpty) {
//         requestBody["whatsapp_no"] = whatsappController.text.trim();
//       }
//       if (facebookController.text.trim().isNotEmpty) {
//         requestBody["facebook_link"] = facebookController.text.trim();
//       }
//       if (instagramController.text.trim().isNotEmpty) {
//         requestBody["instagram_link"] = instagramController.text.trim();
//       }
//       if (websiteController.text.trim().isNotEmpty) {
//         requestBody["website_link"] = websiteController.text.trim();
//       }
//
//       print("════════════════════════════════════════");
//       print("Admin Add Merchant Request:");
//       print("URL: $adminAddMerchantApiUrl");
//       print("Auth Token: $authToken");
//       print("Request Body Keys: ${requestBody.keys.toList()}");
//       print("════════════════════════════════════════");
//
//       // Make API call
//       final response = await http.post(
//         Uri.parse(adminAddMerchantApiUrl),
//         headers: {
//           "Content-Type": "application/json",
//           "Accept": "application/json",
//           "Authorization": "Bearer $authToken",
//         },
//         body: jsonEncode(requestBody),
//       );
//
//       print("════════════════════════════════════════");
//       print("Admin Add Merchant Response Status: ${response.statusCode}");
//       print("Admin Add Merchant Response Body: ${response.body}");
//       print("════════════════════════════════════════");
//
//       if (response.statusCode == 201 || response.statusCode == 200) {
//         final responseData = jsonDecode(response.body);
//
//         if (responseData['status'] == true) {
//           // Show success dialog with email notification info
//           Get.dialog(
//             Dialog(
//               backgroundColor: const Color(0xFF1E1E1E),
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(16),
//               ),
//               child: Padding(
//                 padding: const EdgeInsets.all(24),
//                 child: Column(
//                   mainAxisSize: MainAxisSize.min,
//                   children: [
//                     Container(
//                       padding: const EdgeInsets.all(16),
//                       decoration: BoxDecoration(
//                         color: const Color(0xFF4CAF50).withOpacity(0.2),
//                         shape: BoxShape.circle,
//                       ),
//                       child: const Icon(
//                         Icons.check_circle,
//                         color: Color(0xFF4CAF50),
//                         size: 48,
//                       ),
//                     ),
//                     const SizedBox(height: 20),
//                     const Text(
//                       "Merchant Registered Successfully!",
//                       textAlign: TextAlign.center,
//                       style: TextStyle(
//                         color: Colors.white,
//                         fontSize: 20,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                     const SizedBox(height: 16),
//                     Container(
//                       padding: const EdgeInsets.all(16),
//                       decoration: BoxDecoration(
//                         color: const Color(0xFF64B5F6).withOpacity(0.1),
//                         borderRadius: BorderRadius.circular(12),
//                         border: Border.all(
//                           color: const Color(0xFF64B5F6).withOpacity(0.3),
//                         ),
//                       ),
//                       child: Row(
//                         children: [
//                           const Icon(
//                             Icons.email,
//                             color: Color(0xFF64B5F6),
//                             size: 24,
//                           ),
//                           const SizedBox(width: 12),
//                           Expanded(
//                             child: Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 const Text(
//                                   "Email Sent",
//                                   style: TextStyle(
//                                     color: Color(0xFF64B5F6),
//                                     fontWeight: FontWeight.bold,
//                                     fontSize: 14,
//                                   ),
//                                 ),
//                                 const SizedBox(height: 4),
//                                 Text(
//                                   "Login credentials have been sent to ${emailController.text.trim()}",
//                                   style: TextStyle(
//                                     color: Colors.grey[400],
//                                     fontSize: 12,
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                     const SizedBox(height: 24),
//                     SizedBox(
//                       width: double.infinity,
//                       child: ElevatedButton(
//                         onPressed: () {
//                           Get.back(); // Close dialog
//                           Get.back(); // Go back to previous screen
//                         },
//                         style: ElevatedButton.styleFrom(
//                           backgroundColor: const Color(0xFF64B5F6),
//                           padding: const EdgeInsets.symmetric(vertical: 14),
//                           shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(12),
//                           ),
//                         ),
//                         child: const Text(
//                           "Done",
//                           style: TextStyle(
//                             color: Colors.white,
//                             fontSize: 16,
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//             barrierDismissible: false,
//           );
//
//           // Clear all fields
//           _clearAllFields();
//         } else {
//           Get.snackbar(
//             "Registration Failed",
//             responseData['message'] ?? "Failed to register merchant",
//             snackPosition: SnackPosition.BOTTOM,
//             backgroundColor: Colors.red,
//             colorText: Colors.white,
//             icon: const Icon(Icons.error, color: Colors.white),
//             duration: const Duration(seconds: 4),
//           );
//         }
//       } else {
//         final errorData = jsonDecode(response.body);
//         Get.snackbar(
//           "Registration Failed",
//           errorData['message'] ?? "Failed to register merchant. Please try again.",
//           snackPosition: SnackPosition.BOTTOM,
//           backgroundColor: Colors.red,
//           colorText: Colors.white,
//           icon: const Icon(Icons.error, color: Colors.white),
//           duration: const Duration(seconds: 4),
//         );
//       }
//     } catch (e) {
//       print("Error adding merchant: $e");
//       Get.snackbar(
//         "Error",
//         "An error occurred: ${e.toString()}",
//         snackPosition: SnackPosition.BOTTOM,
//         backgroundColor: Colors.red,
//         colorText: Colors.white,
//         icon: const Icon(Icons.error, color: Colors.white),
//         duration: const Duration(seconds: 4),
//       );
//     } finally {
//       isLoading.value = false;
//     }
//   }
//
//   // ------------------ CLEAR ALL FIELDS ------------------
//   void _clearAllFields() {
//     ownerNameController.clear();
//     shopNameController.clear();
//     emailController.clear();
//     passwordController.clear();
//     phoneNo1Controller.clear();
//     phoneNo2Controller.clear();
//     whatsappController.clear();
//     facebookController.clear();
//     instagramController.clear();
//     websiteController.clear();
//
//     storeImage.value = null;
//     selectedState.value = "";
//     selectedDistrict.value = "";
//     selectedLocation.value = "";
//     shopLat.value = 0.0;
//     shopLng.value = 0.0;
//     pickedLocation.value = "Tap to pick location or use current location";
//
//     districts.clear();
//     locations.clear();
//   }
//
//   @override
//   void onClose() {
//     ownerNameController.dispose();
//     shopNameController.dispose();
//     emailController.dispose();
//     passwordController.dispose();
//     phoneNo1Controller.dispose();
//     phoneNo2Controller.dispose();
//     whatsappController.dispose();
//     facebookController.dispose();
//     instagramController.dispose();
//     websiteController.dispose();
//     super.onClose();
//   }
// }
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

class AdminAddMerchantController extends GetxController {
  final box = GetStorage();

  // ------------------ TEXT CONTROLLERS (NO PASSWORD FIELD) ------------------
  final ownerNameController = TextEditingController();
  final shopNameController = TextEditingController();
  final emailController = TextEditingController();
  // PASSWORD CONTROLLER REMOVED - Backend will generate it
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

  // ------------------ API URLs ------------------
  static const String adminAddMerchantApiUrl =
      "https://rasma.astradevelops.in/e_shoppyy/public/api/admin/register-merchant";
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
      final authToken = box.read('auth_token') ?? '';

      final response = await http.get(
        Uri.parse(statesApi),
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
          "Authorization": "Bearer $authToken",
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
      Get.snackbar(
        "Error",
        "Failed to load states: $e",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
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

      final authToken = box.read('auth_token') ?? '';

      final response = await http.post(
        Uri.parse(districtsApi),
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
          "Authorization": "Bearer $authToken",
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
      Get.snackbar(
        "Error",
        "Failed to load districts: $e",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
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

      final authToken = box.read('auth_token') ?? '';

      final response = await http.post(
        Uri.parse(locationsApi),
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
          "Authorization": "Bearer $authToken",
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
      Get.snackbar(
        "Error",
        "Failed to load locations: $e",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoadingLocations.value = false;
    }
  }

  // ------------------ GET CURRENT LOCATION ------------------
  Future<void> getCurrentLocation() async {
    try {
      isGettingCurrentLocation.value = true;

      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        Get.snackbar(
          "Error",
          "Location services are disabled",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        return;
      }

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
          return;
        }
      }

      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      shopLat.value = position.latitude;
      shopLng.value = position.longitude;

      try {
        List<Placemark> placemarks = await placemarkFromCoordinates(
          position.latitude,
          position.longitude,
        );

        if (placemarks.isNotEmpty) {
          Placemark place = placemarks.first;
          pickedLocation.value =
          "${place.street ?? ''}, ${place.locality ?? ''}, ${place.administrativeArea ?? ''}, ${place.country ?? ''}";
        } else {
          pickedLocation.value =
          "Lat: ${position.latitude.toStringAsFixed(6)}, Lng: ${position.longitude.toStringAsFixed(6)}";
        }
      } catch (e) {
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
      Get.snackbar(
        "Error",
        "Failed to get location: ${e.toString()}",
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

  // ------------------ VALIDATION (NO PASSWORD CHECK) ------------------
  bool validateInputs() {
    if (storeImage.value == null) {
      Get.snackbar(
        "Validation Error",
        "Please select a store image",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.orange,
        colorText: Colors.white,
      );
      return false;
    }

    if (ownerNameController.text.trim().isEmpty) {
      Get.snackbar(
        "Validation Error",
        "Please enter owner name",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.orange,
        colorText: Colors.white,
      );
      return false;
    }

    if (shopNameController.text.trim().isEmpty) {
      Get.snackbar(
        "Validation Error",
        "Please enter shop name",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.orange,
        colorText: Colors.white,
      );
      return false;
    }

    if (emailController.text.trim().isEmpty) {
      Get.snackbar(
        "Validation Error",
        "Please enter email address",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.orange,
        colorText: Colors.white,
      );
      return false;
    }

    if (!GetUtils.isEmail(emailController.text.trim())) {
      Get.snackbar(
        "Validation Error",
        "Please enter a valid email address",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.orange,
        colorText: Colors.white,
      );
      return false;
    }

    // NO PASSWORD VALIDATION - Backend generates it

    if (phoneNo1Controller.text.trim().isEmpty) {
      Get.snackbar(
        "Validation Error",
        "Please enter phone number",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.orange,
        colorText: Colors.white,
      );
      return false;
    }

    if (phoneNo1Controller.text.trim().length != 10) {
      Get.snackbar(
        "Validation Error",
        "Phone number must be 10 digits",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.orange,
        colorText: Colors.white,
      );
      return false;
    }

    if (selectedState.value.isEmpty) {
      Get.snackbar(
        "Validation Error",
        "Please select state",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.orange,
        colorText: Colors.white,
      );
      return false;
    }

    if (selectedDistrict.value.isEmpty) {
      Get.snackbar(
        "Validation Error",
        "Please select district",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.orange,
        colorText: Colors.white,
      );
      return false;
    }

    if (selectedLocation.value.isEmpty) {
      Get.snackbar(
        "Validation Error",
        "Please select main location",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.orange,
        colorText: Colors.white,
      );
      return false;
    }

    if (shopLat.value == 0.0 || shopLng.value == 0.0) {
      Get.snackbar(
        "Validation Error",
        "Please set shop location",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.orange,
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

  // ------------------ SHOW SUCCESS DIALOG (NO PASSWORD SHOWN) ------------------
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
                // Success Icon
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

                // Success Title
                const Text(
                  "Merchant Registered Successfully!",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),

                // Email Sent Confirmation
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
                                  "Credentials Sent!",
                                  style: TextStyle(
                                    color: Color(0xFF64B5F6),
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  "Login credentials have been sent to:",
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

                // Info Box
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: Colors.green.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.green.withOpacity(0.3)),
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
                              "Email Delivery",
                              style: TextStyle(
                                color: Colors.green,
                                fontWeight: FontWeight.bold,
                                fontSize: 13,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              "The merchant should check their inbox and spam folder for the login credentials.",
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

                // Done Button
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton(
                    onPressed: () {
                      Get.back(); // Close dialog
                      Get.back(); // Go back to previous screen
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF64B5F6),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 0,
                    ),
                    child: const Text(
                      "Done",
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

  // ------------------ ADD MERCHANT API CALL (NO PASSWORD IN REQUEST) ------------------
  Future<void> addMerchant() async {
    if (!validateInputs()) return;

    // Store email for success dialog
    final merchantEmail = emailController.text.trim();

    try {
      isLoading.value = true;

      final authToken = box.read('auth_token') ?? '';

      if (authToken.isEmpty) {
        Get.snackbar(
          "Authentication Error",
          "Please login again",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        isLoading.value = false;
        return;
      }

      // Convert image to base64
      String base64Image = await convertImageToBase64(storeImage.value!);

      // Prepare request body - NO PASSWORD FIELD
      final Map<String, dynamic> requestBody = {
        "store_image": base64Image,
        "owner_name": ownerNameController.text.trim(),
        "shop_name": shopNameController.text.trim(),
        "email": merchantEmail,
        // PASSWORD FIELD REMOVED - Backend will auto-generate
        "phone_no_1": phoneNo1Controller.text.trim(),
        "phone_no_2": phoneNo2Controller.text.trim(),
        "state": selectedState.value,
        "district": selectedDistrict.value,
        "main_location": selectedLocation.value,
        "latitude": shopLat.value,
        "longitude": shopLng.value,
      };

      // Add optional fields
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

      print("════════════════════════════════════════");
      print("📧 Registering merchant without password field");
      print("📧 Email: $merchantEmail");
      print("📧 Backend will auto-generate password");
      print("════════════════════════════════════════");

      // Make API call
      final response = await http.post(
        Uri.parse(adminAddMerchantApiUrl),
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
          "Authorization": "Bearer $authToken",
        },
        body: jsonEncode(requestBody),
      );

      print("════════════════════════════════════════");
      print("Response Status: ${response.statusCode}");
      print("Response Body: ${response.body}");
      print("════════════════════════════════════════");

      if (response.statusCode == 201 || response.statusCode == 200) {
        final responseData = jsonDecode(response.body);

        if (responseData['status'] == true) {
          print("✅ SUCCESS: ${responseData['message']}");
          print("✅ Email with auto-generated password sent to: $merchantEmail");

          // Clear fields BEFORE showing dialog
          _clearAllFields();

          // Show success dialog WITHOUT password
          _showSuccessDialog(merchantEmail);
        } else {
          Get.snackbar(
            "Registration Failed",
            responseData['message'] ?? "Failed to register merchant",
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.red,
            colorText: Colors.white,
            duration: const Duration(seconds: 4),
          );
        }
      } else {
        final errorData = jsonDecode(response.body);
        Get.snackbar(
          "Registration Failed",
          errorData['message'] ?? "Failed to register merchant",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
          duration: const Duration(seconds: 4),
        );
      }
    } catch (e) {
      print("❌ ERROR: $e");
      Get.snackbar(
        "Error",
        "An error occurred: ${e.toString()}",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: const Duration(seconds: 4),
      );
    } finally {
      isLoading.value = false;
    }
  }

  // ------------------ CLEAR ALL FIELDS ------------------
  void _clearAllFields() {
    ownerNameController.clear();
    shopNameController.clear();
    emailController.clear();
    // NO PASSWORD CONTROLLER TO CLEAR
    phoneNo1Controller.clear();
    phoneNo2Controller.clear();
    whatsappController.clear();
    facebookController.clear();
    instagramController.clear();
    websiteController.clear();

    storeImage.value = null;
    selectedState.value = "";
    selectedDistrict.value = "";
    selectedLocation.value = "";
    shopLat.value = 0.0;
    shopLng.value = 0.0;
    pickedLocation.value = "Tap to pick location or use current location";

    districts.clear();
    locations.clear();
  }

  @override
  void onClose() {
    ownerNameController.dispose();
    shopNameController.dispose();
    emailController.dispose();
    // NO PASSWORD CONTROLLER TO DISPOSE
    phoneNo1Controller.dispose();
    phoneNo2Controller.dispose();
    whatsappController.dispose();
    facebookController.dispose();
    instagramController.dispose();
    websiteController.dispose();
    super.onClose();
  }
}