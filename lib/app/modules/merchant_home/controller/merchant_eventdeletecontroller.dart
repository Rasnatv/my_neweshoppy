
import 'dart:ui';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../../../data/errors/api_error.dart';
import '../../merchantlogin/widget/successwidget.dart';

class DeleteEventController extends GetxController {
  final RxSet<dynamic> deletingIds = <dynamic>{}.obs;
  final box = GetStorage();

  Future<void> deleteEvent(dynamic eventId, VoidCallback onSuccess) async {
    final String? authToken = box.read('auth_token');


    deletingIds.add(eventId);

    try {
      final response = await http.delete(
        Uri.parse(
          'https://eshoppy.co.in/api/delete-event',
        ),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $authToken',
        },
        body: jsonEncode({
          'event_id': int.parse(eventId.toString()),
        }),
      );

      /// ✅ 2. HANDLE HTTP ERRORS (IMPORTANT)
      if (response.statusCode != 200) {
        final errorMessage = ApiErrorHandler.handleResponse(response);
        AppSnackbar.error(errorMessage);
        return;
      }

      final data = jsonDecode(response.body);

      /// ✅ 3. HANDLE API RESPONSE
      if (data['status'] == '1') {
        AppSnackbar.success(data['message'] ?? "Event deleted successfully");
        onSuccess();
      } else {
        AppSnackbar.error(data['message'] ?? "Failed to delete event");
      }
    } catch (e) {
      /// ✅ 4. HANDLE EXCEPTIONS
      final errorMessage = ApiErrorHandler.handleException(e);
      AppSnackbar.error(errorMessage);
    } finally {
      deletingIds.remove(eventId);
    }
  }
}