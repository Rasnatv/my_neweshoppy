
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

import '../view/districtadmin_home.dart';
import 'districtadmin_eventgettingcontroller.dart';

// TODO: replace with your actual district admin home page import
// import '../view/district_adminhome.dart';

class DistrictAdminUpdateEventController extends GetxController {
  final _box = GetStorage();

  // ─── API URLs ─────────────────────────────────────
  static const String _eventFetchUrl =
      'https://rasma.astradevelops.in/e_shoppyy/public/api/district-admin/event';
  static const String _eventUpdateUrl =
      'https://rasma.astradevelops.in/e_shoppyy/public/api/district-admin/event/update';

  // ─── Observables ──────────────────────────────────
  final isLoading      = false.obs;
  final isEventLoading = false.obs;

  /// Locked — comes from API, user cannot edit
  final lockedDistrict = RxnString();

  final startDate = RxnString();
  final endDate   = RxnString();
  final startTime = RxnString();
  final endTime   = RxnString();

  final pickedImage       = Rxn<File>();
  final existingBannerUrl = RxnString();
  final imageChanged      = false.obs;

  // ─── Text Controllers ─────────────────────────────
  final eventName     = TextEditingController();
  final eventLocation = TextEditingController();

  // ─── Lifecycle ────────────────────────────────────
  @override
  void onClose() {
    eventName.dispose();
    eventLocation.dispose();
    super.onClose();
  }

  // ─── Auth ─────────────────────────────────────────
  String get _authToken => _box.read('auth_token') ?? '';

  Map<String, String> get _jsonHeaders => {
    'Authorization': 'Bearer $_authToken',
    'Accept'       : 'application/json',
    'Content-Type' : 'application/json',
  };

  // ─── Fetch Event ──────────────────────────────────
  Future<void> fetchEvent(String eventId) async {
    if (_authToken.isEmpty) { _handleUnauthorized(); return; }
    try {
      isEventLoading.value = true;
      final response = await http.post(
        Uri.parse(_eventFetchUrl),
        headers: _jsonHeaders,
        body   : jsonEncode({'event_id': int.tryParse(eventId) ?? eventId}),
      );
      final body = jsonDecode(response.body);
      if (response.statusCode == 200 && body['status'] == true) {
        _prefillFromResponse(body['data']);
      } else if (response.statusCode == 401) {
        _handleUnauthorized();
      } else {
        _showError('Error', body['message'] ?? 'Failed to fetch event');
      }
    } catch (e) {
      _showError('Network Error', e.toString());
    } finally {
      isEventLoading.value = false;
    }
  }

  // ─── Prefill ──────────────────────────────────────
  void _prefillFromResponse(Map<String, dynamic> data) {
    eventName.text          = data['event_name']     ?? '';
    eventLocation.text      = data['event_location'] ?? '';
    startDate.value         = data['start_date'];
    endDate.value           = data['end_date'];
    startTime.value         = data['start_time'];
    endTime.value           = data['end_time'];
    existingBannerUrl.value = data['banner_image'];
    lockedDistrict.value    = data['district'];   // ← locked, display-only
    imageChanged.value      = false;
  }

  // ─── Pick Image ───────────────────────────────────
  Future<void> pickImage() async {
    final picked = await ImagePicker().pickImage(
      source      : ImageSource.gallery,
      imageQuality: 85,
    );
    if (picked != null) {
      pickedImage.value  = File(picked.path);
      imageChanged.value = true;
    }
  }

  // ─── Pick Date ────────────────────────────────────
  Future<void> pickDate(BuildContext context, {required bool isStart}) async {
    final today     = DateTime.now();
    final todayOnly = DateTime(today.year, today.month, today.day);

    DateTime initial;
    if (isStart) {
      initial = startDate.value != null
          ? (_parseDate(startDate.value!, todayOnly))
          : todayOnly;
    } else {
      final startParsed = startDate.value != null
          ? _parseDate(startDate.value!, todayOnly)
          : todayOnly;
      initial = endDate.value != null
          ? _parseDate(endDate.value!, startParsed)
          : startParsed;
    }
    if (initial.isBefore(todayOnly)) initial = todayOnly;

    final picked = await showDatePicker(
      context    : context,
      initialDate: initial,
      firstDate  : todayOnly,
      lastDate   : DateTime(2100),
      builder: (context, child) => Theme(
        data: Theme.of(context).copyWith(
          colorScheme: const ColorScheme.light(primary: Color(0xFF4F46E5)),
        ),
        child: child!,
      ),
    );

    if (picked != null) {
      final formatted =
          '${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}';
      if (isStart) {
        startDate.value = formatted;
        if (endDate.value != null) {
          final end = DateTime.tryParse(endDate.value!);
          if (end != null && end.isBefore(picked)) endDate.value = null;
        }
      } else {
        endDate.value = formatted;
      }
    }
  }

