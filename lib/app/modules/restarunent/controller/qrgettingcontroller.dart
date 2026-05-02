//
// import 'dart:convert';
// import 'dart:io';
// import 'package:get/get.dart';
// import 'package:get_storage/get_storage.dart';
// import 'package:http/http.dart' as http;
//
// import '../../../data/models/resaturantqrmodel.dart';
//
// class PaymentgettController extends GetxController {
//   final box = GetStorage();
//
//   final RxBool isLoading = false.obs;
//   final RxString errorMessage = ''.obs;
//   final Rx<PaymentResponseModel?> paymentResponse = Rx(null);
//
//   late final List<String> restaurantIds;
//
//   @override
//   void onInit() {
//     super.onInit();
//     final args = Get.arguments;
//     if (args != null && args is List<String>) {
//       restaurantIds = args;
//     } else {
//       restaurantIds = [];
//     }
//     fetchPaymentDetails();
//   }
//
//   String get authToken => box.read('auth_token') ?? '';
//
//   double get grandTotal {
//     if (paymentResponse.value == null) return 0.0;
//     return paymentResponse.value!.data
//         .fold(0.0, (sum, item) => sum + item.totalPrice);
//   }
//
//   Map<String, String> get _headers => {
//     'Content-Type': 'application/json',
//     'Accept': 'application/json',
//     'Authorization': 'Bearer $authToken',
//   };
//
//   // ── Fetch Payment Details ────────────────────────────────────────────────────
//   Future<void> fetchPaymentDetails() async {
//     if (restaurantIds.isEmpty) {
//       errorMessage.value = 'No restaurant IDs provided';
//       return;
//     }
//
//     try {
//       isLoading.value = true;
//       errorMessage.value = '';
//
//       final response = await http.post(
//         Uri.parse('https://eshoppy.co.in/api/getPayment-Details'),
//         headers: _headers,
//         body: jsonEncode({'restaurant_ids': restaurantIds}),
//       );
//
//       final json = jsonDecode(response.body);
//
//       if (response.statusCode == 200 && json['status'] == true) {
//         paymentResponse.value = PaymentResponseModel.fromJson(json);
//       } else {
//         errorMessage.value =
//             json['message'] ?? 'Failed to load payment details';
//       }
//     } catch (e) {
//       errorMessage.value = 'Network error. Please check your connection.';
//     } finally {
//       isLoading.value = false;
//     }
//   }
//
//   // ── Store Transaction ────────────────────────────────────────────────────────
//   Future<bool> storeTransaction({
//     required dynamic restaurantId,
//     required String transactionId,
//     String? screenshotPath,
//   }) async {
//     try {
//       final int? parsedId = restaurantId is int
//           ? restaurantId
//           : int.tryParse(restaurantId.toString());
//
//       final Map<String, dynamic> body = {
//         'restaurant_id': parsedId ?? restaurantId.toString(),
//         'transaction_id': transactionId,
//       };
//
//       if (screenshotPath != null && screenshotPath.isNotEmpty) {
//         final file = File(screenshotPath);
//         if (await file.exists()) {
//           final bytes = await file.readAsBytes();
//           final base64Str = base64Encode(bytes);
//           final ext = screenshotPath.split('.').last.toLowerCase();
//           final mime = ext == 'png' ? 'image/png' : 'image/jpeg';
//           body['payment_screenshot'] = 'data:$mime;base64,$base64Str';
//         }
//       }
//
//       final response = await http.post(
//         Uri.parse('https://eshoppy.co.in/api/store-Transaction'),
//         headers: _headers,
//         body: jsonEncode(body),
//       );
//
//       final json = jsonDecode(response.body);
//
//       if (response.statusCode == 200 && json['status'] == true) {
//         return true;
//       } else {
//         Get.snackbar(
//           'Transaction Failed',
//           json['message'] ?? 'Could not store transaction. Try again.',
//           snackPosition: SnackPosition.BOTTOM,
//         );
//         return false;
//       }
//     } catch (e) {
//       Get.snackbar(
//         'Network Error',
//         'Could not connect. Please check your connection.',
//         snackPosition: SnackPosition.BOTTOM,
//       );
//       return false;
//     }
//   }
// }
import 'dart:convert';
import 'dart:io';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

