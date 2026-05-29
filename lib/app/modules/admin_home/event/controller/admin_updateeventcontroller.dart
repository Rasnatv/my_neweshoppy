
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

import '../../../../data/errors/api_error.dart';
import '../../../../data/models/merchant_eventupadatemodel.dart';
import '../../../merchantlogin/widget/successwidget.dart';

class AdminEventUpdateController extends GetxController {
  // ─── State ────────────────────────────────────────────────────────────────
  final isLoading = false.obs;
  final isUpdating = false.obs;
  final event = Rxn<HEventModel>();
  final showMode = "district".obs;

  // ─── Form key & controllers ───────────────────────────────────────────────
  final formKey = GlobalKey<FormState>();
  late TextEditingController eventNameCtrl;
  late TextEditingController locationCtrl;

  // ─── Region dropdowns ─────────────────────────────────────────────────────
  final statesList = <String>[].obs;
  final districtsList = <String>[].obs;
  final areasList = <String>[].obs;

  final selectedState = RxnString();
  final selectedDistrict = RxnString();
  final selectedArea = RxnString();

  final isLoadingStates = false.obs;
  final isLoadingDistricts = false.obs;
  final isLoadingAreas = false.obs;

  // ─── Date / time observables ──────────────────────────────────────────────
  final startDate = Rxn<DateTime>();
  final endDate = Rxn<DateTime>();
  final startTime = Rxn<TimeOfDay>();
  final endTime = Rxn<TimeOfDay>();

  // ─── Banner image ─────────────────────────────────────────────────────────
  final pickedImageFile = Rxn<File>();
  final pickedImageBase64 = RxnString();

  // ─── API ──────────────────────────────────────────────────────────────────
  static const _baseUrl = 'https://eshoppy.co.in/api';

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
    locationCtrl = TextEditingController();

    // ── Fetch states first ──
    fetchStates();

    // ── Auto-fetch districts when state changes ──
    ever(selectedState, (String? state) {
      // Don't cascade if we're still populating from fetchEvent
      if (_isPopulating) return;

      selectedDistrict.value = null;
      selectedArea.value = null;
      districtsList.clear();
      areasList.clear();

      if (state != null && state.isNotEmpty) {
        fetchDistricts(state);
      }
    });

    // ── Auto-fetch areas when district changes (only in area mode) ──
    ever(selectedDistrict, (String? district) {
      if (_isPopulating) return;

      selectedArea.value = null;
      areasList.clear();

      if (district != null &&
          district.isNotEmpty &&
          showMode.value == 'area') {
        fetchAreas(district);
      }
    });

    // ── Re-fetch areas when switching TO area mode ──
    ever(showMode, (String mode) {
      if (_isPopulating) return;

      if (mode == 'area' &&
          selectedDistrict.value != null &&
          selectedDistrict.value!.isNotEmpty) {
        fetchAreas(selectedDistrict.value!);
      } else if (mode == 'district') {
        selectedArea.value = null;
        areasList.clear();
      }
    });

    // ── Load event from args ──
    final Map<String, dynamic>? args = Get.arguments != null
        ? Map<String, dynamic>.from(Get.arguments as Map)
        : null;
    final dynamic raw = args?['event_id'];
    final int? eventId = raw == null
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

  // ─── Populate guard ───────────────────────────────────────────────────────
  // Prevents ever() listeners from firing cascading fetches during _populateForm
  bool _isPopulating = false;

