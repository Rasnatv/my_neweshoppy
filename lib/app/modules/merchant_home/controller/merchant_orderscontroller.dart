import 'dart:convert';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import '../../../data/models/merchant_orderrecievedmodel.dart';


class MerchantOrdersController extends GetxController {
  final _box = GetStorage();

  final isLoading = true.obs;
  final hasError = false.obs;
  final errorMessage = ''.obs;
  final orders = <MerchantOrderModel>[].obs;

  String get _token => _box.read('auth_token') ?? '';

  @override
  void onInit() {
    super.onInit();
    fetchMerchantOrders();
  }

  Future<void> fetchMerchantOrders() async {
    try {
      isLoading.value = true;
      hasError.value = false;
      errorMessage.value = '';

      final response = await http.get(
        Uri.parse(
          'https://rasma.astradevelops.in/e_shoppyy/public/api/merchant/orders',
        ),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $_token',
        },
      );

      final body = jsonDecode(response.body);

      if (response.statusCode == 200 && body['status'] == true) {
        final List data = body['data'];
        orders.value =
            data.map((e) => MerchantOrderModel.fromJson(e)).toList();
      } else {
        hasError.value = true;
        errorMessage.value = body['message'] ?? 'Failed to load orders.';
      }
    } catch (e) {
      hasError.value = true;
      errorMessage.value = 'Network error. Please try again.';
    } finally {
      isLoading.value = false;
    }
  }

  // "2026-04-06 09:29:22" → "06 Apr 2026, 09:29 AM"
  String formatDate(String raw) {
    try {
      final dt = DateTime.parse(raw);
      const months = [
        'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
        'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
      ];
      final hour = dt.hour > 12 ? dt.hour - 12 : dt.hour == 0 ? 12 : dt.hour;
      final minute = dt.minute.toString().padLeft(2, '0');
      final period = dt.hour >= 12 ? 'PM' : 'AM';
      return '${dt.day.toString().padLeft(2, '0')} ${months[dt.month - 1]} ${dt.year}  •  $hour:$minute $period';
    } catch (_) {
      return raw;
    }
  }

  int get totalOrdersCount => orders.length;

  double get totalRevenue =>
      orders.fold(0.0, (sum, o) => sum + o.totalAmount);
}