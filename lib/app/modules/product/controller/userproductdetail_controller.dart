//
// import 'dart:convert';
//
// import 'package:flutter/material.dart';
// import 'package:get/get_navigation/src/root/parse_route.dart';
// import 'package:get/get_rx/src/rx_types/rx_types.dart';
// import 'package:get/get_state_manager/src/simple/get_controllers.dart';
// import 'package:get_storage/get_storage.dart';
// import 'package:http/http.dart' as http;
//
// import '../../../data/errors/api_error.dart';
// import '../../../data/models/user_productdetailmodel.dart';
// import '../../merchantlogin/widget/successwidget.dart';
//
// class ProductDetailController extends GetxController {
//   final box = GetStorage();
//   final int productId;
//
//   ProductDetailController({required this.productId});
//
//   var isLoading = false.obs;
//   var product = Rxn<ProductDetailModel>();
//   var selectedVariant = Rxn<ProductVariantModel>();
//   var currentImageIndex = 0.obs;
//
//   late final PageController pageController;
//
//   final String _baseUrl = "https://eshoppy.co.in/api";
//
//   @override
//   void onInit() {
//     super.onInit();
//     pageController = PageController();
//     fetchProduct(productId);
//   }
//
//   @override
//   void onClose() {
//     pageController.dispose();
//     super.onClose();
//   }
//
//   Future<void> fetchProduct(int productId) async {
//     final token = box.read('auth_token');
//     try {
//       isLoading.value = true;
//       final response = await http.post(
//         Uri.parse("$_baseUrl/product-details"),
//         headers: {
//           "Accept": "application/json",
//           "Authorization": "Bearer $token",
//         },
//         body: {"product_id": productId.toString()},
//       );
//
//       if (response.statusCode != 200) {
//         AppSnackbar.error(ApiErrorHandler.handleResponse(response));
//         product.value = null;
//         return;
//       }
//
//       final decoded = json.decode(response.body);
//       if (decoded['status'] == true) {
//         final productData = ProductDetailModel.fromJson(decoded['data']);
//         product.value = productData;
//         if (productData.variants.isNotEmpty) {
//           selectedVariant.value = productData.variants.first;
//           currentImageIndex.value = 0;
//         }
//       } else {
//         product.value = null;
//         AppSnackbar.error(
//             decoded['message']?.toString() ?? "Failed to load product");
//       }
//     } catch (e) {
//       product.value = null;
//       AppSnackbar.error(ApiErrorHandler.handleException(e));
//       debugPrint("Product detail error: $e");
//     } finally {
//       isLoading.value = false;
//     }
//   }
//
//   Map<String, Set<String>> getVariantAttributes() {
//     final Map<String, Set<String>> map = {};
//     for (var v in product.value?.variants ?? []) {
//       v.attributes.forEach((key, value) {
//         map.putIfAbsent(key, () => {});
//         map[key]!.add(value.toString());
//       });
//     }
//     return map;
//   }
//
//   void selectVariant(ProductVariantModel variant) {
//     selectedVariant.value = variant;
//
//     final index = product.value?.variants.indexOf(variant) ?? 0;
//     currentImageIndex.value = index;
//
//     if (pageController.hasClients) {
//       pageController.animateToPage(
//         index,
//         duration: const Duration(milliseconds: 300),
//         curve: Curves.easeInOut,
//       );
//     }
//   }
//
// // ✅ ADD THIS BELOW selectVariant
// void selectVariantById(int variantId) {
//   if (product.value == null) return;
//   final matched = product.value!.variants.firstWhereOrNull(
//         (v) => v.variantId == variantId,
//   );
//   if (matched != null) {
//     selectVariant(matched);
//   }
// }}
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

import '../../../data/errors/api_error.dart';
import '../../../data/models/user_productdetailmodel.dart';
import '../../merchantlogin/widget/successwidget.dart';

