import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

import '../../../data/models/merchant_eventupadatemodel.dart';

class EventUpdateController extends GetxController {
  // ─── State ────────────────────────────────────────────────────────────────
  final isLoading = false.obs;
  final isUpdating = false.obs;
  final event = Rxn<HEventModel>();

  // ─── Form key & controllers ───────────────────────────────────────────────
  final formKey = GlobalKey<FormState>();

  late TextEditingController eventNameCtrl;
  late TextEditingController locationCtrl;

  // ─── Read-only locked fields ──────────────────────────────────────────────
  final district = RxnString();
  final mainLocation = RxnString();

  // ─── Date / time observables ──────────────────────────────────────────────
  final startDate = Rxn<DateTime>();
  final endDate = Rxn<DateTime>();
  final startTime = Rxn<TimeOfDay>();
  final endTime = Rxn<TimeOfDay>();

  // ─── Banner image ─────────────────────────────────────────────────────────
  final pickedImageFile = Rxn<File>();
  final pickedImageBase64 = RxnString();

  // ─── API base URL ─────────────────────────────────────────────────────────
  static const _baseUrl = 'https://rasma.astradevelops.in/e_shoppyy/public/api';

  // ─── Storage ──────────────────────────────────────────────────────────────
  final _box = GetStorage();

