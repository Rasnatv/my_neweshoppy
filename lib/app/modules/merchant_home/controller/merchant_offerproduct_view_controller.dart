import 'dart:convert';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import '../../../data/models/merchant_offerproductviewmodel.dart';

class MerchantOfferProductController extends GetxController {
  final offerProducts = <MerchantOfferProductModel>[].obs;
  final isLoading = false.obs;
  final box = GetStorage();
  int? _offerId;

  final String offerProductUrl =
      "https://rasma.astradevelops.in/e_shoppyy/public/api/view-offer-product";

  void init(int offerId) {
    if (_offerId == offerId) return;
    _offerId = offerId;
    fetchOfferProduct(offerId);
  }

  Future<void> fetchOfferProduct(int offerId) async {
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
        Uri.parse(offerProductUrl),
        headers: {
          "Accept": "application/json",
          "Authorization": "Bearer $token",
          "Content-Type": "application/json",
        },
        body: jsonEncode({"offer_id": offerId}),
      );

      if (response.statusCode == 200) {
        print("API RESPONSE: ${response.body}"); // ✅ debug — remove after fix
        final data = jsonDecode(response.body);
        if (data['status'] == 1) {
          if (data['data'] is List) {
            offerProducts.value = (data['data'] as List)
                .map((e) => MerchantOfferProductModel.fromJson(e))
                .toList();
          } else if (data['data'] is Map) {
            offerProducts.value = [
              MerchantOfferProductModel.fromJson(
                  data['data'] as Map<String, dynamic>)
            ];
          }
        } else {
          Get.snackbar("Error", data['message'] ?? "Failed to load product");
        }
      } else {
        Get.snackbar("Error", "Server error: ${response.statusCode}");
      }
    } catch (e) {
      Get.snackbar("Error", "Something went wrong: $e");
    } finally {
      isLoading.value = false;
    }
  }
}