
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

import '../../../../data/models/districtadmin_advertismnetgetmodel.dart';

class DistrictAdminAdvertisementGetController extends GetxController {

  // ─── Observables ─────────────────────────────
  var isLoading   = false.obs;
  var isDeleting  = false.obs;
  var advertisementList = <DistrictAdminGetAdvertisementModel>[].obs;

  // ─── Auth ─────────────────────────────────────
  final _box = GetStorage();

  String get token => _box.read('auth_token') ?? '';

  static const String _baseUrl =
      'https://rasma.astradevelops.in/e_shoppyy/public/api/district-admin';

  @override
  void onInit() {
    super.onInit();
    fetchAdvertisements();
  }

  // ─── Fetch ────────────────────────────────────
  Future<void> fetchAdvertisements() async {
    if (token.isEmpty) {
      _handleUnauthorized();
      return;
    }

    try {
      isLoading(true);

      final response = await http.get(
        Uri.parse('$_baseUrl/advertisements'),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept':        'application/json',
        },
      );

      final data = json.decode(response.body);

      if (response.statusCode == 200 && data['status'] == true) {
        final List list = data['data'] ?? [];
        advertisementList.value = list
            .map((e) => DistrictAdminGetAdvertisementModel.fromJson(e))
            .toList();
      } else if (response.statusCode == 401) {
        _handleUnauthorized();
      } else {
        _showError(data['message'] ?? 'Server error: ${response.statusCode}');
      }
    } catch (e) {
      _showError('Something went wrong: $e');
    } finally {
      isLoading(false);
    }
  }


  Future<void> deleteAdvertisement(String adId) async {
    if (token.isEmpty) {
      _showError('No auth token found.');
      return;
    }

    try {
      isDeleting(true);

      final uri = Uri.parse('$_baseUrl/advertisement/delete');

      final response = await http.delete(
        uri,
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          "advertisement_id": int.parse(adId), // ✅ IMPORTANT: send as INT
        }),
      );

      final data = json.decode(response.body);

      if (response.statusCode == 200 && data['status'] == true) {

        // ✅ Remove from list AFTER success
        advertisementList.removeWhere((ad) => ad.id == adId);

        Get.snackbar(
          'Deleted',
          data['message'] ?? 'Advertisement deleted successfully',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );

        // ✅ OPTIONAL (BEST PRACTICE)
        await fetchAdvertisements(); // refresh list

      } else {
        _showError(data['message'] ?? 'Delete failed');
      }

    } catch (e) {
      _showError('Something went wrong: $e');
    } finally {
      isDeleting(false);
    }
  }


  // ─── Computed — latest 3 for home widget ──────
  List<DistrictAdminGetAdvertisementModel> get latestAds =>
      advertisementList.take(3).toList();

  // ─── Helpers ──────────────────────────────────
  void _showError(String msg) {
    Get.snackbar(
      'Error', msg,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.red,
      colorText: Colors.white,
    );
  }

  void _handleUnauthorized() {
    Get.snackbar(
      'Session Expired', 'Please log in again.',
      snackPosition: SnackPosition.BOTTOM,
    );
    _box.erase();
    // Get.offAll(() => DistrictAdminLoginPage());
  }
}