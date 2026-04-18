import 'dart:convert';
import 'package:eshoppy/app/modules/userhome/controller/userwithshopaboutmodel.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:get_storage/get_storage.dart';
import '../../../data/errors/api_error.dart';
import '../../merchantlogin/widget/successwidget.dart';

class MerchantAboutController extends GetxController {
  final isLoading = false.obs;
  final about = Rxn<MerchantAboutModel>();

  final box = GetStorage();

  Future<void> loadAbout(int merchantId) async {
    try {
      isLoading.value = true;

      final token = box.read('auth_token');

      final response = await http.post(
        Uri.parse(
          "https://rasma.astradevelops.in/e_shoppyy/public/api/aboutusers",
        ),
        headers: {
          "Authorization": "Bearer $token",
          "Accept": "application/json",
        },
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
          // ✅ LOGICAL ERROR (status != 1)
          final message =
              jsonData['message'] ?? "Something went wrong";
          AppSnackbar.error(message);
        }
      } else {
        // ✅ API ERROR HANDLER
        final errorMessage = ApiErrorHandler.handleResponse(response);
        AppSnackbar.error(errorMessage);
      }
    } catch (e) {
      // ✅ EXCEPTION HANDLER
      final errorMessage = ApiErrorHandler.handleException(e);
      AppSnackbar.error(errorMessage);
    } finally {
      isLoading.value = false;
    }
  }
}