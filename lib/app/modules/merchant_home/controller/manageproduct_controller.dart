//
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:get_storage/get_storage.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';
// import 'dart:io';
//
// import '../../../data/errors/api_error.dart';
// import '../../merchantlogin/widget/successwidget.dart';
//
// class ManageproductController extends GetxController {
//   final box = GetStorage();
//
//   var products = <Product>[].obs;
//   var isLoading = false.obs;
//   var errorMessage = ''.obs;
//
//   String get authToken => box.read("auth_token") ?? "";
//   int? get userRole => box.read("role");
//
//   Map<String, String> get headers => {
//     "Accept": "application/json",
//     "Authorization": "Bearer $authToken",
//   };
//
//   bool get isMerchant => userRole == 2;
//   bool get isAdmin => userRole == 3;
//
//   @override
//   void onInit() {
//     super.onInit();
//
//     fetchProducts();
//   }
//
//   /// ================= FETCH PRODUCTS =================
//   Future<void> fetchProducts() async {
//     try {
//       isLoading.value = true;
//       errorMessage.value = '';
//
//       final response = await http
//           .get(
//         Uri.parse(
//             'https://rasma.astradevelops.in/e_shoppyy/public/api/products'),
//         headers: headers,
//       )
//           .timeout(
//         const Duration(seconds: 30),
//         onTimeout: () =>
//         throw SocketException('Request timeout'),
//       );
//
//       if (response.statusCode == 200) {
//         final jsonData = json.decode(response.body);
//
//         if (jsonData['status'] == true ||
//             jsonData['status'] == 1 ||
//             jsonData['status'] == "1") {
//           final List<dynamic> productsData = jsonData['data'] ?? [];
//
//           products.value =
//               productsData.map((j) => Product.fromJson(j)).toList();
//         } else {
//           errorMessage.value =
//               jsonData['message'] ?? 'Failed to load products';
//
//           AppSnackbar.warning(errorMessage.value);
//         }
//       } else {
//         final msg = ApiErrorHandler.handleResponse(response);
//         errorMessage.value = msg;
//
//         AppSnackbar.error(msg);
//       }
//
//     } catch (e) {
//       final msg = ApiErrorHandler.handleException(e);
//       errorMessage.value = msg;
//
//       AppSnackbar.error(msg);
//
//     } finally {
//       isLoading.value = false;
//     }
//   }
//
//   /// ================= NAVIGATION =================
//   void navigateToUpdateProduct(int productId) {
//     Get.toNamed(
//       '/update-product',
//       arguments: {'product_id': productId},
//     )
//         ?.then((result) {
//       if (result !=null) fetchProducts();
//     });
//   }
//
//
//   /// ================= DELETE PRODUCT =================
//   Future<void> deleteProduct(int productId) async {
//     try {
//       /// ✅ LOADER
//       Get.dialog(
//         const Center(child: CircularProgressIndicator()),
//         barrierDismissible: false,
//       );
//
//       final response = await http.delete(
//         Uri.parse(
//             'https://rasma.astradevelops.in/e_shoppyy/public/api/delete-product'),
//         headers: headers,
//         body: {
//           "product_id": productId.toString(),
//         },
//       );
//
//       Get.back(); // close loader
//
//       if (response.statusCode == 200) {
//         final body = jsonDecode(response.body);
//
//         if (body['status'] == true || body['status'] == 1) {
//           products.removeWhere((p) => p.id == productId);
//
//           /// ✅ SUCCESS MESSAGE
//           AppSnackbar.success(
//               body['message'] ?? "Product deleted successfully");
//         } else {
//           AppSnackbar.warning(
//               body['message'] ?? "Delete failed");
//         }
//       } else {
//         final msg = ApiErrorHandler.handleResponse(response);
//         AppSnackbar.error(msg);
//       }
//
//     } catch (e) {
//       Get.back();
//
//       final msg = ApiErrorHandler.handleException(e);
//       AppSnackbar.error(msg);
//     }
//   }
//
//   /// ================= REFRESH =================
//   Future<void> refreshProducts() async => fetchProducts();
// }
// // ─────────────────────────────────────────────────────────────────────────────
// // MODELS
// // ─────────────────────────────────────────────────────────────────────────────
//
// class Product {
//   final int? id;
//   final String name;
//   final String price;
//   final String image;
//   final List<ProductVariant> variants;
//
//   Product({
//     this.id,
//     required this.name,
//     required this.price,
//     required this.image,
//     required this.variants,
//   });
//
//   factory Product.fromJson(Map<String, dynamic> json) {
//     List<ProductVariant> variantsList = [];
//     if (json['variants'] != null && json['variants'] is List) {
//       variantsList = (json['variants'] as List)
//           .map((v) => ProductVariant.fromJson(v))
//           .toList();
//     }
//
//     String defaultPrice = '0.00';
//     String defaultImage = '';
//
//     if (variantsList.isNotEmpty) {
//       defaultPrice = variantsList[0].price;
//       defaultImage = variantsList[0].image ?? '';
//     }
//
//     return Product(
//       id: json['product_id'],
//       name: json['name'] ?? '',
//       price: defaultPrice,
//       image: defaultImage,
//       variants: variantsList,
//     );
//   }
//
//   Map<String, dynamic> toJson() => {
//     'product_id': id,
//     'name': name,
//     'variants': variants.map((v) => v.toJson()).toList(),
//   };
// }
//
// class ProductVariant {
//   final String price;
//   final String? image;
//
//   ProductVariant({required this.price, this.image});
//
//   factory ProductVariant.fromJson(Map<String, dynamic> json) => ProductVariant(
//     price: json['price']?.toString() ?? '0.00',
//     image: json['image'],
//   );
//
//   Map<String, dynamic> toJson() => {'price': price, 'image': image};
// }
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';

