//
//
// import 'dart:convert';
// import 'dart:io';
//
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:intl/intl.dart';
// import 'package:get_storage/get_storage.dart';
// import 'package:http/http.dart' as http;
//
// import '../../../../data/models/merchant_eventupadatemodel.dart';
// import '../../controller/admin_eventgetcontroller.dart';
// import '../view/admin_event.dart';
//
// class AdminEventUpdateController extends GetxController {
//   // ─── State ────────────────────────────────────────────────────────────────
//   final isLoading = false.obs;
//   final isUpdating = false.obs;
//   final event = Rxn<HEventModel>();
//
//   // ─── Form key & controllers ───────────────────────────────────────────────
//   final formKey = GlobalKey<FormState>();
//   late TextEditingController eventNameCtrl;
//   late TextEditingController locationCtrl;
//
//   // ─── Read-only fields (not editable) ─────────────────────────────────────
//   final mainLocation = RxnString();
//   final district = RxnString();
//
//   // ─── Date / time observables ──────────────────────────────────────────────
//   final startDate = Rxn<DateTime>();
//   final endDate = Rxn<DateTime>();
//   final startTime = Rxn<TimeOfDay>();
//   final endTime = Rxn<TimeOfDay>();
//
//   // ─── Banner image ─────────────────────────────────────────────────────────
//   final pickedImageFile = Rxn<File>();
//   final pickedImageBase64 = RxnString();
//
//   // ─── API ──────────────────────────────────────────────────────────────────
//   static const _baseUrl =
//       'https://rasma.astradevelops.in/e_shoppyy/public/api';
//
//   final _box = GetStorage();
//
//   Map<String, String> get _authHeaders {
//     final token = _box.read<String>('auth_token') ?? '';
//     return {
//       'Content-Type': 'application/json',
//       'Authorization': 'Bearer $token',
//     };
//   }
//
//   // ─── Lifecycle ────────────────────────────────────────────────────────────
//   @override
//   void onInit() {
//     super.onInit();
//     eventNameCtrl = TextEditingController();
//     locationCtrl = TextEditingController();
//
//     final Map<String, dynamic>? args = Get.arguments != null
//         ? Map<String, dynamic>.from(Get.arguments as Map)
//         : null;
//
//     final dynamic raw = args?['event_id'];
//     final int? eventId = raw == null
//         ? null
//         : raw is int
//         ? raw
//         : int.tryParse(raw.toString());
//
//     if (eventId != null) {
//       fetchEvent(eventId);
//     } else {
//       _showError('Invalid event ID');
//     }
//   }
//
//   @override
//   void onClose() {
//     eventNameCtrl.dispose();
//     locationCtrl.dispose();
//     super.onClose();
//   }
//
//   // ─── Display helpers ──────────────────────────────────────────────────────
//   String get formattedStartDate => startDate.value != null
//       ? DateFormat('yyyy-MM-dd').format(startDate.value!)
//       : '';
//
//   String get formattedEndDate => endDate.value != null
//       ? DateFormat('yyyy-MM-dd').format(endDate.value!)
//       : '';
//
//   String get displayStartDate => startDate.value != null
//       ? DateFormat('MMM dd, yyyy').format(startDate.value!)
//       : 'Select date';
//
//   String get displayEndDate => endDate.value != null
//       ? DateFormat('MMM dd, yyyy').format(endDate.value!)
//       : 'Select date';
//
//   String get displayStartTime => startTime.value != null
//       ? startTime.value!.format(Get.context!)
//       : 'Select time';
//
//   String get displayEndTime => endTime.value != null
//       ? endTime.value!.format(Get.context!)
//       : 'Select time';
//
//   // ─── Time formatting ──────────────────────────────────────────────────────
//   // FIX: API expects 24-hr "HH:mm", not "hh:mm a"
//   String _formatTime(TimeOfDay time) {
//     final now = DateTime.now();
//     final dt = DateTime(now.year, now.month, now.day, time.hour, time.minute);
//     return DateFormat('HH:mm').format(dt);
//   }
//
//   // FIX: Handle all time formats returned by the API
//   TimeOfDay? _parseTime(String? timeStr) {
//     if (timeStr == null || timeStr.trim().isEmpty) return null;
//     // Try "hh:mm a" → e.g. "11:00 AM"
//     try {
//       final dt = DateFormat('hh:mm a').parse(timeStr.trim());
//       return TimeOfDay(hour: dt.hour, minute: dt.minute);
//     } catch (_) {}
//     // Try "HH:mm" → e.g. "09:00"
//     try {
//       final dt = DateFormat('HH:mm').parse(timeStr.trim());
//       return TimeOfDay(hour: dt.hour, minute: dt.minute);
//     } catch (_) {}
//     // Try "HH:mm:ss" → e.g. "09:00:00"
//     try {
//       final dt = DateFormat('HH:mm:ss').parse(timeStr.trim());
//       return TimeOfDay(hour: dt.hour, minute: dt.minute);
//     } catch (_) {
//       return null;
//     }
//   }
//
//   // ─── Populate form from model ─────────────────────────────────────────────
//   void _populateForm(HEventModel e) {
//     eventNameCtrl.text = e.eventName;
//     locationCtrl.text = e.eventLocation;
//     startDate.value = DateTime.tryParse(e.startDate);
//     endDate.value = DateTime.tryParse(e.endDate);
//     startTime.value = _parseTime(e.startTime);
//     endTime.value = _parseTime(e.endTime);
//     // Read-only: shown in UI but never sent back as edited values
//     mainLocation.value =
//     (e.mainLocation?.trim().isEmpty ?? true) ? null : e.mainLocation;
//     district.value =
//     (e.district?.trim().isEmpty ?? true) ? null : e.district;
//   }
//
//   // ─── Fetch single event ───────────────────────────────────────────────────
//   Future<void> fetchEvent(int eventId) async {
//     try {
//       isLoading.value = true;
//
//       final response = await http.post(
//         Uri.parse('$_baseUrl/get-Single-Event-admindisrict'),
//         headers: _authHeaders,
//         body: jsonEncode({'event_id': eventId}),
//       );
//
//       final body = jsonDecode(response.body) as Map<String, dynamic>;
//
//       final isSuccess = body['status'] == true ||
//           body['status'] == '1' ||
//           body['status_code'] == 200;
//
//       if (response.statusCode == 200 && isSuccess) {
//         event.value =
//             HEventModel.fromJson(body['data'] as Map<String, dynamic>);
//         _populateForm(event.value!);
//       } else {
//         _showError(body['message']?.toString() ?? 'Failed to fetch event');
//       }
//     } catch (e) {
//       _showError('Network error: $e');
//     } finally {
//       isLoading.value = false;
//     }
//   }
//
//   // ─── Pick banner image ────────────────────────────────────────────────────
//   Future<void> pickBannerImage() async {
//     final picker = ImagePicker();
//     final picked = await picker.pickImage(
//         source: ImageSource.gallery, imageQuality: 85);
//     if (picked == null) return;
//
//     final file = File(picked.path);
//     final bytes = await file.readAsBytes();
//     final ext = picked.path.split('.').last.toLowerCase();
//     final mime = ext == 'png' ? 'image/png' : 'image/jpeg';
//
//     pickedImageFile.value = file;
//     pickedImageBase64.value = 'data:$mime;base64,${base64Encode(bytes)}';
//   }
//
//   // ─── Date pickers ─────────────────────────────────────────────────────────
//   DateTime get _today => DateTime(
//     DateTime.now().year,
//     DateTime.now().month,
//     DateTime.now().day,
//   );
//
//   Future<void> selectStartDate(BuildContext context) async {
//     final initialDate =
//     (startDate.value != null && !startDate.value!.isBefore(_today))
//         ? startDate.value!
//         : _today;
//
//     final picked = await showDatePicker(
//       context: context,
//       initialDate: initialDate,
//       firstDate: _today,
//       lastDate: DateTime(2035),
//     );
//
//     if (picked != null) {
//       startDate.value = picked;
//       if (endDate.value != null && endDate.value!.isBefore(picked)) {
//         endDate.value = null;
//       }
//     }
//   }
//
//   Future<void> selectEndDate(BuildContext context) async {
//     final first =
//     (startDate.value != null && !startDate.value!.isBefore(_today))
//         ? startDate.value!
//         : _today;
//
//     DateTime initial = endDate.value ?? first;
//     if (initial.isBefore(first)) initial = first;
//
//     final picked = await showDatePicker(
//       context: context,
//       initialDate: initial,
//       firstDate: first,
//       lastDate: DateTime(2035),
//     );
//     if (picked != null) endDate.value = picked;
//   }
//
//   // ─── Time pickers ─────────────────────────────────────────────────────────
//   Future<void> selectStartTime(BuildContext context) async {
//     final picked = await showTimePicker(
//       context: context,
//       initialTime: startTime.value ?? TimeOfDay.now(),
//     );
//     if (picked != null) startTime.value = picked;
//   }
//
//   Future<void> selectEndTime(BuildContext context) async {
//     final picked = await showTimePicker(
//       context: context,
//       initialTime: endTime.value ?? TimeOfDay.now(),
//     );
//     if (picked != null) endTime.value = picked;
//   }
//
//   // ─── Update event ─────────────────────────────────────────────────────────
//   Future<void> updateEvent() async {
//     if (!formKey.currentState!.validate()) return;
//
//     if (startDate.value == null || endDate.value == null) {
//       _showError('Please select start and end dates');
//       return;
//     }
//     if (startTime.value == null || endTime.value == null) {
//       _showError('Please select start and end times');
//       return;
//     }
//
//     try {
//       isUpdating.value = true;
//
//       final payload = <String, dynamic>{
//         'event_id': int.parse(event.value!.id),
//         'event_name': eventNameCtrl.text.trim(),
//         'event_location': locationCtrl.text.trim(),
//         // Read-only: always send original values unchanged
//         'main_location': event.value?.mainLocation ?? '',
//         'district': event.value?.district ?? '',
//         'start_date': formattedStartDate,
//         'end_date': formattedEndDate,
//         'start_time': _formatTime(startTime.value!),
//         'end_time': _formatTime(endTime.value!),
//       };
//
//       if (pickedImageBase64.value != null) {
//         payload['banner_image'] = pickedImageBase64.value!;
//       }
//
//       final response = await http.put(
//         Uri.parse('$_baseUrl/update-Event-admin-district'),
//         headers: _authHeaders,
//         body: jsonEncode(payload),
//       );
//
//       final body = jsonDecode(response.body) as Map<String, dynamic>;
//
//       final isSuccess = body['status'] == true ||
//           body['status'] == '1' ||
//           body['status_code'] == 200;
//
//       if (response.statusCode == 200 && isSuccess) {
//         Get.snackbar(
//           'Success',
//           body['message']?.toString() ?? 'Event updated successfully',
//           backgroundColor: const Color(0xFF4CAF50),
//           colorText: Colors.white,
//           snackPosition: SnackPosition.BOTTOM,
//           margin: const EdgeInsets.all(16),
//         );
//
//         // FIX: Force-delete the AdminEventPage controller so its onInit
//         // re-runs and fetchEvents() is called fresh when the page mounts.
//         // Without this GetX returns the stale cached instance and skips onInit.
//         try {
//           Get.delete<AdminEventGetController>(force: true);
//         } catch (_) {}
//
//         Get.offAll(() => AdminEventPage());
//       } else {
//         _showError(body['message']?.toString() ?? 'Failed to update event');
//       }
//     } catch (e) {
//       _showError('Network error: $e');
//     } finally {
//       isUpdating.value = false;
//     }
//   }
//
//   // ─── Error helper ─────────────────────────────────────────────────────────
//   void _showError(String message) {
//     Get.snackbar(
//       'Error',
//       message,
//       backgroundColor: const Color(0xFFF44336),
//       colorText: Colors.white,
//       snackPosition: SnackPosition.BOTTOM,
//       margin: const EdgeInsets.all(16),
//     );
//   }
// }
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

