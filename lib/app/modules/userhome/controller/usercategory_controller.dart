
import 'dart:convert';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

import '../../../data/errors/api_error.dart';
import '../../../data/models/user_category model.dart';
import '../../merchantlogin/widget/successwidget.dart';

class UserCategoryController extends GetxController {
  final box = GetStorage();

  final String api =
      "https://eshoppy.co.in/api/usercategoriesget";

  var isLoading = false.obs;
  var categories = <UserCategoryModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    _fetchFromStorageIfAvailable();
  }

  Future<void> refresh() async {
    await _fetchFromStorageIfAvailable();
  }

  Future<void> _fetchFromStorageIfAvailable() async {
    final token = box.read('auth_token');

    final state        = box.read('state_$token') ?? '';
    final district     = box.read('district_$token') ?? '';
    final mainLocation = box.read('main_location_$token') ?? '';

    // ✅ Fetch when at least state + district is selected
    if (state.isEmpty || district.isEmpty) {
      categories.clear();
      return;
    }

    await fetchCategories(
      state: state,
      district: district,
      mainLocation: mainLocation, // may be empty — backend filters accordingly
    );
  }

  Future<void> fetchCategories({
    required String state,
    required String district,
    required String mainLocation,
  }) async {
    if (isLoading.value) return;

    final token = box.read("auth_token");
    if (token == null) return;

    // ✅ Only require state + district (mainLocation is optional)
    if (state.isEmpty || district.isEmpty) {
      categories.clear();
      return;
    }

    try {
      isLoading.value = true;

      final res = await http.post(
        Uri.parse(api),
        headers: {
          "Accept": "application/json",
          "Authorization": "Bearer $token",
        },
        body: {
          "state": state,
          "district": district,
          "main_location": mainLocation, // empty string when not selected
        },
      );

      if (res.statusCode == 200) {
        final decoded = json.decode(res.body);
        final List list = decoded['data'] ?? [];
        final newCategories =
        list.map((e) => UserCategoryModel.fromJson(e)).toList();

        if (newCategories.isNotEmpty) {
          categories.value = newCategories;
        }
      } else {
        AppSnackbar.error(ApiErrorHandler.handleResponse(res));
      }
    } catch (e) {
      AppSnackbar.error(ApiErrorHandler.handleException(e));
    } finally {
      isLoading.value = false;
    }
  }
}