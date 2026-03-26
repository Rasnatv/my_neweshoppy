
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

class AreaAdminUpdateEventController extends GetxController {
  final _box = GetStorage();

  // ─── API URLs ─────────────────────────────────────
  static const String _areaAdminBaseUrl =
      'https://rasma.astradevelops.in/e_shoppyy/public/api/area-admin';
  static const String _eventFetchUrl =
      'https://rasma.astradevelops.in/e_shoppyy/public/api/event';
  static const String _eventUpdateUrl =
      'https://rasma.astradevelops.in/e_shoppyy/public/api/event/update';

  // ─── Observables ──────────────────────────────────
  final isLoading          = false.obs;
  final isEventLoading     = false.obs;
  final isLocationsLoading = false.obs;

  final mainLocations        = <String>[].obs;
  final selectedMainLocation = RxnString();

  final startDate = RxnString();
  final endDate   = RxnString();
  final startTime = RxnString(); // driven by time picker
  final endTime   = RxnString();

  final pickedImage       = Rxn<File>();
  final existingBannerUrl = RxnString();
  final imageChanged      = false.obs; // true only when user picks a new image

  // ─── Text Controllers ─────────────────────────────
  final eventName     = TextEditingController();
  final eventLocation = TextEditingController();

  // ─── Lifecycle ────────────────────────────────────
  @override
  void onInit() {
    super.onInit();
    fetchMainLocations();
  }

  @override
  void onClose() {
    eventName.dispose();
    eventLocation.dispose();
    super.onClose();
  }

  // ─── Auth ─────────────────────────────────────────
  String get _authToken => _box.read('auth_token') ?? '';

  Map<String, String> get _authHeaders => {
    'Authorization': 'Bearer $_authToken',
    'Accept': 'application/json',
  };

  Map<String, String> get _jsonHeaders => {
    'Authorization': 'Bearer $_authToken',
    'Accept': 'application/json',
    'Content-Type': 'application/json',
  };

