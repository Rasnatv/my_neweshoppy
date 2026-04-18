
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../../../routes/app_pages.dart';
import '../../../data/errors/api_error.dart';
import '../../merchantlogin/widget/successwidget.dart';

class CheckEmailOtpController extends GetxController {
  late final String email;
  late final int role;

  final List<TextEditingController> otpControllers =
  List.generate(6, (_) => TextEditingController());
  final List<FocusNode> focusNodes =
  List.generate(6, (_) => FocusNode());

  final isLoading = false.obs;

  // ✅ Guard flag — prevents using controllers after dispose
  bool _isDisposed = false;

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments as Map<String, dynamic>;
    email = args['email'];
    role = args['role'] ?? 1;
  }

  String get otp => otpControllers.map((e) => e.text).join();

  void onOtpChanged(String val, int index) {
    if (_isDisposed) return; // ✅ guard

    if (val.isNotEmpty && index < 5) {
      if (!_isDisposed && focusNodes[index + 1].canRequestFocus) {
        focusNodes[index + 1].requestFocus();
      }
    } else if (val.isEmpty && index > 0) {
      if (!_isDisposed && focusNodes[index - 1].canRequestFocus) {
        focusNodes[index - 1].requestFocus();
      }
    }
  }

  // ✅ Unfocus everything safely before any async work or navigation
  void _dismissKeyboard() {
    if (_isDisposed) return;
    for (var f in focusNodes) {
      if (f.hasFocus) f.unfocus();
    }
  }

  Future<void> verifyOtp() async {
    if (_isDisposed) return;

    if (otp.length != 6) {
      AppSnackbar.error("Please enter valid OTP");
      return;
    }

    // ✅ Dismiss keyboard BEFORE async gap
    _dismissKeyboard();

    try {
      isLoading.value = true;

      final response = await http.post(
        Uri.parse(
          "https://rasma.astradevelops.in/e_shoppyy/public/api/verify-otp",
        ),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "email": email,
          "otp": otp,
          "role": role,
        }),
      );

      if (_isDisposed) return; // ✅ check after await

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        if (data["status"] == 1 || data["status"] == "1") {
          AppSnackbar.success("OTP verified successfully");

          Get.toNamed(
            Routes.NewPSWD,
            arguments: {
              "email": email,
              "otp": otp,
              "role": role,
            },
          );
        } else {
          AppSnackbar.error(data["message"] ?? "Invalid OTP");
        }
      } else {
        AppSnackbar.error(ApiErrorHandler.handleResponse(response));
      }
    } catch (e) {
      if (!_isDisposed) {
        AppSnackbar.error(ApiErrorHandler.handleException(e));
      }
    } finally {
      if (!_isDisposed) isLoading.value = false;
    }
  }

  Future<void> resendOtp() async {
    if (_isDisposed) return;

    _dismissKeyboard(); // ✅

    try {
      isLoading.value = true;

      final response = await http.post(
        Uri.parse(
          "https://rasma.astradevelops.in/e_shoppyy/public/api/forgot-password",
        ),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "email": email,
          "role": role,
        }),
      );

      if (_isDisposed) return; // ✅ check after await

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        if (data["status"] == 1 || data["status"] == "1") {
          AppSnackbar.success("OTP resent successfully");
        } else {
          AppSnackbar.error(data["message"] ?? "Failed to resend OTP");
        }
      } else {
        AppSnackbar.error(ApiErrorHandler.handleResponse(response));
      }
    } catch (e) {
      if (!_isDisposed) {
        AppSnackbar.error(ApiErrorHandler.handleException(e));
      }
    } finally {
      if (!_isDisposed) isLoading.value = false;
    }
  }

  @override
  void onClose() {
    _isDisposed = true; // ✅ Set flag FIRST

    // ✅ Unfocus all nodes before disposing
    for (var f in focusNodes) {
      if (f.hasFocus) f.unfocus();
    }

    // ✅ Small delay allows Flutter focus system to settle
    // before controllers are actually disposed
    Future.microtask(() {
      for (var c in otpControllers) {
        c.dispose();
      }
      for (var f in focusNodes) {
        f.dispose();
      }
    });

    super.onClose();
  }
}