import '../../../data/errors/api_error.dart';
import '../../merchantlogin/widget/successwidget.dart';

class ManageproductController extends GetxController {
  final box = GetStorage();

  var products = <Product>[].obs;
  var isLoading = false.obs;
  var isLoadingMore = false.obs;
  var errorMessage = ''.obs;
  var hasMoreData = true.obs;

  int _currentPage = 1;
  final int _perPage = 10;

  String get authToken => box.read("auth_token") ?? "";
  int? get userRole => box.read("role");

  Map<String, String> get headers => {
    "Accept": "application/json",
    "Authorization": "Bearer $authToken",
  };

  bool get isMerchant => userRole == 2;
  bool get isAdmin => userRole == 3;

  @override
  void onInit() {
    super.onInit();
    fetchProducts();
  }

  /// ================= FETCH PRODUCTS (Reset to page 1) =================
  Future<void> fetchProducts() async {
    _currentPage = 1;
    hasMoreData.value = true;
    products.clear();
    await _loadPage(_currentPage);
  }

  /// ================= LOAD MORE (Next page) =================
  Future<void> loadMore() async {
    if (isLoadingMore.value || !hasMoreData.value) return;
    _currentPage++;
    await _loadPage(_currentPage);
  }

  /// ================= CORE FETCH =================
  Future<void> _loadPage(int page) async {
    try {
      if (page == 1) {
        isLoading.value = true;
      } else {
        isLoadingMore.value = true;
      }
      errorMessage.value = '';

      final uri = Uri.parse(
        'https://rasma.astradevelops.in/e_shoppyy/public/api/products'
            '?per_page=$_perPage&page=$page',
      );

      final response = await http
          .get(uri, headers: headers)
          .timeout(
        const Duration(seconds: 30),
        onTimeout: () => throw SocketException('Request timeout'),
      );

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);

        if (jsonData['status'] == true ||
            jsonData['status'] == 1 ||
            jsonData['status'] == "1") {
          final List<dynamic> productsData = jsonData['data'] ?? [];
          final newItems =
          productsData.map((j) => Product.fromJson(j)).toList();

          products.addAll(newItems);

          if (newItems.length < _perPage) {
            hasMoreData.value = false;
          }
        } else {
          if (page == 1) {
            errorMessage.value =
                jsonData['message'] ?? 'Failed to load products';
          }
          hasMoreData.value = false;
          AppSnackbar.warning(
              jsonData['message'] ?? 'Failed to load products');
        }
      } else {
        final msg = ApiErrorHandler.handleResponse(response);
        if (page == 1) errorMessage.value = msg;
        AppSnackbar.error(msg);
      }
    } catch (e) {
      final msg = ApiErrorHandler.handleException(e);
      if (page == 1) errorMessage.value = msg;
      AppSnackbar.error(msg);
    } finally {
      isLoading.value = false;
      isLoadingMore.value = false;
    }
  }

  /// ================= NAVIGATION =================
  void navigateToUpdateProduct(int productId) {
    Get.toNamed(
      '/update-product',
      arguments: {'product_id': productId},
    )?.then((result) {
      if (result != null) fetchProducts();
    });
  }

  /// ================= DELETE PRODUCT =================
  Future<void> deleteProduct(int productId) async {
    try {
      Get.dialog(
        const Center(child: CircularProgressIndicator()),
        barrierDismissible: false,
      );

      final response = await http.delete(
        Uri.parse(
            'https://rasma.astradevelops.in/e_shoppyy/public/api/delete-product'),
        headers: headers,
        body: {
          "product_id": productId.toString(),
        },
      );

      Get.back();

      if (response.statusCode == 200) {
        final body = jsonDecode(response.body);

        if (body['status'] == true || body['status'] == 1) {
          products.removeWhere((p) => p.id == productId);
          AppSnackbar.success(
              body['message'] ?? "Product deleted successfully");
        } else {
          AppSnackbar.warning(body['message'] ?? "Delete failed");
        }
      } else {
        final msg = ApiErrorHandler.handleResponse(response);
        AppSnackbar.error(msg);
      }
    } catch (e) {
      Get.back();
      final msg = ApiErrorHandler.handleException(e);
      AppSnackbar.error(msg);
    }
  }

  /// ================= REFRESH =================
  Future<void> refreshProducts() async => fetchProducts();
}

