
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

import '../../../data/models/user_orderconfirmationmodel.dart';
import '../view/orderSuccessScreen.dart';
import 'cartcontroller.dart';


class OrderConfirmationController extends GetxController {
  final int addressId;
  OrderConfirmationController({required this.addressId});

  final _box = GetStorage();

  final isLoading = true.obs;
  final hasError = false.obs;
  final errorMessage = ''.obs;
  final isConfirming = false.obs; // ✅ loading state for confirm button
  final Rx<OrderConfirmationModel?> orderPreview = Rx(null);

  String get _token => _box.read('auth_token') ?? '';

  @override
  void onInit() {
    super.onInit();
    fetchOrderPreview(addressId);
  }

  Future<void> fetchOrderPreview(int addressId) async {
    try {
      isLoading.value = true;
      hasError.value = false;
      errorMessage.value = '';

      final response = await http.post(
        Uri.parse(
          'https://rasma.astradevelops.in/e_shoppyy/public/api/create-order-preview',
        ),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $_token',
        },
        body: jsonEncode({'address_id': addressId}),
      );

      final body = jsonDecode(response.body);

      if (response.statusCode == 200 && body['status'] == true) {
        orderPreview.value = OrderConfirmationModel.fromJson(body['data']);
      } else {
        hasError.value = true;
        errorMessage.value =
            body['message'] ?? 'Failed to load order preview.';
      }
    } catch (e) {
      hasError.value = true;
      errorMessage.value = 'Network error. Please try again.';
    } finally {
      isLoading.value = false;
    }
  }

  // ✅ Confirm Order API
  // Future<void> confirmOrder() async {
  //   try {
  //     isConfirming.value = true;
  //
  //     final response = await http.post(
  //       Uri.parse(
  //         'https://rasma.astradevelops.in/e_shoppyy/public/api/confirm-order',
  //       ),
  //       headers: {
  //         'Content-Type': 'application/json',
  //         'Accept': 'application/json',
  //         'Authorization': 'Bearer $_token',
  //       },
  //       body: jsonEncode({'address_id': addressId}),
  //     );
  //
  //     final body = jsonDecode(response.body);
  //
  //     if (response.statusCode == 200 && body['status'] == true) {
  //       final orderId = body['data']['order_id'];
  //       final totalAmount =
  //       (body['data']['total_amount'] as num).toDouble();
  //
  //       // ✅ Navigate to success screen
  //       Get.off(
  //             () => OrderSuccessScreen(
  //           orderId: orderId,
  //           totalAmount: totalAmount,
  //         ),
  //       );
  //     } else {
  //       Get.snackbar(
  //         'Failed',
  //         body['message'] ?? 'Could not place order. Try again.',
  //         backgroundColor: Colors.red.shade600,
  //         colorText: Colors.white,
  //         snackPosition: SnackPosition.TOP,
  //         borderRadius: 12,
  //         margin: const EdgeInsets.all(14),
  //       );
  //     }
  //   } catch (e) {
  //     Get.snackbar(
  //       'Error',
  //       'Network error. Please try again.',
  //       backgroundColor: Colors.red.shade600,
  //       colorText: Colors.white,
  //       snackPosition: SnackPosition.TOP,
  //       borderRadius: 12,
  //       margin: const EdgeInsets.all(14),
  //     );
  //   } finally {
  //     isConfirming.value = false;
  //   }
  // }
  Future<void> confirmOrder() async {
    try {
      isConfirming.value = true;

      final response = await http.post(
        Uri.parse(
          'https://rasma.astradevelops.in/e_shoppyy/public/api/confirm-order',
        ),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $_token',
        },
        body: jsonEncode({'address_id': addressId}),
      );

      final body = jsonDecode(response.body);

      if (response.statusCode == 200 && body['status'] == true) {
        final orderId = body['data']['order_id'];
        final totalAmount = (body['data']['total_amount'] as num).toDouble();

        // ✅ Refresh cart from server — will reflect empty cart
        if (Get.isRegistered<CartController>()) {
          await Get.find<CartController>().fetchCart();
        }

        Get.off(
              () =>
              OrderSuccessScreen(
                orderId: orderId,
                totalAmount: totalAmount,
              ),
        );
      } else {
        Get.snackbar(
          'Failed',
          body['message'] ?? 'Could not place order. Try again.',
          backgroundColor: Colors.red.shade600,
          colorText: Colors.white,
          snackPosition: SnackPosition.TOP,
          borderRadius: 12,
          margin: const EdgeInsets.all(14),
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Network error. Please try again.',
        backgroundColor: Colors.red.shade600,
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
        borderRadius: 12,
        margin: const EdgeInsets.all(14),
      );
    } finally {
      isConfirming.value = false;
    }
  }}