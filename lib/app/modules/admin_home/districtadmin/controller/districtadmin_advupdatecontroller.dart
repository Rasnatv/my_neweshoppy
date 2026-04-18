
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

import '../../../../data/errors/api_error.dart';
import '../../../../widgets/areaadminsuccesswidget.dart';
import '../../../merchantlogin/widget/successwidget.dart';
import '../view/districtadmin_home.dart';
import 'districtadminadvertismentgetcontroller.dart';


class AdvertisementUpdateController extends GetxController {
  final box = GetStorage();

  final formKey = GlobalKey<FormState>();
  final advertisementController = TextEditingController();

  final RxBool isLoading = false.obs;
  final RxBool isFetching = false.obs;

  final RxString bannerImageUrl = ''.obs;
  final RxString base64Image = ''.obs;

  final Rx<File?> pickedImageFile = Rx<File?>(null);

  final RxList<String> stateList = <String>[].obs;
  final RxString selectedState = ''.obs;

  final RxList<String> districtList = <String>[].obs;
  final RxString selectedDistrict = ''.obs;

  late int advertisementId;

  final picker = ImagePicker();

  final Rx<File?> bannerImage = Rx<File?>(null);

  static const String baseUrl =
      'https://rasma.astradevelops.in/e_shoppyy/public/api';

  String get authToken => box.read('auth_token') ?? '';

  Map<String, String> get headers => {
    'Authorization': 'Bearer $authToken',
    'Accept': 'application/json',
  };

  @override
  void onInit() {
    super.onInit();

    final rawId = Get.arguments?['advertisement_id']?.toString() ?? '0';
    advertisementId = int.tryParse(rawId) ?? 0;

    fetchStates();
    fetchDistricts();

    if (advertisementId != 0) {
      fetchAdvertisementDetails();
    }
  }

  @override
  void onClose() {
    advertisementController.dispose();
    super.onClose();
  }

  // ───────── STATES ─────────
  Future<void> fetchStates() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/getStates-fordistrict'),
        headers: headers,
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200 && data['status'] == true) {
        stateList.value =
            (data['data'] as List).map((e) => e['state'].toString()).toList();
      } else {
        AppSnackbarss.error(ApiErrorHandler.handleResponse(response));
      }
    } catch (e) {
      AppSnackbarss.error(ApiErrorHandler.handleException(e));
    }
  }

  // ───────── DISTRICTS ─────────
  // Future<void> fetchDistricts() async {
  //   try {
  //     final response = await http.get(
  //       Uri.parse('$baseUrl/district-admin/districts'),
  //       headers: headers,
  //     );
  //
  //     final data = jsonDecode(response.body);
  //
  //     if (response.statusCode == 200 && data['status'] == true) {
  //       districtList.value =
  //           (data['data'] as List).map((e) => e.toString()).toList();
  //     } else {
  //       AppSnackbarss.error(ApiErrorHandler.handleResponse(response));
  //     }
  //   } catch (e) {
  //     AppSnackbarss.error(ApiErrorHandler.handleException(e));
  //   }
  // }
  Future<void> fetchDistricts() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/district-admin/districts'),
        headers: headers,
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200 && data['status'] == true) {

        final list = (data['data'] as List)
            .map((e) => e.toString().trim())
            .toSet() // ✅ remove duplicates
            .toList();

        districtList.value = list;

      } else {
        AppSnackbarss.error(ApiErrorHandler.handleResponse(response));
      }
    } catch (e) {
      AppSnackbarss.error(ApiErrorHandler.handleException(e));
    }
  }

  // ───────── FETCH AD ─────────
  Future<void> fetchAdvertisementDetails() async {

    isFetching.value = true;

    try {
      final response = await http.post(
        Uri.parse('$baseUrl/district-admin/advertisement'),
        headers: {
          ...headers,
          'Content-Type': 'application/json',
        },
        body: jsonEncode({'advertisement_id': advertisementId}),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200 && data['status'] == true) {
        final ad = data['data'];

        advertisementController.text = ad['advertisement'] ?? '';
        bannerImageUrl.value = ad['banner_image'] ?? '';

        selectedState.value =
            (ad['state'] ?? '').toString().capitalizeFirst ?? '';

        selectedDistrict.value = (ad['district'] ?? '').toString();
      } else {
        AppSnackbarss.error(ApiErrorHandler.handleResponse(response));
      }
    } catch (e) {
      AppSnackbarss.error(ApiErrorHandler.handleException(e));
    } finally {
      isFetching.value = false;
    }
  }

  Future<void> pickBanner() async {
    try {
      final picked = await picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 85,
      );

      if (picked == null) return;

      final file = File(picked.path);

      // ✅ Decode image to get actual width & height
      final bytes = await file.readAsBytes();
      final decodedImage = await decodeImageFromList(bytes);

      final width  = decodedImage.width;
      final height = decodedImage.height;
      final ratio  = width / height;

      debugPrint(">>> Image size: ${width}x${height}, ratio: $ratio");

      // ✅ Allow only 2:1 ratio (small tolerance ±0.1)
      if (ratio < 1.9 || ratio > 2.1) {
        AppSnackbar.error(
          "Invalid image ratio ${width}x${height}.\nPlease upload a 2:1 ratio image (e.g. 1200x600)",
        );
        return;
      }

      // ✅ Ratio is correct — set directly, no cropper needed
      bannerImage.value = File(picked.path);

    } catch (e) {
      AppSnackbar.error("Image error: $e");
    }
  }


  Future<void> captureImage() async {
    final image =
    await picker.pickImage(source: ImageSource.camera, imageQuality: 85);

    if (image != null) {
      pickedImageFile.value = File(image.path);

      final bytes = await File(image.path).readAsBytes();
      base64Image.value =
      'data:${image.mimeType};base64,${base64Encode(bytes)}';
    }
  }

  void removeImage() {
    pickedImageFile.value = null;
    base64Image.value = '';
  }

  // ───────── UPDATE ─────────
  Future<void> updateAdvertisement() async {
    if (!formKey.currentState!.validate()) return;



    isLoading.value = true;

    try {
      final body = {
        'advertisement_id': advertisementId,
        'advertisement': advertisementController.text.trim(),
        'state': selectedState.value,
        'district': selectedDistrict.value,
      };

      if (base64Image.value.isNotEmpty) {
        body['banner_image'] = base64Image.value;
      }

      final response = await http.put(
        Uri.parse('$baseUrl/district-admin/advertisement/update'),
        headers: {
          ...headers,
          'Content-Type': 'application/json',
        },
        body: jsonEncode(body),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200 && data['status'] == true) {

        AppSnackbarss.success(data['message'] ?? "Updated successfully");

        Future.delayed(const Duration(milliseconds: 1200), () {
          if (Get.isRegistered<DistrictAdminAdvertisementGetController>()) {
            Get.find<DistrictAdminAdvertisementGetController>()
                .fetchAdvertisements();
          }

          Get.offAll(() => Districtadminhomepage());
        });

      } else {
        AppSnackbarss.error(ApiErrorHandler.handleResponse(response));
      }
    } catch (e) {
      AppSnackbarss.error(ApiErrorHandler.handleException(e));
    } finally {
      isLoading.value = false;
    }
  }
}
