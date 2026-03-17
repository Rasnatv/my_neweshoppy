import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class DeleteAdvertisementController extends GetxController {
  final RxSet<dynamic> deletingIds = <dynamic>{}.obs;
  final box = GetStorage();

  Future<void> deleteAdvertisement(
      dynamic advertisementId, VoidCallback onSuccess) async {
    final String? authToken = box.read('auth_token');

    if (authToken == null) {
      Get.snackbar(
        'Unauthorized',
        'Auth token not found. Please login again.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    deletingIds.add(advertisementId);

    try {
      final response = await http.delete(
        Uri.parse(
            'https://rasma.astradevelops.in/e_shoppyy/public/api/delete-advertisement'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $authToken',
        },
        body: jsonEncode({
          'advertisement_id': int.parse(advertisementId.toString()),
        }),
      );

      final data = jsonDecode(response.body);

      if (data['status'] == '1') {
        onSuccess();
        Get.snackbar(
          'Deleted',
          data['message'] ?? 'Advertisement deleted successfully',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
          duration: const Duration(seconds: 2),
        );
      } else {
        Get.snackbar(
          'Failed',
          data['message'] ?? 'Failed to delete advertisement',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Something went wrong. Please try again.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      deletingIds.remove(advertisementId);
    }
  }
}