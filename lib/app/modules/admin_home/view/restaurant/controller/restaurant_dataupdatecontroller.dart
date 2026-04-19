
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

  final box = GetStorage();
  final ImagePicker _picker = ImagePicker();

  String? restaurantId;
  bool _isDataLoaded = false;

  static const String _baseUrl =
      "https://rasma.astradevelops.in/e_shoppyy/public/";

  // ── URL Validators ────────────────────────────────────────────────────────

  /// Generic: must be http/https URL if not empty
  String? validateUrl(String? value, String fieldName) {
    if (value == null || value.trim().isEmpty) return null;
    final uri = Uri.tryParse(value.trim());
    if (uri == null || !uri.hasScheme || !uri.scheme.startsWith('http')) {
      return '$fieldName must start with http:// or https://';
    }
    return null;
  }

  /// Website: any valid http/https URL
  String? validateWebsiteUrl(String? value) => validateUrl(value, 'Website');

  /// Facebook: must contain facebook.com
  String? validateFacebookUrl(String? value) {
    if (value == null || value.trim().isEmpty) return null;
    final err = validateUrl(value, 'Facebook');
    if (err != null) return err;
    if (!value.trim().toLowerCase().contains('facebook.com')) {
      return 'Enter a valid Facebook URL (facebook.com/...)';
    }
    return null;
  }

  /// Instagram: must be instagram.com URL or @handle
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

  /// WhatsApp: exactly 10 digits if not empty
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

    if (data['additional_images'] != null) {
      existingAdditionalImageUrls.value =
      List<String>.from(data['additional_images']);
    }
  }

  String _stripBaseUrl(String url) {
    return url.startsWith(_baseUrl)
        ? url.replaceFirst(_baseUrl, '')
        : url;
  }

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
    additionalImages.addAll(files.map((e) => File(e.path)));
  }

  void removeAdditionalImage(int i) => additionalImages.removeAt(i);
  void removeExistingAdditionalImage(int i) =>
      existingAdditionalImageUrls.removeAt(i);

  Future<void> updateRestaurant() async {
    if (!(formKey.currentState?.validate() ?? false)) return;

    try {
      isUpdating.value = true;

      final token = box.read("auth_token");

      final url = Uri.parse(
          "https://rasma.astradevelops.in/e_shoppyy/public/api/admin/restaurant/update");

      // ── Switch to JSON body instead of MultipartRequest ──────────────────
      // Because API expects all images as base64 strings, not multipart files

      final Map<String, dynamic> body = {};

      // ── Fields ──────────────────────────────────────────────────────────
      body['restaurant_id'] = restaurantId.toString();
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
      if (restaurantImage.value != null) {
        // New image selected — convert to base64
        final bytes = await restaurantImage.value!.readAsBytes();
        body['restaurant_image'] =
        "data:image/jpeg;base64,${base64Encode(bytes)}";
      } else if (restaurantImageUrl.value.isNotEmpty) {
        // No change — send existing URL
        body['restaurant_image'] = restaurantImageUrl.value;
      }

      // ── QR Code ──────────────────────────────────────────────────────────
      if (qrImage.value != null) {
        // New QR selected — convert to base64
        final bytes = await qrImage.value!.readAsBytes();
        body['qr_code'] = "data:image/png;base64,${base64Encode(bytes)}";
      } else if (qrImageUrl.value.isNotEmpty) {
        // No change — send existing URL
        body['qr_code'] = qrImageUrl.value;
      }

      // ── Additional Images ────────────────────────────────────────────────
      final List<String> allAdditionalImages = [];

      // Keep existing ones
      for (var url in existingAdditionalImageUrls) {
        allAdditionalImages.add(url);
      }

      // Convert new ones to base64
      for (var file in additionalImages) {
        final bytes = await file.readAsBytes();
        allAdditionalImages
            .add("data:image/jpeg;base64,${base64Encode(bytes)}");
      }

      body['additional_images'] = allAdditionalImages;

      // ── Send as JSON ──────────────────────────────────────────────────────
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
  }}