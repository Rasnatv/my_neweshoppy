// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:get_storage/get_storage.dart';
// import 'package:http/http.dart' as http;
//
// import '../view/addressposttingmodel.dart';
//
//
// class NewAddAddressController extends GetxController {
//   final box = GetStorage();
//
//   // Form key
//   final formKey = GlobalKey<FormState>();
//
//   // Text controllers
//   final fullNameController = TextEditingController();
//   final phoneController = TextEditingController();
//   final pincodeController = TextEditingController();
//   final stateController = TextEditingController();
//   final districtController = TextEditingController();
//   final cityController = TextEditingController();
//   final houseNoController = TextEditingController();
//   final areaController = TextEditingController();
//
//   // Observables
//   final RxBool isLoading = false.obs;
//
//   // API base URL
//   static const String baseUrl =
//       'https://rasma.astradevelops.in/e_shoppyy/public/api';
//
//   /// Get auth token from GetStorage
//   String get authToken => box.read('auth_token') ?? '';
//
//   /// Add new address
//   Future<void> addAddress() async {
//     if (!formKey.currentState!.validate()) return;
//
//     if (authToken.isEmpty) {
//       Get.snackbar(
//         'Error',
//         'Authentication token not found. Please login again.',
//         backgroundColor: Colors.red.shade100,
//         colorText: Colors.red.shade800,
//         snackPosition: SnackPosition.BOTTOM,
//       );
//       return;
//     }
//
//     isLoading.value = true;
//
//     try {
//       final addressData = AddressModel(
//         fullName: fullNameController.text.trim(),
//         phoneNumber: phoneController.text.trim(),
//         pincode: pincodeController.text.trim(),
//         state: stateController.text.trim(),
//         district: districtController.text.trim(),
//         city: cityController.text.trim(),
//         houseNo: houseNoController.text.trim(),
//         area: areaController.text.trim(),
//       );
//
//       final response = await http.post(
//         Uri.parse('$baseUrl/add-address'),
//         headers: {
//           'Content-Type': 'application/json',
//           'Authorization': 'Bearer $authToken',
//         },
//         body: jsonEncode(addressData.toJson()),
//       );
//
//       final responseData = jsonDecode(response.body);
//
//       if (response.statusCode == 200 || response.statusCode == 201) {
//         if (responseData['status'] == true) {
//           final savedAddress =
//           AddressModel.fromJson(responseData['data']);
//
//           // Optionally save latest address to GetStorage
//           box.write('last_address', jsonEncode(responseData['data']));
//
//
//           _clearFields();
//           Get.back(result: savedAddress);
//         }
//         else {
//           Get.snackbar(
//             'Failed',
//             responseData['message'] ?? 'Failed to add address',
//             backgroundColor: Colors.orange.shade100,
//             colorText: Colors.orange.shade800,
//             snackPosition: SnackPosition.BOTTOM,
//           );
//         }
//       } else {
//         Get.snackbar(
//           'Error',
//           responseData['message'] ?? 'Something went wrong',
//           backgroundColor: Colors.red.shade100,
//           colorText: Colors.red.shade800,
//           snackPosition: SnackPosition.BOTTOM,
//         );
//       }
//     }
//       catch (e) {
//       Get.snackbar(
//         'Error',
//         'Network error: ${e.toString()}',
//         backgroundColor: Colors.red.shade100,
//         colorText: Colors.red.shade800,
//         snackPosition: SnackPosition.BOTTOM,
//       );
//     } finally {
//       isLoading.value = false;
//     }
//   }
//
//   void _clearFields() {
//     fullNameController.clear();
//     phoneController.clear();
//     pincodeController.clear();
//     stateController.clear();
//     districtController.clear();
//     cityController.clear();
//     houseNoController.clear();
//     areaController.clear();
//   }
//
//   @override
//   void onClose() {
//     fullNameController.dispose();
//     phoneController.dispose();
//     pincodeController.dispose();
//     stateController.dispose();
//     districtController.dispose();
//     cityController.dispose();
//     houseNoController.dispose();
//     areaController.dispose();
//     super.onClose();
//   }
// }
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

import '../../merchantlogin/widget/successwidget.dart';
import '../view/addressposttingmodel.dart';



class NewAddAddressController extends GetxController {
  final box = GetStorage();

  // Form key
  final formKey = GlobalKey<FormState>();

  // Text controllers
  final fullNameController = TextEditingController();
  final phoneController = TextEditingController();
  final pincodeController = TextEditingController();
  final stateController = TextEditingController();
  final districtController = TextEditingController();
  final cityController = TextEditingController();
  final houseNoController = TextEditingController();
  final areaController = TextEditingController();

  // Observables
  final RxBool isLoading = false.obs;

  // API base URL
  static const String baseUrl =
      'https://rasma.astradevelops.in/e_shoppyy/public/api';

  /// Get auth token from GetStorage
  String get authToken => box.read('auth_token') ?? '';

  /// Add new address
  Future<void> addAddress() async {
    if (!formKey.currentState!.validate()) return;

    if (authToken.isEmpty) {
      AppSnackbar.error('Authentication token not found. Please login again.'); // 👈
      return;
    }

    isLoading.value = true;

    try {
      final addressData = AddressModel(
        fullName: fullNameController.text.trim(),
        phoneNumber: phoneController.text.trim(),
        pincode: pincodeController.text.trim(),
        state: stateController.text.trim(),
        district: districtController.text.trim(),
        city: cityController.text.trim(),
        houseNo: houseNoController.text.trim(),
        area: areaController.text.trim(),
      );

      final response = await http.post(
        Uri.parse('$baseUrl/add-address'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $authToken',
        },
        body: jsonEncode(addressData.toJson()),
      );

      final responseData = jsonDecode(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        if (responseData['status'] == true) {
          final savedAddress = AddressModel.fromJson(responseData['data']);

          box.write('last_address', jsonEncode(responseData['data']));

          AppSnackbar.success('Address added successfully!'); // 👈

          _clearFields();
          Get.back(result: savedAddress);
        } else {
          AppSnackbar.warning(responseData['message'] ?? 'Failed to add address'); // 👈
        }
      } else {
        AppSnackbar.error(responseData['message'] ?? 'Something went wrong'); // 👈
      }
    } catch (e) {
      AppSnackbar.error('Network error: ${e.toString()}'); // 👈
    } finally {
      isLoading.value = false;
    }
  }

  void _clearFields() {
    fullNameController.clear();
    phoneController.clear();
    pincodeController.clear();
    stateController.clear();
    districtController.clear();
    cityController.clear();
    houseNoController.clear();
    areaController.clear();
  }

  @override
  void onClose() {
    fullNameController.dispose();
    phoneController.dispose();
    pincodeController.dispose();
    stateController.dispose();
    districtController.dispose();
    cityController.dispose();
    houseNoController.dispose();
    areaController.dispose();
    super.onClose();
  }
}