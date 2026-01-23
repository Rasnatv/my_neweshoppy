
import 'dart:convert';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import '../../../data/models/user_shopimagemodel.dart';
import '../../../data/models/user_shopproductmodel.dart';


class UserShopProductController extends GetxController {
  final box = GetStorage();

  var isLoading = false.obs;
  var products = <UserShopProductModel>[].obs;

  var isShopLoading = false.obs;
  var shopDetail = Rxn<UserShopDetailModel>();

  final String productApi =
      "https://rasma.astradevelops.in/e_shoppyy/public/api/shop-products";

  final String shopDetailApi =
      "https://rasma.astradevelops.in/e_shoppyy/public/api/shop-details";

  /// Fetch shop info + products
  Future<void> loadShop(int merchantId) async {
    await fetchShopDetails(merchantId);
    await fetchProducts(merchantId);
  }

  /// Fetch shop details
  Future<void> fetchShopDetails(int merchantId) async {
    final token = box.read('auth_token');
    if (token == null) return;

    try {
      isShopLoading.value = true;

      final response = await http.post(
        Uri.parse(shopDetailApi),
        headers: {
          "Accept": "application/json",
          "Authorization": "Bearer $token",
        },
        body: {
          "merchant_id": merchantId.toString(),
        },
      );

      if (response.statusCode == 200) {
        final decoded = json.decode(response.body);
        shopDetail.value =
            UserShopDetailModel.fromJson(decoded['data']);
      }
    } catch (e) {
      shopDetail.value = null;
      print("Shop detail error: $e");
    } finally {
      isShopLoading.value = false;
    }
  }

  /// Fetch products
  Future<void> fetchProducts(int merchantId) async {
    final token = box.read('auth_token');
    if (token == null) return;

    try {
      isLoading.value = true;

      final response = await http.post(
        Uri.parse(productApi),
        headers: {
          "Accept": "application/json",
          "Authorization": "Bearer $token",
        },
        body: {
          "merchant_id": merchantId.toString(),
        },
      );

      if (response.statusCode == 200) {
        final decoded = json.decode(response.body);
        final List list = decoded['data'];
        products.value =
            list.map((e) => UserShopProductModel.fromJson(e)).toList();
      } else {
        products.clear();
      }
    } catch (e) {
      products.clear();
      print("Product fetch error: $e");
    } finally {
      isLoading.value = false;
    }
  }
}
