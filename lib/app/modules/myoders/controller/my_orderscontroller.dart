
import 'dart:convert';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

import '../../../data/models/user_myordersmodel.dart';
import '../../../data/errors/api_error.dart';
import '../../merchantlogin/widget/successwidget.dart';

class MyOrdersController extends GetxController {
  final _box = GetStorage();

  final isLoading = true.obs;
  final hasError = false.obs;
  final errorMessage = ''.obs;
  final orders = <MyOrdersModel>[].obs;

  String get _token => _box.read('auth_token') ?? '';

  @override
  void onInit() {
    super.onInit();
    fetchMyOrders();
  }

  /// ================= FETCH ORDERS =================
  Future<void> fetchMyOrders() async {
    /// ✅ TOKEN CHECK
    try {
      isLoading.value = true;
      hasError.value = false;
      errorMessage.value = '';

      final response = await http.get(
        Uri.parse(
          'https://eshoppy.co.in/api/my-orders',
        ),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $_token',
        },
      );

      if (response.statusCode == 200) {
        final body = jsonDecode(response.body);

        if (body['status'] == true) {
          final List data = body['data'];
          orders.value =
              data.map((e) => MyOrdersModel.fromJson(e)).toList();
        } else {
          hasError.value = true;
          errorMessage.value =
              body['message'] ?? 'Failed to load orders';

          AppSnackbar.warning(errorMessage.value);
        }
      } else {
        /// ✅ API ERROR HANDLING
        final error = ApiErrorHandler.handleResponse(response);
        hasError.value = true;
        errorMessage.value = error;

        AppSnackbar.error(error);
      }

    } catch (e) {
      /// ✅ EXCEPTION HANDLING
      final error = ApiErrorHandler.handleException(e);
      // hasError.value = true;
      // errorMessage.value = error;

      AppSnackbar.error(error);

    } finally {
      isLoading.value = false;
    }
  }

  /// ================= FORMAT DATE =================
  String formatDate(String rawDate) {
    try {
      final dt = DateTime.parse(rawDate);
      const months = [
        'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
        'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
      ];
      return '${dt.day.toString().padLeft(2, '0')} ${months[dt.month - 1]} ${dt.year}';
    } catch (_) {
      return rawDate;
    }
  }
}