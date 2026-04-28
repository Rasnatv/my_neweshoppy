
import 'dart:convert';
import 'package:eshoppy/app/widgets/areaadminsuccesswidget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

import '../../../../data/errors/api_error.dart';
import '../../../../data/models/districtadmin_advertismnetgetmodel.dart';
import '../../../merchantlogin/widget/successwidget.dart';


class DistrictAdminAdvertisementGetController extends GetxController {

  // ─── Observables ─────────────────────────────
  final isLoading  = false.obs;
  final isDeleting = false.obs;

  final advertisementList =
      <DistrictAdminGetAdvertisementModel>[].obs;

  // ─── Storage ─────────────────────────────────
  final _box = GetStorage();

  String get token => _box.read('auth_token') ?? '';

  static const String _baseUrl =
      'https://eshoppy.co.in/api/district-admin';

  Map<String, String> get _headers => {
    'Authorization': 'Bearer $token',
    'Accept': 'application/json',
  };

  Map<String, String> get _jsonHeaders => {
    'Authorization': 'Bearer $token',
    'Accept': 'application/json',
    'Content-Type': 'application/json',
  };

  @override
  void onInit() {
    super.onInit();
    fetchAdvertisements();
  }

  // ─── FETCH ADVERTISEMENTS ────────────────────
  Future<void> fetchAdvertisements() async {

    try {
      isLoading.value = true;

      final response = await http.get(
        Uri.parse('$_baseUrl/advertisements'),
        headers: _headers,
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200 && data['status'] == true) {
        final List list = data['data'] ?? [];

        advertisementList.assignAll(
          list.map((e) =>
              DistrictAdminGetAdvertisementModel.fromJson(e)).toList(),
        );


      } else {
        final errorMessage =
        ApiErrorHandler.handleResponse(response);
        AppSnackbar.error(errorMessage);
      }

    } catch (e) {
      final errorMessage =
      ApiErrorHandler.handleException(e);
      AppSnackbar.error(errorMessage);

    } finally {
      isLoading.value = false;
    }
  }

  // ─── DELETE ADVERTISEMENT ────────────────────
  Future<void> deleteAdvertisement(String adId) async {

    try {
      isDeleting.value = true;

      final request = http.Request(
        'DELETE',
        Uri.parse('$_baseUrl/advertisement/delete'),
      );

      request.headers.addAll(_jsonHeaders);
      request.body = jsonEncode({
        "advertisement_id": int.tryParse(adId) ?? adId,
      });

      final streamedResponse = await request.send();
      final response =
      await http.Response.fromStream(streamedResponse);

      final data = jsonDecode(response.body);

      if (response.statusCode == 200 && data['status'] == true) {
        // ✅ Remove locally
        advertisementList.removeWhere((ad) => ad.id == adId);

        AppSnackbar.success(
          data['message'] ?? 'Advertisement deleted successfully',
        );

        // ✅ Refresh list (optional but safe)
        await fetchAdvertisements();
      } else {
        final errorMessage =
        ApiErrorHandler.handleResponse(response);
        AppSnackbar.error(errorMessage);
      }

    } catch (e) {
      final errorMessage =
      ApiErrorHandler.handleException(e);
      AppSnackbar.error(errorMessage);

    } finally {
      isDeleting.value = false;
    }
  }

  // ─── Latest Ads (for dashboard) ──────────────
  List<DistrictAdminGetAdvertisementModel> get latestAds =>
      advertisementList.take(3).toList();


}