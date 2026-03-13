

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import '../../../data/models/offer_productdetailmodel.dart';

class MerchantOfferProductDetailController extends GetxController {
  final productDetail        = Rxn<MerchantOfferProductDetailModel>();
  final isLoading            = false.obs;
  final selectedVariantIndex = 0.obs;
  final currentImageIndex    = 0.obs;
  final box                  = GetStorage();

  /// PageController to programmatically scroll the image PageView.
  late final PageController pageController;

  static const String _detailUrl =
      "https://rasma.astradevelops.in/e_shoppyy/public/api/offer-product-details";

  String get _token => box.read("auth_token") ?? "";

  @override
  void onInit() {
    super.onInit();
    pageController = PageController();
  }

  @override
  void onClose() {
    pageController.dispose();
    super.onClose();
  }

  // ── Fetch product detail ──────────────────────────────────────────────────
  // POST /api/offer-product-details
  // Body    : { "product_id": 93 }
  // Response:
  // {
  //   "status": 1,
  //   "data": {
  //     "product_id": "93",
  //     "product_name": "chappal",
  //     "description": "nice with border colour",
  //     "product_attributes": {
  //       "common_attributes": { "material": "...", "brand": "...", "type": "..." },
  //       "variants": [
  //         { "attributes": {...}, "price": 450, "stock": 5,
  //           "image": "https://...", "final_price": 337.5 }
  //       ]
  //     },
  //     "features": []
  //   }
  // }
  Future<void> fetchProductDetail(int productId) async {
    if (_token.isEmpty) {
      Get.snackbar("Error", "Token missing. Please login again.");
      return;
    }

    isLoading.value            = true;
    productDetail.value        = null;
    selectedVariantIndex.value = 0;
    currentImageIndex.value    = 0;

    try {
      final response = await http.post(
        Uri.parse(_detailUrl),
        headers: {
          "Accept":        "application/json",
          "Authorization": "Bearer $_token",
          "Content-Type":  "application/json",
        },
        body: jsonEncode({"product_id": productId}),
      );

      debugPrint("📡 fetchProductDetail status : ${response.statusCode}");
      debugPrint("📥 body                      : ${response.body}");

      if (response.statusCode == 200) {
        final data   = jsonDecode(response.body) as Map<String, dynamic>;
        final status = data['status'];

        if (status == 1 || status == '1' || status == true) {
          productDetail.value = MerchantOfferProductDetailModel.fromJson(
              data['data'] as Map<String, dynamic>);
          debugPrint("✅ Loaded: ${productDetail.value?.productName}");
        } else {
          Get.snackbar(
              "Error", data['message'] ?? "Failed to load details");
        }
      } else {
        Get.snackbar("Error", "Server error: ${response.statusCode}");
      }
    } catch (e) {
      debugPrint("❌ fetchProductDetail error: $e");
      Get.snackbar("Error", "Something went wrong: $e");
    } finally {
      isLoading.value = false;
    }
  }

  // ── Select variant → also scrolls image PageView to that index ───────────
  void selectVariant(int index) {
    selectedVariantIndex.value = index;

    final imageCount = productDetail.value?.productImages.length ?? 0;
    if (imageCount > index && pageController.hasClients) {
      pageController.animateToPage(
        index,
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    }
    currentImageIndex.value =
    index < imageCount ? index : currentImageIndex.value;
  }

  // ── Image swiped → syncs selected variant to matching index ──────────────
  void onImagePageChanged(int imageIndex) {
    currentImageIndex.value = imageIndex;

    final variantCount =
        productDetail.value?.productAttributes.variants.length ?? 0;
    if (imageIndex < variantCount) {
      selectedVariantIndex.value = imageIndex;
    }
  }
}