import '../../../../data/models/merchant_eventupadatemodel.dart';
import '../../controller/admin_eventgetcontroller.dart';
import '../view/admin_event.dart';

class AdminEventUpdateController extends GetxController {
  // ─── State ────────────────────────────────────────────────────────────────
  final isLoading = false.obs;
  final isUpdating = false.obs;
  final event = Rxn<HEventModel>();

  // ─── Form key & controllers ───────────────────────────────────────────────
  final formKey = GlobalKey<FormState>();
  late TextEditingController eventNameCtrl;
  late TextEditingController locationCtrl;

  // ─── Read-only fields (not editable) ─────────────────────────────────────
  final mainLocation = RxnString();
  final district = RxnString();

  // ─── Date / time observables ──────────────────────────────────────────────
  final startDate = Rxn<DateTime>();
  final endDate = Rxn<DateTime>();
  final startTime = Rxn<TimeOfDay>();
  final endTime = Rxn<TimeOfDay>();

  // ─── Banner image ─────────────────────────────────────────────────────────
  final pickedImageFile = Rxn<File>();
  final pickedImageBase64 = RxnString();

  // ─── API ──────────────────────────────────────────────────────────────────
  static const _baseUrl =
      'https://rasma.astradevelops.in/e_shoppyy/public/api';

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

