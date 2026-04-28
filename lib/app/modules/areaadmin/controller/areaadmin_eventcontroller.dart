
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;

import '../../../data/errors/api_error.dart';
import '../../../widgets/areaadminsuccesswidget.dart';
import '../../merchantlogin/widget/successwidget.dart';
import '../view/area_adminhome.dart';

class AreaAdminEventAddController extends GetxController {

  // ─── Form Controllers ─────────────────────────────
  final TextEditingController eventName = TextEditingController();
  final TextEditingController eventLocation = TextEditingController();

  // ─── Observable Fields ────────────────────────────
  final RxString startDate = ''.obs;
  final RxString endDate = ''.obs;
  final RxString startTime = ''.obs;
  final RxString endTime = ''.obs;
  var errorBanner = Rx<String?>(null);

  // ─── Location Observables ─────────────────────────
  final RxString selectedState = ''.obs;
  final RxString selectedDistrict = ''.obs;
  final RxString selectedMainLocation = ''.obs;

  final RxList<String> states = <String>[].obs;
  final RxList<String> districts = <String>[].obs;
  final RxList<String> mainLocations = <String>[].obs;

  // ─── Loading States ───────────────────────────────
  final RxBool isStatesLoading = false.obs;
  final RxBool isDistrictsLoading = false.obs;
  final RxBool isLocationsLoading = false.obs;
  final RxBool isLoading = false.obs;
  final ImagePicker picker = ImagePicker();

  // ─── Image ────────────────────────────────────────
  final Rx<File?> bannerImage = Rx<File?>(null);

  // ─── Storage ──────────────────────────────────────
  final _box = GetStorage();

  // ─── API Base ─────────────────────────────────────
  static const String _baseUrl =
      'https://eshoppy.co.in/api';
  static const String _adminBaseUrl =
      'https://eshoppy.co.in/api/area-admin';

  // ─── Lifecycle ────────────────────────────────────
  @override
  void onInit() {
    super.onInit();
    _initData();
  }

  Future<void> _initData() async {
    if (_authToken.isEmpty) {
      ApiErrorHandler.handleUnauthorized();
      return;
    }
    await Future.wait([fetchStates(), fetchMainLocations()]);
  }

  @override
  void onClose() {
    eventName.dispose();
    eventLocation.dispose();
    super.onClose();
  }

  // ─── Auth Token ───────────────────────────────────
  String get _authToken => _box.read('auth_token') ?? '';

  Map<String, String> get _authHeaders => {
    'Authorization': 'Bearer $_authToken',
    'Accept': 'application/json',
  };

  // ─── Fetch States ─────────────────────────────────
  Future<void> fetchStates() async {
    if (_authToken.isEmpty) {
      ApiErrorHandler.handleUnauthorized();
      return;
    }
    try {
      isStatesLoading.value = true;
      final response = await http.get(
        Uri.parse('$_baseUrl/get-MerchantStates'),
        headers: _authHeaders,
      );

      if (response.statusCode == 200) {
        final body = jsonDecode(response.body);
        if (body['status'].toString() == '1') {
          final List data = body['data'] ?? [];
          states.assignAll(data.map((e) => e.toString()).toList());
        } else {
          AppSnackbar.error(body['message'] ?? 'Failed to load states');
        }
      } else {
        final errorMsg = ApiErrorHandler.handleResponse(response);
        if (response.statusCode != 401) AppSnackbar.error(errorMsg);
      }
    } catch (e) {
      AppSnackbar.error(ApiErrorHandler.handleException(e));
    } finally {
      isStatesLoading.value = false;
    }
  }

  // ─── Fetch Districts ──────────────────────────────
  Future<void> fetchDistricts() async {
    if (_authToken.isEmpty) {
      ApiErrorHandler.handleUnauthorized();
      return;
    }
    try {
      isDistrictsLoading.value = true;
      districts.clear();
      selectedDistrict.value = '';
      selectedMainLocation.value = '';

      final response = await http.get(
        Uri.parse('$_baseUrl/getMerchant-Districts'),
        headers: _authHeaders,
      );

      if (response.statusCode == 200) {
        final body = jsonDecode(response.body);
        if (body['status'].toString() == '1') {
          final List data = body['data'] ?? [];
          // Deduplicate districts (case-insensitive)
          final Set<String> seen = {};
          final List<String> result = [];
          for (var item in data) {
            final d = item['district']?.toString() ?? '';
            if (d.isNotEmpty && seen.add(d.toLowerCase())) {
              result.add(d);
            }
          }
          districts.assignAll(result);
        } else {
          AppSnackbar.error(body['message'] ?? 'Failed to load districts');
        }
      } else {
        final errorMsg = ApiErrorHandler.handleResponse(response);
        if (response.statusCode != 401) AppSnackbar.error(errorMsg);
      }

    } catch (e) {
      AppSnackbar.error(ApiErrorHandler.handleException(e));
    } finally {
      isDistrictsLoading.value = false;
    }
  }

