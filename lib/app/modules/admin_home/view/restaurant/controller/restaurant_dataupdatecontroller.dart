
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

import '../../../../../data/errors/api_error.dart';
import '../../../../merchantlogin/widget/successwidget.dart';

class AdminRestaurantUpdateController extends GetxController {
  final restaurantNameController = TextEditingController();
  final ownerNameController = TextEditingController();
  final addressController = TextEditingController();
  final phoneController = TextEditingController();
  final emailController = TextEditingController();
  final websiteController = TextEditingController();
  final whatsappController = TextEditingController();
  final facebookController = TextEditingController();
  final instagramController = TextEditingController();
  final upiIdController = TextEditingController();

  var isUpdating = false.obs;

  var restaurantImage = Rxn<File>();
  var restaurantImageUrl = ''.obs;

  var qrImage = Rxn<File>();
  var qrImageUrl = ''.obs;

  var additionalImages = <File>[].obs;
  var existingAdditionalImageUrls = <String>[].obs;

  // ✅ Track whether user explicitly modified additional images
  // (removed existing OR added new ones)
  var additionalImagesModified = false.obs;

  final box = GetStorage();
  final ImagePicker _picker = ImagePicker();

  String? restaurantId;
  bool _isDataLoaded = false;

  // ── Validators ────────────────────────────────────────────────────────────

  String? validateUrl(String? value, String fieldName) {
    if (value == null || value.trim().isEmpty) return null;
    final uri = Uri.tryParse(value.trim());
    if (uri == null || !uri.hasScheme || !uri.scheme.startsWith('http')) {
      return '$fieldName must start with http:// or https://';
    }
    return null;
  }

  String? validateWebsiteUrl(String? value) => validateUrl(value, 'Website');

  String? validateFacebookUrl(String? value) {
    if (value == null || value.trim().isEmpty) return null;
    final err = validateUrl(value, 'Facebook');
    if (err != null) return err;
    if (!value.trim().toLowerCase().contains('facebook.com')) {
      return 'Enter a valid Facebook URL (facebook.com/...)';
    }
    return null;
  }

  String? validateInstagramUrl(String? value) {
    if (value == null || value.trim().isEmpty) return null;
    final v = value.trim();
    if (v.startsWith('@')) return null;
    final err = validateUrl(v, 'Instagram');
    if (err != null) return err;
    if (!v.toLowerCase().contains('instagram.com')) {
      return 'Enter a valid Instagram URL (instagram.com/...) or @handle';
    }
    return null;
  }

  String? validateWhatsapp(String? value) {
    if (value == null || value.trim().isEmpty) return null;
    if (value.trim().length != 10) {
      return 'WhatsApp number must be 10 digits';
    }
    return null;
  }

  // ── Form Key ──────────────────────────────────────────────────────────────
  final formKey = GlobalKey<FormState>();

  @override
  void onClose() {
    restaurantNameController.dispose();
    ownerNameController.dispose();
    addressController.dispose();
    phoneController.dispose();
    emailController.dispose();
    websiteController.dispose();
    whatsappController.dispose();
    facebookController.dispose();
    instagramController.dispose();
    upiIdController.dispose();
    super.onClose();
  }

  // ── Load Data ─────────────────────────────────────────────────────────────
  void loadRestaurantData(Map<String, dynamic> data) {
    if (_isDataLoaded) return;
    _isDataLoaded = true;

    restaurantNameController.text = data['restaurant_name'] ?? '';
    ownerNameController.text = data['owner_name'] ?? '';
    addressController.text = data['address'] ?? '';
    phoneController.text = data['phone'] ?? '';
    emailController.text = data['email'] ?? '';
    websiteController.text = data['website'] ?? '';
    whatsappController.text = data['whatsapp'] ?? '';
    facebookController.text = data['facebook_link'] ?? '';
    instagramController.text = data['instagram_link'] ?? '';
    upiIdController.text = data['upi_id'] ?? '';

    restaurantImageUrl.value = data['restaurant_image'] ?? '';
    qrImageUrl.value = data['qr_code'] ?? '';

    // ✅ FIX: Robust additional images parsing
    // API can return:
    //   ["https://..."]  → valid URLs, keep them
    //   [{}]             → empty objects, skip (treat as no images)
    //   []               → empty array, no images
    //   null             → no images
    if (data['additional_images'] != null) {
      final raw = data['additional_images'] as List;
      final parsed = <String>[];

      for (final item in raw) {
        if (item is String) {
          final trimmed = item.trim();
          if (trimmed.isNotEmpty && trimmed.startsWith('http')) {
            parsed.add(trimmed);
          }
        } else if (item is Map && item.isNotEmpty) {
          // Handle object formats like {"url":"..."} {"image":"..."} etc.
          final url = (item['url'] ??
              item['image'] ??
              item['image_url'] ??
              item['path'] ??
              item['src'] ??
              item['file'] ??
              '')
              ?.toString()
              .trim();
          if (url != null && url.isNotEmpty) {
            if (url.startsWith('http')) {
              parsed.add(url);
            } else {
              parsed.add("https://eshoppy.co.in/$url");
            }
          }
        }
        // Empty {} or null items are silently skipped ✅
      }

      existingAdditionalImageUrls.value = parsed;
      debugPrint("✅ Loaded ${parsed.length} additional images: $parsed");
    }
  }

