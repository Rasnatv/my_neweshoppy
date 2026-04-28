
import 'dart:convert';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

import '../../../../data/errors/api_error.dart';
import '../../../../data/models/admin_shopproductmodel.dart';
import '../../../merchantlogin/widget/successwidget.dart';

class ShopProductController extends GetxController {
  var isLoading = false.obs;
  var products = <ShopProduct>[].obs;

  final box = GetStorage();

  /// ── AUTH CHECK ─────────────────────────────────────────
  bool _checkAuth() {
    final token = box.read('auth_token');

    if (token == null || token.toString().isEmpty) {
      Get.offAllNamed('/login');
      return false;
    }
    return true;
  }

  Map<String, String> _headers() {
    final token = box.read('auth_token') ?? '';
    return {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    };
  }

  @override
  void onInit() {
    super.onInit();

    final args = Get.arguments;
    if (args != null && args['shop_id'] != null) {
      fetchProducts(args['shop_id']);
    }
  }

  /// ── FETCH PRODUCTS ─────────────────────────────────────
  Future<void> fetchProducts(dynamic shopId) async {
    if (!_checkAuth()) return;

    isLoading.value = true;
    products.clear();

    try {
      final response = await http.post(
        Uri.parse(
          'https://eshoppy.co.in/api/shop/products',
        ),
        headers: _headers(),
        body: jsonEncode({
          'shop_id': int.parse(shopId.toString()),
        }),
      );

      /// 🔥 HANDLE 401 AUTO LOGOUT
      if (response.statusCode == 401) {
        ApiErrorHandler.handleResponse(response);
        return;
      }

      final data = jsonDecode(response.body);

      if (response.statusCode == 200 && data['status'] == true) {
        final List list = data['data'] ?? [];

        products.assignAll(
          list.map((e) => ShopProduct.fromJson(e)).toList(),
        );
      } else {
        AppSnackbar.error(
          data['message'] ?? 'Failed to fetch products',
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
}