  // ─── Fetch states ─────────────────────────────────────────────────────────
  Future<void> fetchStates() async {
    try {
      isLoadingStates.value = true;
      final response = await http.get(
        Uri.parse('$_baseUrl/get-states'),
        headers: _authHeaders,
      );
      if (response.statusCode == 200) {
        final body = jsonDecode(response.body);
        if (body['status'] == true || body['status'] == 1) {
          statesList.assignAll(List<String>.from(body['data']));
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

  // ─── Fetch districts (POST with state) ───────────────────────────────────
  Future<void> fetchDistricts(String state) async {
    try {
      isLoadingDistricts.value = true;
      final response = await http.post(
        Uri.parse('$_baseUrl/districts'),
        headers: _authHeaders,
        body: jsonEncode({'state': state}),
      );
      if (response.statusCode == 200) {
        final body = jsonDecode(response.body);
        if (body['status'] == true || body['status'] == 1) {
          districtsList.assignAll(List<String>.from(body['data']));
          // Re-validate in case pre-selected district is in the new list
          _revalidateDistrict();
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

  // ─── Fetch areas (POST with district) ────────────────────────────────────
  Future<void> fetchAreas(String district) async {
    try {
      isLoadingAreas.value = true;
      final response = await http.post(
        Uri.parse('$_baseUrl/areas'),
        headers: _authHeaders,
        body: jsonEncode({'district': district}),
      );
      if (response.statusCode == 200) {
        final body = jsonDecode(response.body);
        if (body['status'] == true || body['status'] == 1) {
          areasList.assignAll(List<String>.from(body['data']));
          // Re-validate in case pre-selected area is in the new list
          _revalidateArea();
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

  // ─── Case-insensitive re-validation helpers ───────────────────────────────
  void _revalidateDistrict() {
    if (selectedDistrict.value == null) return;
    final match = districtsList.firstWhereOrNull(
          (d) => d.toLowerCase() == selectedDistrict.value!.toLowerCase(),
    );
    if (match != null) selectedDistrict.value = match;
  }

  void _revalidateArea() {
    if (selectedArea.value == null) return;
    final match = areasList.firstWhereOrNull(
          (a) => a.toLowerCase() == selectedArea.value!.toLowerCase(),
    );
    if (match != null) selectedArea.value = match;
  }

  // ─── Mode toggle ──────────────────────────────────────────────────────────
  void switchToDistrict() {
    showMode.value = "district";
    selectedArea.value = null;
    areasList.clear();
  }

  void switchToArea() {
    showMode.value = "area";
    // ever(showMode) listener will trigger fetchAreas if district is set
  }

  // ─── Display helpers ──────────────────────────────────────────────────────
  String get formattedStartDate =>
      startDate.value != null
          ? DateFormat('yyyy-MM-dd').format(startDate.value!)
          : '';

  String get formattedEndDate =>
      endDate.value != null
          ? DateFormat('yyyy-MM-dd').format(endDate.value!)
          : '';

  String get displayStartDate =>
      startDate.value != null
          ? DateFormat('MMM dd, yyyy').format(startDate.value!)
          : 'Select date';

  String get displayEndDate =>
      endDate.value != null
          ? DateFormat('MMM dd, yyyy').format(endDate.value!)
          : 'Select date';

  String get displayStartTime =>
      startTime.value != null
          ? startTime.value!.format(Get.context!)
          : 'Select time';

  String get displayEndTime =>
      endTime.value != null
          ? endTime.value!.format(Get.context!)
          : 'Select time';

  String _formatTime(TimeOfDay time) {
    final now = DateTime.now();
    final dt = DateTime(now.year, now.month, now.day, time.hour, time.minute);
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
  Future<void> _populateForm(HEventModel e) async {
    // Guard: suppress ever() listeners during population
    _isPopulating = true;

    eventNameCtrl.text = e.eventName;
    locationCtrl.text = e.eventLocation;
    startDate.value = DateTime.tryParse(e.startDate);
    endDate.value = DateTime.tryParse(e.endDate);
    startTime.value = _parseTime(e.startTime);
    endTime.value = _parseTime(e.endTime);

    final hasState = e.state != null && e.state!.isNotEmpty;
    final hasDistrict = e.district != null && e.district!.isNotEmpty;
    final hasArea = e.mainLocation != null && e.mainLocation!.isNotEmpty;

    // Set mode first (no listeners firing due to guard)
    showMode.value = hasArea ? "area" : "district";

    // Set state and fetch districts
    if (hasState) {
      selectedState.value = e.state;
      _isPopulating = false; // Allow fetchDistricts to assign list
      await fetchDistricts(e.state!);
      _isPopulating = true; // Re-enable guard after fetch
    }

    // Set district and fetch areas if needed
    if (hasDistrict) {
      selectedDistrict.value =
          _matchCaseInsensitive(districtsList, e.district!);
      if (hasArea) {
        _isPopulating = false;
        await fetchAreas(e.district!);
        _isPopulating = true;
      }
    }

    // Set area after areasList is populated
    if (hasArea) {
      selectedArea.value = _matchCaseInsensitive(areasList, e.mainLocation!);
    } else {
      selectedArea.value = null;
    }

    _isPopulating = false;
  }

  /// Returns the matching string from [list] (case-insensitive), or [value] as fallback.
  String _matchCaseInsensitive(List<String> list, String value) {
    return list.firstWhereOrNull(
          (item) => item.toLowerCase() == value.toLowerCase(),
    ) ??
        value;
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
          await _populateForm(event.value!);
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
      final picker = ImagePicker();
      final picked = await picker.pickImage(
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
      final ext = file.path
          .split('.')
          .last
          .toLowerCase();
      final mime = ext == 'png' ? 'image/png' : 'image/jpeg';

      pickedImageFile.value = file;
      pickedImageBase64.value = 'data:$mime;base64,${base64Encode(rawBytes)}';
    } catch (e) {
    }
  }

  // ─── Date pickers ─────────────────────────────────────────────────────────
  Future<void> selectStartDate(BuildContext context) async {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
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
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final firstDate =
    (startDate.value != null && startDate.value!.isAfter(today))
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
        'event_id': int.parse(event.value!.id),
        'event_name': eventNameCtrl.text.trim(),
        'start_date': formattedStartDate,
        'end_date': formattedEndDate,
        'start_time': _formatTime(startTime.value!),
        'end_time': _formatTime(endTime.value!),
        'event_location': locationCtrl.text.trim(),
        if (selectedState.value != null) 'state': selectedState.value!,
        if (selectedDistrict.value != null) 'district': selectedDistrict.value!,
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

        // ✅ Handle both '1', 1, and true from API
        final isSuccess = body['status'] == '1' ||
            body['status'] == 1 ||
            body['status'] == true;

        if (isSuccess) {
          event.value = HEventModel.fromJson(body['data']);
          final message = body['message'] ?? 'Event updated successfully';

          // ✅ Navigate back first, then show snackbar on the previous page
          Get.back(result: true);
          Future.delayed(const Duration(milliseconds: 300), () {
            AppSnackbar.success(message);
          });
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
