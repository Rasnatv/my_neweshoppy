import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import '../../../data/models/merchant_offerproductviewmodel.dart';

class MerchantOfferProductController extends GetxController {
  final int offerId;

  MerchantOfferProductController({required this.offerId});

  final offerProducts = <MerchantOfferProductModels>[].obs;
  final isLoading = false.obs;
  final box = GetStorage();

  final String baseUrl =
      "https://rasma.astradevelops.in/e_shoppyy/public/api/view-offer-product";

  @override
  void onInit() {
    super.onInit();
    fetchOfferProduct();
  }
  Future<void> fetchOfferProduct() async {
    isLoading.value = true;
    offerProducts.clear();

    final token = box.read("auth_token") ?? "";

    if (token.isEmpty) {
      isLoading.value = false;
      Get.snackbar("Error", "Token missing. Please login again.");
      return;
    }

    try {
      final response = await http.post(
        Uri.parse(baseUrl),
        headers: {
          "Accept": "application/json",
          "Authorization": "Bearer $token",
          "Content-Type": "application/json",
        },
        body: jsonEncode({"offer_id": offerId}), // ✅ body, not query string
      );

      debugPrint("📡 Status: ${response.statusCode}");
      debugPrint("📥 Body: ${response.body}");

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        if (data['status'] == 1 || data['status'] == '1' || data['status'] == true) {
          final raw = data['data'];

          if (raw == null) {
            offerProducts.clear();
          } else if (raw is List) {
            offerProducts.value = raw
                .map((e) => MerchantOfferProductModels.fromJson(e as Map<String, dynamic>))
                .toList();
          } else if (raw is Map) {
            offerProducts.value = [
              MerchantOfferProductModels.fromJson(raw as Map<String, dynamic>)
            ];
          }

          debugPrint("✅ Loaded ${offerProducts.length} product(s)");
        } else {
          Get.snackbar("Error", data['message'] ?? "Failed to load products");
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


}
