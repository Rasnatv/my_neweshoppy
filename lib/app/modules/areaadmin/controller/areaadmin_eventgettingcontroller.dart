//
// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:get_storage/get_storage.dart';
// import 'package:http/http.dart' as http;
//
// import '../../../data/models/areaadmin_eventsgetmodel.dart';
//
// class AreaadminGettingEventController extends GetxController {
//   var isLoading = false.obs;
//   var hasError = false.obs;
//   var errorMessage = ''.obs;
//
//   var allEvents = <AreaAdmingshowEventModel>[].obs;
//   var recentEvents = <AreaAdmingshowEventModel>[].obs;
//
//   final box = GetStorage();
//
//   @override
//   void onInit() {
//     super.onInit();
//     fetchEvents();
//   }
//
//   Future<void> fetchEvents() async {
//     try {
//       isLoading(true);
//       hasError(false);
//       errorMessage('');
//
//       // ✅ Read token — will work now that GetStorage.init() is called in main
//       final String? token = box.read("auth_token");
//
//       if (token == null || token.isEmpty) {
//         hasError(true);
//         errorMessage('No auth token found. Please log in again.');
//         return;
//       }
//
//       final response = await http.get(
//         Uri.parse("https://rasma.astradevelops.in/e_shoppyy/public/api/events"),
//         headers: {
//           "Accept": "application/json",
//           "Authorization": "Bearer $token",
//         },
//       );
//
//       if (response.statusCode == 200) {
//         final data = jsonDecode(response.body);
//
//         // ✅ Correct — handles both int 1 and boolean true
//         if ((data['status'] == 1 || data['status'] == true) && data['data'] != null) {
//           final List list = data['data'];
//
//           List<AreaAdmingshowEventModel> events =
//           list.map((e) => AreaAdmingshowEventModel.fromJson(e)).toList();
//
//           events.sort((a, b) {
//             try {
//               return DateTime.parse(b.createdAt)
//                   .compareTo(DateTime.parse(a.createdAt));
//             } catch (_) {
//               return 0; // treat unparseable dates as equal
//             }
//           });
//           allEvents.value = events;
//           recentEvents.value = events.take(3).toList();
//         } else {
//           hasError(true);
//           errorMessage(data['message'] ?? 'No events found.');
//         }
//       } else if (response.statusCode == 401) {
//         hasError(true);
//         errorMessage('Session expired. Please log in again.');
//       } else {
//         hasError(true);
//         errorMessage('Server error: ${response.statusCode}');
//       }
//     } catch (e) {
//       hasError(true);
//       errorMessage('Something went wrong: $e');
//     } finally {
//       isLoading(false);
//     }
//   }
//   Future<void> deleteEvent(String eventId) async {
//     // Optimistically remove from both lists immediately
//     recentEvents.removeWhere((e) => e.id == eventId);
//     allEvents.removeWhere((e) => e.id == eventId);
//
//     try {
//       final String? token = box.read("auth_token");
//
//       if (token == null || token.isEmpty) {
//         Get.snackbar('Error', 'No auth token found. Please log in again.',
//             backgroundColor: Colors.red, colorText: Colors.white);
//         return;
//       }
//
//       final response = await http.delete(
//         Uri.parse("https://rasma.astradevelops.in/e_shoppyy/public/api/event/delete"),
//         headers: {
//           "Accept": "application/json",
//           "Authorization": "Bearer $token",
//         },
//         body: {
//           "event_id": eventId.toString(),
//         },
//       );
//
//       final data = jsonDecode(response.body);
//
//       if (response.statusCode == 200 && data['status'] == true) {
//         Get.snackbar('Success', data['message'] ?? 'Event deleted successfully',
//             backgroundColor: Colors.green, colorText: Colors.white);
//       } else {
//         // Rollback failed: re-fetch to restore original state
//         Get.snackbar('Error', data['message'] ?? 'Failed to delete event.',
//             backgroundColor: Colors.red, colorText: Colors.white);
//         fetchEvents(); // restore list if delete failed on server
//       }
//     } catch (e) {
//       Get.snackbar('Error', 'Something went wrong: $e',
//           backgroundColor: Colors.red, colorText: Colors.white);
//       fetchEvents(); // restore on exception too
//     }
//   }
// }
import 'dart:convert';
import 'dart:io';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

