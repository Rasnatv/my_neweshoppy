
import 'dart:convert';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

import '../../../data/errors/api_error.dart';
import '../../../data/models/user_category model.dart';
import '../../merchantlogin/widget/successwidget.dart';

class UserCategoryController extends GetxController {
  final box = GetStorage();

  final String api = "https://eshoppy.co.in/api/usercategoriesget";

  var isLoading = false.obs;
  var categories = <UserCategoryModel>[].obs;

  // ── Storage key — guest uses 'guest', logged-in uses token ───────────────
  String get _storageKey => box.read('auth_token') ?? 'guest';

  @override
  void onInit() {
    super.onInit();
    _fetchFromStorageIfAvailable();
  }

  Future<void> refresh() async {
    await _fetchFromStorageIfAvailable();
  }

  Future<void> _fetchFromStorageIfAvailable() async {
    final state        = box.read('state_$_storageKey') ?? '';
    final district     = box.read('district_$_storageKey') ?? '';
    final mainLocation = box.read('main_location_$_storageKey') ?? '';

    if (state.isEmpty || district.isEmpty) {
      categories.clear();
      return;
    }

    await fetchCategories(
      state: state,
      district: district,
      mainLocation: mainLocation,
    );
  }

  Future<void> fetchCategories({
    required String state,
    required String district,
    required String mainLocation,
  }) async {
    if (isLoading.value) return;
    if (state.isEmpty || district.isEmpty) {
      categories.clear();
      return;
    }

    final token = box.read<String?>('auth_token');

    try {
      isLoading.value = true;

      final res = await http.post(
        Uri.parse(api),
        headers: {
          "Accept": "application/json",
          // Send token only when available — guests call without it
          if (token != null && token.isNotEmpty)
            "Authorization": "Bearer $token",
        },
        body: {
          "state": state,
          "district": district,
          "main_location": mainLocation,
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