
import 'dart:convert';
import 'dart:io';

import 'package:eshoppy/app/modules/merchant_home/views/myadvetisment.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

import '../../../data/errors/api_error.dart';
import '../../../data/models/updateadvertisment_merchnatmodel.dart';
import '../../merchantlogin/widget/successwidget.dart';

class UpdateAdvertisementController extends GetxController {
  // ── API endpoints ─────────────────────────────────────────
  static const String _baseUrl =
      'https://eshoppy.co.in/api';
  static const String _getSingleAdUrl = '$_baseUrl/get-single-advertisement';
  static const String _updateAdUrl    = '$_baseUrl/update-advertisement';

  // ── Storage ───────────────────────────────────────────────
  final box = GetStorage();

  // ── Form key ──────────────────────────────────────────────
  final formKey = GlobalKey<FormState>();

  // ── Text controller ───────────────────────────────────────
  final advertisementController = TextEditingController();

  // ── Observable state ──────────────────────────────────────
  final Rx<updateAdvertisementModel?> advertisement =
  Rx<updateAdvertisementModel?>(null);
  final RxBool   isLoading    = false.obs;
  final RxBool   isSubmitting = false.obs;
  final RxString errorMessage = ''.obs;

  // Banner image
  final Rx<File?> pickedImageFile   = Rx<File?>(null);
  final RxString  existingBannerUrl = ''.obs;
  final RxString  _base64Image      = ''.obs;

  // ── Locked location fields ─────────────────────────────────
  final RxString lockedState    = ''.obs;
  final RxString lockedDistrict = ''.obs;
  final RxString lockedArea     = ''.obs;
  final RxString showMode       = 'district'.obs;

  bool get hasBannerChanged => pickedImageFile.value != null;

  // ── Dynamic headers with Bearer token ─────────────────────
  Map<String, String> get _headers => {
    'Content-Type' : 'application/json',
    'Accept'       : 'application/json',
    'Authorization': 'Bearer ${box.read("auth_token") ?? ""}',
  };

  // ── Lifecycle ─────────────────────────────────────────────
  @override
  void onInit() {
    super.onInit();
    final dynamic args = Get.arguments;
    if (args is Map && args.containsKey('advertisement_id')) {
      fetchAdvertisement(args['advertisement_id'].toString());
    } else if (Get.parameters['advertisement_id'] != null) {
      fetchAdvertisement(Get.parameters['advertisement_id']!);
    }
  }

  @override
  void onClose() {
    advertisementController.dispose();
    super.onClose();
  }



  // ── Fetch single advertisement ────────────────────────────
  Future<void> fetchAdvertisement(String adId) async {
    isLoading.value    = true;
    errorMessage.value = '';
    try {
      final response = await http.post(
        Uri.parse(_getSingleAdUrl),
        headers: _headers,
        body: jsonEncode({'advertisement_id': int.parse(adId)}),
      );

      final decoded    = _decodeResponse(response);
      final adResponse = updateAdvertisementResponse.fromJson(decoded);

      if (adResponse.isSuccess && adResponse.data != null) {
        _populateFields(adResponse.data!);
      } else {
        errorMessage.value = adResponse.message.isNotEmpty
            ? adResponse.message
            : 'Failed to load advertisement.';
      }
    } catch (e) {
      errorMessage.value = ApiErrorHandler.handleException(e);
    } finally {
      isLoading.value = false;
    }
  }

  // ── Populate form from model ──────────────────────────────
  void _populateFields(updateAdvertisementModel data) {
    advertisement.value          = data;
    advertisementController.text = data.advertisement;
    existingBannerUrl.value      = data.bannerImage;

    lockedState.value    = data.state        ?? '';
    lockedDistrict.value = data.district     ?? '';
    lockedArea.value     = data.mainLocation ?? '';

    final hasArea = (data.mainLocation ?? '').trim().isNotEmpty;
    showMode.value = hasArea ? 'area' : 'district';
  }

