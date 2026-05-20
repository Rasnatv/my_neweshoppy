
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

import '../../../data/errors/api_error.dart';
import '../../merchantlogin/widget/successwidget.dart';
import 'merchant_advertismentlistcontroller.dart'; // 👈 import this

class DeleteAdvertisementController extends GetxController {
  final RxSet<dynamic> deletingIds = <dynamic>{}.obs;
  final box = GetStorage();

  Future<void> deleteAdvertisement(
      dynamic advertisementId, VoidCallback onSuccess) async {
    final String? authToken = box.read('auth_token');

    deletingIds.add(advertisementId);

    try {
      final response = await http.delete(
        Uri.parse('https://eshoppy.co.in/api/delete-advertisement'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $authToken',
        },
        body: jsonEncode({
          'advertisement_id': int.parse(advertisementId.toString()),
        }),
      );

      final decoded = jsonDecode(response.body);

      if (response.statusCode == 200 && decoded['status'] == '1') {

        // ✅ Step 1: Remove instantly from observable list
        final listCtrl = Get.find<MerchantAdvertisementGetController>();
        listCtrl.ads.removeWhere(
              (ad) => ad['id'].toString() == advertisementId.toString(),
        );

        // ✅ Step 2: Then sync with server in background
        onSuccess();

        AppSnackbar.success(
          decoded['message'] ?? "Advertisement deleted successfully",
        );

      } else {
        final errorMessage = ApiErrorHandler.handleResponse(response);
        AppSnackbar.error(errorMessage);
      }
    } catch (e) {
      final errorMessage = ApiErrorHandler.handleException(e);
      AppSnackbar.error(errorMessage);
    } finally {
      deletingIds.remove(advertisementId);
    }
  }
}