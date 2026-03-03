// lib/data/controllers/create_offer_controller.dart

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

import '../../../data/models/admin_postingoffermodel.dart';
import '../views/addofferproduct.dart';
import 'merchant_addofferproductcontroller.dart';


class CreateOfferController extends GetxController {
  // ── Storage & HTTP ────────────────────────────────────────────────────────
  final GetStorage _box = GetStorage();
  final ImagePicker _picker = ImagePicker();

  static const String _baseUrl =
      'https://rasma.astradevelops.in/e_shoppyy/public/api';

  String get _authToken => _box.read<String>('auth_token') ?? '';

  Map<String, String> get _headers => {
    'Accept': 'application/json',
    'Content-Type': 'application/json',
    'Authorization': 'Bearer $_authToken',
  };

  // ── Observable state ──────────────────────────────────────────────────────
  final RxBool isSubmitting = false.obs;
  final RxString bannerPath = ''.obs;
  final RxString bannerBase64 = ''.obs;
  final TextEditingController discountController = TextEditingController();

  @override
  void onClose() {
    discountController.dispose();
    super.onClose();
  }

  // ── Pick banner image ─────────────────────────────────────────────────────
  Future<void> pickBanner() async {
    try {
      final XFile? file = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 85,
      );
      if (file == null) return;

      bannerPath.value = file.path;
      final bytes = await file.readAsBytes();
      bannerBase64.value = 'data:image/jpeg;base64,${base64Encode(bytes)}';
    } catch (e) {
      debugPrint('pickBanner error: $e');
      _showError('Could not pick image. Please try again.');
    }
  }

  // ── Create offer ──────────────────────────────────────────────────────────
  Future<void> createOffer() async {
    final discountText = discountController.text.trim();

    if (discountText.isEmpty) {
      _showError('Please enter a discount percentage.');
      return;
    }
    final discount = double.tryParse(discountText);
    if (discount == null || discount <= 0 || discount > 100) {
      _showError('Please enter a valid discount between 1 and 100.');
      return;
    }
    if (bannerBase64.value.isEmpty) {
      _showError('Please select a banner image.');
      return;
    }

    isSubmitting.value = true;

    try {
      final response = await http
          .post(
        Uri.parse('$_baseUrl/offers/create'),
        headers: _headers,
        body: jsonEncode({
          'discount_percentage': discount,
          'offer_banner': bannerBase64.value,
        }),
      )
          .timeout(const Duration(seconds: 60));

      final decoded = jsonDecode(response.body);
      final status = decoded['status'];

      if (status == 1 || status == '1' || status == true) {
        final offerResponse = CreateOfferResponse.fromJson(decoded);
        final data = offerResponse.data!;

        _showSuccess(decoded['message'] ?? 'Offer created successfully!');

        // Navigate to AddOfferProductPage
        Get.to(
              () => AddOfferProductPage(),
          binding: BindingsBuilder(() {
            Get.put(AddOfferProductController(
              offerId: data.offerId,
              discountPercentage: data.discountPercentage,
            ));
          }),
          transition: Transition.rightToLeft,
        );
      } else {
        _showError(decoded['message'] ?? 'Failed to create offer.');
      }
    } catch (e) {
      debugPrint('createOffer error: $e');
      _showError('Something went wrong. Please try again.');
    } finally {
      isSubmitting.value = false;
    }
  }

  // ── Helpers ───────────────────────────────────────────────────────────────
  void _showError(String message) {
    Get.snackbar(
      'Error',
      message,
      backgroundColor: Colors.red.shade600,
      colorText: Colors.white,
      icon: const Icon(Icons.error_outline, color: Colors.white),
      snackPosition: SnackPosition.TOP,
      borderRadius: 12,
      margin: const EdgeInsets.all(16),
      duration: const Duration(seconds: 4),
    );
  }

  void _showSuccess(String message) {
    Get.snackbar(
      'Success',
      message,
      backgroundColor: Colors.green.shade600,
      colorText: Colors.white,
      icon: const Icon(Icons.check_circle_outline, color: Colors.white),
      snackPosition: SnackPosition.TOP,
      borderRadius: 12,
      margin: const EdgeInsets.all(16),
      duration: const Duration(seconds: 3),
    );
  }
}