  // Always display in 12-hour format (e.g. "1:46 PM") regardless of
  // the device's system time setting — avoids "13:46" on 24-hr devices.
  String _displayTime(TimeOfDay time) {
    final now = DateTime.now();
    final dt = DateTime(now.year, now.month, now.day, time.hour, time.minute);
    return DateFormat('h:mm a').format(dt); // h = no leading zero → "1:46 PM"
  }

  String get displayStartTime =>
      startTime.value != null ? _displayTime(startTime.value!) : 'Select time';

  String get displayEndTime =>
      endTime.value != null ? _displayTime(endTime.value!) : 'Select time';

  // ─── Time formatting ──────────────────────────────────────────────────────
  // FIX: API expects 24-hr "HH:mm", not "hh:mm a"
  String _formatTime(TimeOfDay time) {
    final now = DateTime.now();
    final dt = DateTime(now.year, now.month, now.day, time.hour, time.minute);
    return DateFormat('HH:mm').format(dt);
  }

  // FIX: Handle all time formats returned by the API
  TimeOfDay? _parseTime(String? timeStr) {
    if (timeStr == null || timeStr.trim().isEmpty) return null;
    // Try "hh:mm a" → e.g. "11:00 AM"
    try {
      final dt = DateFormat('hh:mm a').parse(timeStr.trim());
      return TimeOfDay(hour: dt.hour, minute: dt.minute);
    } catch (_) {}
    // Try "HH:mm" → e.g. "09:00"
    try {
      final dt = DateFormat('HH:mm').parse(timeStr.trim());
      return TimeOfDay(hour: dt.hour, minute: dt.minute);
    } catch (_) {}
    // Try "HH:mm:ss" → e.g. "09:00:00"
    try {
      final dt = DateFormat('HH:mm:ss').parse(timeStr.trim());
      return TimeOfDay(hour: dt.hour, minute: dt.minute);
    } catch (_) {
      return null;
    }
  }

