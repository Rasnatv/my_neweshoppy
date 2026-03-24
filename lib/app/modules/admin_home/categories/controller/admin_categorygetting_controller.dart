
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

import '../../../../data/models/admin_categorymodel.dart';
import '../../../userhome/view/userhome.dart';

class AdminCategoryListController extends GetxController {
  var categories = <AdminCategoryModel>[].obs;
  var isLoading = false.obs;

  final box = GetStorage();

  final String apiUrl =
      "https://rasma.astradevelops.in/e_shoppyy/public/api/categories";

  @override
  void onInit() {
    super.onInit();
    fetchCategories();
  }

  Future<void> fetchCategories() async {
    isLoading.value = true;

    final token = box.read("auth_token");
    final role = box.read("role");

    if (token == null || token.isEmpty || role != 3) {
      Get.snackbar("Unauthorized", "Please login as admin");
      Get.offAll(() => Userhome());
      isLoading.value = false;
      return;
    }

    try {
      final response = await http.get(
        Uri.parse(apiUrl),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final body = jsonDecode(response.body);

        if (body['status'] == true) {
          categories.value = List<AdminCategoryModel>.from(
            body['data'].map((e) => AdminCategoryModel.fromJson(e)),
          );
        } else {
          Get.snackbar("Error", body['message'] ?? "Failed to load categories");
        }
      } else if (response.statusCode == 401) {
        box.erase();
        Get.snackbar("Session Expired", "Please login again");
        Get.offAll(() => Userhome());
      } else {
        Get.snackbar("Error", "Server Error ${response.statusCode}");
      }
    } catch (e) {
      Get.snackbar("Error", e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> deleteCategory(int categoryId) async {
    try {
      final box = GetStorage();
      final token = box.read('auth_token') ?? '';

      final response = await http.delete(
        Uri.parse('https://rasma.astradevelops.in/e_shoppyy/public/api/delete-category'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({'category_id': categoryId}),
      );

      final data = jsonDecode(response.body);

      if (data['status'] == true) {
        categories.removeWhere((c) => c.id == categoryId);
        Get.snackbar('Success', 'Category deleted successfully',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.green,
            colorText: Colors.white);
      } else {
        Get.snackbar('Error', data['message'] ?? 'Failed to delete',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.red,
            colorText: Colors.white);
      }
    } catch (e) {
      Get.snackbar('Error', 'Something went wrong',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white);
    }
  }

}
