
import 'dart:convert';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

import '../../../data/models/user_productdetailmodel.dart';

class ProductDetailController extends GetxController {
  final box = GetStorage();

  var isLoading = false.obs;
  var product = Rxn<ProductDetailModel>();
  var selectedVariant = Rxn<ProductVariantModel>();
  var quantity = 1.obs;

  final String api =
      "https://rasma.astradevelops.in/e_shoppyy/public/api/product-details";

  /// 🔥 FETCH PRODUCT
  Future<void> fetchProduct(int productId) async {
    final token = box.read('auth_token');
    if (token == null) return;

    try {
      isLoading.value = true;

      final response = await http.post(
        Uri.parse(api),
        headers: {
          "Accept": "application/json",
          "Authorization": "Bearer $token",
        },
        body: {
          "product_id": productId.toString(),
        },
      );

      final decoded = json.decode(response.body);
      product.value = ProductDetailModel.fromJson(decoded['data']);

      /// default variant
      if (product.value!.variants.isNotEmpty) {
        selectedVariant.value = product.value!.variants.first;
      }
    } catch (e) {
      product.value = null;
      print("Product detail error: $e");
    } finally {
      isLoading.value = false;
    }
  }

  /// ✅ DYNAMIC ATTRIBUTE MAP (IMPORTANT)
  /// Example output:
  /// {
  ///   "Ram": {"4gb"},
  ///   "Storage": {"600mb"},
  ///   "Colour": {"Black", "Grey"}
  /// }
  Map<String, Set<String>> getVariantAttributes() {
    final Map<String, Set<String>> attributeMap = {};
    final variants = product.value?.variants ?? [];

    for (var variant in variants) {
      variant.attributes.forEach((key, value) {
        attributeMap.putIfAbsent(key, () => <String>{});
        attributeMap[key]!.add(value.toString());
      });
    }

    return attributeMap;
  }

  /// 🔁 SELECT VARIANT
  void selectVariant(ProductVariantModel variant) {
    selectedVariant.value = variant;
    quantity.value = 1;
  }

  /// ➕ INCREASE QTY
  void increaseQty() {
    if (quantity.value <
        int.parse(selectedVariant.value?.stock ?? "0")) {
      quantity.value++;
    }
  }

  /// ➖ DECREASE QTY
  void decreaseQty() {
    if (quantity.value > 1) quantity.value--;
  }
}
