//
// import 'dart:convert';
// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:get_storage/get_storage.dart';
// import 'package:http/http.dart' as http;
// import 'package:image_cropper/image_cropper.dart';
// import 'package:image_picker/image_picker.dart';
//
// import '../view/area_adminhome.dart';
//
// class AreaAdminUpdateEventController extends GetxController {
//   final _box = GetStorage();
//   var errorBanner = Rx<String?>(null);
//   final Rx<File?> bannerImage = Rx<File?>(null);
//
//   // ─── API URLs ─────────────────────────────────────
//   static const String _eventFetchUrl =
//       'https://rasma.astradevelops.in/e_shoppyy/public/api/event';
//   static const String _eventUpdateUrl =
//       'https://rasma.astradevelops.in/e_shoppyy/public/api/event/update';
//   static const String _statesUrl =
//       'https://rasma.astradevelops.in/e_shoppyy/public/api/get-MerchantStates';
//   static const String _districtsUrl =
//       'https://rasma.astradevelops.in/e_shoppyy/public/api/getMerchant-Districts';
//   static const String _locationsUrl =
//       'https://rasma.astradevelops.in/e_shoppyy/public/api/area-admin/main-locations';
//
//   final ImagePicker picker = ImagePicker();
//
//   // ─── Loading States ───────────────────────────────
//   final isLoading         = false.obs;
//   final isEventLoading    = false.obs;
//   final isLoadingStates   = false.obs;
//   final isLoadingDistricts= false.obs;
//   final isLoadingLocations= false.obs;
//
//   // ─── Dropdown Lists ───────────────────────────────
//   final stateList    = <String>[].obs;
//   final districtList = <String>[].obs;
//   final locationList = <String>[].obs;
//
//   // ─── Selected Dropdown Values ─────────────────────
//   final selectedState        = Rxn<String>();
//   final selectedDistrict     = Rxn<String>();
//   final selectedMainLocation = Rxn<String>();
//
//   // ─── Prefetched Values from API ───────────────────
//   String _prefetchedState    = '';
//   String _prefetchedDistrict = '';
//   String _prefetchedLocation = '';
//
//   // ─── Date / Time ──────────────────────────────────
//   final startDate = RxnString();
//   final endDate   = RxnString();
//   final startTime = RxnString();
//   final endTime   = RxnString();
//
//   // ─── Image ────────────────────────────────────────
//   final pickedImage       = Rxn<File>();
//   final existingBannerUrl = RxnString();
//   final imageChanged      = false.obs;
//
//
//   // ─── Text Controllers ─────────────────────────────
//   final eventName     = TextEditingController();
//   final eventLocation = TextEditingController();
//
//   // ─── Lifecycle ────────────────────────────────────
//   @override
//   void onInit() {
//     super.onInit();
//
//     // Cascade: district depends on state
//     ever(selectedState, (state) {
//       if (state != null && state.isNotEmpty) {
//         selectedDistrict.value     = null;
//         selectedMainLocation.value = null;
//         districtList.clear();
//         locationList.clear();
//         fetchDistricts();
//       }
//     });
//
//     // Cascade: location depends on district
//     ever(selectedDistrict, (district) {
//       if (district != null && district.isNotEmpty) {
//         selectedMainLocation.value = null;
//         locationList.clear();
//         fetchLocations();
//       }
//     });
//   }
//
//   @override
//   void onClose() {
//     eventName.dispose();
//     eventLocation.dispose();
//     super.onClose();
//   }
//
//   // ─── Auth ─────────────────────────────────────────
//   String get _authToken => _box.read('auth_token') ?? '';
//
//   Map<String, String> get _jsonHeaders => {
//     'Authorization': 'Bearer $_authToken',
//     'Accept'       : 'application/json',
//     'Content-Type' : 'application/json',
//   };
//
//   Map<String, String> get _bearerHeaders => {
//     'Authorization': 'Bearer $_authToken',
//     'Accept'       : 'application/json',
//   };
//
//   // ─── Fetch Event ──────────────────────────────────
//   Future<void> fetchEvent(String eventId) async {
//     if (_authToken.isEmpty) {
//       _handleUnauthorized();
//       return;
//     }
//     try {
//       isEventLoading.value = true;
//       final response = await http.post(
//         Uri.parse(_eventFetchUrl),
//         headers: _jsonHeaders,
//         body   : jsonEncode({'event_id': int.tryParse(eventId) ?? eventId}),
//       );
//       final body = jsonDecode(response.body);
//
//       // ✅ API returns data under "0" key, not "data"
//       final eventData = body['0'] ?? body['data'];
//
//       if ((response.statusCode == 200) &&
//           (body['status'] == true || body['status'] == 1) &&
//           eventData != null) {
//         _prefillFromResponse(eventData);
//         // Kick off states fetch — cascade handles district & location
//         await fetchStates();
//       } else if (response.statusCode == 401) {
//         _handleUnauthorized();
//       } else {
//         _showError('Error', body['message'] ?? 'Failed to fetch event');
//       }
//     } catch (e) {
//       _showError('Network Error', e.toString());
//     } finally {
//       isEventLoading.value = false;
//     }
//   }
//
//   // ─── Prefill Fields from API ──────────────────────
//   void _prefillFromResponse(Map<String, dynamic> data) {
//     eventName.text     = data['event_name']     ?? '';
//     eventLocation.text = data['event_location'] ?? '';
//     startDate.value    = data['start_date'];
//     endDate.value      = data['end_date'];
//     startTime.value    = data['start_time'];
//     endTime.value      = data['end_time'];
//     existingBannerUrl.value = data['banner_image'];
//     imageChanged.value = false;
//
//     // Store for pre-selection after dropdowns load
//     _prefetchedState    = data['state']         ?? '';
//     _prefetchedDistrict = data['district']      ?? '';
//     _prefetchedLocation = data['main_location'] ?? '';
//   }
//
//   // ─── Fetch States ─────────────────────────────────
//   Future<void> fetchStates() async {
//     try {
//       isLoadingStates.value = true;
//       final response = await http.get(
//         Uri.parse(_statesUrl),
//         headers: _bearerHeaders,
//       );
//       if (response.statusCode == 200) {
//         final data = jsonDecode(response.body);
//         if (data['status'] == '1' && data['data'] != null) {
//           final List<String> states = List<String>.from(data['data']);
//           stateList.assignAll(states);
//
//           // Pre-select saved state (exact match first, then case-insensitive)
//           if (_prefetchedState.isNotEmpty) {
//             final match = states.firstWhereOrNull(
//                   (s) => s == _prefetchedState,
//             ) ??
//                 states.firstWhereOrNull(
//                       (s) =>
//                   s.toLowerCase() == _prefetchedState.toLowerCase(),
//                 );
//             if (match != null) selectedState.value = match;
//             // ever() will trigger fetchDistricts automatically
//           }
//         }
//       }
//     } catch (e) {
//       debugPrint('fetchStates error: $e');
//     } finally {
//       isLoadingStates.value = false;
//     }
//   }
//
//   // ─── Fetch Districts ──────────────────────────────
//   Future<void> fetchDistricts() async {
//     try {
//       isLoadingDistricts.value = true;
//       final response = await http.get(
//         Uri.parse(_districtsUrl),
//         headers: _bearerHeaders,
//       );
//       if (response.statusCode == 200) {
//         final data = jsonDecode(response.body);
//         if (data['status'] == '1' && data['data'] != null) {
//           final List<String> districts = (data['data'] as List)
//               .map((e) => e['district'].toString())
//               .toSet()
//               .toList(); // deduplicate
//
//           districtList.assignAll(districts);
//
//           // Pre-select saved district
//           if (_prefetchedDistrict.isNotEmpty) {
//             final match = districts.firstWhereOrNull(
//                   (d) => d == _prefetchedDistrict,
//             ) ??
//                 districts.firstWhereOrNull(
//                       (d) =>
//                   d.toLowerCase() == _prefetchedDistrict.toLowerCase(),
//                 );
//             if (match != null) selectedDistrict.value = match;
//             // ever() will trigger fetchLocations automatically
//           }
//         }
//       }
//     } catch (e) {
//       debugPrint('fetchDistricts error: $e');
//     } finally {
//       isLoadingDistricts.value = false;
//     }
//   }
//
//   // ─── Fetch Locations ──────────────────────────────
//   Future<void> fetchLocations() async {
//     try {
//       isLoadingLocations.value = true;
//       final response = await http.get(
//         Uri.parse(_locationsUrl),
//         headers: _bearerHeaders,
//       );
//       if (response.statusCode == 200) {
//         final data = jsonDecode(response.body);
//         if ((data['status'] == 1 || data['status'] == '1') &&
//             data['data'] != null) {
//           final List<String> locations = List<String>.from(data['data']);
//           locationList.assignAll(locations);
//
//           // Pre-select saved location
//           if (_prefetchedLocation.isNotEmpty) {
//             final match = locations.firstWhereOrNull(
//                   (l) => l == _prefetchedLocation,
//             ) ??
//                 locations.firstWhereOrNull(
//                       (l) =>
//                   l.toLowerCase() == _prefetchedLocation.toLowerCase(),
//                 );
//             if (match != null) selectedMainLocation.value = match;
//           }
//         }
//       }
//     } catch (e) {
//       debugPrint('fetchLocations error: $e');
//     } finally {
//       isLoadingLocations.value = false;
//     }
//   }
//
//   Future<void> pickBannerImage() async {
//     final picked = await picker.pickImage(
//       source: ImageSource.gallery,
//       imageQuality: 90,
//     );
//
//     if (picked == null) return;
//
//     File file = File(picked.path);
//
//     final int bytes = await file.length();
//     if (bytes > 1024 * 1024) {
//       errorBanner.value = "Image must be less than 1 MB";
//       return;
//     }
//
//     final croppedFile = await ImageCropper().cropImage(
//       sourcePath: file.path,
//       aspectRatio: const CropAspectRatio(ratioX: 2, ratioY: 1),
//       uiSettings: [
//         AndroidUiSettings(
//           toolbarTitle: 'Crop Banner',
//           toolbarColor: Colors.black,
//           toolbarWidgetColor: Colors.white,
//           lockAspectRatio: true,
//         ),
//         IOSUiSettings(
//           title: 'Crop Banner',
//           aspectRatioLockEnabled: true,
//         ),
//       ],
//     );
//
//     if (croppedFile == null) return;
//
//     file = File(croppedFile.path);
//
//     pickedImage.value = file;   // ✅ FIXED
//     imageChanged.value = true;  // ✅ IMPORTANT
//     errorBanner.value = null;
//   }
//
//   // ─── Pick Date ────────────────────────────────────
//   Future<void> pickDate(BuildContext context, {required bool isStart}) async {
//     final today     = DateTime.now();
//     final todayOnly = DateTime(today.year, today.month, today.day);
//
//     DateTime initial;
//     if (isStart) {
//       initial = startDate.value != null
//           ? _parseDate(startDate.value!, todayOnly)
//           : todayOnly;
//     } else {
//       final startParsed = startDate.value != null
//           ? _parseDate(startDate.value!, todayOnly)
//           : todayOnly;
//       initial = endDate.value != null
//           ? _parseDate(endDate.value!, startParsed)
//           : startParsed;
//     }
//     if (initial.isBefore(todayOnly)) initial = todayOnly;
//
//     final picked = await showDatePicker(
//       context    : context,
//       initialDate: initial,
//       firstDate  : todayOnly,
//       lastDate   : DateTime(2100),
//       builder: (context, child) => Theme(
//         data: Theme.of(context).copyWith(
//           colorScheme: const ColorScheme.light(primary: Color(0xFF4F46E5)),
//         ),
//         child: child!,
//       ),
//     );
//
//     if (picked != null) {
//       final formatted =
//           '${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}';
//       if (isStart) {
//         startDate.value = formatted;
//         if (endDate.value != null) {
//           final end = DateTime.tryParse(endDate.value!);
//           if (end != null && end.isBefore(picked)) endDate.value = null;
//         }
//       } else {
//         endDate.value = formatted;
//       }
//     }
//   }
//
//   // ─── Pick Time ────────────────────────────────────
//   Future<void> pickTime(BuildContext context, {required bool isStart}) async {
//     TimeOfDay initial = TimeOfDay.now();
//     final existing = isStart ? startTime.value : endTime.value;
//     if (existing != null) {
//       final parsed = _parseTimeOfDay(existing);
//       if (parsed != null) initial = parsed;
//     }
//
//     final picked = await showTimePicker(
//       context    : context,
//       initialTime: initial,
//       builder: (context, child) => Theme(
//         data: Theme.of(context).copyWith(
//           colorScheme: const ColorScheme.light(primary: Color(0xFF4F46E5)),
//         ),
//         child: child!,
//       ),
//     );
//
//     if (picked != null) {
//       final formatted = _formatTimeOfDay(picked);
//       if (isStart) {
//         startTime.value = formatted;
//       } else {
//         endTime.value = formatted;
//       }
//     }
//   }
//
//   // ─── Update Event ─────────────────────────────────
//   Future<void> updateEvent(String eventId) async {
//     if (_authToken.isEmpty) {
//       _handleUnauthorized();
//       return;
//     }
//
//     // Validation
//     if (eventName.text.trim().isEmpty) {
//       _showError('Validation', 'Event name is required');
//       return;
//     }
//     if (selectedState.value == null) {
//       _showError('Validation', 'Please select a state');
//       return;
//     }
//     if (selectedDistrict.value == null) {
//       _showError('Validation', 'Please select a district');
//       return;
//     }
//     if (selectedMainLocation.value == null) {
//       _showError('Validation', 'Please select a main location');
//       return;
//     }
//     if (eventLocation.text.trim().isEmpty) {
//       _showError('Validation', 'Event location is required');
//       return;
//     }
//     if (startDate.value == null || endDate.value == null) {
//       _showError('Validation', 'Please select start and end dates');
//       return;
//     }
//     if (startTime.value == null || endTime.value == null) {
//       _showError('Validation', 'Please select start and end times');
//       return;
//     }
//
//     try {
//       isLoading.value = true;
//
//       String? base64Image;
//       if (imageChanged.value && pickedImage.value != null) {
//         final bytes = await pickedImage.value!.readAsBytes();
//         final ext   = pickedImage.value!.path.split('.').last.toLowerCase();
//         final mime  = ext == 'png'
//             ? 'image/png'
//             : ext == 'gif'
//             ? 'image/gif'
//             : 'image/jpeg';
//         base64Image = 'data:$mime;base64,${base64Encode(bytes)}';
//       }
//
//       final Map<String, dynamic> requestBody = {
//         'event_id'      : int.tryParse(eventId) ?? eventId,
//         'event_name'    : eventName.text.trim(),
//         'state'         : selectedState.value,
//         'district'      : selectedDistrict.value,
//         'main_location' : selectedMainLocation.value,
//         'event_location': eventLocation.text.trim(),
//         'start_date'    : startDate.value,
//         'end_date'      : endDate.value,
//         'start_time'    : startTime.value,
//         'end_time'      : endTime.value,
//         if (base64Image != null) 'banner_image': base64Image,
//       };
//
//       final response = await http.put(
//         Uri.parse(_eventUpdateUrl),
//         headers: _jsonHeaders,
//         body   : jsonEncode(requestBody),
//       );
//
//       final body = jsonDecode(response.body);
//
//       if (response.statusCode == 200 &&
//           (body['status'] == true || body['status'] == 1)) {
//         _showSuccess('Success', body['message'] ?? 'Event updated successfully');
//         await Future.delayed(const Duration(milliseconds: 300));
//         Get.offAll(() => AreaAdminhomepage());
//       } else if (response.statusCode == 401) {
//         _handleUnauthorized();
//       } else {
//         _showError('Error', body['message'] ?? 'Update failed');
//       }
//     } catch (e) {
//       _showError('Network Error', e.toString());
//     } finally {
//       isLoading.value = false;
//     }
//   }
//
//   // ─── Time Helpers ─────────────────────────────────
//   TimeOfDay? _parseTimeOfDay(String time) {
//     try {
//       final parts  = time.trim().split(' ');
//       final isPM   = parts.last.toUpperCase() == 'PM';
//       final hm     = parts.first.split(':');
//       int hour     = int.parse(hm[0]);
//       final minute = int.parse(hm[1]);
//       if (isPM && hour != 12) hour += 12;
//       if (!isPM && hour == 12) hour = 0;
//       return TimeOfDay(hour: hour, minute: minute);
//     } catch (_) {
//       return null;
//     }
//   }
//
//   String _formatTimeOfDay(TimeOfDay t) {
//     final period = t.period == DayPeriod.am ? 'AM' : 'PM';
//     final hour   = t.hourOfPeriod == 0 ? 12 : t.hourOfPeriod;
//     final minute = t.minute.toString().padLeft(2, '0');
//     return '$hour:$minute $period';
//   }
//
//   DateTime _parseDate(String value, DateTime fallback) =>
//       DateTime.tryParse(value) ?? fallback;
//
//   // ─── Auth / UI Helpers ────────────────────────────
//   void _handleUnauthorized() {
//     _box.erase();
//     Get.offAllNamed('/login');
//   }
//
//   void _showError(String title, String message) => Get.snackbar(
//     title, message,
//     backgroundColor: Colors.red.shade50,
//     colorText      : Colors.red.shade800,
//     snackPosition  : SnackPosition.TOP,
//   );
//
//   void _showSuccess(String title, String message) => Get.snackbar(
//     title, message,
//     backgroundColor: Colors.green.shade50,
//     colorText      : Colors.green.shade800,
//     snackPosition  : SnackPosition.TOP,
//   );
// }
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

