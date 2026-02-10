
import 'dart:convert';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import '../../../data/models/cartmodel.dart';
import 'package:flutter/material.dart';

class CartController extends GetxController {
  final box = GetStorage();

  var cartItems = <CartItem>[].obs;
  var total = 0.0.obs;
  var isLoading = false.obs;

  String get authToken => box.read('auth_token') ?? "";

  @override
  void onInit() {
    super.onInit();
    fetchCart();
  }

  /// Fetch cart from backend
  Future<void> fetchCart() async {
    if (authToken.isEmpty) {
      cartItems.clear();
      return;
    }

    isLoading.value = true;

    try {
      final response = await http.get(
        Uri.parse("https://rasma.astradevelops.in/e_shoppyy/public/api/cart"),
        headers: {
          "Accept": "application/json",
          "Authorization": "Bearer $authToken",
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> body = jsonDecode(response.body);
        if (body['status'] == true) {
          final List<dynamic> items = body['items'] ?? [];
          cartItems.value = items.map((e) => CartItem.fromJson(e)).toList();
          total.value = double.tryParse(body['total'].toString()) ?? 0.0;
        } else {
          cartItems.clear();
          total.value = 0.0;
        }
      } else if (response.statusCode == 401) {
        cartItems.clear();
        total.value = 0.0;
        // Get.snackbar("Unauthorized", "Please login again",
        //     backgroundColor: Colors.red, colorText: Colors.white);
      } else {
        cartItems.clear();
        total.value = 0.0;
        Get.snackbar("Error", "Failed to fetch cart",
            backgroundColor: Colors.red, colorText: Colors.white);
      }
    } catch (e) {
      debugPrint("Error fetching cart: $e");
      cartItems.clear();
      total.value = 0.0;
    } finally {
      isLoading.value = false;
    }
  }

  /// Add product to cart
  Future<void> addToCart({
    required int productId,
    required String name,
    required String image,
    required double price,
  }) async {
    if (authToken.isEmpty) {
      Get.snackbar("Unauthorized", "Please login first",
          backgroundColor: Colors.red, colorText: Colors.white);
      return;
    }

    isLoading.value = true;

    try {
      final response = await http.post(
        Uri.parse(
            "https://rasma.astradevelops.in/e_shoppyy/public/api/cart/add"),
        headers: {
          "Accept": "application/json",
          "Authorization": "Bearer $authToken",
        },
        body: {
          "product_id": productId.toString(),
          "product_name": name,
          "product_image": image,
          "price": price.toString(),
        },
      );

      final Map<String, dynamic> data = jsonDecode(response.body);

      if (data['status'] == true) {
        Get.snackbar(
          "Success",
          data['message'] ?? "Product added to cart",
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
        await fetchCart();
      } else {
        Get.snackbar(
          "Error",
          data['message'] ?? "Failed to add product",
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      debugPrint("Error adding to cart: $e");
      Get.snackbar("Error", "Something went wrong",
          backgroundColor: Colors.red, colorText: Colors.white);
    } finally {
      isLoading.value = false;
    }
  }

  /// Update quantity
  Future<void> updateQuantity(int productId, String action) async {
    // action = "increment" or "decrement"
    try {
      final response = await http.post(
        Uri.parse(
            "https://rasma.astradevelops.in/e_shoppyy/public/api/cart/update-quantity"),
        headers: {
          "Accept": "application/json",
          "Authorization": "Bearer $authToken",
        },
        body: {
          "product_id": productId.toString(),
          "action": action,
        },
      );

      final Map<String, dynamic> data = jsonDecode(response.body);
      if (data['status'] == true) {
        await fetchCart(); // refresh cart
      } else {
        Get.snackbar("Error", data['message'] ?? "Failed to update cart",
            backgroundColor: Colors.red, colorText: Colors.white);
      }
    } catch (e) {
      debugPrint("Error updating quantity: $e");
    }
  }

  /// Remove product from cart
  Future<void> removeFromCart(int productId) async {
    try {
      final response = await http.delete(
        Uri.parse(
            "https://rasma.astradevelops.in/e_shoppyy/public/api/cart/remove"),
        headers: {
          "Accept": "application/json",
          "Authorization": "Bearer $authToken",
        },
        body: {
          "product_id": productId.toString(),
        },
      );

      final Map<String, dynamic> data = jsonDecode(response.body);
      if (data['status'] == true) {
        await fetchCart();
        Get.snackbar("Success", data['message'] ?? "Removed from cart",
            backgroundColor: Colors.green, colorText: Colors.white);
      } else {
        Get.snackbar("Error", data['message'] ?? "Failed to remove",
            backgroundColor: Colors.red, colorText: Colors.white);
      }
    } catch (e) {
      debugPrint("Error removing from cart: $e");
    }
  }
}
