
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ManageproductController extends GetxController {
  final box = GetStorage();

  var products = <Product>[].obs;
  var isLoading = false.obs;
  var errorMessage = ''.obs;

  // Get auth token from storage (same as login controller)
  String? get authToken => box.read("auth_token");

  // Get user role from storage (same as login controller)
  int? get userRole => box.read("role");

  // Common headers with auth token
  Map<String, String> get headers => {
    "Accept": "application/json",
    "Authorization": "Bearer ${authToken ?? ''}",
  };

  // Check if user is merchant (role 2)
  bool get isMerchant => userRole == 2;

  // Check if user is admin (role 3)
  bool get isAdmin => userRole == 3;

  @override
  void onInit() {
    super.onInit();

    // Check authentication
    if (authToken == null) {
      errorMessage.value = 'Please login first';
      _showError('Authentication Required', 'Please login to continue');
      return;
    }

    // Check if user is merchant or admin
    if (!isMerchant && !isAdmin) {
      errorMessage.value = 'Access denied. Merchant role required.';
      _showError('Access Denied', 'You need merchant privileges to access this page');
      return;
    }

    fetchProducts();
  }

  // Fetch products from API
  Future<void> fetchProducts() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      print('==========================================');
      print('Fetching products from API...');
      print('User Role: $userRole');
      print('Token Present: ${authToken != null}');
      print('Headers: $headers');
      print('==========================================');

      final response = await http.get(
        Uri.parse('https://rasma.astradevelops.in/e_shoppyy/public/api/products'),
        headers: headers,
      ).timeout(
        const Duration(seconds: 30),
        onTimeout: () {
          throw Exception('Request timeout - Please check your internet connection');
        },
      );

      print('Response Status Code: ${response.statusCode}');
      print('Response Body: ${response.body}');

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);

        if (jsonData['status'] == true || jsonData['status'] == 1 || jsonData['status'] == "1") {
          final List<dynamic> productsData = jsonData['data'] ?? [];
          products.value = productsData.map((json) => Product.fromJson(json)).toList();

          print('✅ Successfully loaded ${products.length} products');

          if (products.isEmpty) {
            errorMessage.value = '';
          }
        } else {
          errorMessage.value = jsonData['message'] ?? 'Failed to load products';
          print('❌ API returned status false');
        }
      } else if (response.statusCode == 401) {
        _handleUnauthorized();
      } else if (response.statusCode == 403) {
        errorMessage.value = 'Access forbidden. Merchant role required.';
        print('❌ 403 - Forbidden');
      } else if (response.statusCode == 404) {
        errorMessage.value = 'API endpoint not found.';
        print('❌ 404 - Not Found');
      } else if (response.statusCode >= 500) {
        errorMessage.value = 'Server error. Please try again later.';
        print('❌ ${response.statusCode} - Server Error');
      } else {
        errorMessage.value = 'Error: ${response.statusCode}';
        print('❌ Error: ${response.statusCode} - ${response.reasonPhrase}');
      }
    } catch (e) {
      print('❌ Error fetching products: $e');
      errorMessage.value = 'Network error: ${e.toString()}';
      _showError('Error', 'Failed to fetch products: $e');
    } finally {
      isLoading.value = false;
    }
  }

  // Delete product with API call
  Future<void> deleteProduct(int index) async {
    final product = products[index];

    Get.defaultDialog(
      title: 'Delete Product',
      middleText: 'Are you sure you want to delete "${product.name}"?',
      textConfirm: 'Delete',
      textCancel: 'Cancel',
      confirmTextColor: Colors.white,
      buttonColor: Colors.red,
      cancelTextColor: Colors.black87,
      onConfirm: () async {
        Get.back();

        if (product.id == null) {
          _showError('Error', 'Product ID not found');
          return;
        }

        try {
          // Show loading
          Get.dialog(
            const Center(
              child: CircularProgressIndicator(color: Colors.teal),
            ),
            barrierDismissible: false,
          );

          final response = await http.delete(
            Uri.parse('https://rasma.astradevelops.in/e_shoppyy/public/api/products/${product.id}'),
            headers: headers,
          );

          // Close loading
          Get.back();

          final body = jsonDecode(response.body);

          if (response.statusCode == 200 && (body['status'] == true || body['status'] == 1)) {
            // Remove from list
            products.removeAt(index);

            // Show success
            Get.snackbar(
              'Success',
              body['message'] ?? 'Product deleted successfully',
              snackPosition: SnackPosition.BOTTOM,
              backgroundColor: Colors.green,
              colorText: Colors.white,
              duration: const Duration(seconds: 2),
            );
          } else if (response.statusCode == 401) {
            _handleUnauthorized();
          } else {
            _showError('Error', body['message'] ?? 'Failed to delete product');
          }
        } catch (e) {
          Get.back(); // Close loading
          _showError('Error', 'Failed to delete product: $e');
        }
      },
    );
  }

  // Refresh products
  Future<void> refreshProducts() async {
    await fetchProducts();
  }

  // Handle unauthorized access
  void _handleUnauthorized() {
    errorMessage.value = 'Session expired. Please login again.';
    print('❌ 401 - Unauthorized');

    Get.defaultDialog(
      title: 'Session Expired',
      middleText: 'Your session has expired. Please login again.',
      textConfirm: 'Login',
      confirmTextColor: Colors.white,
      buttonColor: Colors.teal,
      barrierDismissible: false,
      onConfirm: () {
        Get.back();
        logout();
      },
    );
  }

  // Logout user
  void logout() {
    box.erase(); // Clear all storage
    Get.offAllNamed('/login'); // Navigate to login (adjust route as needed)
  }

  // Show error message
  void _showError(String title, String message) {
    Get.snackbar(
      title,
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.red,
      colorText: Colors.white,
      duration: const Duration(seconds: 3),
    );
  }
}

// Updated Product Model to handle new API structure with product_id and variants
class Product {
  final int? id; // This is product_id from API
  final String name;
  final String price; // First variant price
  final String image; // First variant image
  final List<ProductVariant> variants;

  Product({
    this.id,
    required this.name,
    required this.price,
    required this.image,
    required this.variants,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    // Parse variants
    List<ProductVariant> variantsList = [];
    if (json['variants'] != null && json['variants'] is List) {
      variantsList = (json['variants'] as List)
          .map((v) => ProductVariant.fromJson(v))
          .toList();
    }

    // Get first variant for default price and image
    String defaultPrice = '0.00';
    String defaultImage = '';

    if (variantsList.isNotEmpty) {
      defaultPrice = variantsList[0].price;
      defaultImage = variantsList[0].image ?? '';
    }

    return Product(
      id: json['product_id'], // Note: API uses 'product_id'
      name: json['name'] ?? '',
      price: defaultPrice,
      image: defaultImage,
      variants: variantsList,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'product_id': id,
      'name': name,
      'variants': variants.map((v) => v.toJson()).toList(),
    };
  }
}

// Product Variant Model
class ProductVariant {
  final String price;
  final String? image;

  ProductVariant({
    required this.price,
    this.image,
  });

  factory ProductVariant.fromJson(Map<String, dynamic> json) {
    return ProductVariant(
      price: json['price']?.toString() ?? '0.00',
      image: json['image'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'price': price,
      'image': image,
    };
  }
}