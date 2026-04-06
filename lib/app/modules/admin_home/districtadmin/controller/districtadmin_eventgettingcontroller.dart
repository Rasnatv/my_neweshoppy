
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

import '../../../../data/models/districtadmineventmodel.dart';

class DistrictAdminGettingEventController extends GetxController {

  // ─── Observables ─────────────────────────────
  final RxList<DistrictAdminEventModel> allEvents    = <DistrictAdminEventModel>[].obs;
  final RxList<DistrictAdminEventModel> recentEvents = <DistrictAdminEventModel>[].obs;

  final RxBool   isLoading    = false.obs;
  final RxBool   isDeleting   = false.obs;
  final RxBool   hasError     = false.obs;
  final RxString errorMessage = ''.obs;

  // ─── Storage / Auth ──────────────────────────
  final _box = GetStorage();

  String get token => _box.read('auth_token') ?? '';

  Map<String, String> get _headers => {
    'Authorization': 'Bearer $token',
    'Accept'       : 'application/json',
  };

  Map<String, String> get _jsonHeaders => {
    'Authorization': 'Bearer $token',
    'Accept'       : 'application/json',
    'Content-Type' : 'application/json',
  };

  static const String _baseUrl =
      'https://rasma.astradevelops.in/e_shoppyy/public/api/district-admin';

  @override
  void onInit() {
    super.onInit();
    fetchEvents();
  }

  // ─── Fetch Events ─────────────────────────────
  Future<void> fetchEvents() async {
    if (token.isEmpty) { _handleUnauthorized(); return; }
    try {
      isLoading.value    = true;
      hasError.value     = false;
      errorMessage.value = '';

      final res  = await http.get(
        Uri.parse('$_baseUrl/events'),
        headers: _headers,
      );
      final body = jsonDecode(res.body);

      if (res.statusCode == 200 && body['status'] == true) {
        final events = (body['data'] as List)
            .map((e) => DistrictAdminEventModel.fromJson(e as Map<String, dynamic>))
            .toList();
        allEvents.assignAll(events);
        recentEvents.assignAll(
          events.length > 5 ? events.sublist(0, 5) : events,
        );
      } else if (res.statusCode == 401) {
        _handleUnauthorized();
      } else {
        _setError(body['message'] ?? 'Failed to fetch events');
      }
    } catch (e) {
      _setError(e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  // ─── Delete Event ─────────────────────────────
  Future<void> deleteEvent(String id) async {
    if (token.isEmpty) { _handleUnauthorized(); return; }
    try {
      isDeleting.value = true;

      // http.delete() silently drops body in Flutter — use http.Request instead
      final request = http.Request(
        'DELETE',
        Uri.parse('$_baseUrl/event/delete'),
      );
      request.headers.addAll(_jsonHeaders);
      request.body = jsonEncode({'event_id': int.tryParse(id) ?? id});

      final res  = await http.Response.fromStream(await request.send());
      final body = jsonDecode(res.body);

      if (res.statusCode == 200 && body['status'] == true) {
        Get.snackbar(
          'Deleted',
          body['message'] ?? 'Event deleted successfully',
          backgroundColor: Colors.green.shade50,
          colorText      : Colors.green.shade800,
          snackPosition  : SnackPosition.TOP,
        );
        fetchEvents();
      } else if (res.statusCode == 401) {
        _handleUnauthorized();
      } else {
        Get.snackbar(
          'Error',
          body['message'] ?? 'Failed to delete event',
          backgroundColor: Colors.red.shade50,
          colorText      : Colors.red.shade800,
          snackPosition  : SnackPosition.TOP,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        e.toString(),
        backgroundColor: Colors.red.shade50,
        colorText      : Colors.red.shade800,
        snackPosition  : SnackPosition.TOP,
      );
    } finally {
      isDeleting.value = false;
    }
  }

  // ─── Helpers ──────────────────────────────────
  void _setError(String msg) {
    hasError.value     = true;
    errorMessage.value = msg;
  }

  void _handleUnauthorized() {
    Get.snackbar('Session Expired', 'Please login again');
    _box.erase();
    // Get.offAll(() => DistrictAdminLoginPage());
  }
}

