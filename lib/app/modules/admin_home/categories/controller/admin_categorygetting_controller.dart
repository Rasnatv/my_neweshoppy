
import 'dart:convert';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

import '../../../../data/errors/api_error.dart';
import '../../../../data/models/admin_categorymodel.dart';
import '../../../merchantlogin/widget/successwidget.dart';
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

    /// 🔐 TOKEN / ROLE CHECK (SAME LOGIC)
    if (token == null || token.toString().isEmpty || role != 3) {
      AppSnackbar.error("Please login as admin");
      Get.toNamed('/login');
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
          AppSnackbar.error(
              body['message'] ?? "Failed to load categories");
        }
      }

      /// ❌ USE API ERROR HANDLER
      else {
        AppSnackbar.error(ApiErrorHandler.handleResponse(response));
      }
    } catch (e) {
      AppSnackbar.error(ApiErrorHandler.handleException(e));
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> deleteCategory(int categoryId) async {
    try {
      final token = box.read('auth_token') ?? '';

      /// 🔐 TOKEN CHECK
      if (token.isEmpty) {
        AppSnackbar.error("Session expired. Please login again");
        Get.toNamed('/login');
        return;
      }

      final response = await http.delete(
        Uri.parse(
            'https://rasma.astradevelops.in/e_shoppyy/public/api/delete-category'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({'category_id': categoryId}),
      );

      final data = jsonDecode(response.body);

      if (data['status'] == true) {
        categories.removeWhere((c) => c.id == categoryId);
        AppSnackbar.success("Category deleted successfully");
      } else {
        AppSnackbar.error(data['message'] ?? 'Failed to delete');
      }
    } catch (e) {
      AppSnackbar.error(ApiErrorHandler.handleException(e));
    }
  }
}
