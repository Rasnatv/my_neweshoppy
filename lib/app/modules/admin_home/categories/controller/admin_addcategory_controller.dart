
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

import '../../../../data/errors/api_error.dart';
import '../../../merchantlogin/widget/successwidget.dart';

class AdminCategoryController extends GetxController {
  final titleCtrl = TextEditingController();

  final imageFile = Rx<File?>(null);

  final commonAttributes = <String>[].obs;
  final variantAttributes = <String>[].obs;

  final isLoading = false.obs;
  final box = GetStorage();

  final String apiUrl =
      "https://eshoppy.co.in/api/addcategories";

  /// PICK IMAGE
  Future<void> pickImage() async {
    final picked =
    await ImagePicker().pickImage(source: ImageSource.gallery);
    if (picked != null) {
      imageFile.value = File(picked.path);
    }
  }

  /// ADD ATTRIBUTES
  void addCommon(String value) {
    if (value.isNotEmpty && !commonAttributes.contains(value)) {
      commonAttributes.add(value);
    }
  }

  void addVariant(String value) {
    if (value.isNotEmpty && !variantAttributes.contains(value)) {
      variantAttributes.add(value);
    }
  }

  void removeCommon(String value) => commonAttributes.remove(value);
  void removeVariant(String value) => variantAttributes.remove(value);

  /// BASE64 IMAGE
  String _toBase64(File file) {
    final bytes = file.readAsBytesSync();
    return "data:image/jpeg;base64,${base64Encode(bytes)}";
  }

  /// SUBMIT CATEGORY
  Future<void> submit() async {
    if (titleCtrl.text.trim().isEmpty) {
      _error("Category name required");
      return;
    }

    if (imageFile.value == null) {
      _error("Category image required");
      return;
    }

    if (commonAttributes.isEmpty && variantAttributes.isEmpty) {
      _error("Add at least one attribute");
      return;
    }

    final token = box.read("auth_token");

    /// 🔐 TOKEN CHECK
    if (token == null || token.toString().isEmpty) {
      AppSnackbar.error("Session expired. Please login again");
      Get.offAllNamed('/login');
      return;
    }

    isLoading.value = true;

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          "Authorization": "Bearer $token",
          "Accept": "application/json",
          "Content-Type": "application/json",
        },
        body: jsonEncode({
          "name": titleCtrl.text.trim(),
          "image": _toBase64(imageFile.value!),
          "common_attributes": commonAttributes,
          "variant_attributes": variantAttributes,
        }),
      );

      final body = jsonDecode(response.body);

      if (response.statusCode == 201 && body["status"] == true) {
        AppSnackbar.success(body["message"] ?? "Success");
        clearForm();
      } else {
        /// ❌ USE API ERROR HANDLER
        if (response.statusCode != 201) {
          AppSnackbar.error(ApiErrorHandler.handleResponse(response));
        } else {
          _error(body["message"] ?? "Something went wrong");
        }
      }
    } catch (e) {
      AppSnackbar.error(ApiErrorHandler.handleException(e));
    } finally {
      isLoading.value = false;
    }
  }

  void clearForm() {
    titleCtrl.clear();
    imageFile.value = null;
    commonAttributes.clear();
    variantAttributes.clear();
  }

  void _error(String msg) {
    AppSnackbar.error(msg);
  }

  @override
  void onClose() {
    titleCtrl.dispose();
    super.onClose();
  }
}