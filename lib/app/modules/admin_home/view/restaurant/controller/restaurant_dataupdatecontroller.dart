
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

  bool validateForm() {
    if (restaurantNameController.text.isEmpty) {
      AppSnackbar.warning("Restaurant name required");
      return false;
    }
    if (ownerNameController.text.isEmpty) {
      AppSnackbar.warning("Owner name required");
      return false;
    }
    if (phoneController.text.isEmpty) {
      AppSnackbar.warning("Phone required");
      return false;
    }
    if (emailController.text.isEmpty) {
      AppSnackbar.warning("Email required");
      return false;
    }
    return true;
  }

  Future<void> updateRestaurant() async {
    if (!validateForm()) return;

    try {
      isUpdating.value = true;

      final token = box.read("auth_token");

      final url = Uri.parse(
          "https://rasma.astradevelops.in/e_shoppyy/public/api/admin/restaurant/update");

      var request = http.MultipartRequest('POST', url);

      request.headers.addAll({
        "Authorization": "Bearer $token",
        "Accept": "application/json",
      });

      // ── Fields ─────────────────────────────
      request.fields['restaurant_id'] = restaurantId.toString();
      request.fields['restaurant_name'] =
          restaurantNameController.text.trim();
      request.fields['owner_name'] = ownerNameController.text.trim();
      request.fields['address'] = addressController.text.trim();
      request.fields['phone'] = phoneController.text.trim();
      request.fields['email'] = emailController.text.trim();
      request.fields['website'] = websiteController.text.trim();
      request.fields['whatsapp'] = whatsappController.text.trim();
      request.fields['facebook_link'] = facebookController.text.trim();
      request.fields['instagram_link'] = instagramController.text.trim();
      request.fields['upi_id'] = upiIdController.text.trim();

      // ── Main Image ─────────────────────────
      if (restaurantImage.value == null &&
          restaurantImageUrl.value.isNotEmpty) {
        request.fields['existing_restaurant_image'] =
            _stripBaseUrl(restaurantImageUrl.value);
      }

      if (restaurantImage.value != null) {
        request.files.add(await http.MultipartFile.fromPath(
            'restaurant_image', restaurantImage.value!.path));
      }

      // ── QR Image ───────────────────────────
      if (qrImage.value == null && qrImageUrl.value.isNotEmpty) {
        request.fields['existing_qr_code'] =
            _stripBaseUrl(qrImageUrl.value);
      }

      if (qrImage.value != null) {
        request.files.add(await http.MultipartFile.fromPath(
            'qr_code', qrImage.value!.path));
      }

      // ── Additional Images ──────────────────
      for (int i = 0; i < existingAdditionalImageUrls.length; i++) {
        request.fields['existing_additional_images[$i]'] =
            _stripBaseUrl(existingAdditionalImageUrls[i]);
      }

      for (var file in additionalImages) {
        request.files.add(await http.MultipartFile.fromPath(
            'additional_images[]', file.path));
      }

      // ── Send Request ───────────────────────
      final streamed = await request.send();
      final response = await http.Response.fromStream(streamed);

      // ✅ Handle non-200
      if (response.statusCode != 200) {
        final error = ApiErrorHandler.handleResponse(response);
        if (error.isNotEmpty) AppSnackbar.error(error);
        return;
      }

      final body = jsonDecode(response.body);

      if (body['status'].toString() == "1") {
        AppSnackbar.success(body['message'] ?? "Updated successfully");
        Get.back();
      } else {
        AppSnackbar.error(
            body['message'] ?? "Failed to update restaurant");
      }
    } catch (e) {
      final error = ApiErrorHandler.handleException(e);
      AppSnackbar.error(error);
    } finally {
      isUpdating.value = false;
    }
  }
}