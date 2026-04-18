
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

import '../../../data/errors/api_error.dart';

import '../../merchantlogin/widget/successwidget.dart';
import '../view/restaurant/restaurant_menumanagment.dart';

class RestaurantRegController extends GetxController {
  final GetStorage box = GetStorage();
  final ImagePicker picker = ImagePicker();

  Rx<File?> restaurantImage = Rx<File?>(null);
  Rx<File?> qrCodeImage = Rx<File?>(null);
  RxList<File> additionalImages = <File>[].obs;
  RxBool isLoading = false.obs;

  final formKey = GlobalKey<FormState>();

  final ownerCtrl = TextEditingController();
  final restaurantNameCtrl = TextEditingController();
  final addressCtrl = TextEditingController();
  final phoneCtrl = TextEditingController();
  final emailCtrl = TextEditingController();
  final websiteCtrl = TextEditingController();
  final whatsappCtrl = TextEditingController();
  final facebookCtrl = TextEditingController();
  final instaCtrl = TextEditingController();
  final upiCtrl = TextEditingController();

  RxString restaurantImageError = ''.obs;
  RxString qrCodeImageError = ''.obs;

  // ── Token ─────────────────────────────
  String get token {
    final t = box.read('auth_token');
    return t?.toString().trim() ?? '';
  }

  // ── Image Pickers ─────────────────────
  Future<void> pickRestaurantImage() async {
    final XFile? image = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 70,
    );

    if (image != null) {
      restaurantImage.value = File(image.path);
      restaurantImageError.value = '';
    }
  }

  Future<void> pickQrCodeImage() async {
    final XFile? image = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 90,
    );

    if (image != null) {
      qrCodeImage.value = File(image.path);
      qrCodeImageError.value = '';
    }
  }

  Future<void> pickAdditionalImages() async {
    final List<XFile>? images = await picker.pickMultiImage(
      imageQuality: 70,
    );

    if (images != null) {
      additionalImages.addAll(images.map((e) => File(e.path)));
    }
  }

  // ── Base64 Convert ────────────────────
  Future<String> _fileToBase64(File file, {bool isPng = false}) async {
    final bytes = await file.readAsBytes();
    final mime = isPng ? "image/png" : "image/jpeg";
    return "data:$mime;base64,${base64Encode(bytes)}";
  }


  Future<void> submit() async {
    if (restaurantImage.value == null) {
      _showWarning('Please upload a restaurant image');
      return;
    }

    if (qrCodeImage.value == null) {
      qrCodeImageError.value = 'QR code image is required';
      _showWarning('Please upload a payment QR code image');
      return;
    }

    if (!(formKey.currentState?.validate() ?? false)) return;

    if (emailCtrl.text.trim().isEmpty) {
      AppSnackbar.warning('Email is required');
      return;
    }

    if (upiCtrl.text.trim().isEmpty) {
      AppSnackbar.warning('UPI ID is required');
      return;
    }

    final currentToken = token;

    isLoading.value = true;

    try {
      final mainImage = await _fileToBase64(restaurantImage.value!);

      final List<String> additionalBase64 = [];
      for (var img in additionalImages) {
        additionalBase64.add(await _fileToBase64(img));
      }

      final Map<String, dynamic> body = {
        "owner_name": ownerCtrl.text.trim(),
        "restaurant_name": restaurantNameCtrl.text.trim(),
        "address": addressCtrl.text.trim(),
        "phone": phoneCtrl.text.trim(),
        "email": emailCtrl.text.trim(),
        "website": websiteCtrl.text.trim(),
        "whatsapp": whatsappCtrl.text.trim(),
        "facebook_link": facebookCtrl.text.trim(),
        "instagram_link": instaCtrl.text.trim(),
        "upi_id": upiCtrl.text.trim(),
        "restaurant_image": mainImage,
        "additional_images": additionalBase64,
      };

      if (qrCodeImage.value != null) {
        body["qr_code"] =
        await _fileToBase64(qrCodeImage.value!, isPng: true);
      }

      final response = await http.post(
        Uri.parse(
          "https://rasma.astradevelops.in/e_shoppyy/public/api/restaurant/register",
        ),
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/json",
          "Authorization": "Bearer $currentToken",
        },
        body: jsonEncode(body),
      );

      /// ✅ HTTP Error handling
      if (response.statusCode != 200 && response.statusCode != 201) {
        final errMsg = ApiErrorHandler.handleResponse(response);
        AppSnackbar.error(errMsg);
        return;
      }

      /// ✅ Safe JSON parse
      Map<String, dynamic> data = {};
      try {
        data = jsonDecode(response.body);
      } catch (_) {
        AppSnackbar.error("Invalid server response");
        return;
      }

      final status = data['status'];
      final isSuccess = status == true || status == 1 || status == "1";

      if (isSuccess) {
        final rawId =
            data['data']?['id'] ?? data['data']?['restaurant_id'];

        if (rawId != null) {
          final parsedId = int.tryParse(rawId.toString());
          if (parsedId != null) {
            box.write('restaurant_id', parsedId);
          }
        }

        AppSnackbar.success(
          data['message'] ?? "Restaurant registered successfully",
        );

        Get.off(() => MenuManagementPage());
      } else {
        AppSnackbar.error(
          data['message'] ?? "Request failed",
        );
      }
    } catch (e) {
      /// ✅ Exception handling
      final errorMessage = ApiErrorHandler.handleException(e);
      AppSnackbar.error(errorMessage);
    } finally {
      isLoading.value = false;
    }
  }

  void _showWarning(String msg) {
    AppSnackbar.warning(msg);
  }

  @override
  void onClose() {
    ownerCtrl.dispose();
    restaurantNameCtrl.dispose();
    addressCtrl.dispose();
    phoneCtrl.dispose();
    emailCtrl.dispose();
    websiteCtrl.dispose();
    whatsappCtrl.dispose();
    facebookCtrl.dispose();
    instaCtrl.dispose();
    upiCtrl.dispose();
    super.onClose();
  }
}