// class ProductDetailController extends GetxController {
//   final box = GetStorage();
//   final int productId;
//   final int? preSelectedVariantId; // ✅ NEW
//
//   ProductDetailController({
//     required this.productId,
//     this.preSelectedVariantId, // ✅ NEW
//   });
//
//   var isLoading = false.obs;
//   var product = Rxn<ProductDetailModel>();
//   var selectedVariant = Rxn<ProductVariantModel>();
//   var currentImageIndex = 0.obs;
//
//   late final PageController pageController;
//
//   final String _baseUrl = "https://eshoppy.co.in/api";
//
//   @override
//   void onInit() {
//     super.onInit();
//     // ✅ initialPage set AFTER fetchProduct resolves via currentImageIndex
//     // We init with 0 here; will be replaced before PageView builds
//     pageController = PageController(initialPage: 0);
//     fetchProduct(productId);
//   }
//
//   @override
//   void onClose() {
//     pageController.dispose();
//     super.onClose();
//   }
//
//   Future<void> fetchProduct(int productId) async {
//     final token = box.read('auth_token');
//     try {
//       isLoading.value = true;
//       final response = await http.post(
//         Uri.parse("$_baseUrl/product-details"),
//         headers: {
//           "Accept": "application/json",
//           "Authorization": "Bearer $token",
//         },
//         body: {"product_id": productId.toString()},
//       );
//
//       if (response.statusCode != 200) {
//         AppSnackbar.error(ApiErrorHandler.handleResponse(response));
//         product.value = null;
//         return;
//       }
//
//       final decoded = json.decode(response.body);
//       if (decoded['status'] == true) {
//         final productData = ProductDetailModel.fromJson(decoded['data']);
//         product.value = productData;
//
//         if (productData.variants.isNotEmpty) {
//           // ✅ Apply preSelectedVariantId if provided, else default to first
//           ProductVariantModel targetVariant = productData.variants.first;
//
//           if (preSelectedVariantId != null) {
//             final matched = productData.variants.firstWhereOrNull(
//                   (v) => v.variantId == preSelectedVariantId,
//             );
//             if (matched != null) targetVariant = matched;
//           }
//
//           selectedVariant.value = targetVariant;
//           // ✅ Set index here — before PageView is built — so initialPage works
//           currentImageIndex.value =
//               productData.variants.indexOf(targetVariant);
//         }
//       } else {
//         product.value = null;
//         AppSnackbar.error(
//             decoded['message']?.toString() ?? "Failed to load product");
//       }
//     } catch (e) {
//       product.value = null;
//       AppSnackbar.error(ApiErrorHandler.handleException(e));
//       debugPrint("Product detail error: $e");
//     } finally {
//       isLoading.value = false;
//     }
//   }
//
//   Map<String, Set<String>> getVariantAttributes() {
//     final Map<String, Set<String>> map = {};
//     for (var v in product.value?.variants ?? []) {
//       v.attributes.forEach((key, value) {
//         map.putIfAbsent(key, () => {});
//         map[key]!.add(value.toString());
//       });
//     }
//     return map;
//   }
//
//   void selectVariant(ProductVariantModel variant) {
//     selectedVariant.value = variant;
//
//     final index = product.value?.variants.indexOf(variant) ?? 0;
//     currentImageIndex.value = index;
//
//     if (pageController.hasClients) {
//       pageController.animateToPage(
//         index,
//         duration: const Duration(milliseconds: 300),
//         curve: Curves.easeInOut,
//       );
//     }
//   }
//
//   void selectVariantById(int variantId) {
//     if (product.value == null) return;
//     final matched = product.value!.variants.firstWhereOrNull(
//           (v) => v.variantId == variantId,
//     );
//     if (matched != null) selectVariant(matched);
//   }
// }
class ProductDetailController extends GetxController {
  final box = GetStorage();
  final int productId;
  final int? preSelectedVariantId;

  ProductDetailController({
    required this.productId,
    this.preSelectedVariantId,
  });

  var isLoading = false.obs;
  var product = Rxn<ProductDetailModel>();
  var selectedVariant = Rxn<ProductVariantModel>();
  var currentImageIndex = 0.obs;

  late final PageController pageController;

  final String _baseUrl = "https://eshoppy.co.in/api";

  @override
  void onInit() {
    super.onInit();
    // ✅ initialPage stays 0 here — will jump after fetch resolves
    pageController = PageController(initialPage: 0);
    fetchProduct(productId);
  }

  @override
  void onClose() {
    pageController.dispose();
    super.onClose();
  }

  Future<void> fetchProduct(int productId) async {
    final token = box.read('auth_token');
    try {
      isLoading.value = true;
      final response = await http.post(
        Uri.parse("$_baseUrl/product-details"),
        headers: {
          "Accept": "application/json",
          "Authorization": "Bearer $token",
        },
        body: {"product_id": productId.toString()},
      );

      if (response.statusCode != 200) {
        AppSnackbar.error(ApiErrorHandler.handleResponse(response));
        product.value = null;
        return;
      }

      final decoded = json.decode(response.body);
      if (decoded['status'] == true) {
        final productData = ProductDetailModel.fromJson(decoded['data']);
        product.value = productData;

        if (productData.variants.isNotEmpty) {
          // ✅ FIX: pick the pre-selected variant, fall back to first
          ProductVariantModel targetVariant = productData.variants.first;

          if (preSelectedVariantId != null) {
            final matched = productData.variants.firstWhereOrNull(
                  (v) => v.variantId == preSelectedVariantId,
            );
            if (matched != null) targetVariant = matched;
          }

          final targetIndex = productData.variants.indexOf(targetVariant);

          selectedVariant.value = targetVariant;
          currentImageIndex.value = targetIndex;

          // ✅ FIX: jump PageController to correct page after build
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (pageController.hasClients && targetIndex != 0) {
              pageController.jumpToPage(targetIndex);
            }
          });
        }
      } else {
        product.value = null;
        AppSnackbar.error(
            decoded['message']?.toString() ?? "Failed to load product");
      }
    } catch (e) {
      product.value = null;
      AppSnackbar.error(ApiErrorHandler.handleException(e));
      debugPrint("Product detail error: $e");
    } finally {
      isLoading.value = false;
    }
  }

  Map<String, Set<String>> getVariantAttributes() {
    final Map<String, Set<String>> map = {};
    for (var v in product.value?.variants ?? []) {
      v.attributes.forEach((key, value) {
        map.putIfAbsent(key, () => {});
        map[key]!.add(value.toString());
      });
    }
    return map;
  }

  void selectVariant(ProductVariantModel variant) {
    selectedVariant.value = variant;
    final index = product.value?.variants.indexOf(variant) ?? 0;
    currentImageIndex.value = index;
    if (pageController.hasClients) {
      pageController.animateToPage(
        index,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void selectVariantById(int variantId) {
    if (product.value == null) return;
    final matched = product.value!.variants.firstWhereOrNull(
          (v) => v.variantId == variantId,
    );
    if (matched != null) selectVariant(matched);
  }
}