import '../../../data/models/areaadmin_eventsgetmodel.dart';
import '../../../data/errors/api_error.dart';
import '../../../widgets/areaadminsuccesswidget.dart';

class AreaadminGettingEventController extends GetxController {
  var isLoading = false.obs;
  var hasError = false.obs;
  var errorMessage = ''.obs;

  var allEvents = <AreaAdmingshowEventModel>[].obs;
  var recentEvents = <AreaAdmingshowEventModel>[].obs;

  final box = GetStorage();

  String get _token => box.read("auth_token") ?? "";

  @override
  void onInit() {
    super.onInit();
    fetchEvents();
  }

  // ─── FETCH EVENTS ─────────────────────────────────
  Future<void> fetchEvents() async {
    try {
      isLoading(true);
      hasError(false);
      errorMessage('');

      final response = await http.get(
        Uri.parse("https://rasma.astradevelops.in/e_shoppyy/public/api/events"),
        headers: {
          "Accept": "application/json",
          "Authorization": "Bearer $_token",
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        if ((data['status'] == 1 || data['status'] == true) &&
            data['data'] != null) {

          final List list = data['data'];

          List<AreaAdmingshowEventModel> events =
          list.map((e) => AreaAdmingshowEventModel.fromJson(e)).toList();

          /// ✅ Sort latest first
          events.sort((a, b) {
            try {
              return DateTime.parse(b.createdAt)
                  .compareTo(DateTime.parse(a.createdAt));
            } catch (_) {
              return 0;
            }
          });

          allEvents.value = events;
          recentEvents.value = events.take(3).toList();

        } else {
          hasError(true);
          errorMessage(data['message'] ?? 'No events found');
        }

      } else {
        /// ❌ Central error handling
        final error = ApiErrorHandler.handleResponse(response);
        hasError(true);
        errorMessage(error);

        if (error.isNotEmpty) {
          AppSnackbarss.error(error);
        }
      }

    } on SocketException {
      hasError(true);
      errorMessage("No internet connection");
      AppSnackbarss.error("No internet connection");

    } catch (e) {
      hasError(true);
      final err = ApiErrorHandler.handleException(e);
      errorMessage(err);
      AppSnackbarss.error(err);

    } finally {
      isLoading(false);
    }
  }

  // ─── DELETE EVENT ─────────────────────────────────
  Future<void> deleteEvent(String eventId) async {
    /// ✅ Backup for rollback
    final backupAll = List<AreaAdmingshowEventModel>.from(allEvents);
    final backupRecent = List<AreaAdmingshowEventModel>.from(recentEvents);

    /// ✅ Optimistic UI update
    allEvents.removeWhere((e) => e.id == eventId);
    recentEvents.removeWhere((e) => e.id == eventId);

    try {

      final response = await http.delete(
        Uri.parse(
            "https://rasma.astradevelops.in/e_shoppyy/public/api/event/delete"),
        headers: {
          "Accept": "application/json",
          "Authorization": "Bearer $_token",
        },
        body: {
          "event_id": eventId.toString(),
        },
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200 && data['status'] == true) {
        AppSnackbarss.success(
            data['message'] ?? 'Event deleted successfully');
      } else {
        /// ❌ Rollback
        allEvents.value = backupAll;
        recentEvents.value = backupRecent;

        final error = ApiErrorHandler.handleResponse(response);
        if (error.isNotEmpty) AppSnackbarss.error(error);
      }
    } catch (e) {
      AppSnackbarss.error(ApiErrorHandler.handleException(e));
    }
  }}