import '../../../data/errors/api_error.dart';
import '../../../widgets/areaadminsuccesswidget.dart';
import '../view/area_adminhome.dart';

class AreaAdminUpdateEventController extends GetxController {
  final _box = GetStorage();
  var errorBanner = Rx<String?>(null);
  final Rx<File?> bannerImage = Rx<File?>(null);

  // ─── API URLs ─────────────────────────────────────
  static const String _eventFetchUrl =
      'https://rasma.astradevelops.in/e_shoppyy/public/api/event';
  static const String _eventUpdateUrl =
      'https://rasma.astradevelops.in/e_shoppyy/public/api/event/update';
  static const String _statesUrl =
      'https://rasma.astradevelops.in/e_shoppyy/public/api/get-MerchantStates';
  static const String _districtsUrl =
      'https://rasma.astradevelops.in/e_shoppyy/public/api/getMerchant-Districts';
  static const String _locationsUrl =
      'https://rasma.astradevelops.in/e_shoppyy/public/api/area-admin/main-locations';

  final ImagePicker picker = ImagePicker();

  // ─── Loading States ───────────────────────────────
  final isLoading          = false.obs;
  final isEventLoading     = false.obs;
  final isLoadingStates    = false.obs;
  final isLoadingDistricts = false.obs;
  final isLoadingLocations = false.obs;