  // ── Image picker with 2:1 ratio validation ────────────────
  Future<void> pickBannerImage(ImageSource source) async {
    try {
      final picker = ImagePicker();
      final XFile? xFile = await picker.pickImage(
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

      debugPrint(">>> Banner size: ${width}x${height}, ratio: $ratio");

      if (ratio < 1.9 || ratio > 2.1) {
        AppSnackbar.warning(
          "Please upload a 2:1 ratio image (e.g. 1200×600, 800×400).\nYour image: ${width}×${height}",
        );
        return;
      }

      final ext      = xFile.path.split('.').last.toLowerCase();
      final mimeType = ext == 'png' ? 'image/png' : 'image/jpeg';

      pickedImageFile.value = file;
      _base64Image.value    = 'data:$mimeType;base64,${base64Encode(bytes)}';

    } catch (e) {
      AppSnackbar.error(ApiErrorHandler.handleException(e));
    }
  }

  void showImagePickerOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => SafeArea(
        child: Wrap(
          children: [
            // ── Ratio hint banner ─────────────────────────
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              color: Colors.amber.shade50,
              child: Row(
                children: [
                  Icon(Icons.info_outline, size: 16, color: Colors.amber.shade800),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      "Only 2:1 ratio images accepted  (e.g. 1200×600, 800×400)",
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
              leading: const Icon(Icons.photo_camera, color: Color(0xFF00BFA5)),
              title: const Text('Camera',
                  style: TextStyle(fontWeight: FontWeight.w600)),
              onTap: () {
                Get.back();
                pickBannerImage(ImageSource.camera);
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library, color: Color(0xFF00BFA5)),
              title: const Text('Gallery',
                  style: TextStyle(fontWeight: FontWeight.w600)),
              onTap: () {
                Get.back();
                pickBannerImage(ImageSource.gallery);
              },
            ),
          ],
        ),
      ),
    );
  }

  // ── Validation ────────────────────────────────────────────
  String? validateRequired(String? value, String fieldName) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName is required';
    }
    return null;
  }

  // ── Submit update ─────────────────────────────────────────
  Future<void> updateAdvertisement() async {
    if (!formKey.currentState!.validate()) return;
    // if (!_checkToken()) return;

    isSubmitting.value = true;
    errorMessage.value = '';

    try {
      final ad = advertisement.value!;

      final payload = <String, dynamic>{
        'advertisement_id': int.parse(ad.id),
        'advertisement'   : advertisementController.text.trim(),
        'state'           : lockedState.value,
        'district'        : lockedDistrict.value,
        'main_location'   : lockedArea.value,
        if (hasBannerChanged) 'banner_image': _base64Image.value,
      };

      final response = await http.put(
        Uri.parse(_updateAdUrl),
        headers: _headers,
        body: jsonEncode(payload),
      );

      final decoded    = _decodeResponse(response);
      final adResponse = updateAdvertisementResponse.fromJson(decoded);
      if (adResponse.isSuccess && adResponse.data != null) {
        _populateFields(adResponse.data!);
        pickedImageFile.value = null;
        AppSnackbar.success(
          adResponse.message.isNotEmpty
              ? adResponse.message
              : 'Advertisement updated successfully.',
        );

        // ✅ Wait for snackbar to appear, then go back
        await Future.delayed(const Duration(seconds: 2));
        Get.back();
      } else {
        errorMessage.value = adResponse.message.isNotEmpty
            ? adResponse.message
            : 'Failed to update advertisement.';
        AppSnackbar.error(errorMessage.value);
      }
    } catch (e) {
      errorMessage.value = ApiErrorHandler.handleException(e);
      AppSnackbar.error(errorMessage.value);
    } finally {
      isSubmitting.value = false;
    }
  }

  // ── Decode HTTP response ──────────────────────────────────
  Map<String, dynamic> _decodeResponse(http.Response response) {
    if (response.statusCode != 200 && response.statusCode != 201) {
      final errMsg = ApiErrorHandler.handleResponse(response);
      throw Exception(errMsg);
    }
    return jsonDecode(response.body) as Map<String, dynamic>;
  }
}