  // ─── Fetch Main Locations ─────────────────────────
  Future<void> fetchMainLocations() async {
    if (_authToken.isEmpty) {
      ApiErrorHandler.handleUnauthorized();
      return;
    }
    try {
      isLocationsLoading.value = true;
      final response = await http.get(
        Uri.parse('$_adminBaseUrl/main-locations'),
        headers: _authHeaders,
      );

      if (response.statusCode == 200) {
        final body = jsonDecode(response.body);
        if (body['status'].toString() == '1') {
          final List data = body['data'] ?? [];
          mainLocations.assignAll(data.map((e) => e.toString()).toList());
        } else {
          AppSnackbar.error(body['message'] ?? 'Failed to load locations');
        }
      } else {
        final errorMsg = ApiErrorHandler.handleResponse(response);
        if (response.statusCode != 401) AppSnackbar.error(errorMsg);
      }

    } catch (e) {
      AppSnackbar.error(ApiErrorHandler.handleException(e));
    } finally {
      isLocationsLoading.value = false;
    }
  }

  // ─── On State Selected ────────────────────────────
  void onStateSelected(String state) {
    selectedState.value = state;
    selectedDistrict.value = '';
    selectedMainLocation.value = '';
    fetchDistricts();
  }

  // ─── Date Pickers ─────────────────────────────────
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
    if (picked != null) endDate.value = DateFormat('yyyy-MM-dd').format(picked);
  }

  // ─── Time Pickers ─────────────────────────────────
  Future<void> pickStartTime(BuildContext context) async {
    final picked =
    await showTimePicker(context: context, initialTime: TimeOfDay.now());
    if (picked != null) startTime.value = picked.format(context);
  }

  Future<void> pickEndTime(BuildContext context) async {
    final picked =
    await showTimePicker(context: context, initialTime: TimeOfDay.now());
    if (picked != null) endTime.value = picked.format(context);
  }

  Widget _datePickerTheme(BuildContext context, Widget? child) {
    return Theme(
      data: Theme.of(context).copyWith(
        colorScheme: const ColorScheme.light(primary: Color(0xFF6C63FF)),
      ),
      child: child!,
    );
  }

  // ─── Image Picker ─────────────────────────────────
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
      AppSnackbar.warning("Image must be less than 1 MB");
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

  // ─── Validate Form ────────────────────────────────
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
    } else if (selectedMainLocation.value.isEmpty) {
      AppSnackbar.warning('Select main location');
      return false;
    } else if (eventLocation.text.trim().isEmpty) {
      AppSnackbar.warning('Enter event location');
      return false;
    } else if (startDate.value.isEmpty || endDate.value.isEmpty) {
      AppSnackbar.warning('Select dates');
      return false;
    } else if (startTime.value.isEmpty || endTime.value.isEmpty) {
      AppSnackbar.warning('Select time');
      return false;
    } else if (bannerImage.value == null) {
      AppSnackbar.warning('Select banner image');
      return false;
    }
    return true;
  }

  // ─── Submit Event ─────────────────────────────────
  Future<void> addEvent() async {
    if (!_validateForm()) return;
    if (_authToken.isEmpty) {
      ApiErrorHandler.handleUnauthorized();
      return;
    }
    try {
      isLoading.value = true;
      final bytes = await bannerImage.value!.readAsBytes();
      final base64Image = 'data:image/jpeg;base64,${base64Encode(bytes)}';

      final body = {
        'event_name': eventName.text.trim(),
        'start_date': startDate.value,
        'end_date': endDate.value,
        'start_time': startTime.value,
        'end_time': endTime.value,
        'state': selectedState.value,
        'district': selectedDistrict.value,
        'main_location': selectedMainLocation.value,
        'event_location': eventLocation.text.trim(),
        'banner_image': base64Image,
      };

      final response = await http.post(
        Uri.parse('$_adminBaseUrl/create-event'),
        headers: {
          ..._authHeaders,
          'Content-Type': 'application/json',
        },
        body: jsonEncode(body),
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        if (responseData['status'].toString() == '1') {
          AppSnackbar.success(
              responseData['message'] ?? 'Event created successfully');
          _resetForm();
          Get.offAll(() => AreaAdminhomepage());
        } else {
          AppSnackbar.error(
              responseData['message'] ?? 'Failed to create event');
        }
      } else {
        final errorMsg = ApiErrorHandler.handleResponse(response);
        if (response.statusCode != 401) AppSnackbar.error(errorMsg);
      }
    } on SocketException {
      AppSnackbar.error(ApiErrorHandler.handleException(SocketException('')));
    } catch (e) {
      AppSnackbar.error(ApiErrorHandler.handleException(e));
    } finally {
      isLoading.value = false;
    }
  }

  // ─── Reset ────────────────────────────────────────
  void _resetForm() {
    eventName.clear();
    eventLocation.clear();
    startDate.value = '';
    endDate.value = '';
    startTime.value = '';
    endTime.value = '';
    selectedState.value = '';
    selectedDistrict.value = '';
    selectedMainLocation.value = '';
    bannerImage.value = null;
  }
}