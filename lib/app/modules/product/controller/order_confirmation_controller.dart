
import 'dart:convert';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

import '../../../data/models/user_orderconfirmationmodel.dart';
import '../../../data/errors/api_error.dart';
import '../../merchantlogin/widget/successwidget.dart';
import '../view/orderSuccessScreen.dart';
import 'cartcontroller.dart';

class OrderConfirmationController extends GetxController {
  final int addressId;
  OrderConfirmationController({required this.addressId});

  final _box = GetStorage();

  final isLoading = true.obs;
  final hasError = false.obs;
  final errorMessage = ''.obs;
  final isConfirming = false.obs;

  final Rx<OrderConfirmationModel?> orderPreview = Rx(null);

  String get _token => _box.read('auth_token') ?? '';

  @override
  void onInit() {
    super.onInit();
    fetchOrderPreview(addressId);
  }

  Future<void> fetchOrderPreview(int addressId) async {
    /// ✅ TOKEN CHECK

    try {
      isLoading.value = true;
      hasError.value = false;
      errorMessage.value = '';

      final response = await http.post(
        Uri.parse(
          'https://rasma.astradevelops.in/e_shoppyy/public/api/create-order-preview',
        ),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $_token',
        },
        body: jsonEncode({'address_id': addressId}),
      );

      if (response.statusCode == 200) {
        final body = jsonDecode(response.body);

        if (body['status'] == true) {
          orderPreview.value =
              OrderConfirmationModel.fromJson(body['data']);
        } else {
          hasError.value = true;
          errorMessage.value =
              body['message'] ?? 'Failed to load order preview';

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
      hasError.value = true;
      errorMessage.value = error;

      AppSnackbar.error(error);

    } finally {
      isLoading.value = false;
    }
  }

  /// ================= CONFIRM ORDER =================
  Future<void> confirmOrder() async {

    try {
      isConfirming.value = true;

      final response = await http.post(
        Uri.parse(
          'https://rasma.astradevelops.in/e_shoppyy/public/api/confirm-order',
        ),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $_token',
        },
        body: jsonEncode({'address_id': addressId}),
      );

      if (response.statusCode == 200) {
        final body = jsonDecode(response.body);

        if (body['status'] == true) {
          final orderId = body['data']['order_id'];
          final totalAmount =
          (body['data']['total_amount'] as num).toDouble();

          /// ✅ Refresh cart
          if (Get.isRegistered<CartController>()) {
            await Get.find<CartController>().fetchCart();
          }

          /// ✅ Navigate
          Get.off(() => OrderSuccessScreen(
            orderId: orderId,
            totalAmount: totalAmount,
          ));
        } else {
          AppSnackbar.error(
              body['message'] ?? 'Could not place order');
        }
      } else {
        final error = ApiErrorHandler.handleResponse(response);
        AppSnackbar.error(error);
      }

    } catch (e) {

      final error = ApiErrorHandler.handleException(e);
      AppSnackbar.error(error);

    } finally {
      isConfirming.value = false;
    }
  }
}