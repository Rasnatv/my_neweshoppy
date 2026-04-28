
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;

import '../../../../data/errors/api_error.dart';
import '../../../../widgets/areaadminsuccesswidget.dart';
import '../../../merchantlogin/widget/successwidget.dart';
import '../view/districtadmin_home.dart';

class DistrictAdminEventAddController extends GetxController {

  final TextEditingController eventName = TextEditingController();
  final TextEditingController eventLocation = TextEditingController();

  final RxString startDate = ''.obs;
  final RxString endDate = ''.obs;
  final RxString startTime = ''.obs;
  final RxString endTime = ''.obs;
  final RxString selectedDistrict = ''.obs;
  final RxString selectedState = ''.obs;
  final Rx<File?> bannerImage = Rx<File?>(null);

  final RxBool isLoading = false.obs;
  final RxBool isDistrictsLoading = false.obs;
  final RxBool isStatesLoading = false.obs;

  final RxList<String> districts = <String>[].obs;
  final RxList<String> states = <String>[].obs;

  final _box = GetStorage();
  var errorBanner = Rx<String?>(null);
  final ImagePicker picker = ImagePicker();


  static const String _baseUrl =
      'https://eshoppy.co.in/api/district-admin';
  static const String _publicBaseUrl =
      'https://eshoppy.co.in/api';

  @override
  void onInit() {
    super.onInit();
    fetchStates();
    fetchDistricts();
  }

  @override
  void onClose() {
    eventName.dispose();
    eventLocation.dispose();
    super.onClose();
  }

  String get _authToken => _box.read('auth_token') ?? '';

  Map<String, String> get _headers => {
    'Authorization': 'Bearer $_authToken',
    'Accept': 'application/json',
  };

  // ─── FETCH STATES ─────────────────────────────
  Future<void> fetchStates() async {
    try {
      isStatesLoading.value = true;

      final response = await http.get(
        Uri.parse('$_publicBaseUrl/getStates-fordistrict'),
        headers: _headers,
      );

      final body = jsonDecode(response.body);

      if (response.statusCode == 200 && body['status'] == true) {
        final List data = body['data'] ?? [];
        states.assignAll(
          data.map((e) => (e['state'] ?? '').toString()).toList(),
        );
      } else {
        AppSnackbar.error(ApiErrorHandler.handleResponse(response));
      }
    } catch (e) {
      AppSnackbar.error(ApiErrorHandler.handleException(e));
    } finally {
      isStatesLoading.value = false;
    }
  }

  // ─── FETCH DISTRICTS ─────────────────────────
  Future<void> fetchDistricts() async {


    try {
      isDistrictsLoading.value = true;

      final response = await http.get(
        Uri.parse('$_baseUrl/districts'),
        headers: _headers,
      );

      final body = jsonDecode(response.body);

      if (response.statusCode == 200 && body['status'] == true) {
        final List data = body['data'] ?? [];
        districts.assignAll(data.map((e) => e.toString()).toList());
      } else {
        AppSnackbar.error(ApiErrorHandler.handleResponse(response));
      }
    } catch (e) {
      AppSnackbar.error(ApiErrorHandler.handleException(e));
    } finally {
      isDistrictsLoading.value = false;
    }
  }

