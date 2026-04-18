//
// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:get_storage/get_storage.dart';
// import 'package:http/http.dart' as http;
// import '../../../data/models/user_productdetailmodel.dart';
// import 'cartcontroller.dart';
// import '../view/cartscreen.dart';
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
//   var quantity = 1.obs;
//   var isAddedToCart = false.obs;
//
//   Worker? _cartWorker;
//
//   final String api =
//       "https://rasma.astradevelops.in/e_shoppyy/public/api/product-details";
//
//   @override
//   void onInit() {
//     super.onInit();
//     fetchProduct(productId);
//   }
//
//   @override
//   void onClose() {
//     _cartWorker?.dispose();
//     super.onClose();
//   }
//
//   // ✅ FETCH PRODUCT
//   Future<void> fetchProduct(int productId) async {
//     final token = box.read('auth_token');
//     if (token == null) return;
//
//     try {
//       isLoading.value = true;
//       isAddedToCart.value = false;
//
//       final response = await http.post(
//         Uri.parse(api),
//         headers: {
//           "Accept": "application/json",
//           "Authorization": "Bearer $token",
//         },
//         body: {"product_id": productId.toString()},
//       );
//
//       final decoded = json.decode(response.body);
//
//       if (decoded['status'] == true) {
//         final productData =
//         ProductDetailModel.fromJson(decoded['data']);
//
//         product.value = productData;
//
//         // ✅ VERY IMPORTANT
//         if (productData.variants.isNotEmpty) {
//           selectedVariant.value = productData.variants.first;
//         }
//
//         _syncCartState();
//       } else {
//         product.value = null;
//       }
//     } catch (e) {
//       product.value = null;
//       debugPrint("Product detail error: $e");
//     } finally {
//       isLoading.value = false;
//     }
//   }
//
//   // ✅ CART SYNC
//   void _syncCartState() {
//     if (product.value == null) return;
//
//     final pid = product.value!.productId.toString();
//
//     if (Get.isRegistered<CartController>()) {
//       final cart = Get.find<CartController>();
//
//       isAddedToCart.value =
//           cart.cartItems.any((item) => item.productId.toString() == pid);
//
//       _cartWorker?.dispose();
//       _cartWorker = ever(cart.cartItems, (_) {
//         isAddedToCart.value =
//             cart.cartItems.any((item) => item.productId.toString() == pid);
//       });
//     } else {
//       _checkIfAlreadyInCart();
//     }
//   }
//
//   Future<void> _checkIfAlreadyInCart() async {
//     try {
//       final token = box.read('auth_token');
//       if (token == null) return;
//
//       final response = await http.get(
//         Uri.parse(
//             "https://rasma.astradevelops.in/e_shoppyy/public/api/cart"),
//         headers: {
//           "Accept": "application/json",
//           "Authorization": "Bearer $token",
//         },
//       );
//
//       final body = jsonDecode(response.body);
//
//       if (body['status'] == true) {
//         final List items = body['items'] ?? [];
//         final pid = product.value!.productId.toString();
//
//         isAddedToCart.value =
//             items.any((item) => item['product_id'].toString() == pid);
//       }
//     } catch (_) {}
//   }
//
//   // ✅ ADD TO CART
//   Future<void> addToCart() async {
//     if (selectedVariant.value == null) {
//       Get.snackbar("Error", "Select variant first");
//       return;
//     }
//
//     final stockCount = selectedVariant.value!.stock;
//
//     if (stockCount <= 0) {
//       Get.snackbar("Out of Stock", "No stock available");
//       return;
//     }
//
//     try {
//       final token = box.read('auth_token');
//       if (token == null) return;
//
//       final response = await http.post(
//         Uri.parse(
//             "https://rasma.astradevelops.in/e_shoppyy/public/api/cart/add"),
//         headers: {
//           "Accept": "application/json",
//           "Authorization": "Bearer $token",
//         },
//         body: {
//           "product_id": product.value!.productId.toString(),
//           "product_name": product.value!.productName,
//           "product_image": selectedVariant.value!.image,
//           "price": selectedVariant.value!.price.toString(),
//           "quantity": quantity.value.toString(),
//         },
//       );
//
//       final data = jsonDecode(response.body);
//
//       if (data['status'] == true) {
//         isAddedToCart.value = true;
//
//         if (Get.isRegistered<CartController>()) {
//           await Get.find<CartController>().fetchCart();
//         }
//
//         Get.snackbar("Success", "Added to cart");
//       }
//     } catch (e) {
//       Get.snackbar("Error", "Something went wrong");
//     }
//   }
//
//   void goToCart() {
//     Get.to(() => CartScreen());
//   }
//
//   // ✅ VARIANTS
//   Map<String, Set<String>> getVariantAttributes() {
//     final Map<String, Set<String>> map = {};
//
//     final variants = product.value?.variants ?? [];
//
//     for (var v in variants) {
//       v.attributes.forEach((key, value) {
//         map.putIfAbsent(key, () => {});
//         map[key]!.add(value.toString());
//       });
//     }
//
//     return map;
//   }
//
//   void selectVariant(ProductVariantModel variant) {
//     selectedVariant.value = variant;
//     quantity.value = 1;
//   }
//
//   void increaseQty() {
//     final stock = selectedVariant.value?.stock ?? 0;
//     if (quantity.value < stock) {
//       quantity.value++;
//     }
//   }
//
//   void decreaseQty() {
//     if (quantity.value > 1) quantity.value--;
//   }
// }
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import '../../../data/errors/api_error.dart';
import '../../../data/models/user_productdetailmodel.dart';

import '../../merchantlogin/widget/successwidget.dart';
import 'cartcontroller.dart';
import '../view/cartscreen.dart';

class ProductDetailController extends GetxController {
  final box = GetStorage();
  final int productId;

