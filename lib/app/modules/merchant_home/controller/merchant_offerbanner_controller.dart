
import 'dart:convert';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

import '../../../data/models/merchant_offerbannermodel.dart';

class MerchantOfferBannerController extends GetxController {
  final offer= <MerchantOffersviewmodel>[].obs;
  final isLoading = false.obs;
  final box = GetStorage();

  final String offerUrl =
      "https://rasma.astradevelops.in/e_shoppyy/public/api/mercgetoffer";

  @override
  void onInit() {
    fetchOffers();
    super.onInit();
  }

  Future<void> fetchOffers() async {
    isLoading.value = true;

    final token = box.read("auth_token") ?? "";

    if (token.isEmpty) {
      isLoading.value = false;
      Get.snackbar("Error", "Token missing. Please login again.");
      return;
    }

    try {
      final response = await http.get(
        Uri.parse(offerUrl),
        headers: {
          "Accept": "application/json",
          "Authorization": "Bearer $token",
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        if (data['status'] == 1) {
          final List rawList = data['data'] ?? [];
          offer.value =
              rawList.map((e) => MerchantOffersviewmodel.fromJson(e)).toList();
        } else {
          Get.snackbar("Error", data['message'] ?? "Failed to load offers");
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