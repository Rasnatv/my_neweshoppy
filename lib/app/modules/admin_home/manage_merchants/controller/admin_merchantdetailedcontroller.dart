
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

import '../../../../data/models/admin_merchantdetailedmodel.dart';
import '../../manage_merchants/controller/mervchant_approvalstatus_controller.dart';

class AdminMerchantDetailController extends GetxController {
  final box = GetStorage();

  var isLoading = true.obs;
  var merchant = Rxn<AdminMerchantDetail>();

  /// ===============================
  /// FETCH MERCHANT DETAILS
  /// ===============================
  Future<void> fetchMerchantDetail(int merchantId) async {
    isLoading.value = true;

    final token = box.read("auth_token");
    if (token == null) {
      Get.snackbar("Error", "Admin token missing");
      isLoading.value = false;
      return;
    }

    try {
      final response = await http.post(
        Uri.parse(
          "https://rasma.astradevelops.in/e_shoppyy/public/api/admin/merchant/details",
        ),
        headers: {
          "Accept": "application/json",
          "Authorization": "Bearer $token",
        },
        body: {
          "merchant_id": merchantId.toString(),
        },
      );

      if (response.statusCode == 200) {
        final body = jsonDecode(response.body);

        if (body['status'] == true) {
          merchant.value =
              AdminMerchantDetail.fromJson(body['data']);
        } else {
          Get.snackbar("Error", body['message'] ?? "Failed");
        }
      }
    } catch (e) {
      Get.snackbar("Error", "Failed to load merchant");
    } finally {
      isLoading.value = false;
    }
  }

  /// ===============================
  /// APPROVE / REJECT MERCHANT
  /// ===============================
  Future<void> updateApproval({
    required int merchantId,
    required String status, // approved | rejected
  }) async {
    final token = box.read("auth_token");
    if (token == null) {
      Get.snackbar("Error", "Admin token missing");
      return;
    }

    try {
      final response = await http.post(
        Uri.parse(
          "https://rasma.astradevelops.in/e_shoppyy/public/api/admin/merchant/approve-reject",
        ),
        headers: {
          "Accept": "application/json",
          "Authorization": "Bearer $token",
        },
        body: {
          "merchant_id": merchantId.toString(),
          "approval_status": status,
        },
      );

      if (response.statusCode == 200) {
        final body = jsonDecode(response.body);

        if (body['status'] == true) {
          /// ✅ UPDATE DETAIL PAGE STATE
          merchant.value =
              merchant.value!.copyWith(approvalStatus: status);

          /// ✅ VERY IMPORTANT
          /// REFRESH HOME MERCHANT LIST
          if (Get.isRegistered<AdminMerchantController>()) {
            Get.find<AdminMerchantController>().fetchMerchants();
          }

          Get.snackbar(
            "Success",
            body['message'],
            backgroundColor:
            status == "approved" ? Colors.green : Colors.red,
            colorText: Colors.white,
            snackPosition: SnackPosition.BOTTOM,
          );
        } else {
          Get.snackbar("Error", body['message'] ?? "Update failed");
        }
      }
    } catch (e) {
      Get.snackbar("Error", "Approval update failed");
    }
  }
}