  // ─── Fetch Event ──────────────────────────────────
  Future<void> fetchEvent(String eventId) async {
    if (_authToken.isEmpty) {
      _handleUnauthorized();
      return;
    }
    try {
      isEventLoading.value = true;
      final response = await http.post(
        Uri.parse(_eventFetchUrl),
        headers: _jsonHeaders,
        body: jsonEncode({'event_id': int.tryParse(eventId) ?? eventId}),
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

  // ─── Prefill from API response ────────────────────
  void _prefillFromResponse(Map<String, dynamic> data) {
    eventName.text     = data['event_name']     ?? '';
    eventLocation.text = data['event_location'] ?? '';
    startDate.value    = data['start_date'];
    endDate.value      = data['end_date'];
    startTime.value    = data['start_time']; // e.g. "12:00 AM"
    endTime.value      = data['end_time'];   // e.g. "8:00 PM"
    existingBannerUrl.value = data['banner_image'];
    imageChanged.value = false;

    final mainLoc = data['main_location'] ?? '';
    if (mainLocations.contains(mainLoc)) {
      selectedMainLocation.value = mainLoc;
    }
    ever(mainLocations, (_) {
      if (mainLocations.contains(mainLoc) &&
          selectedMainLocation.value == null) {
        selectedMainLocation.value = mainLoc;
      }
    });
  }

  // ─── Fetch Main Locations (unchanged) ────────────
  Future<void> fetchMainLocations() async {
    if (_authToken.isEmpty) {
      _handleUnauthorized();
      return;
    }
    try {
      isLocationsLoading.value = true;
      final response = await http.get(
        Uri.parse('$_areaAdminBaseUrl/main-locations'),
        headers: _authHeaders,
      );
      final body = jsonDecode(response.body);
      if (response.statusCode == 200 && body['status'] == true) {
        final List data = body['data'] ?? [];
        mainLocations.assignAll(data.map((e) => e.toString()).toList());
      } else if (response.statusCode == 401) {
        _handleUnauthorized();
      } else {
        _showError('Error', body['message'] ?? 'Failed to load locations');
      }
    } catch (e) {
      _showError('Network Error', e.toString());
    } finally {
      isLocationsLoading.value = false;
    }
  }

  // ─── Pick Image ───────────────────────────────────
  Future<void> pickImage() async {
    final picked = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      imageQuality: 85,
    );
    if (picked != null) {
      pickedImage.value  = File(picked.path);
      imageChanged.value = true; // mark image as dirty
    }
  }

  // ─── Pick Date (today or future only) ────────────
  Future<void> pickDate(BuildContext context, {required bool isStart}) async {
    final today     = DateTime.now();
    final todayOnly = DateTime(today.year, today.month, today.day);

    DateTime initial;
    if (isStart) {
      initial = startDate.value != null
          ? _parseDate(startDate.value!, todayOnly)
          : todayOnly;
    } else {
      // end date must be >= start date
      final startParsed = startDate.value != null
          ? _parseDate(startDate.value!, todayOnly)
          : todayOnly;
      initial = endDate.value != null
          ? _parseDate(endDate.value!, startParsed)
          : startParsed;
    }

    // clamp initial to firstDate to avoid assertion error
    if (initial.isBefore(todayOnly)) initial = todayOnly;

    final picked = await showDatePicker(
      context    : context,
      initialDate: initial,
      firstDate  : todayOnly, // ← past dates disabled
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
        // clear end date if it falls before the new start date
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
      final formatted = _formatTimeOfDay(picked); // "hh:mm AM/PM"
      if (isStart) {
        startTime.value = formatted;
      } else {
        endTime.value = formatted;
      }
    }
  }

  // ─── Update Event ─────────────────────────────────
  Future<void> updateEvent(String eventId) async {
    if (_authToken.isEmpty) {
      _handleUnauthorized();
      return;
    }

    if (eventName.text.trim().isEmpty ||
        eventLocation.text.trim().isEmpty ||
        selectedMainLocation.value == null ||
        startDate.value == null ||
        endDate.value == null ||
        startTime.value == null ||
        endTime.value == null) {
      _showError('Validation', 'Please fill all fields');
      return;
    }

    try {
      isLoading.value = true;

      // ── Image: only send if user picked a new one ──
      String? base64Image;
      if (imageChanged.value && pickedImage.value != null) {
        final bytes = await pickedImage.value!.readAsBytes();
        final ext   = pickedImage.value!.path.split('.').last.toLowerCase();
        final mime  = ext == 'png'
            ? 'image/png'
            : ext == 'gif'
            ? 'image/gif'
            : 'image/jpeg';
        // data URI prefix lets the server detect file type
        base64Image = 'data:$mime;base64,${base64Encode(bytes)}';
      }

      final Map<String, dynamic> requestBody = {
        'event_id'      : int.tryParse(eventId) ?? eventId,
        'event_name'    : eventName.text.trim(),
        'event_location': eventLocation.text.trim(),
        'main_location' : selectedMainLocation.value,
        'start_date'    : startDate.value,
        'end_date'      : endDate.value,
        'start_time'    : startTime.value,
        'end_time'      : endTime.value,
        if (base64Image != null) 'banner_image': base64Image,
      };

      final response = await http.put(
        Uri.parse(_eventUpdateUrl),
        headers: _jsonHeaders,
        body   : jsonEncode(requestBody),
      );

      final body = jsonDecode(response.body);

      if (response.statusCode == 200 && body['status'] == true) {
        Get.back(result: true);
        _showSuccess('Success', body['message'] ?? 'Event updated successfully');
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
  /// Parse "12:00 AM" / "8:00 PM" → TimeOfDay
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
    } catch (_) {
      return null;
    }
  }

  /// Format TimeOfDay → "h:mm AM/PM"
  String _formatTimeOfDay(TimeOfDay t) {
    final period = t.period == DayPeriod.am ? 'AM' : 'PM';
    final hour   = t.hourOfPeriod == 0 ? 12 : t.hourOfPeriod;
    final minute = t.minute.toString().padLeft(2, '0');
    return '$hour:$minute $period';
  }

  /// Parse date string safely with fallback
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