
import 'dart:convert';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

import '../../../../data/errors/api_error.dart';
import '../../../../data/models/districtadmineventmodel.dart';
import '../../../../widgets/areaadminsuccesswidget.dart';


class DistrictAdminGettingEventController extends GetxController {

  // ─── Observables ─────────────────────────────
  final RxList<DistrictAdminEventModel> allEvents    = <DistrictAdminEventModel>[].obs;
  final RxList<DistrictAdminEventModel> recentEvents = <DistrictAdminEventModel>[].obs;

  final RxBool   isLoading    = false.obs;
  final RxBool   isDeleting   = false.obs;
  final RxBool   hasError     = false.obs;
  final RxString errorMessage = ''.obs;

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

  // ─── FETCH EVENTS ─────────────────────────────
  Future<void> fetchEvents() async {

    try {
      isLoading.value    = true;
      hasError.value     = false;
      errorMessage.value = '';

      final res = await http.get(
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

      } else {
        final error = ApiErrorHandler.handleResponse(res);
        _setError(error);
        AppSnackbarss.error(error);
      }

    } catch (e) {
      final error = ApiErrorHandler.handleException(e);
      _setError(error);
      AppSnackbarss.error(error);
    } finally {
      isLoading.value = false;
    }
  }

  // ─── DELETE EVENT ─────────────────────────────
  Future<void> deleteEvent(String id) async {


    try {
      isDeleting.value = true;

      final request = http.Request(
        'DELETE',
        Uri.parse('$_baseUrl/event/delete'),
      );

      request.headers.addAll(_jsonHeaders);
      request.body = jsonEncode({'event_id': int.tryParse(id) ?? id});

      final res = await http.Response.fromStream(await request.send());
      final body = jsonDecode(res.body);

      if (res.statusCode == 200 && body['status'] == true) {

        AppSnackbarss.success(
            body['message'] ?? 'Event deleted successfully');

        await fetchEvents();

      } else {
        AppSnackbarss.error(ApiErrorHandler.handleResponse(res));
      }

    } catch (e) {
      AppSnackbarss.error(ApiErrorHandler.handleException(e));
    } finally {
      isDeleting.value = false;
    }
  }

  // ─── HELPERS ──────────────────────────────────
  void _setError(String msg) {
    hasError.value     = true;
    errorMessage.value = msg;
  }
}