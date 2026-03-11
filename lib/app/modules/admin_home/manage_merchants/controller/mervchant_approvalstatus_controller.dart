
import 'dart:convert';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

import '../../../../data/models/merchant_model.dart';

class AdminMerchantController extends GetxController {
  final box = GetStorage();

  var merchants = <AdminMerchant>[].obs;
  var isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchMerchants();
  }

  Future<void> fetchMerchants() async {
    isLoading.value = true;

    final token = box.read("auth_token");
    if (token == null) return;

    try {
      final response = await http.get(
        Uri.parse(
          "https://rasma.astradevelops.in/e_shoppyy/public/api/admin/merchants",
        ),
        headers: {
          "Accept": "application/json",
          "Authorization": "Bearer $token",
        },
      );

      final body = jsonDecode(response.body);
      if (body['status'] == true) {
        merchants.value = (body['data'] as List)
            .map((e) => AdminMerchant.fromJson(e))
            .toList();
      }
    } finally {
      isLoading.value = false;
    }
  }
}
