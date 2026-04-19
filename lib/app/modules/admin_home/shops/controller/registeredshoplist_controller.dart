
import 'dart:convert';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

import '../../../../data/errors/api_error.dart';
import '../../../../data/models/registeredshopsmodel.dart';
import '../../../merchantlogin/widget/successwidget.dart';

class AdminShopController extends GetxController {
  final box = GetStorage();

  var isLoading = false.obs;
  var shopList = <Shop>[].obs;

  final String apiUrl =
      'https://rasma.astradevelops.in/e_shoppyy/public/api/merc/reg/shop';

  // ─────────────────────────────────────────────
  // 🔐 AUTH CHECK
  // ─────────────────────────────────────────────
  bool _checkAuth() {
    final token = box.read('auth_token');

    if (token == null || token.toString().isEmpty) {
      box.erase();
      Get.offAllNamed('/login');
      return false;
    }
    return true;
  }

  // ─────────────────────────────────────────────
  // 🔐 HEADERS
  // ─────────────────────────────────────────────
  Map<String, String> _headers() {
    final token = box.read('auth_token') ?? '';

    return {
      "Accept": "application/json",
      "Authorization": "Bearer $token",
    };
  }

  // ─────────────────────────────────────────────
  // 🚀 INIT
  // ─────────────────────────────────────────────
  @override
  void onInit() {
    super.onInit();
    fetchShops();
  }

  // ─────────────────────────────────────────────
  // 📦 FETCH SHOPS
  // ─────────────────────────────────────────────
  Future<void> fetchShops() async {
    if (!_checkAuth()) return;

    try {
      isLoading.value = true;

      final response = await http.get(
        Uri.parse(apiUrl),
        headers: _headers(),
      );

      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);

        if (decoded['status'] == true) {
          final List list = decoded['data'] ?? [];

          shopList.assignAll(
            list.map((e) => Shop.fromJson(e)).toList(),
          );
        } else {
          AppSnackbar.error(decoded['message'] ?? "Failed to load shops");
        }
      } else if (response.statusCode == 401) {
        _handleUnauthorized();
      } else {
        AppSnackbar.error(
          ApiErrorHandler.handleResponse(response),
        );
      }
    } catch (e) {
      AppSnackbar.error(
        ApiErrorHandler.handleException(e),
      );
    } finally {
      isLoading.value = false;
    }
  }

  // ─────────────────────────────────────────────
  // 🔄 REFRESH
  // ─────────────────────────────────────────────
  Future<void> refreshShops() async {
    await fetchShops();
  }

  // ─────────────────────────────────────────────
  // 🚫 UNAUTHORIZED HANDLER
  // ─────────────────────────────────────────────
  void _handleUnauthorized() {
    box.erase();

    AppSnackbar.error("Session expired. Please login again.");

    Future.delayed(const Duration(milliseconds: 500), () {
      Get.offAllNamed('/login');
    });
  }
}
