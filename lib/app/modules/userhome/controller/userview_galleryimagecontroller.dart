import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:get_storage/get_storage.dart';

import '../../../data/models/merchant_gallerymode.dart';

class MerchantGalleryViewController extends GetxController {
  final int merchantId;
  MerchantGalleryViewController({required this.merchantId});

  final box = GetStorage();
  String get token => box.read("auth_token") ?? "";

  RxList<MerchantImage> images = <MerchantImage>[].obs;
  RxBool isLoading = false.obs;

  final String baseUrl =
      "https://rasma.astradevelops.in/e_shoppyy/public/api/user/merchant";

  @override
  void onInit() {
    super.onInit();
    fetchImages();
  }

  Future<void> fetchImages() async {
    try {
      isLoading(true);

      final response = await http.post(
        Uri.parse("$baseUrl/images"),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
        body: jsonEncode({"merchant_id": merchantId}),
      );

      final data = jsonDecode(response.body);
      print("==> GALLERY RESPONSE: $data");

      if (response.statusCode == 200 && data["status"] == 1) {
        images.value = (data["data"] as List)
            .map((e) => MerchantImage.fromJson(e))
            .toList();
      } else {
        Get.snackbar("Error", data["message"] ?? "Failed to load gallery");
      }
    } catch (e) {
      print("==> Gallery fetch error: $e");
      Get.snackbar("Error", "Failed to load gallery");
    } finally {
      isLoading(false);
    }
  }
}