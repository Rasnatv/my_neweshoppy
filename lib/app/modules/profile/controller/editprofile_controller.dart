
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

import '../../../data/errors/api_error.dart';
import '../../../data/models/edit_profilemodel.dart';
import '../../../widgets/network_trihgiger.dart';
import '../../merchantlogin/widget/successwidget.dart'; // ← adjust path

class EditProfileController extends GetxController {
  final box    = GetStorage();
  final picker = ImagePicker();

  final nameCtrl    = TextEditingController();
  final emailCtrl   = TextEditingController();
  final phoneCtrl   = TextEditingController();
  final addressCtrl = TextEditingController();

  final isLoading     = false.obs;
  final profile       = Rxn<ProfileModel>();
  final selectedImage = Rx<File?>(null);

  String? base64Image;

   String get token => box.read('auth_token') ?? "";

  @override
  void onInit() {
    super.onInit();
    fetchProfile();

  }

  // ── Fetch Profile ──────────────────────────────────────────────────────────
  Future<void> fetchProfile() async {
    try {
      isLoading(true);

      final response = await http.get(
        Uri.parse(
            'https://rasma.astradevelops.in/e_shoppyy/public/api/get-profile'),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final body = jsonDecode(response.body);

        if (body['status'] == "1") {
          final data = ProfileModel.fromJson(body['data']);
          profile.value     = data;
          nameCtrl.text     = data.fullName ?? "";
          emailCtrl.text    = data.email    ?? "";
          phoneCtrl.text    = data.phone    ?? "";
          addressCtrl.text  = data.address  ?? "";
        } else {
          profile.value = null;
          final msg = body['message']?.toString();
          if (msg != null && msg.isNotEmpty) ;
        }
      } else {
        AppSnackbar.error(ApiErrorHandler.handleResponse(response));
      }
    } catch (e) {
      // AppSnackbar.error(ApiErrorHandler.handleException(e));
      // debugPrint('fetchProfile error: $e');
    } finally {
      isLoading(false);
    }
  }

  // ── Pick Image ─────────────────────────────────────────────────────────────
  Future<void> pickImage() async {
    try {
      final picked = await picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 70,
      );

      if (picked != null) {
        selectedImage.value = File(picked.path);
        base64Image =
        "data:image/jpeg;base64,${base64Encode(selectedImage.value!.readAsBytesSync())}";
      }
    } catch (e) {
      AppSnackbar.error('Failed to pick image. Please try again.');
      debugPrint('pickImage error: $e');
    }
  }

  // ── Update Profile ─────────────────────────────────────────────────────────
  Future<void> updateProfile() async {
    if (token.isEmpty) {
      AppSnackbar.warning('Please log in to update your profile.');
      return;
    }

    try {
      isLoading(true);

      final response = await http.post(
        Uri.parse(
            'https://rasma.astradevelops.in/e_shoppyy/public/api/edit-profile'),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
        body: {
          'full_name': nameCtrl.text.trim(),
          'phone':     phoneCtrl.text.trim(),
          'address':   addressCtrl.text.trim(),
          if (base64Image != null) 'profile_image': base64Image!,
        },
      );

      if (response.statusCode == 200) {
        final body = jsonDecode(response.body);

        if (body['status'] == "1") {
          await fetchProfile();
          Get.back();
          AppSnackbar.success(
            body['message']?.toString().isNotEmpty == true
                ? body['message'].toString()
                : 'Profile updated successfully.',
          );
        } else {
          final msg = body['message']?.toString();
          AppSnackbar.error(
            msg != null && msg.isNotEmpty
                ? msg
                : 'Failed to update profile. Please try again.',
          );
        }
      } else {
        AppSnackbar.error(ApiErrorHandler.handleResponse(response));
      }
    } catch (e) {
      // AppSnackbar.error(ApiErrorHandler.handleException(e));
      // debugPrint('updateProfile error: $e');
    } finally {
      isLoading(false);
    }
  }
}
