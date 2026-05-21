
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

import '../../../../data/errors/api_error.dart';
import '../../../merchantlogin/widget/successwidget.dart';
import '../controller/admin_categorygetting_controller.dart';
import 'admin_categorieslist.dart';

class AdminEditCategoryController extends GetxController {
  final _box = GetStorage();

  // ✅ Single getter — always fresh, never stale
  String get _token => _box.read('auth_token') ?? '';

  final isLoading  = false.obs;
  final isUpdating = false.obs;

  final titleCtrl = TextEditingController();

  final imageFile = Rxn<File>();
  String existingImageUrl = '';

  final commonAttributes = <String>[].obs;
  final variantAttributes = <String>[].obs;

  int categoryId = 0;

  static const _base = 'https://eshoppy.co.in/api';

  @override
  void onClose() {
    titleCtrl.dispose();
    super.onClose();
  }

  Future<void> init(int id) async {
    categoryId = id;
    await fetchCategory();
  }


  Future<void> fetchCategory() async {

    try {
      isLoading(true);

      final res = await http.post(
        Uri.parse('$_base/get-category'),
        headers: _headers(),
        body: jsonEncode({'category_id': categoryId}),
      );

      if (res.statusCode == 200) {
        final body = jsonDecode(res.body);

        if (body['status'] == true && body['data'] != null) {
          final data = body['data'];

          titleCtrl.text   = data['name'] ?? '';
          existingImageUrl = data['image'] ?? '';

          commonAttributes.assignAll(
              List<String>.from(data['attributes']?['common'] ?? []));
          variantAttributes.assignAll(
              List<String>.from(data['attributes']?['variant'] ?? []));
        } else {
          AppSnackbar.error(body['message'] ?? 'Failed to fetch category');
        }
      } else {
        // ✅ 401 → handleUnauthorized fires inside handleResponse
        //    returns '' for 401, so guard prevents blank snackbar
        final msg = ApiErrorHandler.handleResponse(res);
        if (msg.isNotEmpty) AppSnackbar.error(msg);
      }
    } catch (e) {
      // ✅ SocketException returns '' — guard prevents blank snackbar
      final msg = ApiErrorHandler.handleException(e);
      if (msg.isNotEmpty) AppSnackbar.error(msg);
    } finally {
      isLoading(false);
    }
  }

  // ── IMAGE PICK ─────────────────────────────────────────────────────────────
  Future<void> pickImage() async {
    try {
      final picked = await ImagePicker().pickImage(
        source: ImageSource.gallery,
        imageQuality: 80,
      );

      if (picked == null) return;
      imageFile.value = File(picked.path);
    } catch (e) {
      AppSnackbar.error("Image picking failed");
    }
  }

  // ── ATTRIBUTE HELPERS ──────────────────────────────────────────────────────
  void addCommon(String v) {
    if (!commonAttributes.contains(v)) commonAttributes.add(v);
  }

  void removeCommon(String v) => commonAttributes.remove(v);

  void addVariant(String v) {
    if (!variantAttributes.contains(v)) variantAttributes.add(v);
  }

  void removeVariant(String v) => variantAttributes.remove(v);

  // ── SUBMIT UPDATE ──────────────────────────────────────────────────────────
  Future<void> submit() async {

    final name = titleCtrl.text.trim();
    if (name.isEmpty) {
      AppSnackbar.warning('Category name is required');
      return;
    }

    try {
      isUpdating(true);

      final Map<String, dynamic> body = {
        'category_id'        : categoryId,
        'name'               : name,
        'common_attributes'  : commonAttributes.toList(),
        'variant_attributes' : variantAttributes.toList(),
      };

      if (imageFile.value != null) {
        final bytes = await imageFile.value!.readAsBytes();
        final ext   = imageFile.value!.path.split('.').last.toLowerCase();
        final mime  = ext == 'png' ? 'image/png' : 'image/jpeg';
        body['image'] = 'data:$mime;base64,${base64Encode(bytes)}';
      }

      final res = await http.put(
        Uri.parse('$_base/update-category'),
        headers: _headers(),
        body: jsonEncode(body),
      );

      if (res.statusCode == 200) {
        final resBody = jsonDecode(res.body);

        if (resBody['status'] == true) {
          AppSnackbar.success(resBody['message'] ?? 'Category updated successfully');

          await Future.delayed(const Duration(milliseconds: 800));

          if (Get.isRegistered<AdminCategoryListController>()) {
            Get.find<AdminCategoryListController>().fetchCategories();
          }

          Get.off(AdminCategoryListPage());
        } else {
          AppSnackbar.error(resBody['message'] ?? 'Update failed');
        }
      } else {
        // ✅ 401 → handleUnauthorized fires inside handleResponse
        final msg = ApiErrorHandler.handleResponse(res);
        if (msg.isNotEmpty) AppSnackbar.error(msg);
      }
    } catch (e) {
      final msg = ApiErrorHandler.handleException(e);
      if (msg.isNotEmpty) AppSnackbar.error(msg);
    } finally {
      isUpdating(false);
    }
  }

  // ── HEADERS ────────────────────────────────────────────────────────────────
  Map<String, String> _headers() => {
    'Content-Type' : 'application/json',
    'Accept'       : 'application/json',
    'Authorization': 'Bearer $_token',
  };
}