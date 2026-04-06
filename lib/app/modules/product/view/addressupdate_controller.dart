
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import '../../../data/models/address_updatemodel.dart';
import '../controller/address_listcontroller.dart'; // ← import list controller
import 'addresslistpage.dart';            // ← import list page

class AddressUpdateController extends GetxController {
  final box = GetStorage();

  static const String baseUrl =
      'https://rasma.astradevelops.in/e_shoppyy/public/api';

  final RxBool isLoading = false.obs;
  final RxBool isFetching = false.obs;

  final formKey = GlobalKey<FormState>();

  final fullNameController = TextEditingController();
  final phoneController = TextEditingController();
  final pincodeController = TextEditingController();
  final stateController = TextEditingController();
  final districtController = TextEditingController();
  final cityController = TextEditingController();
  final houseNoController = TextEditingController();
  final areaController = TextEditingController();

  String get authToken => box.read('auth_token') ?? '';

  @override
  void onClose() {
    fullNameController.dispose();
    phoneController.dispose();
    pincodeController.dispose();
    stateController.dispose();
    districtController.dispose();
    cityController.dispose();
    houseNoController.dispose();
    areaController.dispose();
    super.onClose();
  }

  // ── Fetch address by ID ─────────────────────────────────────────────────────
  Future<void> fetchAddress(int addressId) async {
    if (authToken.isEmpty) {
      Get.snackbar('Error', 'Authentication token not found.',
          backgroundColor: Colors.red.shade100,
          colorText: Colors.red.shade800,
          snackPosition: SnackPosition.BOTTOM);
      return;
    }

    isFetching.value = true;
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/get-address'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $authToken',
        },
        body: jsonEncode({'address_id': addressId}),
      );

      final data = jsonDecode(response.body) as Map<String, dynamic>;

      if ((response.statusCode == 200 || response.statusCode == 201) &&
          data['status'] == true) {
        final addr = AddressUpdateModel.fromJson(
            data['data'] as Map<String, dynamic>);
        _populateFields(addr);
      } else {
        Get.snackbar(
          'Failed',
          data['message']?.toString() ?? 'Failed to fetch address',
          backgroundColor: Colors.orange.shade100,
          colorText: Colors.orange.shade800,
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (e) {
      Get.snackbar('Error', 'Network error: ${e.toString()}',
          backgroundColor: Colors.red.shade100,
          colorText: Colors.red.shade800,
          snackPosition: SnackPosition.BOTTOM);
    } finally {
      isFetching.value = false;
    }
  }

  void _populateFields(AddressUpdateModel addr) {
    fullNameController.text = addr.fullName;
    phoneController.text = addr.phoneNumber;
    pincodeController.text = addr.pincode;
    stateController.text = addr.state;
    districtController.text = addr.district;
    cityController.text = addr.city;
    houseNoController.text = addr.houseNo;
    areaController.text = addr.area;
  }

  // ── Update address ──────────────────────────────────────────────────────────
  Future<void> updateAddress(int addressId) async {
    if (!formKey.currentState!.validate()) return;
    if (authToken.isEmpty) {
      Get.snackbar('Error', 'Authentication token not found.',
          backgroundColor: Colors.red.shade100,
          colorText: Colors.red.shade800,
          snackPosition: SnackPosition.BOTTOM);
      return;
    }

    // 1️⃣ Show circular indicator inside button
    isLoading.value = true;

    try {
      final response = await http.put(
        Uri.parse('$baseUrl/update-address'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $authToken',
        },
        body: jsonEncode({
          'address_id': addressId,
          'full_name': fullNameController.text.trim(),
          'phone_number': phoneController.text.trim(),
          'pincode': pincodeController.text.trim(),
          'state': stateController.text.trim(),
          'district': districtController.text.trim(),
          'city': cityController.text.trim(),
          'house_no': houseNoController.text.trim(),
          'area': areaController.text.trim(),
        }),
      );

      final data = jsonDecode(response.body) as Map<String, dynamic>;

      if ((response.statusCode == 200 || response.statusCode == 201) &&
          data['status'] == true) {
        // 2️⃣ Stop loader
        isLoading.value = false;


        // 4️⃣ Wait for snackbar
        await Future.delayed(const Duration(seconds: 1));

        // 5️⃣ Delete cached AddressListController so the new page
        //    creates a fresh one and onInit calls fetchAddresses()
        await Get.delete<AddressListController>(force: true);

        // 6️⃣ Replace edit page with a fresh AddressListPage
        //    Fresh controller onInit → fetchAddresses() → list updates
        Get.off(() => AddressListPage());
      } else {
        isLoading.value = false;
        Get.snackbar(
          'Failed',
          data['message']?.toString() ?? 'Failed to update address',
          backgroundColor: Colors.orange.shade100,
          colorText: Colors.orange.shade800,
          snackPosition: SnackPosition.BOTTOM,
          duration: const Duration(seconds: 2),
          margin: const EdgeInsets.all(12),
          borderRadius: 10,
        );
      }
    } catch (e) {
      isLoading.value = false;
      Get.snackbar(
        'Error',
        'Network error: ${e.toString()}',
        backgroundColor: Colors.red.shade100,
        colorText: Colors.red.shade800,
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 2),
        margin: const EdgeInsets.all(12),
        borderRadius: 10,
      );
    }
  }
}