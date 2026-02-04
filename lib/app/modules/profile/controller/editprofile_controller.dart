
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import '../../../data/models/edit_profilemodel.dart';
import '../../landingview/view/landing_screen.dart';

class EditProfileController extends GetxController {
  final box = GetStorage();
  final picker = ImagePicker();

  // Text Controllers
  final nameCtrl = TextEditingController();
  final emailCtrl = TextEditingController();
  final phoneCtrl = TextEditingController();
  final addressCtrl = TextEditingController();

  final isLoading = false.obs;
  final profile = Rxn<ProfileModel>();

  /// Image
  final selectedImage = Rx<File?>(null);
  String? base64Image;

  String get token => box.read('auth_token') ?? '';

  @override
  void onInit() {
    super.onInit();
    fetchProfile();
  }

  /// 🔹 PICK IMAGE
  Future<void> pickImage() async {
    final picked = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 70,
    );

    if (picked != null) {
      selectedImage.value = File(picked.path);
      base64Image =
      "data:image/jpeg;base64,${base64Encode(selectedImage.value!.readAsBytesSync())}";
    }
  }

  /// 🔹 GET PROFILE
  Future<void> fetchProfile() async {
    final response = await http.get(
      Uri.parse(
          'https://rasma.astradevelops.in/e_shoppyy/public/api/get-profile'),
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
  }

  /// 🔹 UPDATE PROFILE + IMAGE
  Future<void> updateProfile() async {
    try {
      isLoading.value = true;

      final response = await http.post(
        Uri.parse(
            'https://rasma.astradevelops.in/e_shoppyy/public/api/edit-profile'),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
        body: {
          'full_name': nameCtrl.text.trim(),
          'phone': phoneCtrl.text.trim(),
          'address': addressCtrl.text.trim(),
          if (base64Image != null) 'profile_image': base64Image!,
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

        Get.offAll(() => LandingView());
      } else {
        Get.snackbar("Error", body['message'],
            backgroundColor: Colors.red, colorText: Colors.white);
      }
    } finally {
      isLoading.value = false;
    }
  }
}
