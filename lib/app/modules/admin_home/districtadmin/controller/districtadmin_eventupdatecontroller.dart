
import 'dart:convert';
import 'dart:io';
import 'package:eshoppy/app/widgets/areaadminsuccesswidget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
 // ← adjust path
import '../../../../data/errors/api_error.dart';
import '../../../merchantlogin/widget/successwidget.dart';
import '../view/districtadmin_home.dart';
import 'districtadmin_eventgettingcontroller.dart';

class DistrictAdminUpdateEventController extends GetxController {
  final _box = GetStorage();

  // ─── API URLs ─────────────────────────────────────
  static const String _baseUrl =
      'https://eshoppy.co.in/api/district-admin';
  static const String _publicBaseUrl =
      'https://eshoppy.co.in/api';

  // ─── Observables ──────────────────────────────────
  final isLoading          = false.obs;
  final isEventLoading     = false.obs;
  final isStatesLoading    = false.obs;
  final isDistrictsLoading = false.obs;

  final states    = <String>[].obs;
  final districts = <String>[].obs;

  final selectedState    = RxnString();
  final selectedDistrict = RxnString();

  final startDate = RxnString();
  final endDate   = RxnString();
  final startTime = RxnString();
  final endTime   = RxnString();

  final pickedImage       = Rxn<File>();
  final existingBannerUrl = RxnString();
  final imageChanged      = false.obs;
  var   errorBanner       = Rx<String?>(null);

  // ─── Text Controllers ─────────────────────────────
  final eventName     = TextEditingController();
  final eventLocation = TextEditingController();

  final ImagePicker picker = ImagePicker();

  // ─── Lifecycle ────────────────────────────────────
  @override
  void onInit() {
    super.onInit();
    fetchStates();
    fetchDistricts();
  }

  @override
  void onClose() {
    eventName.dispose();
    eventLocation.dispose();
    super.onClose();
  }

  // ─── Auth ─────────────────────────────────────────
  String get _authToken => _box.read('auth_token') ?? '';

  Map<String, String> get _headers => {
    'Authorization': 'Bearer $_authToken',
    'Accept'       : 'application/json',
  };