import '../../../data/errors/api_error.dart';
import '../../../data/models/resaturantqrmodel.dart'; // ← adjust path
import '../../merchantlogin/widget/successwidget.dart';  // ← adjust path

class PaymentgettController extends GetxController {
  final box = GetStorage();

  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;
  final Rx<PaymentResponseModel?> paymentResponse = Rx(null);

  late final List<String> restaurantIds;

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments;
    if (args != null && args is List<String>) {
      restaurantIds = args;
    } else {
      restaurantIds = [];
    }
    fetchPaymentDetails();
  }

  String get authToken => box.read('auth_token') ?? '';

  double get grandTotal {
    if (paymentResponse.value == null) return 0.0;
    return paymentResponse.value!.data
        .fold(0.0, (sum, item) => sum + item.totalPrice);
  }

  Map<String, String> get _headers => {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
    'Authorization': 'Bearer $authToken',
  };

  // ── Fetch Payment Details ──────────────────────────────────────────────────
  Future<void> fetchPaymentDetails() async {
    if (restaurantIds.isEmpty) {
      errorMessage.value = 'No restaurant IDs provided';
      AppSnackbar.warning('No restaurant IDs provided');
      return;
    }

    try {
      isLoading.value = true;
      errorMessage.value = '';

      final response = await http.post(
        Uri.parse('https://eshoppy.co.in/api/getPayment-Details'),
        headers: _headers,
        body: jsonEncode({'restaurant_ids': restaurantIds}),
      );

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        if (json['status'] == true) {
          paymentResponse.value = PaymentResponseModel.fromJson(json);
        } else {
          final msg = json['message'] ?? 'Failed to load payment details';
          errorMessage.value = msg;
          AppSnackbar.error(msg);
        }
      } else {
        final msg = ApiErrorHandler.handleResponse(response);
        errorMessage.value = msg;
        if (msg.isNotEmpty) AppSnackbar.error(msg);
      }
    } catch (e) {
      final msg = ApiErrorHandler.handleException(e);
      errorMessage.value = msg.isNotEmpty ? msg : 'Network error. Please check your connection.';
      if (msg.isNotEmpty) AppSnackbar.error(msg);
    } finally {
      isLoading.value = false;
    }
  }

  // ── Store Transaction ──────────────────────────────────────────────────────
  Future<bool> storeTransaction({
    required dynamic restaurantId,
    required String transactionId,
    String? screenshotPath,
  }) async {
    try {
      final int? parsedId = restaurantId is int
          ? restaurantId
          : int.tryParse(restaurantId.toString());

      final Map<String, dynamic> body = {
        'restaurant_id': parsedId ?? restaurantId.toString(),
        'transaction_id': transactionId,
      };

      if (screenshotPath != null && screenshotPath.isNotEmpty) {
        final file = File(screenshotPath);
        if (await file.exists()) {
          final bytes = await file.readAsBytes();
          final base64Str = base64Encode(bytes);
          final ext = screenshotPath.split('.').last.toLowerCase();
          final mime = ext == 'png' ? 'image/png' : 'image/jpeg';
          body['payment_screenshot'] = 'data:$mime;base64,$base64Str';
        }
      }

      final response = await http.post(
        Uri.parse('https://eshoppy.co.in/api/store-Transaction'),
        headers: _headers,
        body: jsonEncode(body),
      );

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        if (json['status'] == true) {
          AppSnackbar.success('Transaction stored successfully');
          return true;
        } else {
          final msg = json['message'] ?? 'Could not store transaction. Try again.';
          AppSnackbar.error(msg);
          return false;
        }
      } else {
        final msg = ApiErrorHandler.handleResponse(response);
        if (msg.isNotEmpty) AppSnackbar.error(msg);
        return false;
      }
    } catch (e) {
      final msg = ApiErrorHandler.handleException(e);
      if (msg.isNotEmpty) AppSnackbar.error(msg);
      return false;
    }
  }
}