  // ─── Populate form from model ─────────────────────────────────────────────
  void _populateForm(HEventModel e) {
    eventNameCtrl.text = e.eventName;
    locationCtrl.text = e.eventLocation;
    startDate.value = DateTime.tryParse(e.startDate);
    endDate.value = DateTime.tryParse(e.endDate);
    startTime.value = _parseTime(e.startTime);
    endTime.value = _parseTime(e.endTime);
    // Read-only: shown in UI but never sent back as edited values
    mainLocation.value =
    (e.mainLocation?.trim().isEmpty ?? true) ? null : e.mainLocation;
    district.value =
    (e.district?.trim().isEmpty ?? true) ? null : e.district;
  }

  // ─── Fetch single event ───────────────────────────────────────────────────
  Future<void> fetchEvent(int eventId) async {
    try {
      isLoading.value = true;

      final response = await http.post(
        Uri.parse('$_baseUrl/get-Single-Event-admindisrict'),
        headers: _authHeaders,
        body: jsonEncode({'event_id': eventId}),
      );

      final body = jsonDecode(response.body) as Map<String, dynamic>;

      final isSuccess = body['status'] == true ||
          body['status'] == '1' ||
          body['status_code'] == 200;

      if (response.statusCode == 200 && isSuccess) {
        event.value =
            HEventModel.fromJson(body['data'] as Map<String, dynamic>);
        _populateForm(event.value!);
      } else {
        _showError(body['message']?.toString() ?? 'Failed to fetch event');
      }
    } catch (e) {
      _showError('Network error: $e');
    } finally {
      isLoading.value = false;
    }
  }

