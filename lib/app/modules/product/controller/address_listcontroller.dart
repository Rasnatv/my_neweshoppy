import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import '../../../data/models/addresslistmodel.dart';


class AddressListController extends GetxController {
  final box = GetStorage();

  static const String baseUrl =
      'https://rasma.astradevelops.in/e_shoppyy/public/api';

  final RxList<AddressListModel> addressList = <AddressListModel>[].obs;
  final RxBool isLoading = false.obs;
  final RxInt selectedAddressId = (-1).obs;

  String get authToken => box.read('auth_token') ?? '';

  @override
  void onInit() {
    super.onInit();
    fetchAddresses();
  }

  // ── Fetch address list ──────────────────────────────────────────────────────
  Future<void> fetchAddresses() async {
    if (authToken.isEmpty) {
      Get.snackbar('Error', 'Authentication token not found. Please login again.',
          backgroundColor: Colors.red.shade100,
          colorText: Colors.red.shade800,
          snackPosition: SnackPosition.BOTTOM);
      return;
    }

    isLoading.value = true;
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/address-list'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $authToken',
        },
      );

      final data = jsonDecode(response.body);

      if ((response.statusCode == 200 || response.statusCode == 201) &&
          data['status'] == true) {
        final List list = data['data'] ?? [];
        addressList.value =
            list.map((e) => AddressListModel.fromJson(e)).toList();

        // Auto-select first address
        if (addressList.isNotEmpty) {
          selectedAddressId.value = addressList.first.addressId;
        }
      } else {
        Get.snackbar('Failed', data['message'] ?? 'Failed to fetch addresses',
            backgroundColor: Colors.orange.shade100,
            colorText: Colors.orange.shade800,
            snackPosition: SnackPosition.BOTTOM);
      }
    } catch (e) {
      Get.snackbar('Error', 'Network error: ${e.toString()}',
          backgroundColor: Colors.red.shade100,
          colorText: Colors.red.shade800,
          snackPosition: SnackPosition.BOTTOM);
    } finally {
      isLoading.value = false;
    }
  }

  // ── Select address ──────────────────────────────────────────────────────────
  void selectAddress(int id) {
    selectedAddressId.value = id;
  }

  // ── Get selected address ────────────────────────────────────────────────────
  AddressListModel? get selectedAddress {
    try {
      return addressList
          .firstWhere((a) => a.addressId == selectedAddressId.value);
    } catch (_) {
      return null;
    }
  }

  // ── Deliver to selected address ─────────────────────────────────────────────
  void deliverToSelected() {
    final addr = selectedAddress;
    if (addr == null) return;
    // Save selected address to storage for next step
    box.write('selected_address', jsonEncode(addr.toJson()));
    box.write('selected_address_id', addr.addressId);

    Get.snackbar(
      'Address Selected',
      'Delivering to ${addr.fullName}\'s address',
      backgroundColor: const Color(0xFFB02399).withOpacity(0.1),
      colorText: const Color(0xFFB02399),
      snackPosition: SnackPosition.BOTTOM,
    );

    // Navigate to payment — replace with your actual route
    // Get.to(() => PaymentPage());
  }
}