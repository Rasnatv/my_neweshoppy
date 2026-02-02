import 'dart:convert';
import 'package:eshoppy/app/modules/landingview/view/landing_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import '../../../data/models/edit_profilemodel.dart';
import '../view/profile_view.dart';

class EditProfileController extends GetxController {
  final box = GetStorage();

  // Text Controllers
  final nameCtrl = TextEditingController();
  final emailCtrl = TextEditingController();
  final phoneCtrl = TextEditingController();
  final addressCtrl = TextEditingController();

  final isLoading = false.obs;
  final profile = Rxn<ProfileModel>();

  String get token => box.read('auth_token') ?? '';

  @override
  void onInit() {
    super.onInit();
    fetchProfile();
  }

  /// 🔹 GET PROFILE
  Future<void> fetchProfile() async {
    try {
      final response = await http.get(
        Uri.parse(
          'https://rasma.astradevelops.in/e_shoppyy/public/api/get-profile',
        ),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );

      final body = jsonDecode(response.body);

      if (response.statusCode == 200 && body['status'] == "1") {
        profile.value = ProfileModel.fromJson(body['data']);

        nameCtrl.text = profile.value!.fullName;
        emailCtrl.text = profile.value!.email;
        phoneCtrl.text = profile.value!.phone;
        addressCtrl.text = profile.value!.address;
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  /// 🔹 UPDATE PROFILE
  Future<void> updateProfile() async {
    try {
      isLoading.value = true;

      final response = await http.post(
        Uri.parse(
          'https://rasma.astradevelops.in/e_shoppyy/public/api/edit-profile',
        ),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
        body: {
          'full_name': nameCtrl.text.trim(),
          'phone': phoneCtrl.text.trim(),
          'address': addressCtrl.text.trim(),
        },
      );

      final body = jsonDecode(response.body);

      if (response.statusCode == 200 && body['status'] == "1") {
        profile.value = ProfileModel.fromJson(body['data']);

        Get.snackbar(
          "Success",
          body['message'],
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );

        /// ✅ CLEAR STACK → PROFILE VIEW
        Get.offAll(() => LandingView());
      } else {
        Get.snackbar(
          "Error",
          body['message'],
          backgroundColor: Colors.redAccent,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        "Error",
        "Something went wrong",
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }
}
