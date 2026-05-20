import 'dart:convert';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

import '../../../data/errors/api_error.dart';
import '../../../data/models/categoryshoplistmodel.dart';
import '../../merchantlogin/widget/successwidget.dart';

class UserShoplistController extends GetxController {
  final box = GetStorage();

  final String api =
      "https://eshoppy.co.in/api/user/shops-by-category";

  var isLoading = false.obs;
  var shops = <ShoplistModel>[].obs;

  Future<void> fetchShopsByCategory(int categoryId) async {
    final token = box.read("auth_token");

    try {
      isLoading.value = true;

      final response = await http.post(
        Uri.parse(api),
        headers: {
          "Accept": "application/json",
          "Authorization": "Bearer $token",
        },
        body: {
          "category_id": categoryId.toString(),
        },
      );

      if (response.statusCode == 200) {
        final decoded = json.decode(response.body);
        final List list = decoded['data'] ?? [];

        shops.value = list.map((e) => ShoplistModel.fromJson(e)).toList();
      } else {
        shops.clear();

        // ✅ API ERROR HANDLER
        final errorMessage = ApiErrorHandler.handleResponse(response);
        AppSnackbar.error(errorMessage);
      }
    } catch (e) {
      shops.clear();

      // ✅ EXCEPTION HANDLER
      final errorMessage = ApiErrorHandler.handleException(e);
      AppSnackbar.error(errorMessage);

      print("Shop fetch error: $e");
    } finally {
      isLoading.value = false;
    }
  }

  void clearShops() {
    shops.clear();
  }
}