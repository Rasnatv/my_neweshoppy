
import 'dart:convert';
import 'dart:io';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

import '../../../data/models/areaadmin_eventsgetmodel.dart';
import '../../../data/errors/api_error.dart';
import '../../merchantlogin/widget/successwidget.dart';
import 'areaadmin_dashboardcountcnroller.dart';

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
        Uri.parse("https://eshoppy.co.in/api/events"),
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

        }

      } else {
        /// ❌ Central error handling
        final error = ApiErrorHandler.handleResponse(response);
        hasError(true);
        errorMessage(error);

        if (error.isNotEmpty) {
          AppSnackbar.error(error);
        }
      }

    }  catch (e) {
      hasError(true);
      final err = ApiErrorHandler.handleException(e);
      errorMessage(err);
      AppSnackbar.error(err);

    } finally {
      isLoading(false);
    }
  }

  Future<void> deleteEvent(String eventId) async {
    final backupAll = List<AreaAdmingshowEventModel>.from(allEvents);
    final backupRecent = List<AreaAdmingshowEventModel>.from(recentEvents);

    // Optimistic remove
    allEvents.removeWhere((e) => e.id == eventId);
    recentEvents.removeWhere((e) => e.id == eventId);

    try {
      final response = await http.delete(
        Uri.parse("https://eshoppy.co.in/api/event/delete"),
        headers: {
          "Accept": "application/json",
          "Authorization": "Bearer $_token",
        },
        body: {
          "event_id": eventId.toString(),
        },
      );

      final data = jsonDecode(response.body);

      // ✅ Fix: match same status check as fetchEvents
      final isSuccess = response.statusCode == 200 &&
          (data['status'] == true || data['status'] == 1);

      if (isSuccess) {
        AppSnackbar.success(data['message'] ?? 'Event deleted successfully');
        await fetchEvents(); // ✅ re-fetch to sync server state
      } else {
        // Rollback optimistic update
        allEvents.value = backupAll;
        recentEvents.value = backupRecent;

        final error = ApiErrorHandler.handleResponse(response);
        if (error.isNotEmpty) AppSnackbar.error(error);
      }
    } catch (e) {
      // Rollback on network error too
      allEvents.value = backupAll;
      recentEvents.value = backupRecent;
      AppSnackbar.error(ApiErrorHandler.handleException(e));
    }
  }}
