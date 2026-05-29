//
import 'dart:convert';
import 'package:entenaadu/app/modules/userhome/controller/userwithshopaboutmodel.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:get_storage/get_storage.dart';

import '../../../data/errors/api_error.dart';
import '../../merchantlogin/widget/successwidget.dart';
import '../widget/guestrole.dart';

class MerchantAboutController extends GetxController {
  final isLoading = false.obs;
  final about = Rxn<MerchantAboutModel>();

  final box = GetStorage();

  // ── Optional Auth Header ──────────────────────────────────
  Map<String, String> getHeaders() {
    final token = box.read('auth_token');

    Map<String, String> headers = {
      "Accept": "application/json",
    };

    // Add token only if logged in
    if (token != null &&
        token.toString().isNotEmpty &&
        !GuestService.isGuest) {
      headers["Authorization"] = "Bearer $token";
    }

    return headers;
  }

  Future<void> loadAbout(int merchantId) async {
    try {
      isLoading.value = true;

      final response = await http.post(
        Uri.parse(
          "https://eshoppy.co.in/api/aboutusers",
        ),
        headers: getHeaders(),
        body: {
          "merchant_id": merchantId.toString(),
        },
      );

      final jsonData = json.decode(response.body);

      if (response.statusCode == 200) {
        if (jsonData['status'] == "1") {
          about.value =
              MerchantAboutModel.fromJson(jsonData['data']);
        } else {
          final message =
              jsonData['message'] ??
                  "Something went wrong";

          AppSnackbar.error(message);
        }
      } else {
        final errorMessage =
        ApiErrorHandler.handleResponse(response);

        AppSnackbar.error(errorMessage);
      }
    } catch (e) {
      final errorMessage =
      ApiErrorHandler.handleException(e);

      AppSnackbar.error(errorMessage);
    } finally {
      isLoading.value = false;
    }
  }
}