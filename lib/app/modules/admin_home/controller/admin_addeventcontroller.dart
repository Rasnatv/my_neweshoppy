
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

import '../../../data/models/admin_addeventmodel.dart';

class AdminEventAddController extends GetxController {
  // ─── State ───────────────────────────────────────────────
  var events    = <AdminaddEventModel>[].obs;
  var isLoading = false.obs;

  // ─── Form Controllers ────────────────────────────────────
  final eventName     = TextEditingController();
  final eventLocation = TextEditingController();

  // ─── Date / Time Observables ─────────────────────────────
  final startDate = ''.obs;
  final endDate   = ''.obs;
  final startTime = ''.obs;
  final endTime   = ''.obs;

  // ─── Banner Image ────────────────────────────────────────
  final bannerImage = Rx<File?>(null);

  // ─── Storage & Picker ────────────────────────────────────
  final box    = GetStorage();
  final picker = ImagePicker();

  DateTime? _selectedStartDate;

  // ─── District & Area ─────────────────────────────────────
  final districts          = <String>[].obs;
  final areas              = <String>[].obs;
  final isLoadingDistricts = false.obs;
  final isLoadingAreas     = false.obs;

  // 'district' | 'area' | null
  final locationType      = Rx<String?>(null);
  final selectedDistrict  = Rx<String?>(null);
  final selectedArea      = Rx<String?>(null);

  // ─── Auth token helper ────────────────────────────────────
  String get _token => box.read('auth_token')?.toString().trim() ?? '';

  Map<String, String> get _headers => {
    'Accept': 'application/json',
    'Authorization': 'Bearer $_token',
  };

  // ─── Lifecycle ────────────────────────────────────────────
  @override
  void onInit() {
    super.onInit();
    fetchDistricts();
    fetchAreas();
  }

  @override
  void onClose() {
    eventName.dispose();
    eventLocation.dispose();
    super.onClose();
  }

  // ─── Set location type (toggle) ───────────────────────────
  void setLocationType(String type) {
    locationType.value     = type;
    selectedDistrict.value = null;
    selectedArea.value     = null;
  }

  // ─── Fetch Districts ──────────────────────────────────────
  Future<void> fetchDistricts() async {
    isLoadingDistricts.value = true;
    try {
      final response = await http.get(
        Uri.parse(
            'https://rasma.astradevelops.in/e_shoppyy/public/api/districts'),
        headers: _headers,
      );
      final body = jsonDecode(response.body);
      if (body['status'] == true && body['data'] != null) {
        districts.value = List<String>.from(body['data']);
      }
    } catch (_) {
      Get.snackbar('Error', 'Failed to load districts');
    } finally {
      isLoadingDistricts.value = false;
    }
  }

  // ─── Fetch Areas ──────────────────────────────────────────
  Future<void> fetchAreas() async {
    isLoadingAreas.value = true;
    try {
      final response = await http.get(
        Uri.parse(
            'https://rasma.astradevelops.in/e_shoppyy/public/api/areas'),
        headers: _headers,
      );
      final body = jsonDecode(response.body);
      if (body['status'] == true && body['data'] != null) {
        areas.value = List<String>.from(body['data']);
      }
    } catch (_) {
      Get.snackbar('Error', 'Failed to load areas');
    } finally {
      isLoadingAreas.value = false;
    }
  }

