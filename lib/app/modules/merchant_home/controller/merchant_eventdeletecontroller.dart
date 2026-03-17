import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class DeleteEventController extends GetxController {
  final RxSet<dynamic> deletingIds = <dynamic>{}.obs;
  final box = GetStorage();

  Future<void> deleteEvent(dynamic eventId, VoidCallback onSuccess) async {
    final String? authToken = box.read('auth_token');

    if (authToken == null) {
      Get.snackbar(
        'Unauthorized',
        'Auth token not found. Please login again.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    deletingIds.add(eventId);

    try {
      final response = await http.delete(
        Uri.parse(
            'https://rasma.astradevelops.in/e_shoppyy/public/api/delete-event'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $authToken',
        },
        body: jsonEncode({
          'event_id': int.parse(eventId.toString()),
        }),
      );

      final data = jsonDecode(response.body);

      if (data['status'] == '1') {
        onSuccess();
        Get.snackbar(
          'Deleted',
          data['message'] ?? 'Event deleted successfully',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
          duration: const Duration(seconds: 2),
        );
      } else {
        Get.snackbar(
          'Failed',
          data['message'] ?? 'Failed to delete event',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Something went wrong. Please try again.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      deletingIds.remove(eventId);
    }
  }
}