// ─────────────────────────────────────────────────────────────────────────────
// MODELS
// ─────────────────────────────────────────────────────────────────────────────

class Product {
  final int? id;
  final String name;
  final String price;
  final String image;
  final List<ProductVariant> variants;

  Product({
    this.id,
    required this.name,
    required this.price,
    required this.image,
    required this.variants,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    List<ProductVariant> variantsList = [];
    if (json['variants'] != null && json['variants'] is List) {
      variantsList = (json['variants'] as List)
          .map((v) => ProductVariant.fromJson(v))
          .toList();
    }

    String defaultPrice = '0.00';
    String defaultImage = '';

    if (variantsList.isNotEmpty) {
      defaultPrice = variantsList[0].price;
      defaultImage = variantsList[0].image ?? '';
    }

    return Product(
      id: json['product_id'],
      name: json['name'] ?? '',
      price: defaultPrice,
      image: defaultImage,
      variants: variantsList,
    );
  }

  Map<String, dynamic> toJson() => {
    'product_id': id,
    'name': name,
    'variants': variants.map((v) => v.toJson()).toList(),
  };
}

class ProductVariant {
  final String price;
  final String? image;

  ProductVariant({required this.price, this.image});

  factory ProductVariant.fromJson(Map<String, dynamic> json) =>
      ProductVariant(
        price: json['price']?.toString() ?? '0.00',
        image: json['image'],
      );

  Map<String, dynamic> toJson() => {'price': price, 'image': image};
}