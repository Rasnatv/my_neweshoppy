
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
      'https://eshoppy.co.in/api/getUser-PurchasedProducts';

  // ── State ─────────────────────────────────────
  var isLoading = false.obs;
  var errorMessage = ''.obs;
  var orders = <OrderItem>[].obs;
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

    if (args == null || args['user_id'] == null) {
      errorMessage.value = 'User ID not provided';
      AppSnackbar.error("User ID not provided");
      return;
    }

    final rawId = args['user_id'];
    final userId = int.tryParse(rawId.toString());

    if (userId == null || userId <= 0) {
      errorMessage.value = 'Invalid User ID';
      return;
    }

    currentUserId.value = userId;
    fetchPurchasedProducts(userId);
  }

  // Future<void> fetchPurchasedProducts(int userId) async {
  //   try {
  //     isLoading.value = true;
  //     errorMessage.value = '';
  //     orders.clear();
  //
  //     final response = await http.post(
  //       Uri.parse(_url),
  //       headers: _headers,
  //       body: jsonEncode({'user_id': userId}),
  //     );
  //
  //     if (response.statusCode != 200) {
  //       final error = ApiErrorHandler.handleResponse(response);
  //       errorMessage.value = error;
  //       AppSnackbar.error(error);
  //       return;
  //     }
  //
  //     final body = jsonDecode(response.body);
  //
  //     if (body['status'] == true || body['status'] == 1) {
  //       final model = PurchasedProductModel.fromJson(body);
  //       orders.assignAll(model.data);
  //     }
  //     // No else — empty state UI handles the no-orders case silently
  //
  //   } catch (e) {
  //     final error = ApiErrorHandler.handleException(e);
  //     errorMessage.value = error;
  //     AppSnackbar.error(error);
  //   } finally {
  //     isLoading.value = false;
  //   }
  // }
  Future<void> fetchPurchasedProducts(int userId) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';
      orders.clear();

      final response = await http.post(
        Uri.parse(_url),
        headers: _headers,
        body: jsonEncode({'user_id': userId}),
      );

      final body = jsonDecode(response.body);

      // Treat status:false or empty data as silent empty state — not an error
      if (body['status'] == true || body['status'] == 1) {
        final model = PurchasedProductModel.fromJson(body);
        orders.assignAll(model.data);
        return; // ← done, no snackbar
      }

      // Only show error snackbar for real HTTP failures (non-200 AND not a "no data" response)
      if (response.statusCode != 200) {
        final error = ApiErrorHandler.handleResponse(response);
        if (error.isNotEmpty) {
          errorMessage.value = error;
          AppSnackbar.error(error);
        }
      }

      // status:false with 200 = no orders — fall through silently

    } catch (e) {
      final error = ApiErrorHandler.handleException(e);
      if (error.isNotEmpty) {
        errorMessage.value = error;
        AppSnackbar.error(error);
      }
    } finally {
      isLoading.value = false;
    }
  }

  double get totalSpend =>
      orders.fold(0.0, (sum, o) => sum + o.totalAmount);
}