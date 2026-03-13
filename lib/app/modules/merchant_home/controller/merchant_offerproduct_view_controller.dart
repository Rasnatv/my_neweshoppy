import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import '../../../data/models/merchant_offerproductviewmodel.dart';

class MerchantOfferProductController extends GetxController {
  final int offerId;

  MerchantOfferProductController({required this.offerId});

  final offerProducts = <NMerchantOfferProductModels>[].obs;
  final isLoading  = false.obs;
  final isDeleting = false.obs;
  final box = GetStorage();

  static const String _base =
      "https://rasma.astradevelops.in/e_shoppyy/public/api";

  String get _token => box.read("auth_token") ?? "";

  Map<String, String> get _headers => {
    "Accept":        "application/json",
    "Authorization": "Bearer $_token",
    "Content-Type":  "application/json",
  };

  @override
  void onInit() {
    super.onInit();
    fetchOfferProduct();
  }

  // ── Fetch ─────────────────────────────────────────────────────────────────
  // POST /api/view-offer-product
  // Body  : { "offer_id": 20 }
  // Response:
  // {
  //   "status": 1,
  //   "message": "Offer products fetched successfully",
  //   "data": [
  //     {
  //       "product_id":          "93",
  //       "product_name":        "chappal",
  //       "original_price":      "450.00",
  //       "discount_percentage": "25.00",
  //       "discount_price":      "337.50",
  //       "image":               "https://..."
  //     }
  //   ]
  // }
  Future<void> fetchOfferProduct() async {
    if (_token.isEmpty) {
      Get.snackbar("Error", "Token missing. Please login again.");
      return;
    }

    isLoading.value = true;
    offerProducts.clear();

    try {
      final response = await http.post(
        Uri.parse("$_base/view-offer-product"),
        headers: _headers,
        body: jsonEncode({"offer_id": offerId}),
      );

      debugPrint("📡 fetchOfferProduct status : ${response.statusCode}");
      debugPrint("📥 body                     : ${response.body}");

      if (response.statusCode == 200) {
        final data   = jsonDecode(response.body) as Map<String, dynamic>;
        final status = data['status'];

        if (status == 1 || status == '1' || status == true) {
          final raw = data['data'];

          if (raw is List) {
            // Normal case — array of products
            offerProducts.value = raw
                .map((e) => NMerchantOfferProductModels.fromJson(
                e as Map<String, dynamic>))
                .toList();
          } else if (raw is Map) {
            // Fallback — single product object
            offerProducts.value = [
              NMerchantOfferProductModels.fromJson(
                  raw as Map<String, dynamic>),
            ];
          }

          debugPrint("✅ Loaded ${offerProducts.length} product(s)");
        } else {
          Get.snackbar(
              "Error", data['message'] ?? "Failed to load products");
        }
      } else {
        Get.snackbar("Error", "Server error: ${response.statusCode}");
      }
    } catch (e) {
      debugPrint("❌ fetchOfferProduct error: $e");
      Get.snackbar("Error", "Something went wrong: $e");
    } finally {
      isLoading.value = false;
    }
  }

  // ── Delete ────────────────────────────────────────────────────────────────
  Future<void> deleteOfferProduct(int productId) async {
    if (_token.isEmpty) {
      Get.snackbar("Error", "Token missing. Please login again.");
      return;
    }

    isDeleting.value = true;

    try {
      final response = await http.post(
        Uri.parse("$_base/delete-offer-product"),
        headers: _headers,
        body: jsonEncode({
          "offer_id":   offerId,
          "product_id": productId,
        }),
      );

      debugPrint("🗑️ deleteOfferProduct status : ${response.statusCode}");
      debugPrint("📥 body                      : ${response.body}");

      final data      = jsonDecode(response.body) as Map<String, dynamic>;
      final status    = data['status'];
      final isSuccess = status == 1 || status == '1' || status == true;

      if ((response.statusCode == 200 || response.statusCode == 201) &&
          isSuccess) {
        // Remove locally so no extra fetch is needed
        offerProducts.removeWhere((p) => p.productId == productId);

        Get.snackbar(
          "Deleted",
          data['message'] ?? "Product removed successfully.",
          backgroundColor: Colors.green.shade600,
          colorText: Colors.white,
          icon: const Icon(Icons.check_circle_outline, color: Colors.white),
          snackPosition: SnackPosition.BOTTOM,
        );
      } else {
        Get.snackbar(
          "Error",
          data['message'] ?? "Failed to delete product.",
          backgroundColor: Colors.red.shade600,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (e) {
      debugPrint("❌ deleteOfferProduct error: $e");
      Get.snackbar("Error", "Something went wrong: $e",
          snackPosition: SnackPosition.BOTTOM);
    } finally {
      isDeleting.value = false;
    }
  }
}