  /// Builds headers with Bearer token read fresh from storage each call.
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
      _showError('Invalid event ID');
    }
  }

  @override
  void onClose() {
    eventNameCtrl.dispose();
    locationCtrl.dispose();
    super.onClose();
  }

  // ─── Helpers ──────────────────────────────────────────────────────────────
  String get formattedStartDate =>
      startDate.value != null
          ? DateFormat('yyyy-MM-dd').format(startDate.value!)
          : '—';

  String get formattedEndDate =>
      endDate.value != null
          ? DateFormat('yyyy-MM-dd').format(endDate.value!)
          : '—';

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

  TimeOfDay? _parseTime(String? timeStr) {
    if (timeStr == null || timeStr.isEmpty) return null;
    try {
      final dt = DateFormat('hh:mm a').parse(timeStr);
      return TimeOfDay(hour: dt.hour, minute: dt.minute);
    } catch (_) {
      try {
        // Fallback: try 24h format HH:mm
        final dt = DateFormat('HH:mm').parse(timeStr);
        return TimeOfDay(hour: dt.hour, minute: dt.minute);
      } catch (_) {
        return null;
      }
    }
  }

  void _populateForm(HEventModel e) {
    eventNameCtrl.text = e.eventName;
    locationCtrl.text = e.eventLocation;
    startDate.value = DateTime.tryParse(e.startDate);
    endDate.value = DateTime.tryParse(e.endDate);
    startTime.value = _parseTime(e.startTime);
    endTime.value = _parseTime(e.endTime);

    district.value = e.district.isNotEmpty ? e.district : null;
    mainLocation.value =
    (e.mainLocation != null && e.mainLocation!.isNotEmpty)
        ? e.mainLocation
        : null;
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

      final body = jsonDecode(response.body);
      if (response.statusCode == 200 && body['status'] == '1') {
        event.value = HEventModel.fromJson(body['data']);
        _populateForm(event.value!);
      } else {
        _showError(body['message'] ?? 'Failed to fetch event');
      }
    } catch (e) {
      _showError('Network error: $e');
    } finally {
      isLoading.value = false;
    }
  }

  // ─── Pick image ───────────────────────────────────────────────────────────
  Future<void> pickBannerImage() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(
        source: ImageSource.gallery, imageQuality: 85);
    if (picked == null) return;

    final file = File(picked.path);
    final bytes = await file.readAsBytes();
    final ext = picked.path.split('.').last.toLowerCase();
    final mime = ext == 'png' ? 'image/png' : 'image/jpeg';

    pickedImageFile.value = file;
    pickedImageBase64.value = 'data:$mime;base64,${base64Encode(bytes)}';
  }

  // ─── Date / time pickers ──────────────────────────────────────────────────
  //
  // Future<void> selectStartDate(BuildContext context) async {
  //   final now = DateTime.now();
  //   final initial = startDate.value ?? now;
  //
  //   final picked = await showDatePicker(
  //     context: context,
  //     initialDate: initial,
  //     firstDate: DateTime(2020),
  //     lastDate: DateTime(2030),
  //   );
  //
  //   if (picked != null) {
  //     startDate.value = picked;
  //
  //     // ── FIX: clear end date + end time if they are now before start date ──
  //     if (endDate.value != null) {
  //       final end = endDate.value!;
  //       // Compare date-only (strip time component)
  //       final endDateOnly =
  //       DateTime(end.year, end.month, end.day);
  //       final startDateOnly =
  //       DateTime(picked.year, picked.month, picked.day);
  //
  //       if (endDateOnly.isBefore(startDateOnly)) {
  //         endDate.value = null;
  //         endTime.value = null;
  //         Get.snackbar(
  //           'Notice',
  //           'End date & time were reset because they were before the new start date.',
  //           backgroundColor: const Color(0xFFFF9800),
  //           colorText: Colors.white,
  //           snackPosition: SnackPosition.BOTTOM,
  //           margin: const EdgeInsets.all(16),
  //           duration: const Duration(seconds: 3),
  //         );
  //       }
  //     }
  //   }
  // }
  //
  // Future<void> selectEndDate(BuildContext context) async {
  //   final now = DateTime.now();
  //
  //   // ── FIX: compute a safe initial date that is never before firstDate ──
  //   final firstDate = startDate.value ?? DateTime(2020);
  //   DateTime safeInitial;
  //
  //   if (endDate.value != null) {
  //     final end = endDate.value!;
  //     final endDateOnly = DateTime(end.year, end.month, end.day);
  //     final firstDateOnly =
  //     DateTime(firstDate.year, firstDate.month, firstDate.day);
  //     // If stored endDate is before firstDate, clamp to firstDate
  //     safeInitial =
  //     endDateOnly.isBefore(firstDateOnly) ? firstDate : endDate.value!;
  //   } else {
  //     safeInitial = firstDate;
  //   }
  //
  //   final picked = await showDatePicker(
  //     context: context,
  //     initialDate: safeInitial,   // ← always valid, never before firstDate
  //     firstDate: firstDate,
  //     lastDate: DateTime(2030),
  //   );
  //
  //   if (picked != null) endDate.value = picked;
  // }
  Future<void> selectStartDate(BuildContext context) async {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day); // strip time

    // If existing startDate is in the past, clamp initial to today
    final safeInitial = (startDate.value != null &&
        startDate.value!.isAfter(today.subtract(const Duration(days: 1))))
        ? startDate.value!
        : today;

    final picked = await showDatePicker(
      context: context,
      initialDate: safeInitial,
      firstDate: today,           // ← past dates greyed out / unselectable
      lastDate: DateTime(2030),
    );

    if (picked != null) {
      startDate.value = picked;

      // Clear end date+time if now before new start
      if (endDate.value != null) {
        final endOnly = DateTime(
            endDate.value!.year, endDate.value!.month, endDate.value!.day);
        if (endOnly.isBefore(picked)) {
          endDate.value = null;
          endTime.value = null;
          Get.snackbar(
            'Notice',
            'End date & time were reset because they were before the new start date.',
            backgroundColor: const Color(0xFFFF9800),
            colorText: Colors.white,
            snackPosition: SnackPosition.BOTTOM,
            margin: const EdgeInsets.all(16),
            duration: const Duration(seconds: 3),
          );
        }
      }
    }
  }

  Future<void> selectEndDate(BuildContext context) async {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    // firstDate is whichever is later: today OR the selected start date
    final firstDate = (startDate.value != null &&
        startDate.value!.isAfter(today))
        ? startDate.value!
        : today;

    // Clamp initialDate so it's never before firstDate
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
      firstDate: firstDate,       // ← past + pre-startDate greyed out
      lastDate: DateTime(2030),
    );

    if (picked != null) endDate.value = picked;
  }

  Future<void> selectStartTime(BuildContext context) async {
    final picked = await showTimePicker(
      context: context,
      initialTime: startTime.value ?? TimeOfDay.now(),
    );

    if (picked != null) {
      startTime.value = picked;

      // ── FIX: if same date, clear end time when it is now <= start time ──
      if (endTime.value != null && _isSameDay()) {
        final sMinutes = picked.hour * 60 + picked.minute;
        final eMinutes =
            endTime.value!.hour * 60 + endTime.value!.minute;
        if (eMinutes <= sMinutes) {
          endTime.value = null;
          Get.snackbar(
            'Notice',
            'End time was reset because it was not after the new start time.',
            backgroundColor: const Color(0xFFFF9800),
            colorText: Colors.white,
            snackPosition: SnackPosition.BOTTOM,
            margin: const EdgeInsets.all(16),
            duration: const Duration(seconds: 3),
          );
        }
      }
    }
  }

  Future<void> selectEndTime(BuildContext context) async {
    // ── FIX: guard: ensure end time is after start time on the same date ──
    TimeOfDay initialTime = endTime.value ?? TimeOfDay.now();

    final picked = await showTimePicker(
      context: context,
      initialTime: initialTime,
    );

    if (picked != null) {
      // Validate on same day
      if (_isSameDay() && startTime.value != null) {
        final sMinutes =
            startTime.value!.hour * 60 + startTime.value!.minute;
        final eMinutes = picked.hour * 60 + picked.minute;
        if (eMinutes <= sMinutes) {
          Get.snackbar(
            'Invalid Time',
            'End time must be after start time.',
            backgroundColor: const Color(0xFFF44336),
            colorText: Colors.white,
            snackPosition: SnackPosition.BOTTOM,
            margin: const EdgeInsets.all(16),
          );
          return; // ← do NOT save an invalid end time
        }
      }
      endTime.value = picked;
    }
  }

  /// Returns true when startDate and endDate are the same calendar day.
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
      _showError('Please select start and end dates');
      return;
    }
    if (startTime.value == null || endTime.value == null) {
      _showError('Please select start and end times');
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
        'district': district.value ?? '',
        'main_location': mainLocation.value ?? '',
      };

      if (pickedImageBase64.value != null) {
        payload['banner_image'] = pickedImageBase64.value!;
      }

      final response = await http.put(
        Uri.parse('$_baseUrl/update-event'),
        headers: _authHeaders,
        body: jsonEncode(payload),
      );

      final body = jsonDecode(response.body);
      if (response.statusCode == 200 && body['status'] == '1') {
        event.value = HEventModel.fromJson(body['data']);
        Get.snackbar(
          'Success',
          body['message'] ?? 'Event updated successfully',
          backgroundColor: const Color(0xFF4CAF50),
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
          margin: const EdgeInsets.all(16),
        );
        Get.back(result: event.value);
      } else {
        _showError(body['message'] ?? 'Failed to update event');
      }
    } catch (e) {
      _showError('Network error: $e');
    } finally {
      isUpdating.value = false;
    }
  }

  // ─── Error helper ─────────────────────────────────────────────────────────
  void _showError(String message) {
    Get.snackbar(
      'Error',
      message,
      backgroundColor: const Color(0xFFF44336),
      colorText: Colors.white,
      snackPosition: SnackPosition.BOTTOM,
      margin: const EdgeInsets.all(16),
    );
  }
}