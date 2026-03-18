import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

import '../../../../data/models/admin_shopproductdetailsmodel.dart';






class mAdminProductDetailController extends GetxController {
  final GetStorage box = GetStorage();

  // Observable state
  final Rx<mAdminProductDetailModel?> productDetailResponse =
  Rx<mAdminProductDetailModel?>(null);
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;
  final RxInt selectedVariantIndex = 0.obs;

  // API endpoint
  static const String _baseUrl =
      'https://rasma.astradevelops.in/e_shoppyy/public/api/product/detailss';

  // GetStorage keys
  static const String _authTokenKey = 'auth_token';
  static const String authTokenKey = _authTokenKey; // public alias for UI

  /// Retrieve auth token from GetStorage
  String? get authToken => box.read<String>(_authTokenKey);

  /// Save auth token to GetStorage
  void saveAuthToken(String token) {
    box.write(_authTokenKey, token);
  }

  /// Shortcut getter for product data
  mProductDetail? get product => productDetailResponse.value?.data;

  /// Currently selected variant
  mProductVariant? get selectedVariant {
    final variants = product?.variants;
    if (variants == null || variants.isEmpty) return null;
    if (selectedVariantIndex.value >= variants.length) return null;
    return variants[selectedVariantIndex.value];
  }

  @override
  void onInit() {
    super.onInit();
    // Optionally auto-fetch on init if productId is passed via arguments
    final args = Get.arguments;
    if (args != null && args is Map && args['product_id'] != null) {
      fetchProductDetail(productId: args['product_id']);
    }
  }

  /// Fetch product details from the API
  Future<void> fetchProductDetail({required int productId}) async {
    final token = authToken;
    if (token == null || token.isEmpty) {
      errorMessage.value = 'Authentication token not found. Please login again.';
      Get.snackbar(
        'Auth Error',
        errorMessage.value,
        backgroundColor: Colors.red.shade700,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    try {
      isLoading.value = true;
      errorMessage.value = '';

      final response = await http.post(
        Uri.parse(_baseUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
        body: jsonEncode({'product_id': productId}),
      );

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body) as Map<String, dynamic>;
        final model = mAdminProductDetailModel.fromJson(json);

        if (model.status) {
          productDetailResponse.value = model;
          selectedVariantIndex.value = 0;
        } else {
          errorMessage.value = model.message;
          _showErrorSnackbar(model.message);
        }
      } else if (response.statusCode == 401) {
        errorMessage.value = 'Unauthorized. Please login again.';
        _showErrorSnackbar(errorMessage.value);
      } else {
        errorMessage.value = 'Server error: ${response.statusCode}';
        _showErrorSnackbar(errorMessage.value);
      }
    } catch (e) {
      errorMessage.value = 'Network error: ${e.toString()}';
      _showErrorSnackbar(errorMessage.value);
    } finally {
      isLoading.value = false;
    }
  }

  /// Select a variant by index
  void selectVariant(int index) {
    selectedVariantIndex.value = index;
  }

  /// Clear product detail from state
  void clearProductDetail() {
    productDetailResponse.value = null;
    errorMessage.value = '';
    selectedVariantIndex.value = 0;
  }

  void _showErrorSnackbar(String message) {
    Get.snackbar(
      'Error',
      message,
      backgroundColor: Colors.red.shade700,
      colorText: Colors.white,
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 3),
    );
  }
}