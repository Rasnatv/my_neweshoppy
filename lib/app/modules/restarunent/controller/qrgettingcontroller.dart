//
// import 'dart:convert';
// import 'package:get/get.dart';
// import 'package:get_storage/get_storage.dart';
// import 'package:http/http.dart' as http;
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
//
//     final args = Get.arguments;
//     if (args != null && args is List<String>) {
//       restaurantIds = args;
//     } else {
//       restaurantIds = [];
//     }
//
//     fetchPaymentDetails();
//   }
//
//   String get authToken => box.read('auth_token') ?? '';
//
//   double get grandTotal {
//     if (paymentResponse.value == null) return 0.0;
//
//     return paymentResponse.value!.data
//         .fold(0.0, (sum, item) => sum + item.totalPrice);
//   }
//
//   Future<void> fetchPaymentDetails() async {
//     if (restaurantIds.isEmpty) {
//       errorMessage.value = 'No restaurant IDs provided.';
//       return;
//     }
//
//     try {
//       isLoading.value = true;
//       errorMessage.value = '';
//
//       final response = await http.post(
//         Uri.parse(
//             'https://rasma.astradevelops.in/e_shoppyy/public/api/getPayment-Details'),
//         headers: {
//           'Content-Type': 'application/json',
//           'Authorization': 'Bearer $authToken',
//         },
//         body: jsonEncode({'restaurant_ids': restaurantIds}),
//       );
//
//       print("API RESPONSE: ${response.body}");
//
//       if (response.statusCode == 200) {
//         final json = jsonDecode(response.body);
//         paymentResponse.value = PaymentResponseModel.fromJson(json);
//       } else {
//         errorMessage.value = 'Failed to fetch payment details.';
//       }
//     } catch (e) {
//       errorMessage.value = 'Something went wrong: $e';
//     } finally {
//       isLoading.value = false;
//     }
//   }
// }
import 'dart:convert';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

import '../../../data/models/resaturantqrmodel.dart';
import '../../../data/errors/api_error.dart';
import '../../merchantlogin/widget/successwidget.dart';

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

  Future<void> fetchPaymentDetails() async {

    if (restaurantIds.isEmpty) {
      AppSnackbar.warning('No restaurant IDs provided');
      return;
    }

    try {
      isLoading.value = true;
      errorMessage.value = '';

      final response = await http.post(
        Uri.parse(
          'https://rasma.astradevelops.in/e_shoppyy/public/api/getPayment-Details',
        ),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $authToken',
        },
        body: jsonEncode({'restaurant_ids': restaurantIds}),
      );

      print("API RESPONSE: ${response.body}");

      /// ✅ SUCCESS
      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        paymentResponse.value = PaymentResponseModel.fromJson(json);

        // Optional success snackbar
        // AppSnackbar.success("Payment details loaded");

      } else {
        /// ✅ HANDLE API ERRORS (IMPORTANT)
        final error = ApiErrorHandler.handleResponse(response);
        errorMessage.value = error;
        AppSnackbar.error(error);
      }

    } catch (e) {
      /// ✅ HANDLE EXCEPTIONS (NO INTERNET ETC)
      final error = ApiErrorHandler.handleException(e);
      errorMessage.value = error;
      AppSnackbar.error(error);

    } finally {
      isLoading.value = false;
    }
  }
}