  // ─── Image Pick / Remove ──────────────────────────────────
  Future<void> pickBannerImage() async {
    final img = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 85,
    );
    if (img != null) bannerImage.value = File(img.path);
  }

  void removeBannerImage() => bannerImage.value = null;

  // ─── Date Pickers ─────────────────────────────────────────
  Future<void> pickStartDate(BuildContext context) async {
    final date = await showDatePicker(
      context: context,
      firstDate: DateTime.now(),
      lastDate: DateTime(2035),
      initialDate: DateTime.now(),
    );
    if (date != null) {
      _selectedStartDate = date;
      startDate.value    = _formatDate(date);
      endDate.value      = '';
    }
  }

  Future<void> pickEndDate(BuildContext context) async {
    if (_selectedStartDate == null) {
      Get.snackbar('Error', 'Select start date first',
          backgroundColor: Colors.red, colorText: Colors.white);
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

  // ─── Time Pickers ─────────────────────────────────────────
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

  // ─── Add Event ────────────────────────────────────────────
  Future<void> addEvent() async {
    try {
      isLoading.value = true;

      if (_token.isEmpty) {
        Get.snackbar('Session Expired', 'Please login again',
            backgroundColor: Colors.red, colorText: Colors.white);
        return;
      }

      final imgBytes  = await bannerImage.value!.readAsBytes();
      final imgBase64 = 'data:image/jpeg;base64,${base64Encode(imgBytes)}';

      final body = {
        'event_name':     eventName.text.trim(),
        'start_date':     startDate.value,
        'end_date':       endDate.value,
        'start_time':     startTime.value,
        'end_time':       endTime.value,
        'event_location': eventLocation.text.trim(),
        'district':
        locationType.value == 'district' ? selectedDistrict.value ?? '' : '',
        'main_location':
        locationType.value == 'area' ? selectedArea.value ?? '' : '',
        'banner_image': imgBase64,
      };

      final response = await http.post(
        Uri.parse(
            'https://rasma.astradevelops.in/e_shoppyy/public/api/create-event'),
        headers: {
          ..._headers,
          'Content-Type': 'application/json',
        },
        body: jsonEncode(body),
      );

      final res = jsonDecode(response.body);

      if (res['status'].toString() == '1' ||
          response.statusCode == 200 ||
          response.statusCode == 201) {
        final newEvent = AdminaddEventModel.fromJson(res['data']);
        events.insert(0, newEvent);

        clearForm();
        Get.back(result: true);
        Get.snackbar(
          'Success',
          res['message'] ?? 'Event created successfully',
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      } else {
        Get.snackbar(
          'Error',
          res['message'] ?? 'Failed to create event',
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar('Error', 'Something went wrong: $e',
          backgroundColor: Colors.red, colorText: Colors.white);
    } finally {
      isLoading.value = false;
    }
  }

  // ─── Fetch Events ─────────────────────────────────────────
  Future<void> fetchEvents() async {
    if (_token.isEmpty) {
      Get.snackbar('Session Expired', 'Please login again',
          backgroundColor: Colors.red, colorText: Colors.white);
      return;
    }
    try {
      isLoading.value = true;
      final response = await http.get(
        Uri.parse(
            'https://rasma.astradevelops.in/e_shoppyy/public/api/events'),
        headers: _headers,
      );
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final List list = data['data'] ?? data['events'] ?? [];
        events.value =
            list.map((e) => AdminaddEventModel.fromJson(e)).toList();
        events.sort((a, b) => b.id.compareTo(a.id));
      }
    } catch (_) {
      Get.snackbar('Error', 'Failed to fetch events',
          backgroundColor: Colors.red, colorText: Colors.white);
    } finally {
      isLoading.value = false;
    }
  }

  // ─── Delete Event ─────────────────────────────────────────
  Future<void> deleteEvent(String id) async {
    if (_token.isEmpty) return;

    final confirm = await Get.dialog<bool>(
      AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Delete Event',
            style: TextStyle(fontWeight: FontWeight.bold)),
        content: const Text('Are you sure you want to delete this event?'),
        actions: [
          TextButton(
            onPressed: () => Get.back(result: false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Get.back(result: true),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
            ),
            child: const Text('Delete',
                style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );

    if (confirm != true) return;

    try {
      isLoading.value = true;
      final response = await http.delete(
        Uri.parse(
            'https://rasma.astradevelops.in/e_shoppyy/public/api/delete-event/$id'),
        headers: _headers,
      );
      if (response.statusCode == 200 || response.statusCode == 204) {
        events.removeWhere((e) => e.id == id);
        Get.snackbar('Deleted', 'Event removed successfully',
            backgroundColor: Colors.green, colorText: Colors.white);
      } else {
        final res = jsonDecode(response.body);
        Get.snackbar('Error', res['message'] ?? 'Failed to delete event',
            backgroundColor: Colors.red, colorText: Colors.white);
      }
    } catch (_) {
      Get.snackbar('Error', 'Something went wrong',
          backgroundColor: Colors.red, colorText: Colors.white);
    } finally {
      isLoading.value = false;
    }
  }

  // ─── Clear Form ───────────────────────────────────────────
  void clearForm() {
    eventName.clear();
    eventLocation.clear();
    startDate.value        = '';
    endDate.value          = '';
    startTime.value        = '';
    endTime.value          = '';
    bannerImage.value      = null;
    _selectedStartDate     = null;
    locationType.value     = null;
    selectedDistrict.value = null;
    selectedArea.value     = null;
  }

  // ─── Helpers ──────────────────────────────────────────────
  String _formatDate(DateTime d) =>
      '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';

  String _formatTime(TimeOfDay t) {
    final hour   = t.hourOfPeriod == 0 ? 12 : t.hourOfPeriod;
    final minute = t.minute.toString().padLeft(2, '0');
    final period = t.period == DayPeriod.am ? 'AM' : 'PM';
    return '$hour:$minute $period';
  }
}