  ProductDetailController({required this.productId});

  var isLoading = false.obs;
  var product = Rxn<ProductDetailModel>();
  var selectedVariant = Rxn<ProductVariantModel>();
  var quantity = 1.obs;
  var isAddedToCart = false.obs;

  Worker? _cartWorker;

  final String _baseUrl =
      "https://rasma.astradevelops.in/e_shoppyy/public/api";

  @override
  void onInit() {
    super.onInit();
    fetchProduct(productId);
  }

  @override
  void onClose() {
    _cartWorker?.dispose();
    super.onClose();
  }

  // ✅ FETCH PRODUCT
  Future<void> fetchProduct(int productId) async {
    final token = box.read('auth_token');

    try {
      isLoading.value = true;
      isAddedToCart.value = false;

      final response = await http.post(
        Uri.parse("$_baseUrl/product-details"),
        headers: {
          "Accept": "application/json",
          "Authorization": "Bearer $token",
        },
        body: {"product_id": productId.toString()},
      );

      // ✅ Handle non-2xx HTTP errors
      if (response.statusCode != 200) {
        final errorMsg = ApiErrorHandler.handleResponse(response);
        AppSnackbar.error(errorMsg);
        product.value = null;
        return;
      }

      final decoded = json.decode(response.body);

      if (decoded['status'] == true) {
        final productData = ProductDetailModel.fromJson(decoded['data']);
        product.value = productData;

        if (productData.variants.isNotEmpty) {
          selectedVariant.value = productData.variants.first;
        }

        _syncCartState();
      } else {
        product.value = null;
        final msg = decoded['message']?.toString() ?? "Failed to load product";
        AppSnackbar.error(msg);
      }
    } catch (e) {
      product.value = null;
      final errorMsg = ApiErrorHandler.handleException(e);
      AppSnackbar.error(errorMsg);
      debugPrint("Product detail error: $e");
    } finally {
      isLoading.value = false;
    }
  }

  // ✅ CART SYNC
  void _syncCartState() {
    if (product.value == null) return;

    final pid = product.value!.productId.toString();

    if (Get.isRegistered<CartController>()) {
      final cart = Get.find<CartController>();

      isAddedToCart.value =
          cart.cartItems.any((item) => item.productId.toString() == pid);

      _cartWorker?.dispose();
      _cartWorker = ever(cart.cartItems, (_) {
        isAddedToCart.value =
            cart.cartItems.any((item) => item.productId.toString() == pid);
      });
    } else {
      _checkIfAlreadyInCart();
    }
  }

  Future<void> _checkIfAlreadyInCart() async {
    try {
      final token = box.read('auth_token');
      if (token == null) return;

      final response = await http.get(
        Uri.parse("$_baseUrl/cart"),
        headers: {
          "Accept": "application/json",
          "Authorization": "Bearer $token",
        },
      );

      if (response.statusCode != 200) {
        // Silent fail — not shown to user, just logged
        debugPrint("Cart check failed: ${response.statusCode}");
        return;
      }

      final body = jsonDecode(response.body);

      if (body['status'] == true) {
        final List items = body['items'] ?? [];
        final pid = product.value!.productId.toString();

        isAddedToCart.value =
            items.any((item) => item['product_id'].toString() == pid);
      }
    } catch (e) {
      debugPrint("Cart check exception: $e");
    }
  }

  // ✅ ADD TO CART
  Future<void> addToCart() async {
    if (selectedVariant.value == null) {
      AppSnackbar.warning("Please select a variant first");
      return;
    }

    final stockCount = selectedVariant.value!.stock;

    if (stockCount <= 0) {
      AppSnackbar.warning("This item is currently out of stock");
      return;
    }

    try {
      final token = box.read('auth_token');
      if (token == null) return;

      final response = await http.post(
        Uri.parse("$_baseUrl/cart/add"),
        headers: {
          "Accept": "application/json",
          "Authorization": "Bearer $token",
        },
        body: {
          "product_id": product.value!.productId.toString(),
          "product_name": product.value!.productName,
          "product_image": selectedVariant.value!.image,
          "price": selectedVariant.value!.price.toString(),
          "quantity": quantity.value.toString(),
        },
      );

      // ✅ Handle non-2xx HTTP errors
      if (response.statusCode != 200) {
        final errorMsg = ApiErrorHandler.handleResponse(response);
        AppSnackbar.error(errorMsg);
        return;
      }

      final data = jsonDecode(response.body);

      if (data['status'] == true) {
        isAddedToCart.value = true;

        if (Get.isRegistered<CartController>()) {
          await Get.find<CartController>().fetchCart();
        }

        AppSnackbar.success("Item added to cart successfully");
      } else {
        final msg = data['message']?.toString() ?? "Failed to add to cart";
        AppSnackbar.error(msg);
      }
    } catch (e) {
      final errorMsg = ApiErrorHandler.handleException(e);
      AppSnackbar.error(errorMsg);
    }
  }

  void goToCart() {
    Get.to(() => CartScreen());
  }

  // ✅ VARIANTS
  Map<String, Set<String>> getVariantAttributes() {
    final Map<String, Set<String>> map = {};
    final variants = product.value?.variants ?? [];

    for (var v in variants) {
      v.attributes.forEach((key, value) {
        map.putIfAbsent(key, () => {});
        map[key]!.add(value.toString());
      });
    }

    return map;
  }

  void selectVariant(ProductVariantModel variant) {
    selectedVariant.value = variant;
    quantity.value = 1;
  }

  void increaseQty() {
    final stock = selectedVariant.value?.stock ?? 0;
    if (quantity.value < stock) {
      quantity.value++;
    }
  }

  void decreaseQty() {
    if (quantity.value > 1) quantity.value--;
  }
}