
import 'dart:convert';
import 'dart:io';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

import '../services/session manager.dart';

class ApiErrorHandler {
  static final box = GetStorage();

  static String handleResponse(http.Response response) {
    final statusCode = response.statusCode;
    final message = _extractMessage(response.body);

    switch (statusCode) {
      case 400:
        return message ?? "Bad request";
      case 401:

        //
         handleUnauthorized();
         return ""; // ✅ prevent duplicate snackbar
        // return message ?? "Session expired. Please login agoain";
      case 403:
        return message ?? "Access denied";
      case 404:
        return message ?? "Not found";
      case 422:
        return message ?? "Validation error";
      case 500:
        return message ?? "Server error";
      default:
        return message ?? "Something went wrong";
    }
  }

  // static String handleException(dynamic error) {
  //   if (error is SocketException) {
  //     return "No internet connection";
  //   }
  //   return "Unexpected error occurred";
  // }
  static String handleException(dynamic error) {
    if (error is SocketException) {
      return ""; // ✅ IMPORTANT: return empty
    }
    return "Unexpected error occurred";
  }

  static String? _extractMessage(String body) {
    try {
      final decoded = jsonDecode(body);
      if (decoded is Map<String, dynamic>) {
        return decoded['message']?.toString();
      }
    } catch (_) {}
    return null;
  }

  static void handleUnauthorized() {
    final token = box.read("auth_token");

    if (token != null && token
        .toString()
        .isNotEmpty) {
      box.remove("auth_token");
    }

    Get.offAllNamed('/login');
  }
   }
