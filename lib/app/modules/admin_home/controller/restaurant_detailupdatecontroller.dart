
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import '../../../data/models/restaurant_detailupdatemodel.dart';

class RestaurantUpdateController extends GetxController {
  final box = GetStorage();
  final picker = ImagePicker();

  late int restaurantId;
  Map<String, dynamic>? restaurantData;

  Rx<File?> restaurantImage = Rx<File?>(null);

  final ownerCtrl = TextEditingController();
  final addressCtrl = TextEditingController();
  final phoneCtrl = TextEditingController();
  final emailCtrl = TextEditingController();
  final websiteCtrl = TextEditingController();
  final whatsappCtrl = TextEditingController();
  final facebookCtrl = TextEditingController();
  final instaCtrl = TextEditingController();

  String get adminToken => box.read('admin_token') ?? '';

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments as Map<String, dynamic>?;
    if (args != null) {
      restaurantId = args['restaurantId'];
      restaurantData = args['restaurantData'];

      ownerCtrl.text = restaurantData?['owner_name'] ?? '';
      addressCtrl.text = restaurantData?['address'] ?? '';
      phoneCtrl.text = restaurantData?['phone'] ?? '';
      emailCtrl.text = restaurantData?['email'] ?? '';
      websiteCtrl.text = restaurantData?['website'] ?? '';
      whatsappCtrl.text = restaurantData?['whatsapp'] ?? '';
      facebookCtrl.text = restaurantData?['facebook'] ?? '';
      instaCtrl.text = restaurantData?['instagram'] ?? '';
    }
  }

  Future<void> pickImage() async {
    final XFile? img =
    await picker.pickImage(source: ImageSource.gallery, imageQuality: 70);
    if (img != null) restaurantImage.value = File(img.path);
  }

  Future<String> _base64(File file) async {
    final bytes = await file.readAsBytes();
    return "data:image/jpeg;base64,${base64Encode(bytes)}";
  }

  Future<void> updateRestaurant({VoidCallback? onUpdated}) async {
    if (adminToken.isEmpty) {
      Get.snackbar("Unauthorized", "Admin session expired");
      return;
    }

    String? image64;
    if (restaurantImage.value != null) image64 = await _base64(restaurantImage.value!);

    final request = RestaurantUpdateRequest(
      restaurantId: restaurantId,
      restaurantImage: image64,
      ownerName: ownerCtrl.text.trim().isEmpty ? null : ownerCtrl.text.trim(),
      address: addressCtrl.text.trim().isEmpty ? null : addressCtrl.text.trim(),
      phone: phoneCtrl.text.trim().isEmpty ? null : phoneCtrl.text.trim(),
      email: emailCtrl.text.trim().isEmpty ? null : emailCtrl.text.trim(),
      website: websiteCtrl.text.trim().isEmpty ? null : websiteCtrl.text.trim(),
      whatsapp: whatsappCtrl.text.trim().isEmpty ? null : whatsappCtrl.text.trim(),
      facebook: facebookCtrl.text.trim().isEmpty ? null : facebookCtrl.text.trim(),
      instagram: instaCtrl.text.trim().isEmpty ? null : instaCtrl.text.trim(),
    );

    try {
      final response = await http.post(
        Uri.parse(
          "https://rasma.astradevelops.in/e_shoppyy/public/api/admin/restaurant/update",
        ),
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/json",
          "Authorization": "Bearer $adminToken",
        },
        body: jsonEncode(request.toJson()),
      );

      final data = jsonDecode(response.body);

      if (data['status'].toString() == "1") {
        Get.snackbar("Success", data['message']);
        onUpdated?.call();
        Get.back();
      } else {
        Get.snackbar("Error", data['message'] ?? "Update failed");
      }
    } catch (e) {
      Get.snackbar("Error", e.toString());
    }
  }
}
