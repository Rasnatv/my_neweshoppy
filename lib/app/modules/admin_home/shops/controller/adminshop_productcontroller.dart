import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../../../../data/models/admin_shopproductmodel.dart';

class ShopProductController extends GetxController {
  var isLoading = false.obs;
  var products = <ShopProduct>[].obs;
  final box = GetStorage();

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments;
    if (args != null && args['shop_id'] != null) {
      fetchProducts(args['shop_id']);
    }
  }

  Future<void> fetchProducts(dynamic shopId) async {
    isLoading.value = true;
    products.clear();

    final String? authToken = box.read('auth_token');

    if (authToken == null) {
      Get.snackbar(
        'Unauthorized',
        'Auth token not found. Please login again.',
        snackPosition: SnackPosition.BOTTOM,
      );
      isLoading.value = false;
      return;
    }

    try {
      final response = await http.post(
        Uri.parse(
            'https://rasma.astradevelops.in/e_shoppyy/public/api/shop/products'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $authToken',
        },
        body: jsonEncode({
          'shop_id': int.parse(shopId.toString()),
        }),
      );

      final data = jsonDecode(response.body);

      if (data['status'] == true) {
        final List list = data['data'] ?? [];
        products.assignAll(
            list.map((e) => ShopProduct.fromJson(e)).toList());
      } else {
        Get.snackbar(
          'Failed',
          data['message'] ?? 'Failed to fetch products',
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Something went wrong. Please try again.',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }
}