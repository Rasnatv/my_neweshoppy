import 'dart:convert';
import 'package:eshoppy/app/modules/merchant_home/controller/manageproduct_controller.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import '../../../data/models/offer_productdetailmodel.dart';

class MerchantOfferProductDetailController extends GetxController {
  final productDetail = Rxn<MerchantOfferProductDetailModel>();
  final isLoading = false.obs;
  final selectedVariantIndex = 0.obs;
  final box = GetStorage();

  final String detailUrl =
      "https://rasma.astradevelops.in/e_shoppyy/public/api/offer-product-details";

  Future<void> fetchProductDetail(int productId) async {
    isLoading.value = true;
    productDetail.value = null;

    final token = box.read("auth_token") ?? "";
    if (token.isEmpty) {
      isLoading.value = false;
      Get.snackbar("Error", "Token missing. Please login again.");
      return;
    }

    try {
      final response = await http.post(
        Uri.parse(detailUrl),
        headers: {
          "Accept": "application/json",
          "Authorization": "Bearer $token",
          "Content-Type": "application/json",
        },
        body: jsonEncode({ "product_id":productId })

      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['status'] == 1) {
          productDetail.value =
              MerchantOfferProductDetailModel.fromJson(data['data']);
        } else {
          Get.snackbar(
              "Error", data['message'] ?? "Failed to load product details");
        }
      } else {
        Get.snackbar("Error", "Server error: ${response.statusCode}");
      }
    } catch (e) {
      print("EXCEPTION: $e");
      Get.snackbar("Error", "Something went wrong: $e");
    } finally {
      isLoading.value = false;
    }
  }

  void selectVariant(int index) {
    selectedVariantIndex.value = index;
  }
}