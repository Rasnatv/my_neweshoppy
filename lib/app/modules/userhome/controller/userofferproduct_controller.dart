
import 'dart:convert';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

import '../../../data/models/userofferproductmodel.dart';

class UserOfferProductController extends GetxController {
  final String merchant_id;

  UserOfferProductController(this.merchant_id);

  var isLoading = false.obs;
  var productList = <UserOfferProductModel>[].obs;

  final box = GetStorage();

  @override
  void onInit() {
    super.onInit();
    print('🔵 Controller initialized with merchant_id: $merchant_id');
    fetchOfferProducts();
  }

  Future<void> fetchOfferProducts() async {
    try {
      isLoading(true);

      final token = box.read('auth_token');
      print('🔑 Token: $token');
      print('📦 Merchant ID being sent: $merchant_id');

      final response = await http.post(
        Uri.parse(
          'https://rasma.astradevelops.in/e_shoppyy/public/api/merchant/offer-products',
        ),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
          'Content-Type': 'application/x-www-form-urlencoded', // ← Added
        },
        body: {
          'merchant_id': merchant_id,
        },
      );

      print('📡 Response Status: ${response.statusCode}');
      print('📄 Response Body: ${response.body}');

      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);

        if (decoded['status'] == 1) {
          final List data = decoded['data'];
          print('✅ Products found: ${data.length}');

          productList.value =
              data.map((e) => UserOfferProductModel.fromJson(e)).toList();
        } else {
          print('❌ API returned status 0: ${decoded['message']}');
          Get.snackbar('Error', decoded['message'] ?? 'Unknown error');
        }
      } else {
        print('❌ Server error: ${response.statusCode}');
        Get.snackbar('Error', 'Server error: ${response.statusCode}');
      }
    } catch (e) {
      print('❌ Exception: $e');
      Get.snackbar('Error', 'Failed to load offer products: $e');
    } finally {
      isLoading(false);
    }
  }
}