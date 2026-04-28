
import 'dart:convert';
import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

import '../../../../data/errors/api_error.dart';
import '../../../../data/models/merchant_eventupadatemodel.dart';
  // ← adjust path
import '../../../merchantlogin/widget/successwidget.dart';
import '../view/admin_event.dart';

class AdminEventUpdateController extends GetxController {
  // ─── State ────────────────────────────────────────────────────────────────
  final isLoading  = false.obs;
  final isUpdating = false.obs;
  final event      = Rxn<HEventModel>();
  final showMode   = "district".obs;

  // ─── Form key & controllers ───────────────────────────────────────────────
  final formKey = GlobalKey<FormState>();
  late TextEditingController eventNameCtrl;
  late TextEditingController locationCtrl;

  // ─── Region dropdowns ─────────────────────────────────────────────────────
  final statesList    = <String>[].obs;
  final districtsList = <String>[].obs;
  final areasList     = <String>[].obs;

  final selectedState    = RxnString();
  final selectedDistrict = RxnString();
  final selectedArea     = RxnString();

  final isLoadingStates    = false.obs;
  final isLoadingDistricts = false.obs;
  final isLoadingAreas     = false.obs;

  // ─── Date / time observables ──────────────────────────────────────────────
  final startDate = Rxn<DateTime>();
  final endDate   = Rxn<DateTime>();
  final startTime = Rxn<TimeOfDay>();
  final endTime   = Rxn<TimeOfDay>();

  // ─── Banner image ─────────────────────────────────────────────────────────
  final pickedImageFile   = Rxn<File>();
  final pickedImageBase64 = RxnString();

  // ─── API ──────────────────────────────────────────────────────────────────
  static const _baseUrl =
      'https://eshoppy.co.in/api';

  final _box = GetStorage();

