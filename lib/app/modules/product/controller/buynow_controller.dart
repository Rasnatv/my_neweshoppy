// import 'package:get/get.dart';
// import 'package:get/get_state_manager/src/simple/get_controllers.dart';
// import 'package:flutter/material.dart';
//
// class BuyNowController extends GetxController {
//   var quantity = 1.obs;
//   var selectedPayment = ''.obs;
//   var addressController = TextEditingController();
//
//   void increment() => quantity.value++;
//   void decrement() {
//     if (quantity.value > 1) quantity.value--;
//   }
//
//   void placeOrder() {
//     if (addressController.text.isEmpty) {
//       Get.snackbar('Error', 'Please enter delivery address');
//       return;
//     }
//     if (selectedPayment.value.isEmpty) {
//       Get.snackbar('Error', 'Please select payment method');
//       return;
//     }
//     // Place order logic here
//     Get.snackbar('Success', 'Order Placed Successfully');
//   }
// }
import 'dart:convert';
import 'dart:io';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

import '../../../data/errors/api_error.dart';
import '../../merchantlogin/widget/successwidget.dart';

class BuyNowController extends GetxController {
  final box = GetStorage();

  var quantity = 1.obs;
  var selectedPayment = ''.obs;
  var addressController = TextEditingController();

  var isLoading = false.obs;

  String get authToken => box.read('auth_token') ?? '';

  void increment() => quantity.value++;

  void decrement() {
    if (quantity.value > 1) quantity.value--;
  }

  Future<void> placeOrder() async {
    /// ✅ VALIDATION
    if (addressController.text.trim().isEmpty) {
      AppSnackbar.warning('Please enter delivery address');
      return;
    }

    if (selectedPayment.value.isEmpty) {
      AppSnackbar.warning('Please select payment method');
      return;
    }

    try {
      isLoading.value = true;

      final response = await http.post(
        Uri.parse('YOUR_PLACE_ORDER_API'), // 🔁 replace with real API
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $authToken',
        },
        body: jsonEncode({
          'address': addressController.text.trim(),
          'payment_method': selectedPayment.value,
          'quantity': quantity.value,
        }),
      );

      /// ✅ SUCCESS
      if (response.statusCode == 200) {
        AppSnackbar.success('Order Placed Successfully');

        /// Optional: clear fields
        addressController.clear();
        selectedPayment.value = '';
        quantity.value = 1;

      } else {
        /// ✅ API ERROR HANDLING
        final error = ApiErrorHandler.handleResponse(response);
        AppSnackbar.error(error);
      }

    } catch (e) {
      /// ✅ EXCEPTION HANDLING
      final error = ApiErrorHandler.handleException(e);
      AppSnackbar.error(error);

    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    addressController.dispose();
    super.onClose();
  }
}