  // ─── DATE ─────────────────────────────────────
  Future<void> pickStartDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
      builder: (context, child) => _datePickerTheme(context, child),
    );

    if (picked != null) {
      startDate.value = DateFormat('yyyy-MM-dd').format(picked);

      if (endDate.value.isNotEmpty) {
        final end = DateTime.parse(endDate.value);
        if (end.isBefore(picked)) endDate.value = '';
      }
    }
  }

  Future<void> pickEndDate(BuildContext context) async {
    final initialDate = startDate.value.isNotEmpty
        ? DateTime.parse(startDate.value)
        : DateTime.now();

    final picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: initialDate,
      lastDate: DateTime(2100),
      builder: (context, child) => _datePickerTheme(context, child),
    );

    if (picked != null) {
      endDate.value = DateFormat('yyyy-MM-dd').format(picked);
    }
  }

  // ─── TIME ─────────────────────────────────────
  Future<void> pickStartTime(BuildContext context) async {
    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) startTime.value = picked.format(context);
  }

  Future<void> pickEndTime(BuildContext context) async {
    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) endTime.value = picked.format(context);
  }

  Widget _datePickerTheme(BuildContext context, Widget? child) {
    return Theme(
      data: Theme.of(context).copyWith(
        colorScheme: const ColorScheme.light(
          primary: Color(0xFF6C63FF),
        ),
      ),
      child: child!,
    );
  }

  Future<void> pickBannerImage() async {
    final picked = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 90,
    );

    if (picked == null) return;

    File file = File(picked.path);

    // SIZE CHECK (1MB limit)
    final int bytes = await file.length();
    if (bytes > 1024 * 1024) {
      errorBanner.value = "Image must be less than 1 MB";
      return;
    }

    // CROP IMAGE (2:1 ratio)
    final croppedFile = await ImageCropper().cropImage(
      sourcePath: file.path,
      aspectRatio: const CropAspectRatio(ratioX: 2, ratioY: 1),
      uiSettings: [
        AndroidUiSettings(
          toolbarTitle: 'Crop Banner',
          toolbarColor: Colors.black,
          toolbarWidgetColor: Colors.white,
          lockAspectRatio: true,
        ),
        IOSUiSettings(
          title: 'Crop Banner',
          aspectRatioLockEnabled: true,
        ),
      ],
    );

    if (croppedFile == null) return;

    file = File(croppedFile.path);

    bannerImage.value = file;
    errorBanner.value = null;
  }

  // ─── VALIDATION ───────────────────────────────
  bool _validateForm() {
    if (eventName.text.trim().isEmpty) {
      AppSnackbar.warning('Enter event name');
      return false;
    } else if (selectedState.value.isEmpty) {
      AppSnackbar.warning('Select state');
      return false;
    } else if (selectedDistrict.value.isEmpty) {
      AppSnackbar.warning('Select district');
      return false;
    } else if (startDate.value.isEmpty || endDate.value.isEmpty) {
      AppSnackbar.warning('Select dates');
      return false;
    } else if (startTime.value.isEmpty || endTime.value.isEmpty) {
      AppSnackbar.warning('Select time');
      return false;
    } else if (eventLocation.text.trim().isEmpty) {
      AppSnackbar.warning('Enter event location');
      return false;
    } else if (bannerImage.value == null) {
      AppSnackbar.warning('Select banner image');
      return false;
    }
    return true;
  }

  // ─── ADD EVENT ────────────────────────────────
  Future<void> addEvent() async {
    if (!_validateForm()) return;
    try {
      isLoading.value = true;

      final bytes = await bannerImage.value!.readAsBytes();
      final base64Image = 'data:image/jpeg;base64,${base64Encode(bytes)}';

      final response = await http.post(
        Uri.parse('$_baseUrl/event/create'),
        headers: {
          ..._headers,
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'event_name': eventName.text.trim(),
          'start_date': startDate.value,
          'end_date': endDate.value,
          'start_time': startTime.value,
          'end_time': endTime.value,
          'state': selectedState.value,
          'district': selectedDistrict.value,
          'event_location': eventLocation.text.trim(),
          'banner_image': base64Image,
        }),
      );

      final responseData = jsonDecode(response.body);

      if (response.statusCode == 200 &&
          (responseData['status'] == true || responseData['status'] == 1)) {

        AppSnackbar.success(
            responseData['message'] ?? 'Event created successfully');

        _resetForm();
        Get.offAll(() => Districtadminhomepage());

      } else {
        AppSnackbar.error(ApiErrorHandler.handleResponse(response));
      }

    } catch (e) {
      AppSnackbar.error(ApiErrorHandler.handleException(e));
    } finally {
      isLoading.value = false;
    }
  }

  // ─── RESET ────────────────────────────────────
  void _resetForm() {
    eventName.clear();
    eventLocation.clear();
    startDate.value = '';
    endDate.value = '';
    startTime.value = '';
    endTime.value = '';
    selectedState.value = '';
    selectedDistrict.value = '';
    bannerImage.value = null;
  }
}