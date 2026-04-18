import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

import '../../../data/errors/api_error.dart';
import '../../../data/models/admin_addeventmodel.dart';
import '../../merchantlogin/widget/successwidget.dart';

class AdminEventAddController extends GetxController {
  var events = <AdminaddEventModel>[].obs;
  var isLoading = false.obs;

  final eventName = TextEditingController();
  final eventLocation = TextEditingController();

  final startDate = ''.obs;
  final endDate = ''.obs;
  final startTime = ''.obs;
  final endTime = ''.obs;

  final bannerImage = Rx<File?>(null);

  final box = GetStorage();
  final picker = ImagePicker();

  DateTime? _selectedStartDate;

  final stateList = <String>[].obs;
  final districtList = <String>[].obs;
  final areaList = <String>[].obs;

  final isLoadingStates = false.obs;
  final isLoadingDistricts = false.obs;
  final isLoadingAreas = false.obs;

  final selectedState = Rx<String?>(null);
  final selectedDistrict = Rx<String?>(null);
  final selectedArea = Rx<String?>(null);

  final showMode = 'district'.obs;

  static const _baseUrl = 'https://rasma.astradevelops.in/e_shoppyy/public/api';
  static const _statesUrl = '$_baseUrl/merchant/states';
  static const _districtsUrl = '$_baseUrl/districts';
  static const _areasUrl = '$_baseUrl/areas';
  static const _createUrl = '$_baseUrl/create-event';

  String get _token => box.read('auth_token')?.toString().trim() ?? '';

  Map<String, String> get _headers => {
    'Accept': 'application/json',
    'Authorization': 'Bearer $_token',
  };

  // ───────── TOKEN CHECK ─────────
  bool _checkAuth() {
    if (_token.isEmpty) {
      Get.offAllNamed('/login');
      return false;
    }
    return true;
  }

  @override
  void onInit() {
    super.onInit();
    fetchStates();
    fetchDistricts();
    fetchAreas();
  }

  @override
  void onClose() {
    eventName.dispose();
    eventLocation.dispose();
    super.onClose();
  }

  void setShowMode(String mode) {
    showMode.value = mode;
    selectedState.value = null;
    selectedDistrict.value = null;
    selectedArea.value = null;
  }

  // ───────── STATES ─────────
  Future<void> fetchStates() async {
    if (!_checkAuth()) return;

    isLoadingStates.value = true;
    try {
      final response = await http.get(Uri.parse(_statesUrl), headers: _headers);

      if (response.statusCode == 200) {
        final body = jsonDecode(response.body);

        if ((body['status'] == true || body['status'] == 1) && body['data'] != null) {
          stateList.value = List<String>.from(body['data']);
        }
      } else {
        AppSnackbar.error(ApiErrorHandler.handleResponse(response));
      }
    } catch (e) {
      AppSnackbar.error(ApiErrorHandler.handleException(e));
    } finally {
      isLoadingStates.value = false;
    }
  }

  // ───────── DISTRICTS ─────────
  Future<void> fetchDistricts() async {
    if (!_checkAuth()) return;

    isLoadingDistricts.value = true;
    try {
      final response = await http.get(Uri.parse(_districtsUrl), headers: _headers);

      if (response.statusCode == 200) {
        final body = jsonDecode(response.body);

        if (body['status'] == true && body['data'] != null) {
          districtList.value = List<String>.from(body['data']);
        }
      } else {
        AppSnackbar.error(ApiErrorHandler.handleResponse(response));
      }
    } catch (e) {
      AppSnackbar.error(ApiErrorHandler.handleException(e));
    } finally {
      isLoadingDistricts.value = false;
    }
  }

  // ───────── AREAS ─────────
  Future<void> fetchAreas() async {
    if (!_checkAuth()) return;

    isLoadingAreas.value = true;
    try {
      final response = await http.get(Uri.parse(_areasUrl), headers: _headers);

      if (response.statusCode == 200) {
        final body = jsonDecode(response.body);

        if (body['status'] == true && body['data'] != null) {
          areaList.value = List<String>.from(body['data']);
        }
      } else {
        AppSnackbar.error(ApiErrorHandler.handleResponse(response));
      }
    } catch (e) {
      AppSnackbar.error(ApiErrorHandler.handleException(e));
    } finally {
      isLoadingAreas.value = false;
    }
  }

  // ───────── IMAGE PICK WITH 2:1 RATIO ─────────
  Future<void> pickBannerImage() async {
    final picked = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 85,
    );

    if (picked == null) return;

    File file = File(picked.path);

