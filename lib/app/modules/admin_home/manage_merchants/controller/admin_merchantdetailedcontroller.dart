import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

import '../../../../data/errors/api_error.dart';
import '../../../../data/models/admin_merchantdetailedmodel.dart';
import '../../../merchantlogin/widget/successwidget.dart';
import '../../manage_merchants/controller/mervchant_approvalstatus_controller.dart';


class AdminMerchantDetailController extends GetxController {
  final box = GetStorage();

  var isLoading = true.obs;
  var merchant = Rxn<AdminMerchantDetail>();

  /// ===============================
  /// AUTH CHECK
  /// ===============================
  bool _checkAuth() {
    final token = box.read("auth_token");

    if (token == null || token.toString().isEmpty) {
      Get.offAllNamed('/login');
      return false;
    }
    return true;
  }

  Map<String, String> _headers() {
    final token = box.read("auth_token") ?? '';
    return {
      "Accept": "application/json",
      "Authorization": "Bearer $token",
    };
  }

  /// ===============================
  /// FETCH MERCHANT DETAILS
  /// ===============================
  Future<void> fetchMerchantDetail(int merchantId) async {
    if (!_checkAuth()) return;

    isLoading.value = true;

    try {
      final response = await http.post(
        Uri.parse(
          "https://rasma.astradevelops.in/e_shoppyy/public/api/admin/merchant/details",
        ),
        headers: _headers(),
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
          AppSnackbar.error(body['message'] ?? "Failed");
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

  /// ===============================
  /// APPROVE / REJECT MERCHANT
  /// ===============================
  Future<void> updateApproval({
    required int merchantId,
    required String status, // approved | rejected
  }) async {
    if (!_checkAuth()) return;

    try {
      final response = await http.post(
        Uri.parse(
          "https://rasma.astradevelops.in/e_shoppyy/public/api/admin/merchant/approve-reject",
        ),
        headers: _headers(),
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

          /// ✅ REFRESH LIST
          if (Get.isRegistered<AdminMerchantController>()) {
            Get.find<AdminMerchantController>().fetchMerchants();
          }

          AppSnackbar.success(body['message'] ?? "Updated successfully");
        } else {
          AppSnackbar.error(body['message'] ?? "Update failed");
        }
      } else {
        AppSnackbar.error(ApiErrorHandler.handleResponse(response));
      }
    } catch (e) {
      AppSnackbar.error(ApiErrorHandler.handleException(e));
    }
  }
}