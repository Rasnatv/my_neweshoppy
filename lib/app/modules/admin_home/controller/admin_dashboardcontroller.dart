import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

class AdminDashboardController extends GetxController {
  final RxString totalMerchants = '0'.obs;
  final RxString totalUsers = '0'.obs;
  final RxString totalProducts = '0'.obs;
  final RxBool isLoading = false.obs;

  final box = GetStorage(); // 👈 Fixed

  @override
  void onInit() {
    super.onInit();
    fetchDashboardCounts();
  }

  Future<void> fetchDashboardCounts() async {
    try {
      isLoading.value = true;

      final String? token = box.read('auth_token');

      print('📦 TOKEN: $token');

      final response = await http.get(
        Uri.parse(
            'https://rasma.astradevelops.in/e_shoppyy/public/api/dashboard-counts'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          if (token != null) 'Authorization': 'Bearer $token',
        },
      );

      print('📡 STATUS CODE: ${response.statusCode}');
      print('📄 RESPONSE BODY: ${response.body}');

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonData = jsonDecode(response.body);

        if (jsonData['status'] == true && jsonData['data'] != null) {
          final data = jsonData['data'];
          totalMerchants.value = data['total_merchants'].toString();
          totalUsers.value = data['total_users'].toString();
          totalProducts.value = data['total_products'].toString();
          print('✅ Dashboard counts loaded successfully');
        } else {
          Get.snackbar(
            'Warning',
            jsonData['message'] ?? 'No data received',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.orange,
            colorText: Colors.white,
          );
        }
      } else if (response.statusCode == 401) {
        print('🔐 UNAUTHORIZED - Token invalid or expired');
        Get.snackbar(
          'Session Expired',
          'Please login again',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      } else {
        print('❌ HTTP ERROR: ${response.statusCode} → ${response.body}');
        Get.snackbar(
          'Error',
          'Server error: ${response.statusCode}',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      print('💥 EXCEPTION: $e');
      Get.snackbar(
        'Error',
        'Something went wrong: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }
}