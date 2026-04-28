
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

import '../../../data/models/area_admin_advertismentgetmodel.dart';
import '../../../data/errors/api_error.dart';
import '../../../widgets/areaadminsuccesswidget.dart';
import '../../merchantlogin/widget/successwidget.dart';

class AreaAdminAdvertisementgetController extends GetxController {
  var isLoading = false.obs;
  var advertisementList = <AreaAdmingetAdvertisementModel>[].obs;

  final box = GetStorage();

  @override
  void onInit() {
    super.onInit();
    fetchAdvertisements();
  }

  // ───────────────── FETCH ADS ─────────────────
  Future<void> fetchAdvertisements() async {
    try {
      isLoading(true);

      final String? token = box.read('auth_token');

      if (token == null || token.isEmpty) {
        Get.toNamed('/login');
        return;
      }

      final response = await http.get(
        Uri.parse(
          'https://eshoppy.co.in/api/area-admin/advertisements',
        ),
        headers: {
          "Authorization": "Bearer $token",
          "Accept": "application/json",
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        if (data['data'] != null) {
          final List list = data['data'];

          final ads = list
              .map((e) => AreaAdmingetAdvertisementModel.fromJson(e))
              .toList();

          // Keep your logic (latest first)
          ads.sort((a, b) => b.id.compareTo(a.id));

          advertisementList.value = ads;
        } else {
          advertisementList.clear();
        }
      } else {
        final errorMsg = ApiErrorHandler.handleResponse(response);
        AppSnackbar.error(errorMsg);
      }
    } catch (e) {
      final errorMsg = ApiErrorHandler.handleException(e);
      AppSnackbar.error(errorMsg);
    } finally {
      isLoading(false);
    }
  }

  // ───────────────── DELETE AD ─────────────────
  Future<void> deleteAdvertisement(int adId) async {
    // Optimistic UI remove (same logic)
    advertisementList.removeWhere((ad) => ad.id == adId);

    try {
      final String? token = box.read('auth_token');

      if (token == null || token.isEmpty) {
        AppSnackbar.error("No auth token found.");
        fetchAdvertisements(); // rollback
        return;
      }

      final response = await http.delete(
        Uri.parse(
          'https://eshoppy.co.in/api/area-admin/advertisement/delete',
        ),
        headers: {
          "Authorization": "Bearer $token",
          "Accept": "application/json",
          "Content-Type": "application/json",
        },
        body: jsonEncode({"ad_id": adId}),
      );

      final data = json.decode(response.body);

      if (response.statusCode == 200 && data['status'] == true) {
        AppSnackbar.success(
          data['message'] ?? "Advertisement deleted.",
        );
      } else {
        final errorMsg = ApiErrorHandler.handleResponse(response);
        AppSnackbar.error(errorMsg);
        fetchAdvertisements(); // rollback
      }
    } catch (e) {
      final errorMsg = ApiErrorHandler.handleException(e);
      AppSnackbar.error(errorMsg);
      fetchAdvertisements(); // rollback
    }
  }

  // ───────────────── LATEST 3 ADS ─────────────────
  List<AreaAdmingetAdvertisementModel> get latestAds =>
      advertisementList.take(3).toList();
}