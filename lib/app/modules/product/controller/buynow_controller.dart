import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:flutter/material.dart';

class BuyNowController extends GetxController {
  var quantity = 1.obs;
  var selectedPayment = ''.obs;
  var addressController = TextEditingController();

  void increment() => quantity.value++;
  void decrement() {
    if (quantity.value > 1) quantity.value--;
  }

  void placeOrder() {
    if (addressController.text.isEmpty) {
      Get.snackbar('Error', 'Please enter delivery address');
      return;
    }
    if (selectedPayment.value.isEmpty) {
      Get.snackbar('Error', 'Please select payment method');
      return;
    }
    // Place order logic here
    Get.snackbar('Success', 'Order Placed Successfully');
  }
}