
import 'dart:convert';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

import '../../../data/errors/api_error.dart';
import '../../../data/models/merchant_offerproductviewmodel.dart';
import '../../merchantlogin/widget/successwidget.dart';

class MerchantOfferProductController extends GetxController {
  final int offerId;

  MerchantOfferProductController({required this.offerId});

  final offerProducts = <NMerchantOfferProductModels>[].obs;
  final isLoading = false.obs;
  final isDeleting = false.obs;
  final isRefreshing = false.obs;

  final box = GetStorage();

  static const String _base =
      "https://eshoppy.co.in/api";

  String get _token => box.read("auth_token") ?? "";

  Map<String, String> get _headers => {
    "Accept": "application/json",
    "Authorization": "Bearer $_token",
    "Content-Type": "application/json",
  };

  @override
  void onInit() {
    super.onInit();
    fetchOfferProduct();
  }

  // ================= FETCH =================
  Future<void> fetchOfferProduct() async {


    isLoading.value = true;
    offerProducts.clear();

    try {
      final response = await http.post(
        Uri.parse("$_base/view-offer-product"),
        headers: _headers,
        body: jsonEncode({"offer_id": offerId}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        final status = data['status'];

        if (status == 1 || status == '1' || status == true) {
          final raw = data['data'];

          if (raw is List) {
            offerProducts.value = raw
                .map((e) => NMerchantOfferProductModels.fromJson(
                e as Map<String, dynamic>))
                .toList();
          } else if (raw is Map) {
            offerProducts.value = [
              NMerchantOfferProductModels.fromJson(
                  raw as Map<String, dynamic>)
            ];
          }
        } else {
          AppSnackbar.error(data['message'] ?? "Failed to load products");
        }
      } else {
        AppSnackbar.error(ApiErrorHandler.handleResponse(response));
      }
    } catch (e) {
      AppSnackbar.error(ApiErrorHandler.handleException(e));
    } finally {
      isLoading.value = false;
    }
  }

  // ================= SILENT REFRESH =================
  Future<void> silentRefresh() async {
    if (_token.isEmpty) return;

    isRefreshing.value = true;

    try {
      final response = await http.post(
        Uri.parse("$_base/view-offer-product"),
        headers: _headers,
        body: jsonEncode({"offer_id": offerId}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        final status = data['status'];

        if (status == 1 || status == '1' || status == true) {
          final raw = data['data'];

          if (raw is List) {
            offerProducts.value = raw
                .map((e) => NMerchantOfferProductModels.fromJson(
                e as Map<String, dynamic>))
                .toList();
          } else if (raw is Map) {
            offerProducts.value = [
              NMerchantOfferProductModels.fromJson(
                  raw as Map<String, dynamic>)
            ];
          }
        }
      }
    } catch (_) {
      // silent — no error snackbar
    } finally {
      isRefreshing.value = false;
    }
  }

  // ================= PATCH LOCALLY =================
  // ✅ Instantly updates the card UI before silentRefresh completes
  void patchProductLocally(int productId, Map<String, dynamic> changes) {
    final index = offerProducts.indexWhere((p) => p.productId == productId);
    if (index == -1) return;

    final old = offerProducts[index];

    // Recalculate discount percentage if prices changed
    final newReal =
        (changes['real_price'] as double?) ?? old.realPrice;
    final newOffer =
        (changes['offer_price'] as double?) ?? old.offerPrice;
    final newDiscount = newReal > 0
        ? ((newReal - newOffer) / newReal * 100)
        : old.discountPercentage;

    offerProducts[index] = NMerchantOfferProductModels(
      productId: old.productId,
      productName:
      (changes['product_name'] as String?) ?? old.productName,
      productImage:
      (changes['product_image'] as String?) ?? old.productImage,
      discountPercentage: newDiscount,
      realPrice: newReal,
      offerPrice: newOffer,
    );

    // ✅ Force Obx to rebuild the card immediately
    offerProducts.refresh();
  }

  // ================= DELETE =================
  Future<void> deleteOfferProduct(int productId) async {
    if (_token.isEmpty) {
      AppSnackbar.error("Session expired. Please login again");
      return;
    }

    isDeleting.value = true;

    try {
      final response = await http.delete(
        Uri.parse("$_base/delete-offer-product"),
        headers: _headers,
        body: jsonEncode({
          "offer_product_id": productId,
        }),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        final status = data['status'];

        if (status == 1 || status == '1' || status == true) {
          offerProducts.removeWhere((p) => p.productId == productId);
          AppSnackbar.success(
              data['message'] ?? "Product removed successfully");
        } else {
          AppSnackbar.error(data['message'] ?? "Failed to delete product");
        }
      } else {
        AppSnackbar.error(ApiErrorHandler.handleResponse(response));
      }
    } catch (e) {
      AppSnackbar.error(ApiErrorHandler.handleException(e));
    } finally {
      isDeleting.value = false;
    }
  }
}