
import 'dart:convert';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

import '../../../data/errors/api_error.dart';
import '../../landingview/controller/landing_controller.dart';
import '../../landingview/view/landing_screen.dart';
import '../../merchantlogin/widget/successwidget.dart'; // ← adjust path

class ChangePasswordController extends GetxController {
  final box       = GetStorage();
  final isLoading = false.obs;

  String get _token => box.read('auth_token') ?? '';

  Future<void> changePassword({
    required String oldPassword,
    required String newPassword,
    required String confirmPassword,
  }) async {

    try {
      isLoading.value = true;

      final response = await http.post(
        Uri.parse(
          'https://eshoppy.co.in/api/change-password',
        ),
        headers: {
          'Authorization': 'Bearer $_token',
          'Accept': 'application/json',
        },
        body: {
          'current_password': oldPassword,
          'new_password':     newPassword,
          'confirm_password': confirmPassword,
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        if (data['status'] == "1") {
          AppSnackbar.success(
            data['message']?.toString().isNotEmpty == true
                ? data['message'].toString()
                : 'Password changed successfully.',
          );
          Get.offAll(() => LandingView(), arguments: LandingItem.Profile);
        } else {
          AppSnackbar.error(
            data['message']?.toString().isNotEmpty == true
                ? data['message'].toString()
                : 'Password change failed. Please try again.',
          );
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