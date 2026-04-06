
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

import '../controller/admin_categorygetting_controller.dart';
import 'admin_categorieslist.dart';

class AdminEditCategoryController extends GetxController {
  // ── GetStorage auth ──────────────────────────────────────────────────────
  final _box = GetStorage();
  String get authToken => _box.read('auth_token') ?? '';

  // ── Observables ──────────────────────────────────────────────────────────
  final isLoading = false.obs;
  final isUpdating = false.obs;

  // Form
  final titleCtrl = TextEditingController();

  // Image
  final imageFile = Rxn<File>();
  String existingImageUrl = '';

  // Attributes (pre-filled from API, user can add/remove)
  final commonAttributes = <String>[].obs;
  final variantAttributes = <String>[].obs;

  // Category id set on init
  int categoryId = 0;

  // ── API base ─────────────────────────────────────────────────────────────
  static const _base = 'https://rasma.astradevelops.in/e_shoppyy/public/api';

  @override
  void onClose() {
    titleCtrl.dispose();
    super.onClose();
  }

  // ── Called from page ─────────────────────────────────────────────────────
  Future<void> init(int id) async {
    categoryId = id;
    await fetchCategory();
  }

  // ── Fetch & pre-fill ─────────────────────────────────────────────────────
  Future<void> fetchCategory() async {
    try {
      isLoading(true);
      final res = await http.post(
        Uri.parse('$_base/get-category'),
        headers: _headers(),
        body: jsonEncode({'category_id': categoryId}),
      );
      final body = jsonDecode(res.body);
      if (res.statusCode == 200 && body['status'] == true) {
        final data = body['data'];
        titleCtrl.text = data['name'] ?? '';
        existingImageUrl = data['image'] ?? '';
        commonAttributes.assignAll(
            List<String>.from(data['attributes']['common'] ?? []));
        variantAttributes.assignAll(
            List<String>.from(data['attributes']['variant'] ?? []));
      } else {
        _showError(body['message'] ?? 'Failed to fetch category');
      }
    } catch (e) {
      _showError('Network error: $e');
    } finally {
      isLoading(false);
    }
  }

  // ── Image picker ─────────────────────────────────────────────────────────
  Future<void> pickImage() async {
    final picked = await ImagePicker()
        .pickImage(source: ImageSource.gallery, imageQuality: 80);
    if (picked != null) imageFile.value = File(picked.path);
  }

  // ── Attribute helpers ─────────────────────────────────────────────────────
  void addCommon(String v) {
    if (!commonAttributes.contains(v)) commonAttributes.add(v);
  }

  void removeCommon(String v) => commonAttributes.remove(v);

  void addVariant(String v) {
    if (!variantAttributes.contains(v)) variantAttributes.add(v);
  }

  void removeVariant(String v) => variantAttributes.remove(v);

  // ── Submit update ─────────────────────────────────────────────────────────
  Future<void> submit() async {
    final name = titleCtrl.text.trim();
    if (name.isEmpty) {
      _showError('Category name is required');
      return;
    }

    try {
      isUpdating(true);

      final Map<String, dynamic> body = {
        'category_id': categoryId,
        'name': name,
        'common_attributes': commonAttributes.toList(),
        'variant_attributes': variantAttributes.toList(),
      };

      // Attach new image as base64 only if user picked one
      if (imageFile.value != null) {
        final bytes = await imageFile.value!.readAsBytes();
        final ext =
        imageFile.value!.path.split('.').last.toLowerCase();
        final mime = ext == 'png' ? 'image/png' : 'image/jpeg';
        body['image'] = 'data:$mime;base64,${base64Encode(bytes)}';
      }

      final res = await http.put(
        Uri.parse('$_base/update-category'),
        headers: _headers(),
        body: jsonEncode(body),
      );

      final resBody = jsonDecode(res.body);
      if (res.statusCode == 200 && resBody['status'] == true) {
        // Show success snackbar
        Get.snackbar(
          'Success',
          resBody['message'] ?? 'Category updated successfully',
          backgroundColor: Colors.green,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
          margin: const EdgeInsets.all(16),
          borderRadius: 10,
          duration: const Duration(seconds: 2),
          icon: const Icon(Icons.check_circle, color: Colors.white),
        );

        await Future.delayed(const Duration(milliseconds: 800));

        // Find the list controller and refresh it before going back
        if (Get.isRegistered<AdminCategoryListController>()) {
          Get.find<AdminCategoryListController>().fetchCategories();
        }

        // Go back to list page — passes result:true so list can also
        // react if needed (e.g. scroll-to-updated item in future)
        Get.off(AdminCategoryListPage());
        // Get.back(result: true);
      } else {
        _showError(resBody['message'] ?? 'Update failed');
      }
    } catch (e) {
      _showError('Network error: $e');
    } finally {
      isUpdating(false);
    }
  }

  // ── Helpers ───────────────────────────────────────────────────────────────
  Map<String, String> _headers() => {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
    'Authorization': 'Bearer $authToken',
  };

  void _showError(String msg) => Get.snackbar(
    'Error',
    msg,
    backgroundColor: Colors.red,
    colorText: Colors.white,
    snackPosition: SnackPosition.BOTTOM,
    margin: const EdgeInsets.all(16),
    borderRadius: 10,
  );
}