  Map<String, String> get _authHeaders {
    final token = _box.read<String>('auth_token') ?? '';
    return {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
  }

  // ─── Lifecycle ────────────────────────────────────────────────────────────
  @override
  void onInit() {
    super.onInit();
    eventNameCtrl = TextEditingController();
    locationCtrl  = TextEditingController();

    fetchStates();
    fetchDistricts();
    fetchAreas();

    final Map<String, dynamic>? args = Get.arguments != null
        ? Map<String, dynamic>.from(Get.arguments as Map)
        : null;
    final dynamic raw     = args?['event_id'];
    final int?    eventId = raw == null
        ? null
        : raw is int
        ? raw
        : int.tryParse(raw.toString());

    if (eventId != null) {
      fetchEvent(eventId);
    } else {
      AppSnackbar.error('Invalid event ID');
    }
  }

  @override
  void onClose() {
    eventNameCtrl.dispose();
    locationCtrl.dispose();
    super.onClose();
  }

  // ─── Fetch dropdowns ──────────────────────────────────────────────────────
  Future<void> fetchStates() async {
    try {
      isLoadingStates.value = true;
      final response = await http.get(
        Uri.parse('$_baseUrl/get-states'),
        headers: _authHeaders,
      );
      if (response.statusCode == 200) {
        final body = jsonDecode(response.body);
        if (body['status'] == true) {
          statesList.assignAll(List<String>.from(body['data']));
          _validateSelectedState();
        } else {
          AppSnackbar.error(body['message'] ?? 'Failed to load states');
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

  Future<void> fetchDistricts() async {
    try {
      isLoadingDistricts.value = true;
      final response = await http.get(
        Uri.parse('$_baseUrl/districts'),
        headers: _authHeaders,
      );
      if (response.statusCode == 200) {
        final body = jsonDecode(response.body);
        if (body['status'] == true) {
          districtsList.assignAll(List<String>.from(body['data']));
          _validateSelectedDistrict();
        } else {
          AppSnackbar.error(body['message'] ?? 'Failed to load districts');
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

  Future<void> fetchAreas() async {
    try {
      isLoadingAreas.value = true;
      final response = await http.get(
        Uri.parse('$_baseUrl/areas'),
        headers: _authHeaders,
      );
      if (response.statusCode == 200) {
        final body = jsonDecode(response.body);
        if (body['status'] == true) {
          areasList.assignAll(List<String>.from(body['data']));
          _validateSelectedArea();
        } else {
          AppSnackbar.error(body['message'] ?? 'Failed to load areas');
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

  void _validateSelectedState() {
    if (selectedState.value == null) return;
    final match = statesList.firstWhereOrNull(
          (s) => s.toLowerCase() == selectedState.value!.toLowerCase(),
    );
    selectedState.value = match ?? selectedState.value;
  }

  void _validateSelectedDistrict() {
    if (selectedDistrict.value == null) return;
    final match = districtsList.firstWhereOrNull(
          (d) => d.toLowerCase() == selectedDistrict.value!.toLowerCase(),
    );
    selectedDistrict.value = match ?? selectedDistrict.value;
  }

  void _validateSelectedArea() {
    if (selectedArea.value == null) return;
    final match = areasList.firstWhereOrNull(
          (a) => a.toLowerCase() == selectedArea.value!.toLowerCase(),
    );
    selectedArea.value = match ?? selectedArea.value;
  }

  // ─── Mode toggle ──────────────────────────────────────────────────────────
  void switchToDistrict() {
    showMode.value     = "district";
    selectedArea.value = null;
  }

  void switchToArea() {
    showMode.value = "area";
  }

  // ─── Display helpers ──────────────────────────────────────────────────────
  String get formattedStartDate => startDate.value != null
      ? DateFormat('yyyy-MM-dd').format(startDate.value!)
      : '';

  String get formattedEndDate => endDate.value != null
      ? DateFormat('yyyy-MM-dd').format(endDate.value!)
      : '';

  String get displayStartDate => startDate.value != null
      ? DateFormat('MMM dd, yyyy').format(startDate.value!)
      : 'Select date';

  String get displayEndDate => endDate.value != null
      ? DateFormat('MMM dd, yyyy').format(endDate.value!)
      : 'Select date';

  String get displayStartTime => startTime.value != null
      ? startTime.value!.format(Get.context!)
      : 'Select time';

  String get displayEndTime => endTime.value != null
      ? endTime.value!.format(Get.context!)
      : 'Select time';

  String _formatTime(TimeOfDay time) {
    final now = DateTime.now();
    final dt  = DateTime(now.year, now.month, now.day, time.hour, time.minute);
    return DateFormat('hh:mm a').format(dt);
  }

  TimeOfDay? _parseTime(String? t) {
    if (t == null || t.isEmpty) return null;
    try {
      final dt = DateFormat('hh:mm a').parse(t);
      return TimeOfDay(hour: dt.hour, minute: dt.minute);
    } catch (_) {
      try {
        final dt = DateFormat('HH:mm').parse(t);
        return TimeOfDay(hour: dt.hour, minute: dt.minute);
      } catch (_) {
        return null;
      }
    }
  }

  // ─── Populate form ────────────────────────────────────────────────────────
  void _populateForm(HEventModel e) {
    eventNameCtrl.text = e.eventName;
    locationCtrl.text  = e.eventLocation;
    startDate.value    = DateTime.tryParse(e.startDate);
    endDate.value      = DateTime.tryParse(e.endDate);
    startTime.value    = _parseTime(e.startTime);
    endTime.value      = _parseTime(e.endTime);

    selectedState.value    = (e.state != null && e.state!.isNotEmpty)
        ? e.state : null;
    selectedDistrict.value = (e.district != null && e.district!.isNotEmpty)
        ? e.district : null;

    if (e.mainLocation != null && e.mainLocation!.isNotEmpty) {
      showMode.value     = "area";
      selectedArea.value = e.mainLocation;
    } else {
      showMode.value     = "district";
      selectedArea.value = null;
    }

    _validateSelectedState();
    _validateSelectedDistrict();
    _validateSelectedArea();
  }

  // ─── Fetch event ──────────────────────────────────────────────────────────
  Future<void> fetchEvent(int eventId) async {
    try {
      isLoading.value = true;
      final response = await http.post(
        Uri.parse('$_baseUrl/get-single-event'),
        headers: _authHeaders,
        body: jsonEncode({'event_id': eventId}),
      );
      if (response.statusCode == 200) {
        final body = jsonDecode(response.body);
        if (body['status'] == '1') {
          event.value = HEventModel.fromJson(body['data']);
          _populateForm(event.value!);
        } else {
          AppSnackbar.error(body['message'] ?? 'Failed to fetch event');
        }
      } else {
        AppSnackbar.error(ApiErrorHandler.handleResponse(response));
      }
    } catch (e) {
      AppSnackbar.error(ApiErrorHandler.handleException(e));
    } finally {
      isLoading.value = false;
    }
  }

  // ─── Banner image pick ────────────────────────────────────────────────────
  Future<void> pickBannerImage() async {
    try {
      final picker  = ImagePicker();
      final picked  = await picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 85,
      );
      if (picked == null) return;

      File file = File(picked.path);

      if (await file.length() > 1024 * 1024) {
        AppSnackbar.error('Please upload image less than 1 MB');
        return;
      }

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

      if (await file.length() > 1024 * 1024) {
        AppSnackbar.error('Cropped image still exceeds 1 MB');
        return;
      }

      final rawBytes = await file.readAsBytes();
      final ext      = file.path.split('.').last.toLowerCase();
      final mime     = ext == 'png' ? 'image/png' : 'image/jpeg';

      pickedImageFile.value   = file;
      pickedImageBase64.value = 'data:$mime;base64,${base64Encode(rawBytes)}';
    } catch (e) {
      AppSnackbar.error('Something went wrong while picking image');
    }
  }

  // ─── Date pickers ─────────────────────────────────────────────────────────
  Future<void> selectStartDate(BuildContext context) async {
    final now         = DateTime.now();
    final today       = DateTime(now.year, now.month, now.day);
    final safeInitial = (startDate.value != null &&
        !startDate.value!.isBefore(today))
        ? startDate.value!
        : today;

    final picked = await showDatePicker(
      context: context,
      initialDate: safeInitial,
      firstDate: today,
      lastDate: DateTime(2030),
    );

    if (picked != null) {
      startDate.value = picked;
      if (endDate.value != null) {
        final endOnly = DateTime(
            endDate.value!.year, endDate.value!.month, endDate.value!.day);
        if (endOnly.isBefore(picked)) {
          endDate.value = null;
          endTime.value = null;
          AppSnackbar.warning(
            'End date & time were reset because they were before the new start date.',
          );
        }
      }
    }
  }

  Future<void> selectEndDate(BuildContext context) async {
    final now       = DateTime.now();
    final today     = DateTime(now.year, now.month, now.day);
    final firstDate = (startDate.value != null &&
        startDate.value!.isAfter(today))
        ? startDate.value!
        : today;

    DateTime safeInitial;
    if (endDate.value != null) {
      final endOnly = DateTime(
          endDate.value!.year, endDate.value!.month, endDate.value!.day);
      safeInitial = endOnly.isBefore(firstDate) ? firstDate : endDate.value!;
    } else {
      safeInitial = firstDate;
    }

    final picked = await showDatePicker(
      context: context,
      initialDate: safeInitial,
      firstDate: firstDate,
      lastDate: DateTime(2030),
    );
    if (picked != null) endDate.value = picked;
  }

  // ─── Time pickers ─────────────────────────────────────────────────────────
  Future<void> selectStartTime(BuildContext context) async {
    final picked = await showTimePicker(
      context: context,
      initialTime: startTime.value ?? TimeOfDay.now(),
    );
    if (picked != null) {
      startTime.value = picked;
      if (endTime.value != null && _isSameDay()) {
        final sMin = picked.hour * 60 + picked.minute;
        final eMin = endTime.value!.hour * 60 + endTime.value!.minute;
        if (eMin <= sMin) {
          endTime.value = null;
          AppSnackbar.warning(
            'End time was reset because it was not after the new start time.',
          );
        }
      }
    }
  }

  Future<void> selectEndTime(BuildContext context) async {
    final picked = await showTimePicker(
      context: context,
      initialTime: endTime.value ?? TimeOfDay.now(),
    );
    if (picked != null) {
      if (_isSameDay() && startTime.value != null) {
        final sMin = startTime.value!.hour * 60 + startTime.value!.minute;
        final eMin = picked.hour * 60 + picked.minute;
        if (eMin <= sMin) {
          AppSnackbar.error('End time must be after start time.');
          return;
        }
      }
      endTime.value = picked;
    }
  }

  bool _isSameDay() {
    final s = startDate.value;
    final e = endDate.value;
    if (s == null || e == null) return false;
    return s.year == e.year && s.month == e.month && s.day == e.day;
  }

  // ─── Update event ─────────────────────────────────────────────────────────
  Future<void> updateEvent() async {
    if (!formKey.currentState!.validate()) return;
    if (startDate.value == null || endDate.value == null) {
      AppSnackbar.error('Please select start and end dates');
      return;
    }
    if (startTime.value == null || endTime.value == null) {
      AppSnackbar.error('Please select start and end times');
      return;
    }
    if (showMode.value == "area" && selectedArea.value == null) {
      AppSnackbar.error('Please select an area');
      return;
    }

    try {
      isUpdating.value = true;

      final payload = <String, dynamic>{
        'event_id'      : int.parse(event.value!.id),
        'event_name'    : eventNameCtrl.text.trim(),
        'start_date'    : formattedStartDate,
        'end_date'      : formattedEndDate,
        'start_time'    : _formatTime(startTime.value!),
        'end_time'      : _formatTime(endTime.value!),
        'event_location': locationCtrl.text.trim(),
        if (selectedState.value != null)    'state'    : selectedState.value!,
        if (selectedDistrict.value != null) 'district' : selectedDistrict.value!,
        if (showMode.value == "area" && selectedArea.value != null)
          'main_location': selectedArea.value!,
      };

      if (pickedImageBase64.value != null) {
        payload['banner_image'] = pickedImageBase64.value!;
      }

      final response = await http.put(
        Uri.parse('$_baseUrl/update-event'),
        headers: _authHeaders,
        body: jsonEncode(payload),
      );

      if (response.statusCode == 200) {
        final body = jsonDecode(response.body);
        if (body['status'] == '1') {
          event.value = HEventModel.fromJson(body['data']);
          AppSnackbar.success(body['message'] ?? 'Event updated successfully');
          Get.back(result: true);
        } else {
          AppSnackbar.error(body['message'] ?? 'Failed to update event');
        }
      } else {
        AppSnackbar.error(ApiErrorHandler.handleResponse(response));
      }
    } catch (e) {
      AppSnackbar.error(ApiErrorHandler.handleException(e));
    } finally {
      isUpdating.value = false;
    }
  }
}
