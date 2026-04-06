
import 'dart:convert';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import '../../landingview/controller/landing_controller.dart';
import '../../landingview/view/landing_screen.dart';
import '../../merchantlogin/widget/successwidget.dart';
import '../view/profile_view.dart';

class ChangePasswordController extends GetxController {
  final box = GetStorage();
  final isLoading = false.obs;

  Future<void> changePassword({
    required String oldPassword,
    required String newPassword,
    required String confirmPassword,
  }) async {
    try {
      isLoading.value = true;

      final token = box.read('auth_token');

      final response = await http.post(
        Uri.parse(
          'https://rasma.astradevelops.in/e_shoppyy/public/api/change-password',
        ),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
        body: {
          'current_password': oldPassword,
          'new_password': newPassword,
          'confirm_password': confirmPassword,
        },
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200 && data['status'] == "1") {
        AppSnackbar.success(data['message']); // ✅
        Get.offAll(() => LandingView(), arguments: LandingItem.Profile);
      } else {
        AppSnackbar.error(data['message'] ?? "Password change failed"); // ✅
      }
    } catch (e) {
      AppSnackbar.error("Something went wrong"); // ✅
    } finally {
      isLoading.value = false;
    }
  }
}