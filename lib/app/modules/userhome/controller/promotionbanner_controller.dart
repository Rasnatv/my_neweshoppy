
import 'dart:convert';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

class PromotionController extends GetxController {
  final RxList<String> bannerImages = <String>[].obs;
  final GetStorage box = GetStorage();

  final String apiUrl =
      "https://rasma.astradevelops.in/e_shoppyy/public/api/advertisements/images";

  @override
  void onInit() {
    super.onInit();

    // 🔥 SIGNUP CASE (token comes later)
    box.listenKey("auth_token", (value) {
      if (value != null && value.toString().isNotEmpty) {
        fetchBanners();
      }
    });

    // 🔥 LOGIN / APP RESTART CASE
    final token = box.read("auth_token");
    if (token != null && token.toString().isNotEmpty) {
      fetchBanners();
    }
  }

  Future<void> fetchBanners() async {
    final String? token = box.read("auth_token");
    if (token == null || token.isEmpty) return;

    try {
      final response = await http.get(
        Uri.parse(apiUrl),
        headers: {
          "Authorization": "Bearer $token",
          "Accept": "application/json",
        },
      );

      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);

        if (decoded['status'] == 1 || decoded['status'] == "1") {
          bannerImages.assignAll(
            List<String>.from(
              decoded['data'].map((e) => e['image_url']),
            ),
          );
        }
      }
    } catch (e) {
      print("Banner error: $e");
    }
  }
}
