
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import '../../../data/errors/api_error.dart';
import '../../../data/models/address_updatemodel.dart';
import '../../merchantlogin/widget/successwidget.dart';
import '../controller/address_listcontroller.dart';
import 'addresslistpage.dart';
 // ← your AppSnackbar

class AddressUpdateController extends GetxController {
  final box = GetStorage();

  static const String baseUrl =
      'https://eshoppy.co.in/api';

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

  // ── Fetch address by ID ────────────────────────────────────────────────────
  Future<void> fetchAddress(int addressId) async {
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
        // ← Use ApiErrorHandler for non-success HTTP responses
        final errorMsg = ApiErrorHandler.handleResponse(response);
        AppSnackbar.warning(errorMsg);
      }
    } catch (e) {
      // ← Use ApiErrorHandler for exceptions (SocketException, etc.)
      final errorMsg = ApiErrorHandler.handleException(e);
      AppSnackbar.error(errorMsg);
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

  // ── Update address ─────────────────────────────────────────────────────────
  Future<void> updateAddress(int addressId) async {
    if (!formKey.currentState!.validate()) return;

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
        isLoading.value = false;


        await Future.delayed(const Duration(seconds: 1));

        await Get.delete<AddressListController>(force: true);
        Get.off(() => AddressListPage());
      } else {
        isLoading.value = false;

        // ← ApiErrorHandler for non-success HTTP responses
        final errorMsg = ApiErrorHandler.handleResponse(response);
        AppSnackbar.warning(errorMsg);
      }
    } catch (e) {
      isLoading.value = false;

      // ← ApiErrorHandler for exceptions
      final errorMsg = ApiErrorHandler.handleException(e);
      AppSnackbar.error(errorMsg);
    }
  }
}