  // ─── Dropdown Lists ───────────────────────────────
  final stateList    = <String>[].obs;
  final districtList = <String>[].obs;
  final locationList = <String>[].obs;

  // ─── Selected Dropdown Values ─────────────────────
  final selectedState        = Rxn<String>();
  final selectedDistrict     = Rxn<String>();
  final selectedMainLocation = Rxn<String>();

  // ─── Prefetched Values from API ───────────────────
  String _prefetchedState    = '';
  String _prefetchedDistrict = '';
  String _prefetchedLocation = '';

  // ─── Date / Time ──────────────────────────────────
  final startDate = RxnString();
  final endDate   = RxnString();
  final startTime = RxnString();
  final endTime   = RxnString();

  // ─── Image ────────────────────────────────────────
  final pickedImage       = Rxn<File>();
  final existingBannerUrl = RxnString();
  final imageChanged      = false.obs;

  // ─── Text Controllers ─────────────────────────────
  final eventName     = TextEditingController();
  final eventLocation = TextEditingController();

  // ─── Lifecycle ────────────────────────────────────
  @override
  void onInit() {
    super.onInit();

    ever(selectedState, (state) {
      if (state != null && state.isNotEmpty) {
        selectedDistrict.value     = null;
        selectedMainLocation.value = null;
        districtList.clear();
        locationList.clear();
        fetchDistricts();
      }
    });

    ever(selectedDistrict, (district) {
      if (district != null && district.isNotEmpty) {
        selectedMainLocation.value = null;
        locationList.clear();
        fetchLocations();
      }
    });
  }

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

