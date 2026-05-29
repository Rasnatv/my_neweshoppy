import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

import '../../merchantlogin/widget/successwidget.dart';
import '../../userlogin/view/login.dart'; // your AppSnackbar & LoginPageView

class DeleteUserAccountController extends GetxController {
  final GetStorage box = GetStorage();
  final RxBool isLoading = false.obs;

  static const String _deleteUrl =
      'https://eshoppy.co.in/api/user/delete-account';

  Future<void> deleteAccount() async {
    final String? token = box.read<String?>('auth_token');

    if (token == null || token.isEmpty) {
      Get.offAll(() => const LoginPageView());
      return;
    }

    isLoading.value = true;

    try {
      final response = await http.delete(
        Uri.parse(_deleteUrl),
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'reason': 'No longer using app',
          'confirmation': 'DELETE',
        }),
      ).timeout(
        const Duration(seconds: 30),
        onTimeout: () =>
        throw Exception("Connection timed out. Please try again."),
      );

      final body = jsonDecode(response.body);

      if (response.statusCode == 200 && body['success'] == true) {
        await _clearAndLogout(token);
      } else {
        AppSnackbar.error(body['message'] ?? 'Failed to delete account.');
      }
    } catch (e) {
      debugPrint("Delete user account error: $e");
      AppSnackbar.error(
        e.toString().contains("timed out")
            ? "Connection timed out. Please try again."
            : "Something went wrong. Please try again.",
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> _clearAndLogout(String token) async {
    // Clear token-specific location cache
    await box.remove('state_$token');
    await box.remove('district_$token');
    await box.remove('main_location_$token');

    await box.remove('auth_token');
    await box.remove('is_logged_in');
    await box.remove('role');
    await box.remove('user_data');
    await box.remove('is_guest');
    await box.remove('just_logged_in');

    debugPrint("✅ User account deleted. Storage cleared.");

    // ✅ Close dialog + go to login
    Get.back(); // close confirmation dialog
    AppSnackbar.success('Account deleted successfully.');

    await Future.delayed(const Duration(milliseconds: 300));
    Get.offAll(
          () => const LoginPageView(),
      transition: Transition.fadeIn,
      duration: const Duration(milliseconds: 400),
    );
  }

}