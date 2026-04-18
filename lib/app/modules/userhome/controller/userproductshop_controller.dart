
import 'dart:convert';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

import '../../../data/errors/api_error.dart';
import '../../../data/models/user_shopimagemodel.dart';
import '../../../data/models/user_shopproductmodel.dart';
import '../../merchantlogin/widget/successwidget.dart';

class UserShopProductController extends GetxController {
  final box = GetStorage();

  var isLoading = false.obs;
  var products = <UserShopProductModel>[].obs;

  var isShopLoading = false.obs;
  var shopDetail = Rxn<UserShopDetailModel>();

  final String productApi =
      "https://rasma.astradevelops.in/e_shoppyy/public/api/shop-products";

  final String shopDetailApi =
      "https://rasma.astradevelops.in/e_shoppyy/public/api/shop-details";

  Future<void> loadShop(int merchantId) async {
    await fetchShopDetails(merchantId);
    await fetchProducts(merchantId);
  }

  /// ── Fetch shop details ─────────────────────────────────────
  Future<void> fetchShopDetails(int merchantId) async {
    final token = box.read('auth_token');
    if (token == null) return;

    try {
      isShopLoading.value = true;

      final response = await http.post(
        Uri.parse(shopDetailApi),
        headers: {
          "Accept": "application/json",
          "Authorization": "Bearer $token",
        },
        body: {
          "merchant_id": merchantId.toString(),
        },
      );

      if (response.statusCode == 200) {
        final decoded = json.decode(response.body);

        // ✅ FIX: API returns boolean true, not integer 1
        final bool isSuccess = decoded['status'] == true;

        if (isSuccess && decoded['data'] != null) {
          shopDetail.value = UserShopDetailModel.fromJson(decoded['data']);
        } else {
          shopDetail.value = null;
          final message = decoded['message'] ?? "Failed to load shop details";
          AppSnackbar.error(message);
        }
      } else {
        shopDetail.value = null;
        final errorMessage = ApiErrorHandler.handleResponse(response);
        AppSnackbar.error(errorMessage);
      }
    } catch (e) {
      shopDetail.value = null;
      final errorMessage = ApiErrorHandler.handleException(e);
      AppSnackbar.error(errorMessage);
      print("Shop detail error: $e");
    } finally {
      isShopLoading.value = false;
    }
  }

  /// ── Fetch products ─────────────────────────────────────────
  Future<void> fetchProducts(int merchantId) async {
    final token = box.read('auth_token');
    if (token == null) return;

    try {
      isLoading.value = true;

      final response = await http.post(
        Uri.parse(productApi),
        headers: {
          "Accept": "application/json",
          "Authorization": "Bearer $token",
        },
        body: {
          "merchant_id": merchantId.toString(),
        },
      );

      if (response.statusCode == 200) {
        final decoded = json.decode(response.body);
        final List list = decoded['data'] ?? [];
        products.value =
            list.map((e) => UserShopProductModel.fromJson(e)).toList();
      } else {
        products.clear();
        final errorMessage = ApiErrorHandler.handleResponse(response);
        AppSnackbar.error(errorMessage);
      }
    } catch (e) {
      products.clear();
      final errorMessage = ApiErrorHandler.handleException(e);
      AppSnackbar.error(errorMessage);
      print("Product fetch error: $e");
    } finally {
      isLoading.value = false;
    }
  }
}