  Map<String, String> get _bearerHeaders => {
    'Authorization': 'Bearer $_authToken',
    'Accept'       : 'application/json',
  };

  // ─── Fetch Event ──────────────────────────────────
  Future<void> fetchEvent(String eventId) async {
    if (_authToken.isEmpty) {
      ApiErrorHandler.handleUnauthorized();
      return;
    }
    try {
      isEventLoading.value = true;
      final response = await http.post(
        Uri.parse(_eventFetchUrl),
        headers: _jsonHeaders,
        body   : jsonEncode({'event_id': int.tryParse(eventId) ?? eventId}),
      );

      if (response.statusCode == 200) {
        final body = jsonDecode(response.body);
        final eventData = body['0'] ?? body['data'];

        if ((body['status'] == true || body['status'] == 1) &&
            eventData != null) {
          _prefillFromResponse(eventData);
          await fetchStates();
        } else {
          AppSnackbarss.error(body['message'] ?? 'Failed to fetch event');
        }
      } else {
        final errorMsg = ApiErrorHandler.handleResponse(response);
        if (response.statusCode != 401) AppSnackbarss.error(errorMsg);
      }
    } catch (e) {
      AppSnackbarss.error(ApiErrorHandler.handleException(e));
    } finally {
      isEventLoading.value = false;
    }
  }

