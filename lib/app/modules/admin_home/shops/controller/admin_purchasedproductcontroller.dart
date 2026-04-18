// import 'dart:convert';
// import 'package:get/get.dart';
// import 'package:get_storage/get_storage.dart';
// import 'package:http/http.dart' as http;
//
// import '../../../../data/models/admin_userpurchasedproductsmodel.dart';
//
// class PurchasedProductController extends GetxController {
//   final box = GetStorage();
//
//   static const String _url =
//       'https://rasma.astradevelops.in/e_shoppyy/public/api/getUser-PurchasedProducts';
//
//   // ── State ──────────────────────────────────────────────────
//   var isLoading = false.obs;
//   var errorMessage = ''.obs;
//   var purchasedProducts = <PurchasedProduct>[].obs;
//   var currentUserId = 0.obs;
//
//   // ── Auth ───────────────────────────────────────────────────
//   String? get _token => box.read<String>('auth_token');
//
//   Map<String, String> get _headers => {
//     'Content-Type': 'application/json',
//     'Accept': 'application/json',
//     'Authorization': 'Bearer ${_token ?? ''}',
//   };
//
//   @override
//   void onInit() {
//     super.onInit();
//
//     final args = Get.arguments;
//
//     print("ARGS RECEIVED: $args"); // ✅ DEBUG
//
//     if (args == null || args['user_id'] == null) {
//       errorMessage.value = 'User ID not provided';
//       return;
//     }
//
//     final rawId = args['user_id'];
//     final userId = int.tryParse(rawId.toString());
//
//     if (userId == null || userId <= 0) {
//       errorMessage.value = 'Invalid User ID';
//       return;
//     }
//
//     currentUserId.value = userId;
//     fetchPurchasedProducts(userId);
//   }
//
//   Future<void> fetchPurchasedProducts(int userId) async {
//     try {
//       isLoading.value = true;
//       errorMessage.value = '';
//       purchasedProducts.clear();
//
//       final response = await http.post(
//         Uri.parse(_url),
//         headers: _headers,
//         body: jsonEncode({'user_id': userId}),
//       );
//
//       final body = jsonDecode(response.body);
//
//       if (response.statusCode == 200 &&
//           (body['status'] == 1 || body['status'] == true)) {
//         final model = PurchasedProductModel.fromJson(body);
//         purchasedProducts.assignAll(model.data);
//       } else {
//         errorMessage.value =
//             body['message'] ?? 'Failed to fetch purchased products';
//       }
//     } catch (e) {
//       errorMessage.value = 'Error: $e';
//     } finally {
//       isLoading.value = false;
//     }
//   }
//
//   double get totalSpend =>
//       purchasedProducts.fold(0.0, (sum, p) => sum + p.total);
// }
import 'dart:convert';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

import '../../../../data/errors/api_error.dart';
import '../../../../data/models/admin_userpurchasedproductsmodel.dart';
import '../../../merchantlogin/widget/successwidget.dart';

class PurchasedProductController extends GetxController {
  final box = GetStorage();

  static const String _url =
      'https://rasma.astradevelops.in/e_shoppyy/public/api/getUser-PurchasedProducts';

  // ── State ─────────────────────────────────────
  var isLoading = false.obs;
  var errorMessage = ''.obs;
  var purchasedProducts = <PurchasedProduct>[].obs;
  var currentUserId = 0.obs;

  // ── Auth ──────────────────────────────────────
  String? get _token => box.read<String>('auth_token');

  Map<String, String> get _headers => {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
    'Authorization': 'Bearer ${_token ?? ''}',
  };

  @override
  void onInit() {
    super.onInit();

    final args = Get.arguments;
    print("ARGS RECEIVED: $args");

    if (args == null || args['user_id'] == null) {
      errorMessage.value = 'User ID not provided';
      AppSnackbar.error("User ID not provided");
      return;
    }

    final rawId = args['user_id'];
    final userId = int.tryParse(rawId.toString());

    if (userId == null || userId <= 0) {
      errorMessage.value = 'Invalid User ID';
      AppSnackbar.error("Invalid User ID");
      return;
    }

    currentUserId.value = userId;
    fetchPurchasedProducts(userId);
  }

  Future<void> fetchPurchasedProducts(int userId) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';
      purchasedProducts.clear();

      final response = await http.post(
        Uri.parse(_url),
        headers: _headers,
        body: jsonEncode({'user_id': userId}),
      );

      // ✅ Handle non-200 status codes FIRST
      if (response.statusCode != 200) {
        final error = ApiErrorHandler.handleResponse(response);
        errorMessage.value = error;
        AppSnackbar.error(error);
        return;
      }

      final body = jsonDecode(response.body);

      if (body['status'] == 1 || body['status'] == true) {
        final model = PurchasedProductModel.fromJson(body);
        purchasedProducts.assignAll(model.data);

        // Optional success snackbar
        if (model.data.isEmpty) {
          AppSnackbar.warning("No purchased products found");
        }
      } else {
        final msg =
            body['message'] ?? 'Failed to fetch purchased products';
        errorMessage.value = msg;
        AppSnackbar.error(msg);
      }
    } catch (e) {
      final error = ApiErrorHandler.handleException(e);
      errorMessage.value = error;
      AppSnackbar.error(error);
    } finally {
      isLoading.value = false;
    }
  }

  double get totalSpend =>
      purchasedProducts.fold(0.0, (sum, p) => sum + p.total);
}
