
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

import '../../../data/errors/api_error.dart';
import '../../../data/models/admin_postingoffermodel.dart';
import '../../merchantlogin/widget/successwidget.dart';
import '../views/addofferproduct.dart';
import 'merchant_addofferproductcontroller.dart';

class CreateOfferController extends GetxController {
  // ── Storage & HTTP ─────────────────────────────────────────
  final GetStorage _box    = GetStorage();
  final ImagePicker _picker = ImagePicker();

  static const String _baseUrl =
      'https://rasma.astradevelops.in/e_shoppyy/public/api';

  String get _authToken => _box.read<String>('auth_token') ?? '';

  Map<String, String> get _headers => {
    'Accept'        : 'application/json',
    'Content-Type'  : 'application/json',
    'Authorization' : 'Bearer $_authToken',
  };

  // ── Observable state ───────────────────────────────────────
  final RxBool   isSubmitting = false.obs;
  final Rx<File?> pickedBannerFile = Rx<File?>(null);
  final RxString  bannerBase64     = ''.obs;

  final TextEditingController discountController = TextEditingController();

  @override
  void onClose() {
    discountController.dispose();
    super.onClose();
  }


  Future<void> pickBanner() async {
    try {
      final XFile? xFile = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 85,
      );
      if (xFile == null) return;

      final file  = File(xFile.path);
      final bytes = await file.readAsBytes();

      // ── 2:1 ratio validation ───────────────────────────────
      final decodedImage = await decodeImageFromList(bytes);
      final width  = decodedImage.width;
      final height = decodedImage.height;
      final ratio  = width / height;

      debugPrint(">>> Banner size: ${width}x${height}, ratio: $ratio");

      if (ratio < 1.9 || ratio > 2.1) {
        AppSnackbar.warning(
          "Please upload a 2:1 ratio image (e.g. 1200×600, 800×400).\nYour image: ${width}×${height}",
        );
        return;
      }

      // ── Valid — store file & base64 ────────────────────────
      final ext      = xFile.path.split('.').last.toLowerCase();
      final mimeType = ext == 'png' ? 'image/png' : 'image/jpeg';

      pickedBannerFile.value = file;
      bannerBase64.value     = 'data:$mimeType;base64,${base64Encode(bytes)}';

    } catch (e) {
      AppSnackbar.error(ApiErrorHandler.handleException(e));
    }
  }

  // ── Show picker options (camera + gallery) ─────────────────
  void showImagePickerOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => SafeArea(
        child: Wrap(
          children: [
            // ── Ratio hint ─────────────────────────────────
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(
                  horizontal: 16, vertical: 10),
              color: Colors.amber.shade50,
              child: Row(
                children: [
                  Icon(Icons.info_outline,
                      size: 16, color: Colors.amber.shade800),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      "Only 2:1 ratio images accepted (e.g. 1200×600, 800×400)",
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.amber.shade900,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            ListTile(
              leading: const Icon(Icons.photo_camera,
                  color: Color(0xFF00BFA5)),
              title: const Text('Camera',
                  style: TextStyle(fontWeight: FontWeight.w600)),
              onTap: () async {
                Get.back();
                await _pickFromSource(ImageSource.camera);
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library,
                  color: Color(0xFF00BFA5)),
              title: const Text('Gallery',
                  style: TextStyle(fontWeight: FontWeight.w600)),
              onTap: () async {
                Get.back();
                await pickBanner();
              },
            ),
          ],
        ),
      ),
    );
  }

  // ── Internal: pick from camera with same validation ────────
  Future<void> _pickFromSource(ImageSource source) async {
    try {
      final XFile? xFile = await _picker.pickImage(
        source: source,
        imageQuality: 85,
      );
      if (xFile == null) return;

      final file  = File(xFile.path);
      final bytes = await file.readAsBytes();

      final decodedImage = await decodeImageFromList(bytes);
      final width  = decodedImage.width;
      final height = decodedImage.height;
      final ratio  = width / height;

      if (ratio < 1.9 || ratio > 2.1) {
        AppSnackbar.warning(
          "Please upload a 2:1 ratio image (e.g. 1200×600, 800×400).\nYour image: ${width}×${height}",
        );
        return;
      }

      final ext      = xFile.path.split('.').last.toLowerCase();
      final mimeType = ext == 'png' ? 'image/png' : 'image/jpeg';

      pickedBannerFile.value = file;
      bannerBase64.value     = 'data:$mimeType;base64,${base64Encode(bytes)}';

    } catch (e) {
      AppSnackbar.error(ApiErrorHandler.handleException(e));
    }
  }

  // ── Create offer ───────────────────────────────────────────
  Future<void> createOffer() async {
    // ── Validation ─────────────────────────────────────────
    final discountText = discountController.text.trim();

    if (discountText.isEmpty) {
      AppSnackbar.warning('Please enter a discount percentage.');
      return;
    }
    final discount = double.tryParse(discountText);
    if (discount == null || discount <= 0 || discount > 100) {
      AppSnackbar.warning('Please enter a valid discount between 1 and 100.');
      return;
    }
    if (bannerBase64.value.isEmpty) {
      AppSnackbar.warning('Please select a banner image.');
      return;
    }
    // if (!_checkToken()) return;

    isSubmitting.value = true;

    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/offers/create'),
        headers: _headers,
        body: jsonEncode({
          'discount_percentage': discount,
          'offer_banner'       : bannerBase64.value,
        }),
      ).timeout(const Duration(seconds: 60));

      // ── Non-2xx → ApiErrorHandler ──────────────────────
      if (response.statusCode != 200 && response.statusCode != 201) {
        AppSnackbar.error(ApiErrorHandler.handleResponse(response));
        return;
      }

      final decoded = jsonDecode(response.body);
      final status  = decoded['status'];

      // ── Success ────────────────────────────────────────
      if (status == 1 || status == '1' || status == true) {
        final offerResponse = CreateOfferResponse.fromJson(decoded);
        final data = offerResponse.data!;

        AppSnackbar.success(
          decoded['message']?.toString().isNotEmpty == true
              ? decoded['message']
              : 'Offer created successfully.',
        );

        await Future.delayed(const Duration(seconds: 2));

        Get.offAll(
              () => AddOfferProductPage(),
          binding: BindingsBuilder(() {
            Get.put(AddOfferProductController(
              offerId           : data.offerId,
              discountPercentage: data.discountPercentage,
            ));
          }),
          transition: Transition.rightToLeft,
        );

        // ── API-level failure ──────────────────────────────
      } else {
        AppSnackbar.error(
          decoded['message']?.toString().isNotEmpty == true
              ? decoded['message']
              : 'Failed to create offer.',
        );
      }
    } catch (e) {
      AppSnackbar.error(ApiErrorHandler.handleException(e));
    } finally {
      isSubmitting.value = false;
    }
  }
}