  // ─── Pick Time ────────────────────────────────────
  Future<void> pickTime(BuildContext context, {required bool isStart}) async {
    TimeOfDay initial = TimeOfDay.now();
    final existing = isStart ? startTime.value : endTime.value;
    if (existing != null) {
      final parsed = _parseTimeOfDay(existing);
      if (parsed != null) initial = parsed;
    }

    final picked = await showTimePicker(
      context    : context,
      initialTime: initial,
      builder: (context, child) => Theme(
        data: Theme.of(context).copyWith(
          colorScheme: const ColorScheme.light(primary: Color(0xFF4F46E5)),
        ),
        child: child!,
      ),
    );

    if (picked != null) {
      final formatted = _formatTimeOfDay(picked);
      if (isStart) {
        startTime.value = formatted;
      } else {
        endTime.value = formatted;
      }
    }
  }

  // ─── Update Event ─────────────────────────────────
  Future<void> updateEvent(String eventId) async {
    if (_authToken.isEmpty) { _handleUnauthorized(); return; }

    if (eventName.text.trim().isEmpty ||
        eventLocation.text.trim().isEmpty ||
        startDate.value == null ||
        endDate.value   == null ||
        startTime.value == null ||
        endTime.value   == null) {
      _showError('Validation', 'Please fill all fields');
      return;
    }

    try {
      isLoading.value = true;

      String? base64Image;
      if (imageChanged.value && pickedImage.value != null) {
        final bytes = await pickedImage.value!.readAsBytes();
        final ext   = pickedImage.value!.path.split('.').last.toLowerCase();
        final mime  = ext == 'png' ? 'image/png'
            : ext == 'gif' ? 'image/gif'
            : 'image/jpeg';
        base64Image = 'data:$mime;base64,${base64Encode(bytes)}';
      }

      final Map<String, dynamic> requestBody = {
        'event_id'      : int.tryParse(eventId) ?? eventId,
        'event_name'    : eventName.text.trim(),
        'event_location': eventLocation.text.trim(),
        'start_date'    : startDate.value,
        'end_date'      : endDate.value,
        'start_time'    : startTime.value,
        'end_time'      : endTime.value,
        // district is sent as-is from the API — user cannot edit it
        if (lockedDistrict.value != null) 'district': lockedDistrict.value,
        if (base64Image != null) 'banner_image': base64Image,
      };

      final response = await http.put(
        Uri.parse(_eventUpdateUrl),
        headers: _jsonHeaders,
        body   : jsonEncode(requestBody),
      );

      final body = jsonDecode(response.body);


      if (response.statusCode == 200 && body['status'] == true) {
        _showSuccess('Success', body['message'] ?? 'Event updated successfully');
        await Future.delayed(const Duration(milliseconds: 300));

        // ✅ Directly trigger fetchEvents on the list controller before going back
        if (Get.isRegistered<DistrictAdminGettingEventController>()) {
          Get.find<DistrictAdminGettingEventController>().fetchEvents();
        }

        Get.toNamed('/districtadminhome');
      } else if (response.statusCode == 401) {
        _handleUnauthorized();
      } else {
        _showError('Error', body['message'] ?? 'Update failed');
      }
    } catch (e) {
      _showError('Network Error', e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  // ─── Time Helpers ─────────────────────────────────
  TimeOfDay? _parseTimeOfDay(String time) {
    try {
      final parts  = time.trim().split(' ');
      final isPM   = parts.last.toUpperCase() == 'PM';
      final hm     = parts.first.split(':');
      int hour     = int.parse(hm[0]);
      final minute = int.parse(hm[1]);
      if (isPM && hour != 12) hour += 12;
      if (!isPM && hour == 12) hour = 0;
      return TimeOfDay(hour: hour, minute: minute);
    } catch (_) { return null; }
  }

  String _formatTimeOfDay(TimeOfDay t) {
    final period = t.period == DayPeriod.am ? 'AM' : 'PM';
    final hour   = t.hourOfPeriod == 0 ? 12 : t.hourOfPeriod;
    final minute = t.minute.toString().padLeft(2, '0');
    return '$hour:$minute $period';
  }

  DateTime _parseDate(String value, DateTime fallback) =>
      DateTime.tryParse(value) ?? fallback;

  // ─── Auth / UI Helpers ────────────────────────────
  void _handleUnauthorized() {
    _box.erase();
    Get.offAllNamed('/login');
  }

  void _showError(String title, String message) => Get.snackbar(
    title, message,
    backgroundColor: Colors.red.shade50,
    colorText      : Colors.red.shade800,
    snackPosition  : SnackPosition.TOP,
  );

  void _showSuccess(String title, String message) => Get.snackbar(
    title, message,
    backgroundColor: Colors.green.shade50,
    colorText      : Colors.green.shade800,
    snackPosition  : SnackPosition.TOP,
  );
}