  // ─── Pick banner image ────────────────────────────────────────────────────
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

  // ─── Date pickers ─────────────────────────────────────────────────────────
  DateTime get _today => DateTime(
    DateTime.now().year,
    DateTime.now().month,
    DateTime.now().day,
  );

  Future<void> selectStartDate(BuildContext context) async {
    final initialDate =
    (startDate.value != null && !startDate.value!.isBefore(_today))
        ? startDate.value!
        : _today;

    final picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: _today,
      lastDate: DateTime(2035),
    );

    if (picked != null) {
      startDate.value = picked;
      if (endDate.value != null && endDate.value!.isBefore(picked)) {
        endDate.value = null;
      }
    }
  }

  Future<void> selectEndDate(BuildContext context) async {
    final first =
    (startDate.value != null && !startDate.value!.isBefore(_today))
        ? startDate.value!
        : _today;

    DateTime initial = endDate.value ?? first;
    if (initial.isBefore(first)) initial = first;

    final picked = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: first,
      lastDate: DateTime(2035),
    );
    if (picked != null) endDate.value = picked;
  }

  // ─── Time pickers ─────────────────────────────────────────────────────────
  Future<void> selectStartTime(BuildContext context) async {
    final picked = await showTimePicker(
      context: context,
      initialTime: startTime.value ?? TimeOfDay.now(),
    );
    if (picked != null) startTime.value = picked;
  }

  Future<void> selectEndTime(BuildContext context) async {
    final picked = await showTimePicker(
      context: context,
      initialTime: endTime.value ?? TimeOfDay.now(),
    );
    if (picked != null) endTime.value = picked;
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
        'event_location': locationCtrl.text.trim(),
        // Read-only: always send original values unchanged
        'main_location': event.value?.mainLocation ?? '',
        'district': event.value?.district ?? '',
        'start_date': formattedStartDate,
        'end_date': formattedEndDate,
        'start_time': _formatTime(startTime.value!),
        'end_time': _formatTime(endTime.value!),
      };

      if (pickedImageBase64.value != null) {
        payload['banner_image'] = pickedImageBase64.value!;
      }

      final response = await http.put(
        Uri.parse('$_baseUrl/update-Event-admin-district'),
        headers: _authHeaders,
        body: jsonEncode(payload),
      );

      final body = jsonDecode(response.body) as Map<String, dynamic>;

      final isSuccess = body['status'] == true ||
          body['status'] == '1' ||
          body['status_code'] == 200;

      if (response.statusCode == 200 && isSuccess) {
        Get.snackbar(
          'Success',
          body['message']?.toString() ?? 'Event updated successfully',
          backgroundColor: const Color(0xFF4CAF50),
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
          margin: const EdgeInsets.all(16),
        );

        // FIX: Force-delete the AdminEventPage controller so its onInit
        // re-runs and fetchEvents() is called fresh when the page mounts.
        // Without this GetX returns the stale cached instance and skips onInit.
        try {
          Get.delete<AdminEventGetController>(force: true);
        } catch (_) {}

        Get.offAll(() => AdminEventPage());
      } else {
        _showError(body['message']?.toString() ?? 'Failed to update event');
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