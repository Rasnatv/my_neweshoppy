

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class OfferController extends GetxController {
  // ---------------- CONTROLLERS ----------------
  final TextEditingController offerNameCtrl = TextEditingController();

  // ---------------- OFFER TYPES ----------------
  final List<String> offerTypes = [
    "Flat Discount",
    "Percentage Discount",
    "Buy 1 Get 1",
    "Free Shipping",
  ];

  RxString selectedOfferType = "".obs;

  // ---------------- BANNER IMAGE ----------------
  final ImagePicker _picker = ImagePicker();
  Rx<File?> bannerImage = Rx<File?>(null);

  Future<void> pickBannerImage() async {
    final XFile? image =
    await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      bannerImage.value = File(image.path);
    }
  }

  // ---------------- CREATE OFFER ----------------
  void createOffer() {
    if (offerNameCtrl.text.isEmpty) {
      Get.snackbar("Error", "Offer name required");
      return;
    }

    if (selectedOfferType.value.isEmpty) {
      Get.snackbar("Error", "Select offer type");
      return;
    }

    if (bannerImage.value == null) {
      Get.snackbar("Error", "Upload offer banner");
      return;
    }

    final offerData = {
      "offerName": offerNameCtrl.text.trim(),
      "offerType": selectedOfferType.value,
      "bannerImage": bannerImage.value!.path,
    };

    debugPrint("OFFER CREATED => $offerData");

    Get.snackbar("Success", "Offer created successfully");
  }

  @override
  void onClose() {
    offerNameCtrl.dispose();
    super.onClose();
  }
}
