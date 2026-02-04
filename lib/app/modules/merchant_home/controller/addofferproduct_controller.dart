//
// import 'package:get/get.dart';
// import 'package:flutter/material.dart';
// import '../../../data/models/offerproductcontroller.dart';
// import '../../admin_home/offer/views/admin_merchantofferspage.dart';
//
// class OfferController extends GetxController {
//   static const int maxProducts = 5;
//
//   RxList<OfferProduct> selectedProducts = <OfferProduct>[].obs;
//
//   void addProduct(OfferProduct product) {
//     if (selectedProducts.length >= maxProducts) {
//       Get.snackbar(
//         "Limit Reached",
//         "You can add maximum $maxProducts products",
//         snackPosition: SnackPosition.BOTTOM,
//         backgroundColor: Colors.red.shade50,
//         colorText: Colors.red,
//       );
//       return;
//     }
//
//     // final exists = selectedProducts
//     //     .any((element) => element.productId == product.productId);
//     //
//     // if (exists) {
//     //   Get.snackbar("Already Added", "This product already exists");
//     //   return;
//     // }
//
//     selectedProducts.add(product);
//   }
//
//   void removeProduct(int index) {
//     selectedProducts.removeAt(index);
//   }
//
//   bool validateOfferProducts() {
//     if (selectedProducts.isEmpty) {
//       Get.snackbar("Error", "Add at least one product");
//       return false;
//     }
//     if (selectedProducts.length > maxProducts) {
//       Get.snackbar("Error", "Maximum $maxProducts products allowed");
//       return false;
//     }
//     return true;
//   }
// }
