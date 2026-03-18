
import 'dart:convert';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

import '../../../data/models/userofferproductmodel.dart';

class UserOfferProductController extends GetxController {
  final String offer_id;

  UserOfferProductController(this.offer_id);

  var isLoading = false.obs;
  var productList = <UserOfferProductModel>[].obs;
  var errorMessage = ''.obs;

  final box = GetStorage();

  @override
  void onInit() {
    super.onInit();
    fetchOfferProducts();
  }

  Future<void> fetchOfferProducts() async {
    try {
      isLoading(true);
      errorMessage('');

      final token = box.read('auth_token');

      final response = await http.post(
        Uri.parse(
          'https://rasma.astradevelops.in/e_shoppyy/public/api/merchant/offer-products',
        ),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },

        body: jsonEncode({
          'offer_id': offer_id.toString(),
        }),
      );

      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);

        if (decoded['status'] == 1) {
          final List data = decoded['data'] ?? [];
          productList.value =
              data.map((e) => UserOfferProductModel.fromJson(e)).toList();
        } else {
          errorMessage(decoded['message'] ?? 'Something went wrong');
          Get.snackbar('Error', errorMessage.value);
        }
      } else {
        errorMessage('Server error: ${response.statusCode}');
        Get.snackbar('Error', errorMessage.value);
      }
    } catch (e) {
      errorMessage('Failed to load offer products');
      Get.snackbar('Error', errorMessage.value);
    } finally {
      isLoading(false);
    }
  }
}