  // ── Image Pickers ─────────────────────────────────────────────────────────
  Future<void> pickRestaurantImage() async {
    final file = await _picker.pickImage(source: ImageSource.gallery);
    if (file != null) restaurantImage.value = File(file.path);
  }

  Future<void> pickQrImage() async {
    final file = await _picker.pickImage(source: ImageSource.gallery);
    if (file != null) qrImage.value = File(file.path);
  }

  Future<void> pickAdditionalImages() async {
    final files = await _picker.pickMultiImage();
    if (files.isNotEmpty) {
      additionalImages.addAll(files.map((e) => File(e.path)));
      additionalImagesModified.value = true; // ✅ Mark as modified
    }
  }

  void removeAdditionalImage(int i) {
    additionalImages.removeAt(i);
    additionalImagesModified.value = true; // ✅ Mark as modified
  }

  void removeExistingAdditionalImage(int i) {
    existingAdditionalImageUrls.removeAt(i);
    additionalImagesModified.value = true; // ✅ Mark as modified
  }

  // ── Update ────────────────────────────────────────────────────────────────
  Future<void> updateRestaurant() async {
    if (!(formKey.currentState?.validate() ?? false)) return;

    try {
      isUpdating.value = true;

      final token = box.read("auth_token");
      final url = Uri.parse(
          "https://eshoppy.co.in/api/admin/restaurant/update");

      final Map<String, dynamic> body = {};

      // ── Text Fields ──────────────────────────────────────────────────────
      body['restaurant_id'] = restaurantId ?? '';
      body['restaurant_name'] = restaurantNameController.text.trim();
      body['owner_name'] = ownerNameController.text.trim();
      body['address'] = addressController.text.trim();
      body['phone'] = phoneController.text.trim();
      body['email'] = emailController.text.trim();
      body['website'] = websiteController.text.trim();
      body['whatsapp'] = whatsappController.text.trim();
      body['facebook_link'] = facebookController.text.trim();
      body['instagram_link'] = instagramController.text.trim();
      body['upi_id'] = upiIdController.text.trim();

      // ── Main Restaurant Image ────────────────────────────────────────────
      // ✅ Only send when a NEW image is picked (as base64).
      // When unchanged, omit the key → backend keeps existing file.
      if (restaurantImage.value != null) {
        final bytes = await restaurantImage.value!.readAsBytes();
        body['restaurant_image'] =
        "data:image/jpeg;base64,${base64Encode(bytes)}";
      }

      // ── QR Code ──────────────────────────────────────────────────────────
      // ✅ Same fix as restaurant_image above.
      if (qrImage.value != null) {
        final bytes = await qrImage.value!.readAsBytes();
        body['qr_code'] = "data:image/png;base64,${base64Encode(bytes)}";
      }

      // ── Additional Images ────────────────────────────────────────────────
      // ✅ KEY FIX:
      // Only send additional_images if the user actually modified them
      // (added new images OR removed existing ones).
      //
      // If NOT modified → omit the key entirely → backend keeps existing
      // files untouched. This prevents the 500 "unlink(): Is a directory"
      // crash caused by the API returning [{}] (empty objects), which get
      // filtered to [], and [] sent to backend triggers a bad unlink call.
      if (additionalImagesModified.value) {
        final List<String> allAdditionalImages = [];

        for (final existingUrl in existingAdditionalImageUrls) {
          final trimmed = existingUrl.trim();
          if (trimmed.isNotEmpty && trimmed.startsWith('http')) {
            allAdditionalImages.add(trimmed);
          }
        }

        for (final file in additionalImages) {
          final bytes = await file.readAsBytes();
          allAdditionalImages
              .add("data:image/jpeg;base64,${base64Encode(bytes)}");
        }

        body['additional_images'] = allAdditionalImages;

        debugPrint(
            "📤 Sending ${allAdditionalImages.length} additional images (modified)");
        debugPrint(
            "📤 Existing URLs: ${allAdditionalImages.where((e) => e.startsWith('http')).toList()}");
        debugPrint(
            "📤 New images count: ${allAdditionalImages.where((e) => e.startsWith('data:')).length}");
      } else {
        debugPrint(
            "📤 Additional images NOT modified — key omitted from request");
      }

      // ── Send ──────────────────────────────────────────────────────────────
      final response = await http.post(
        url,
        headers: {
          "Authorization": "Bearer $token",
          "Accept": "application/json",
          "Content-Type": "application/json",
        },
        body: jsonEncode(body),
      );

      debugPrint("Status: ${response.statusCode}");
      debugPrint("Body: ${response.body}");

      if (response.statusCode != 200 && response.statusCode != 201) {
        AppSnackbar.error(ApiErrorHandler.handleResponse(response));
        return;
      }

      final responseBody = jsonDecode(response.body);

      if (responseBody['status'].toString() == "1" ||
          responseBody['status'] == true) {
        AppSnackbar.success(
            responseBody['message'] ?? "Updated successfully");
        Get.back();
      } else {
        AppSnackbar.error(
            responseBody['message'] ?? "Failed to update restaurant");
      }
    } catch (e) {
      debugPrint("Error: $e");
      AppSnackbar.error(ApiErrorHandler.handleException(e));
    } finally {
      isUpdating.value = false;
    }
  }
}