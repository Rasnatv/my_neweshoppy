
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

import '../../../data/errors/api_error.dart';
import '../../../data/models/user_productdetailmodel.dart';
import '../../merchantlogin/widget/successwidget.dart';

class ProductDetailController extends GetxController {
  final box = GetStorage();
  final int productId;

  ProductDetailController({required this.productId});

  var isLoading = false.obs;
  var product = Rxn<ProductDetailModel>();
  var selectedVariant = Rxn<ProductVariantModel>();

  final String _baseUrl = "https://eshoppy.co.in/api";

  @override
  void onInit() {
    super.onInit();
    fetchProduct(productId);
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
          selectedVariant.value = productData.variants.first;
        }
      } else {
        product.value = null;
        AppSnackbar.error(decoded['message']?.toString() ?? "Failed to load product");
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
  }
}