  // ─── Prefill Fields from API ──────────────────────
  void _prefillFromResponse(Map<String, dynamic> data) {
    eventName.text          = data['event_name']     ?? '';
    eventLocation.text      = data['event_location'] ?? '';
    startDate.value         = data['start_date'];
    endDate.value           = data['end_date'];
    startTime.value         = data['start_time'];
    endTime.value           = data['end_time'];
    existingBannerUrl.value = data['banner_image'];
    imageChanged.value      = false;

    _prefetchedState    = data['state']         ?? '';
    _prefetchedDistrict = data['district']      ?? '';
    _prefetchedLocation = data['main_location'] ?? '';
  }

  // ─── Fetch States ─────────────────────────────────
  Future<void> fetchStates() async {
    try {
      isLoadingStates.value = true;
      final response = await http.get(
        Uri.parse(_statesUrl),
        headers: _bearerHeaders,
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['status'] == '1' && data['data'] != null) {
          final List<String> states = List<String>.from(data['data']);
          stateList.assignAll(states);

          if (_prefetchedState.isNotEmpty) {
            final match = states.firstWhereOrNull(
                  (s) => s == _prefetchedState,
            ) ??
                states.firstWhereOrNull(
                      (s) => s.toLowerCase() == _prefetchedState.toLowerCase(),
                );
            if (match != null) selectedState.value = match;
          }
        } else {
          AppSnackbarss.error(data['message'] ?? 'Failed to load states');
        }
      } else {
        final errorMsg = ApiErrorHandler.handleResponse(response);
        if (response.statusCode != 401) AppSnackbarss.error(errorMsg);
      }

    } catch (e) {
      AppSnackbarss.error(ApiErrorHandler.handleException(e));
    } finally {
      isLoadingStates.value = false;
    }
  }

  // ─── Fetch Districts ──────────────────────────────
  Future<void> fetchDistricts() async {
    try {
      isLoadingDistricts.value = true;
      final response = await http.get(
        Uri.parse(_districtsUrl),
        headers: _bearerHeaders,
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['status'] == '1' && data['data'] != null) {
          final List<String> districts = (data['data'] as List)
              .map((e) => e['district'].toString())
              .toSet()
              .toList();
          districtList.assignAll(districts);

          if (_prefetchedDistrict.isNotEmpty) {
            final match = districts.firstWhereOrNull(
                  (d) => d == _prefetchedDistrict,
            ) ??
                districts.firstWhereOrNull(
                      (d) =>
                  d.toLowerCase() == _prefetchedDistrict.toLowerCase(),
                );
            if (match != null) selectedDistrict.value = match;
          }
        } else {
          AppSnackbarss.error(data['message'] ?? 'Failed to load districts');
        }
      } else {
        final errorMsg = ApiErrorHandler.handleResponse(response);
        if (response.statusCode != 401) AppSnackbarss.error(errorMsg);
      }
    } catch (e) {
      AppSnackbarss.error(ApiErrorHandler.handleException(e));
    } finally {
      isLoadingDistricts.value = false;
    }
  }

  // ─── Fetch Locations ──────────────────────────────
  Future<void> fetchLocations() async {
    try {
      isLoadingLocations.value = true;
      final response = await http.get(
        Uri.parse(_locationsUrl),
        headers: _bearerHeaders,
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if ((data['status'] == 1 || data['status'] == '1') &&
            data['data'] != null) {
          final List<String> locations = List<String>.from(data['data']);
          locationList.assignAll(locations);

          if (_prefetchedLocation.isNotEmpty) {
            final match = locations.firstWhereOrNull(
                  (l) => l == _prefetchedLocation,
            ) ??
                locations.firstWhereOrNull(
                      (l) =>
                  l.toLowerCase() == _prefetchedLocation.toLowerCase(),
                );
            if (match != null) selectedMainLocation.value = match;
          }
        } else {
          AppSnackbarss.error(data['message'] ?? 'Failed to load locations');
        }
      } else {
        final errorMsg = ApiErrorHandler.handleResponse(response);
        if (response.statusCode != 401) AppSnackbarss.error(errorMsg);
      }
    } catch (e) {
      AppSnackbarss.error(ApiErrorHandler.handleException(e));
    } finally {
      isLoadingLocations.value = false;
    }
  }

  // ─── Image Picker ─────────────────────────────────
  Future<void> pickBannerImage() async {
    final picked = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 90,
    );

    if (picked == null) return;

    File file = File(picked.path);

    final int bytes = await file.length();
    if (bytes > 1024 * 1024) {
      errorBanner.value = "Image must be less than 1 MB";
      AppSnackbarss.warning("Image must be less than 1 MB");
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
    if (_authToken.isEmpty) {
      ApiErrorHandler.handleUnauthorized();
      return;
    }

    // ─── Validation ───────────────────────────────
    if (eventName.text.trim().isEmpty) {
      AppSnackbarss.warning('Event name is required');
      return;
    }
    if (selectedState.value == null) {
      AppSnackbarss.warning('Please select a state');
      return;
    }
    if (selectedDistrict.value == null) {
      AppSnackbarss.warning('Please select a district');
      return;
    }
    if (selectedMainLocation.value == null) {
      AppSnackbarss.warning('Please select a main location');
      return;
    }
    if (eventLocation.text.trim().isEmpty) {
      AppSnackbarss.warning('Event location is required');
      return;
    }
    if (startDate.value == null || endDate.value == null) {
      AppSnackbarss.warning('Please select start and end dates');
      return;
    }
    if (startTime.value == null || endTime.value == null) {
      AppSnackbarss.warning('Please select start and end times');
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
        'state'         : selectedState.value,
        'district'      : selectedDistrict.value,
        'main_location' : selectedMainLocation.value,
        'event_location': eventLocation.text.trim(),
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

      if (response.statusCode == 200) {
        final body = jsonDecode(response.body);
        if (body['status'] == true || body['status'] == 1) {
          AppSnackbarss.success(body['message'] ?? 'Event updated successfully');
          await Future.delayed(const Duration(milliseconds: 300));
          Get.offAll(() => AreaAdminhomepage());
        } else {
          AppSnackbarss.error(body['message'] ?? 'Update failed');
        }
      } else {
        final errorMsg = ApiErrorHandler.handleResponse(response);
        if (response.statusCode != 401) AppSnackbarss.error(errorMsg);
      }
    } catch (e) {
      AppSnackbarss.error(ApiErrorHandler.handleException(e));
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