  Map<String, String> get _jsonHeaders => {
    'Authorization': 'Bearer $_authToken',
    'Accept'       : 'application/json',
    'Content-Type' : 'application/json',
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
        Uri.parse('$_publicBaseUrl/getStates-fordistrict'),
        headers: _headers,
      );
      if (response.statusCode == 200) {
        final body = jsonDecode(response.body);
        if (body['status'] == true) {
          final List data = body['data'] ?? [];
          states.assignAll(
            data.map((e) => (e['state'] ?? '').toString()).toList(),
          );
        }
        }
      else {
    AppSnackbar.error(ApiErrorHandler.handleResponse(response));
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
      final response = await http.get(
        Uri.parse('$_baseUrl/districts'),
        headers: _headers,
      );
      if (response.statusCode == 200) {
        final body = jsonDecode(response.body);
        if (body['status'] == true) {
          final List data = body['data'] ?? [];
          districts.assignAll(data.map((e) => e.toString()).toList());
        }
      } else {
        AppSnackbar.error(ApiErrorHandler.handleResponse(response));
      }
    } catch (e) {
      AppSnackbar.error(ApiErrorHandler.handleException(e));
    } finally {
      isDistrictsLoading.value = false;
    }
  }

  // ─── Fetch Event ──────────────────────────────────
  Future<void> fetchEvent(String eventId) async {
    if (_authToken.isEmpty) {
      ApiErrorHandler.handleUnauthorized();
      return;
    }
    try {
      isEventLoading.value = true;
      final response = await http.post(
        Uri.parse('$_baseUrl/event'),
        headers: _jsonHeaders,
        body   : jsonEncode({'event_id': int.tryParse(eventId) ?? eventId}),
      );
      if (response.statusCode == 200) {
        final body = jsonDecode(response.body);
        if (body['status'] == true) {
          _prefillFromResponse(body['data']);
        }
      } else {
        AppSnackbar.error(ApiErrorHandler.handleResponse(response));
      }
    } catch (e) {
      AppSnackbar.error(ApiErrorHandler.handleException(e));
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
    selectedState.value     = data['state'];
    selectedDistrict.value  = data['district'];
    imageChanged.value      = false;
  }

  // ─── Pick Banner Image ────────────────────────────
  Future<void> pickBannerImage() async {
    final picked = await picker.pickImage(
      source      : ImageSource.gallery,
      imageQuality: 90,
    );
    if (picked == null) return;

    File file = File(picked.path);

    if (await file.length() > 1024 * 1024) {
      AppSnackbar.error('Image must be less than 1 MB');
      errorBanner.value = 'Image must be less than 1 MB';
      return;
    }

    final croppedFile = await ImageCropper().cropImage(
      sourcePath: file.path,
      aspectRatio: const CropAspectRatio(ratioX: 2, ratioY: 1),
      uiSettings: [
        AndroidUiSettings(
          toolbarTitle      : 'Crop Banner',
          toolbarColor      : Colors.black,
          toolbarWidgetColor: Colors.white,
          lockAspectRatio   : true,
        ),
        IOSUiSettings(
          title                : 'Crop Banner',
          aspectRatioLockEnabled: true,
        ),
      ],
    );
    if (croppedFile == null) return;

    file               = File(croppedFile.path);
    pickedImage.value  = file;
    imageChanged.value = true;
    errorBanner.value  = null;
  }

  // ─── Pick Date ────────────────────────────────────
  Future<void> pickDate(BuildContext context, {required bool isStart}) async {
    final today     = DateTime.now();
    final todayOnly = DateTime(today.year, today.month, today.day);

    DateTime initial;
    if (isStart) {
      initial = startDate.value != null
          ? _parseDate(startDate.value!, todayOnly)
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
      builder    : (context, child) => Theme(
        data : Theme.of(context).copyWith(
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
          if (end != null && end.isBefore(picked)) {
            endDate.value = null;
            AppSnackbar.warning(
              'End date was reset because it was before the new start date.',
            );
          }
        }
      } else {
        endDate.value = formatted;
      }
    }
  }

  // ─── Pick Time ────────────────────────────────────
  Future<void> pickTime(BuildContext context, {required bool isStart}) async {
    TimeOfDay initial    = TimeOfDay.now();
    final    existing    = isStart ? startTime.value : endTime.value;
    if (existing != null) {
      final parsed = _parseTimeOfDay(existing);
      if (parsed != null) initial = parsed;
    }

    final picked = await showTimePicker(
      context    : context,
      initialTime: initial,
      builder    : (context, child) => Theme(
        data : Theme.of(context).copyWith(
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
    if (_authToken.isEmpty) {
      ApiErrorHandler.handleUnauthorized();
      return;
    }

    if (eventName.text.trim().isEmpty ||
        eventLocation.text.trim().isEmpty ||
        selectedState.value    == null ||
        selectedDistrict.value == null ||
        startDate.value == null ||
        endDate.value   == null ||
        startTime.value == null ||
        endTime.value   == null) {
      AppSnackbar.error('Please fill all fields');
      return;
    }

    try {
      isLoading.value = true;

      String? base64Image;
      if (imageChanged.value && pickedImage.value != null) {
        final bytes = await pickedImage.value!.readAsBytes();
        final ext   = pickedImage.value!.path.split('.').last.toLowerCase();
        final mime  = ext == 'png'
            ? 'image/png'
            : ext == 'gif'
            ? 'image/gif'
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
        'state'         : selectedState.value,
        'district'      : selectedDistrict.value,
        if (base64Image != null) 'banner_image': base64Image,
      };

      final response = await http.put(
        Uri.parse('$_baseUrl/event/update'),
        headers: _jsonHeaders,
        body   : jsonEncode(requestBody),
      );

      if (response.statusCode == 200) {
        final body = jsonDecode(response.body);
        if (body['status'] == true) {
          AppSnackbar.success(body['message'] ?? 'Event updated successfully');
          await Future.delayed(const Duration(milliseconds: 300));

          if (Get.isRegistered<DistrictAdminGettingEventController>()) {
            Get.find<DistrictAdminGettingEventController>().fetchEvents();
          }

          Get.toNamed('/districtadminhome');
        } else {
          AppSnackbar.error(body['message'] ?? 'Update failed');
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

  // ─── Time Helpers ─────────────────────────────────
  TimeOfDay? _parseTimeOfDay(String time) {
    try {
      final parts  = time.trim().split(' ');
      final isPM   = parts.last.toUpperCase() == 'PM';
      final hm     = parts.first.split(':');
      int   hour   = int.parse(hm[0]);
      final minute = int.parse(hm[1]);
      if (isPM  && hour != 12) hour += 12;
      if (!isPM && hour == 12) hour  = 0;
      return TimeOfDay(hour: hour, minute: minute);
    } catch (_) {
      return null;
    }
  }

  String _formatTimeOfDay(TimeOfDay t) {
    final period = t.period == DayPeriod.am ? 'AM' : 'PM';
    final hour   = t.hourOfPeriod == 0 ? 12 : t.hourOfPeriod;
    final minute = t.minute.toString().padLeft(2, '0');
    return '$hour:$minute $period';
  }

  DateTime _parseDate(String value, DateTime fallback) =>
      DateTime.tryParse(value) ?? fallback;
}