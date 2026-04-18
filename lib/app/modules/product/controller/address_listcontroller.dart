
import 'dart:convert';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

import '../../../data/errors/api_error.dart';
import '../../../data/models/addresslistmodel.dart';
import '../../merchantlogin/widget/successwidget.dart'; // ← adjust path

class AddressListController extends GetxController {
  final box = GetStorage();

  static const String baseUrl =
      'https://rasma.astradevelops.in/e_shoppyy/public/api';

  final RxList<AddressListModel> addressList = <AddressListModel>[].obs;
  final RxBool isLoading                     = false.obs;
  final RxInt  selectedAddressId             = (-1).obs;

  String get authToken => box.read('auth_token') ?? '';

  @override
  void onInit() {
    super.onInit();
    fetchAddresses();
  }

  // ── Fetch address list ─────────────────────────────────────────────────────
  Future<void> fetchAddresses() async {
    if (authToken.isEmpty) {
      AppSnackbar.warning('Authentication token not found. Please log in.');
      return;
    }

    isLoading.value = true;
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/address-list'),
        headers: {
          'Content-Type':  'application/json',
          'Authorization': 'Bearer $authToken',
        },
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = jsonDecode(response.body);

        if (data['status'] == true) {
          final List list = data['data'] ?? [];
          addressList.value =
              list.map((e) => AddressListModel.fromJson(e)).toList();

          // Auto-select first address
          if (addressList.isNotEmpty) {
            selectedAddressId.value = addressList.first.addressId;
          }
        } else {
          final msg = data['message']?.toString();
          AppSnackbar.error(
            msg != null && msg.isNotEmpty
                ? msg
                : 'Failed to fetch addresses.',
          );
        }
      } else {
        AppSnackbar.error(ApiErrorHandler.handleResponse(response));
      }
    } catch (e) {
      AppSnackbar.error(ApiErrorHandler.handleException(e));
    } finally {
      isLoading.value = false;
    }
  }

  // ── Select address ─────────────────────────────────────────────────────────
  void selectAddress(int id) {
    selectedAddressId.value = id;
  }

  // ── Get selected address ───────────────────────────────────────────────────
  AddressListModel? get selectedAddress {
    try {
      return addressList
          .firstWhere((a) => a.addressId == selectedAddressId.value);
    } catch (_) {
      return null;
    }
  }

  // ── Deliver to selected address ────────────────────────────────────────────
  void deliverToSelected() {
    final addr = selectedAddress;
    if (addr == null) {
      AppSnackbar.warning('Please select an address to continue.');
      return;
    }

    box.write('selected_address',    jsonEncode(addr.toJson()));
    box.write('selected_address_id', addr.addressId);

    AppSnackbar.success('Delivering to ${addr.fullName}\'s address.');

    // Navigate to payment — replace with your actual route
    // Get.to(() => PaymentPage());
  }
}