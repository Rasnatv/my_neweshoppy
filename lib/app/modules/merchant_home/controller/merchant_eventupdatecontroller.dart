
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

import '../../../data/models/merchant_eventupadatemodel.dart';
import '../../merchantlogin/widget/successwidget.dart';
import '../views/myevents.dart';
import '../../../data/errors/api_error.dart';


class EventUpdateController extends GetxController {
  final isLoading = false.obs;
  final isUpdating = false.obs;
  final event = Rxn<HEventModel>();

  final formKey = GlobalKey<FormState>();
  late TextEditingController eventNameCtrl;
  late TextEditingController locationCtrl;

  final state = RxnString();
  final district = RxnString();
  final mainLocation = RxnString();

  final startDate = Rxn<DateTime>();
  final endDate = Rxn<DateTime>();
  final startTime = Rxn<TimeOfDay>();
  final endTime = Rxn<TimeOfDay>();

  final pickedImageFile = Rxn<File>();
  final pickedImageBase64 = RxnString();

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

  @override
  void onInit() {
    super.onInit();
    eventNameCtrl = TextEditingController();
    locationCtrl = TextEditingController();

    final args = Get.arguments != null
        ? Map<String, dynamic>.from(Get.arguments as Map)
        : null;

    final raw = args?['event_id'];
    final int? eventId =
    raw == null ? null : raw is int ? raw : int.tryParse(raw.toString());

    if (eventId != null) {
      fetchEvent(eventId);
    }
  }

  @override
  void onClose() {
    eventNameCtrl.dispose();
    locationCtrl.dispose();
    super.onClose();
  }

  String get formattedStartDate =>
      startDate.value != null
          ? DateFormat('yyyy-MM-dd').format(startDate.value!)
          : '';

  String get formattedEndDate =>
      endDate.value != null
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
    final dt =
    DateTime(now.year, now.month, now.day, time.hour, time.minute);
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

  void _populateForm(HEventModel e) {
    eventNameCtrl.text = e.eventName;
    locationCtrl.text = e.eventLocation;
    startDate.value = DateTime.tryParse(e.startDate);
    endDate.value = DateTime.tryParse(e.endDate);
    startTime.value = _parseTime(e.startTime);
    endTime.value = _parseTime(e.endTime);

    state.value = (e.state != null && e.state!.isNotEmpty) ? e.state : null;
    district.value =
    (e.district != null && e.district!.isNotEmpty) ? e.district : null;
    mainLocation.value = (e.mainLocation != null &&
        e.mainLocation!.isNotEmpty)
        ? e.mainLocation
        : null;
  }

  // ================= FETCH EVENT =================
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
      } else if (response.statusCode != 200) {
        AppSnackbar.error(ApiErrorHandler.handleResponse(response));
      }
    }

    finally {
      isLoading.value = false;
    }
  }

  Future<void> pickBannerImage() async {
    final picker = ImagePicker();

    final picked = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 90,
    );

    if (picked == null) return;

    File file = File(picked.path);

    // 1️⃣ SIZE CHECK (1MB limit)
    final int bytes = await file.length();
    if (bytes > 1024 * 1024) {
      AppSnackbar.error("Please upload image less than 1 MB");
      return;
    }

    // 2️⃣ CROP (2:1 ratio)
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

    final rawBytes = await file.readAsBytes();
    final ext = file.path.split('.').last.toLowerCase();
    final mime = ext == 'png' ? 'image/png' : 'image/jpeg';

    pickedImageFile.value = file;
    pickedImageBase64.value =
    'data:$mime;base64,${base64Encode(rawBytes)}';
  }

  // ================= DATE =================
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
              'End date & time were reset because they were before start date');
        }
      }
    }
  }

  Future<void> selectEndDate(BuildContext context) async {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    final firstDate = (startDate.value != null &&
        startDate.value!.isAfter(today))
        ? startDate.value!
        : today;

    final picked = await showDatePicker(
      context: context,
      initialDate: firstDate,
      firstDate: firstDate,
      lastDate: DateTime(2030),
    );

    if (picked != null) endDate.value = picked;
  }

  // ================= TIME =================
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

          AppSnackbar.warning('End time reset (must be after start time)');
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
          AppSnackbar.error('End time must be after start time');
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

  // ================= UPDATE =================
  Future<void> updateEvent() async {
    if (!formKey.currentState!.validate()) return;

    if (startDate.value == null || endDate.value == null) {
      AppSnackbar.warning('Please select start & end dates');
      return;
    }

    if (startTime.value == null || endTime.value == null) {
      AppSnackbar.warning('Please select start & end time');
      return;
    }

    try {
      isUpdating.value = true;

      final payload = {
        'event_id': int.parse(event.value!.id),
        'event_name': eventNameCtrl.text.trim(),
        'start_date': formattedStartDate,
        'end_date': formattedEndDate,
        'start_time': _formatTime(startTime.value!),
        'end_time': _formatTime(endTime.value!),
        'event_location': locationCtrl.text.trim(),
        if (state.value != null) 'state': state.value!,
        if (district.value != null) 'district': district.value!,
        if (mainLocation.value != null)
          'main_location': mainLocation.value!,
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

        AppSnackbar.success("Event updated successfully");

        Get.off(MerchantEventsPage());
      } else if (response.statusCode != 200) {
        AppSnackbar.error(ApiErrorHandler.handleResponse(response));
      }
    }
    finally {
      isUpdating.value = false;
    }
  }
}