    // 1️⃣ SIZE CHECK (1MB limit)
    final int bytes = await file.length();
    if (bytes > 1024 * 1024) {
      AppSnackbar.error("Please upload an image less than 1 MB");
      return;
    }

    // 2️⃣ CROP IMAGE (2:1 RATIO)
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

    // 3️⃣ FINAL ASSIGN
    bannerImage.value = file;
  }

  void removeBannerImage() => bannerImage.value = null;

  // ───────── DATE TIME ─────────
  Future<void> pickStartDate(BuildContext context) async {
    final date = await showDatePicker(
      context: context,
      firstDate: DateTime.now(),
      lastDate: DateTime(2035),
      initialDate: DateTime.now(),
    );

    if (date != null) {
      _selectedStartDate = date;
      startDate.value = _formatDate(date);
      endDate.value = '';
    }
  }

  Future<void> pickEndDate(BuildContext context) async {
    if (_selectedStartDate == null) {
      AppSnackbar.error('Select start date first');
      return;
    }

    final date = await showDatePicker(
      context: context,
      firstDate: _selectedStartDate!,
      lastDate: DateTime(2035),
      initialDate: _selectedStartDate!,
    );

    if (date != null) endDate.value = _formatDate(date);
  }

  Future<void> pickStartTime(BuildContext context) async {
    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (time != null) startTime.value = _formatTime(time);
  }

  Future<void> pickEndTime(BuildContext context) async {
    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (time != null) endTime.value = _formatTime(time);
  }

  // ───────── VALIDATION ─────────
  String? validate() {
    if (eventName.text.trim().isEmpty) return 'Enter event name';
    if (eventLocation.text.trim().isEmpty) return 'Enter event location';
    if (startDate.value.isEmpty) return 'Select start date';
    if (endDate.value.isEmpty) return 'Select end date';
    if (startTime.value.isEmpty) return 'Select start time';
    if (endTime.value.isEmpty) return 'Select end time';
    if (bannerImage.value == null) return 'Upload banner image';
    if (selectedState.value == null) return 'Select a state';
    if (selectedDistrict.value == null) return 'Select a district';
    if (showMode.value == 'area' && selectedArea.value == null) {
      return 'Select an area';
    }
    return null;
  }

  // ───────── ADD EVENT ─────────
  Future<void> addEvent() async {
    if (!_checkAuth()) return;

    final err = validate();
    if (err != null) {
      AppSnackbar.error(err);
      return;
    }

    try {
      isLoading.value = true;

      final imgBytes = await bannerImage.value!.readAsBytes();
      final imgBase64 = 'data:image/jpeg;base64,${base64Encode(imgBytes)}';

      final body = {
        'event_name': eventName.text.trim(),
        'start_date': startDate.value,
        'end_date': endDate.value,
        'start_time': startTime.value,
        'end_time': endTime.value,
        'event_location': eventLocation.text.trim(),
        'state': selectedState.value ?? '',
        'district': selectedDistrict.value ?? '',
        'banner_image': imgBase64,
      };

      if (showMode.value == 'area') {
        body['main_location'] = selectedArea.value ?? '';
      }

      final response = await http.post(
        Uri.parse(_createUrl),
        headers: {..._headers, 'Content-Type': 'application/json'},
        body: jsonEncode(body),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final res = jsonDecode(response.body);

        final newEvent = AdminaddEventModel.fromJson(res['data']);
        events.insert(0, newEvent);

        clearForm();
        Get.back(result: true);

        AppSnackbar.success(res['message'] ?? 'Event created successfully');
      } else {
        AppSnackbar.error(ApiErrorHandler.handleResponse(response));
      }
    } catch (e) {
      AppSnackbar.error(ApiErrorHandler.handleException(e));
    } finally {
      isLoading.value = false;
    }
  }

  void clearForm() {
    eventName.clear();
    eventLocation.clear();
    startDate.value = '';
    endDate.value = '';
    startTime.value = '';
    endTime.value = '';
    bannerImage.value = null;
    _selectedStartDate = null;
    selectedState.value = null;
    selectedDistrict.value = null;
    selectedArea.value = null;
    showMode.value = 'district';
  }

  String _formatDate(DateTime d) =>
      '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';

  String _formatTime(TimeOfDay t) {
    final hour = t.hourOfPeriod == 0 ? 12 : t.hourOfPeriod;
    final minute = t.minute.toString().padLeft(2, '0');
    final period = t.period == DayPeriod.am ? 'AM' : 'PM';
    return '$hour:$minute $period';
  }
}