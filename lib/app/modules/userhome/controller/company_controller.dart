
import 'dart:convert';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

import '../../../data/errors/api_error.dart';
import '../../../data/models/categoryshoplistmodel.dart';
import '../../merchantlogin/widget/successwidget.dart';

class CompanyController extends GetxController {
  final box = GetStorage();

  final String api =
      "https://rasma.astradevelops.in/e_shoppyy/public/api/user/shops-by-category";

  var isLoading = false.obs;
  var shops = <ShoplistModel>[].obs;

  Future<void> fetchShopsByCategory(int categoryId) async {
    final token = box.read("auth_token");
    if (token == null) return;

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

        shops.value =
            list.map((e) => ShoplistModel.fromJson(e)).toList();
      } else {
        shops.clear();

        // ✅ USE YOUR ERROR HANDLER
        final errorMessage = ApiErrorHandler.handleResponse(response);

        // ✅ SHOW YOUR CUSTOM SNACKBAR
        AppSnackbar.error(errorMessage);
      }
    } catch (e) {
      shops.clear();

      // ✅ HANDLE EXCEPTIONS (NO INTERNET, ETC)
      final errorMessage = ApiErrorHandler.handleException(e);

      AppSnackbar.error(errorMessage);
    } finally {
      isLoading.value = false;
    }
  }

  void clearShops() {
    shops.clear();
  }
}