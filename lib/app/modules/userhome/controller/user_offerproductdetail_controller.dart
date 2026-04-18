
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

import '../../../data/errors/api_error.dart';
import '../../../data/models/user_offerdetailmodel.dart';
import '../../merchantlogin/widget/successwidget.dart';

class UserOfferProductDetailController extends GetxController {
  final box = GetStorage();

  final String apiUrl =
      "https://rasma.astradevelops.in/e_shoppyy/public/api/offer-product/details";

  var isLoading = false.obs;
  var productData = Rx<UserOfferProductDetail?>(null);

  var selectedAttributes = <String, String>{}.obs;
  var selectedVariant = Rx<ProductVariant?>(null);
  var currentImageIndex = 0.obs;

  Future<void> fetchProductDetails(int offerProductId) async {
    try {
      isLoading.value = true;
      productData.value = null;
      selectedAttributes.clear();
      selectedVariant.value = null;
      currentImageIndex.value = 0;

      final token = box.read("auth_token");
      if (token == null) {
        AppSnackbar.error("Authentication token not found");
        return;
      }

      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
        body: jsonEncode({"offer_product_id": offerProductId}),
      );

      if (response.statusCode == 200) {
        final body = jsonDecode(response.body);

        if (body['status'] == 1) {
          productData.value = UserOfferProductDetail.fromJson(body['data']);

          if (productData.value!.variants.isNotEmpty) {
            _initializeFirstVariant();
          }
        } else {
          // ✅ LOGICAL ERROR (status != 1)
          final message =
              body['message'] ?? "Failed to fetch product details";
          AppSnackbar.error(message);
        }
      } else {
        // ✅ API ERROR HANDLER
        final errorMessage = ApiErrorHandler.handleResponse(response);
        AppSnackbar.error(errorMessage);
      }
    } catch (e) {
      // ✅ EXCEPTION HANDLER
      final errorMessage = ApiErrorHandler.handleException(e);
      AppSnackbar.error(errorMessage);
    } finally {
      isLoading.value = false;
    }
  }

  void _initializeFirstVariant() {
    if (productData.value == null || productData.value!.variants.isEmpty) return;

    final firstVariant = productData.value!.variants.first;
    selectedAttributes.value = Map.from(firstVariant.attributes);
    selectedVariant.value = firstVariant;
    _syncImageIndexToVariant(firstVariant);
  }

  void selectAttribute(String attributeName, String value) {
    selectedAttributes[attributeName] = value;
    _updateSelectedVariant();
  }

  void _updateSelectedVariant() {
    if (productData.value == null) return;

    final matchingVariant = productData.value!.variants.firstWhereOrNull(
          (variant) => _attributesMatch(variant.attributes, selectedAttributes),
    );

    selectedVariant.value = matchingVariant;

    if (matchingVariant != null) {
      _syncImageIndexToVariant(matchingVariant);
    }
  }

  void _syncImageIndexToVariant(ProductVariant variant) {
    final images = productData.value?.productImages ?? [];
    final idx = images.indexOf(variant.image);
    if (idx != -1) currentImageIndex.value = idx;
  }

  bool _attributesMatch(
      Map<String, String> variantAttrs, Map<String, String> selectedAttrs) {
    if (variantAttrs.length != selectedAttrs.length) return false;
    for (var key in variantAttrs.keys) {
      if (variantAttrs[key] != selectedAttrs[key]) return false;
    }
    return true;
  }

  List<String> getAvailableValuesForAttribute(String attributeName) {
    if (productData.value == null) return [];
    return productData.value!.variants
        .map((v) => v.attributes[attributeName])
        .whereType<String>()
        .toSet()
        .toList();
  }

  String getAttributeDisplayName(String key) {
    return key[0].toUpperCase() + key.substring(1);
  }

  double getDiscountAmount() {
    if (selectedVariant.value == null) return 0;
    return selectedVariant.value!.price - selectedVariant.value!.offerPrice;
  }
}