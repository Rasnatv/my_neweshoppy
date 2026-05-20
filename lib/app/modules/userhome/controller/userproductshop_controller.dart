

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

  // ── Product pagination state ──────────────────────────────
  var isLoading        = false.obs;   // first-page load
  var isLoadingMore    = false.obs;   // subsequent pages
  var hasMore          = true.obs;    // more pages available?
  int _currentPage     = 1;
  static const int _perPage = 10;

  var products = <UserShopProductModel>[].obs;

  // ── Shop detail state ─────────────────────────────────────
  var isShopLoading  = false.obs;
  var shopDetail     = Rxn<UserShopDetailModel>();

  // ── API endpoints ─────────────────────────────────────────
  final String productApi =
      //"https://rasma.astradevelops.in/e_shoppyy/public/api/shop-products";
       "https://eshoppy.co.in/api/shop-products?page=1&per_page=10" ;
  final String shopDetailApi =
      "https://eshoppy.co.in/api/shop-details";

  // ── Entry point called by the view ────────────────────────
  Future<void> loadShop(int merchantId) async {
    _resetPagination();
    await fetchShopDetails(merchantId);
    await fetchProducts(merchantId, isFirstPage: true);
  }

  void _resetPagination() {
    _currentPage = 1;
    hasMore.value = true;
    products.clear();
  }

  // ── Load next page (called on scroll-to-bottom) ───────────
  Future<void> loadMoreProducts(int merchantId) async {
    if (isLoadingMore.value || !hasMore.value) return;
    await fetchProducts(merchantId, isFirstPage: false);
  }

  // ── Fetch shop details ────────────────────────────────────
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
        body: {"merchant_id": merchantId.toString()},
      );

      if (response.statusCode == 200) {
        final decoded = json.decode(response.body);
        if (decoded['status'] == true && decoded['data'] != null) {
          shopDetail.value = UserShopDetailModel.fromJson(decoded['data']);
        } else {
          shopDetail.value = null;
          AppSnackbar.error(decoded['message'] ?? "Failed to load shop details");
        }
      } else {
        shopDetail.value = null;
        AppSnackbar.error(ApiErrorHandler.handleResponse(response));
      }
    } catch (e) {
      shopDetail.value = null;
      AppSnackbar.error(ApiErrorHandler.handleException(e));
    } finally {
      isShopLoading.value = false;
    }
  }

  // ── Fetch products (paginated) ────────────────────────────
  Future<void> fetchProducts(int merchantId,
      {required bool isFirstPage}) async {
    final token = box.read('auth_token');
    if (token == null) return;

    try {
      if (isFirstPage) {
        isLoading.value = true;
      } else {
        isLoadingMore.value = true;
      }

      final uri = Uri.parse(productApi).replace(queryParameters: {
        "page":     _currentPage.toString(),
        "per_page": _perPage.toString(),
      });

      final response = await http.post(
        uri,
        headers: {
          "Accept": "application/json",
          "Authorization": "Bearer $token",
        },
        body: {"merchant_id": merchantId.toString()},
      );

      if (response.statusCode == 200) {
        final decoded = json.decode(response.body);
        final List list = decoded['data'] ?? [];

        final newItems =
        list.map((e) => UserShopProductModel.fromJson(e)).toList();

        if (isFirstPage) {
          products.value = newItems;
        } else {
          products.addAll(newItems);
        }

        // If we got fewer items than requested, no more pages exist
        if (newItems.length < _perPage) {
          hasMore.value = false;
        } else {
          _currentPage++;
        }
      } else {
        if (isFirstPage) products.clear();
        AppSnackbar.error(ApiErrorHandler.handleResponse(response));
      }
    } catch (e) {
      if (isFirstPage) products.clear();
      AppSnackbar.error(ApiErrorHandler.handleException(e));
    } finally {
      isLoading.value     = false;
      isLoadingMore.value = false;
    }
  }
}