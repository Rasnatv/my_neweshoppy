import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

import '../../../data/models/user_offerdetailmodel.dart';

class UserOfferProductDetailController extends GetxController {
  final box = GetStorage();

  final String apiUrl = "https://rasma.astradevelops.in/e_shoppyy/public/api/offer-product/details";

  // Loading state
  var isLoading = false.obs;

  // Product data
  var productData = Rx<UserOfferProductDetail?>(null);

  // Selected variant attributes
  var selectedAttributes = <String, String>{}.obs;

  // Current selected variant
  var selectedVariant = Rx<ProductVariant?>(null);

  // Current image index for carousel
  var currentImageIndex = 0.obs;

  // Quantity
  var quantity = 1.obs;

  @override
  void onInit() {
    super.onInit();
  }

  // Fetch product details
  Future<void> fetchProductDetails(int offerProductId) async {
    try {
      isLoading.value = true;
      final token = box.read("auth_token");

      if (token == null) {
        Get.snackbar("Error", "Authentication token not found");
        return;
      }

      print("📤 Fetching offer product details for ID: $offerProductId");

      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
        body: jsonEncode({
          "offer_product_id": offerProductId,
        }),
      );

      print("📥 Response status: ${response.statusCode}");
      print("📥 Response body: ${response.body}");

      if (response.statusCode == 200) {
        final body = jsonDecode(response.body);

        if (body['status'] == 1) {
          productData.value = UserOfferProductDetail.fromJson(body['data']);

          // Initialize first variant if available
          if (productData.value!.variants.isNotEmpty) {
            _initializeFirstVariant();
          }

          print("✅ Product details loaded successfully");
        } else {
          Get.snackbar("Error", body['message'] ?? "Failed to fetch product details");
        }
      } else {
        Get.snackbar("Error", "Failed to fetch product details");
      }
    } catch (e) {
      print("❌ Error: $e");
      Get.snackbar("Error", "Failed to fetch product details: $e");
    } finally {
      isLoading.value = false;
    }
  }

  // Initialize first variant
  void _initializeFirstVariant() {
    if (productData.value == null || productData.value!.variants.isEmpty) return;

    final firstVariant = productData.value!.variants.first;
    selectedAttributes.value = Map.from(firstVariant.attributes);
    selectedVariant.value = firstVariant;

    print("✓ Initialized with first variant: ${firstVariant.attributes}");
  }

  // Select variant attribute
  void selectAttribute(String attributeName, String value) {
    selectedAttributes[attributeName] = value;
    _updateSelectedVariant();
  }

  // Update selected variant based on selected attributes
  void _updateSelectedVariant() {
    if (productData.value == null) return;

    // Find matching variant
    final matchingVariant = productData.value!.variants.firstWhereOrNull(
          (variant) => _attributesMatch(variant.attributes, selectedAttributes),
    );

    if (matchingVariant != null) {
      selectedVariant.value = matchingVariant;
      print("✓ Updated to variant: ${matchingVariant.attributes}");
    } else {
      selectedVariant.value = null;
      print("⚠️ No matching variant found");
    }
  }

  // Check if attributes match
  bool _attributesMatch(Map<String, String> variantAttrs, Map<String, String> selectedAttrs) {
    if (variantAttrs.length != selectedAttrs.length) return false;

    for (var key in variantAttrs.keys) {
      if (variantAttrs[key] != selectedAttrs[key]) return false;
    }
    return true;
  }

  // Get available values for an attribute
  List<String> getAvailableValuesForAttribute(String attributeName) {
    if (productData.value == null) return [];

    return productData.value!.variants
        .map((v) => v.attributes[attributeName])
        .whereType<String>()
        .toSet()
        .toList();
  }

  // Get attribute display name
  String getAttributeDisplayName(String key) {
    return key[0].toUpperCase() + key.substring(1);
  }

  // Increase quantity
  void increaseQuantity() {
    if (selectedVariant.value != null) {
      if (quantity.value < selectedVariant.value!.stock) {
        quantity.value++;
      } else {
        Get.snackbar("Max Stock", "Only ${selectedVariant.value!.stock} items available");
      }
    }
  }

  // Decrease quantity
  void decreaseQuantity() {
    if (quantity.value > 1) {
      quantity.value--;
    }
  }

  // Add to cart
  void addToCart() {
    if (selectedVariant.value == null) {
      Get.snackbar("Error", "Please select a variant");
      return;
    }

    if (selectedVariant.value!.stock <= 0) {
      Get.snackbar("Out of Stock", "This variant is currently out of stock");
      return;
    }

    // TODO: Implement your add to cart logic here
    Get.snackbar(
      "Added to Cart",
      "${productData.value!.productName} (${quantity.value} item${quantity.value > 1 ? 's' : ''})",
      backgroundColor: Color(0xFF10B981),
      colorText: Colors.white,
    );

    print("🛒 Added to cart: ${selectedVariant.value!.attributes} x${quantity.value}");
  }

  // Calculate discount amount
  double getDiscountAmount() {
    if (productData.value == null || selectedVariant.value == null) return 0;
    return selectedVariant.value!.price - productData.value!.offerPrice;
  }
}

