
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

import '../../../data/errors/api_error.dart';
import '../../merchantlogin/widget/successwidget.dart';
import '../view/addressposttingmodel.dart';

class NewAddAddressController extends GetxController {
  final box = GetStorage();

  final formKey = GlobalKey<FormState>();

  final fullNameController = TextEditingController();
  final phoneController = TextEditingController();
  final pincodeController = TextEditingController();
  final stateController = TextEditingController();
  final districtController = TextEditingController();
  final cityController = TextEditingController();
  final houseNoController = TextEditingController();
  final areaController = TextEditingController();

  final RxBool isLoading = false.obs;

  static const String baseUrl =
      'https://eshoppy.co.in/api';

  String get authToken => box.read('auth_token') ?? '';

  /// ================= ADD ADDRESS =================
  Future<void> addAddress() async {
    if (!formKey.currentState!.validate()) return;

    isLoading.value = true;

    try {
      final addressData = AddressModel(
        fullName: fullNameController.text.trim(),
        phoneNumber: phoneController.text.trim(),
        pincode: pincodeController.text.trim(),
        state: stateController.text.trim(),
        district: districtController.text.trim(),
        city: cityController.text.trim(),
        houseNo: houseNoController.text.trim(),
        area: areaController.text.trim(),
      );

      final response = await http.post(
        Uri.parse('$baseUrl/add-address'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $authToken',
        },
        body: jsonEncode(addressData.toJson()),
      );

      /// ✅ SUCCESS
      if (response.statusCode == 200 || response.statusCode == 201) {
        final responseData = jsonDecode(response.body);

        if (responseData['status'] == true) {
          final savedAddress =
          AddressModel.fromJson(responseData['data']);

          box.write(
              'last_address', jsonEncode(responseData['data']));

          AppSnackbar.success('Address added successfully!');

          _clearFields();
          Get.back(result: savedAddress);
        } else {
          AppSnackbar.warning(
              responseData['message'] ?? 'Failed to add address');
        }

      } else {
        /// ✅ API ERROR HANDLING (IMPORTANT)
        final error = ApiErrorHandler.handleResponse(response);
        AppSnackbar.error(error);
      }

    } catch (e) {
      /// ✅ EXCEPTION HANDLING
      final error = ApiErrorHandler.handleException(e);
      AppSnackbar.error(error);

    } finally {
      isLoading.value = false;
    }
  }

  /// ================= HELPERS =================
  void _clearFields() {
    fullNameController.clear();
    phoneController.clear();
    pincodeController.clear();
    stateController.clear();
    districtController.clear();
    cityController.clear();
    houseNoController.clear();
    areaController.clear();
  }

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
}