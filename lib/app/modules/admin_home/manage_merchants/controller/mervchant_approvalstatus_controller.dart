import 'dart:convert';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

import '../../../../data/errors/api_error.dart';
import '../../../../data/models/merchant_model.dart';
import '../../../merchantlogin/widget/successwidget.dart';

class AdminMerchantController extends GetxController {
  final box = GetStorage();

  var merchants = <AdminMerchant>[].obs;
  var isLoading = false.obs;


  Map<String, String> _headers() {
    final token = box.read("auth_token") ?? '';
    return {
      "Accept": "application/json",
      "Authorization": "Bearer $token",
    };
  }

  @override
  void onInit() {
    super.onInit();
    fetchMerchants();
  }

  /// ---------------- FETCH MERCHANTS ----------------
  Future<void> fetchMerchants() async {

    isLoading.value = true;

    try {
      final response = await http.get(
        Uri.parse(
          "https://eshoppy.co.in/api/admin/merchants",
        ),
        headers: _headers(),
      );

      if (response.statusCode == 200) {
        final body = jsonDecode(response.body);

        if (body['status'] == true) {
          merchants.value = (body['data'] as List)
              .map((e) => AdminMerchant.fromJson(e))
              .toList();
        } else {
          AppSnackbar.error(body['message'] ?? "Failed to load merchants");
        }
      } else {
        AppSnackbar.error(ApiErrorHandler.handleResponse(response));
      }
    } catch (e) {
      AppSnackbar.error(ApiErrorHandler.handleException(e));
    } finally {
      isLoading.value = false;
    }
  }
}