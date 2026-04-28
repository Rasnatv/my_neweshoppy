
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

import '../../../data/models/whishlistmodel.dart';
import '../../../widgets/network_trihgiger.dart';
import '../../../data/errors/api_error.dart';
import '../../merchantlogin/widget/successwidget.dart';

class WishlistController extends GetxController {
  final GetStorage box = GetStorage();

  var wishlist = <WishlistItem>[].obs;
  var isLoading = false.obs;

  final String addUrl =
      "https://eshoppy.co.in/api/wishlist/add";
  final String getUrl =
      "https://eshoppy.co.in/api/wishlist/get";
  final String removeUrl =
      "https://eshoppy.co.in/api/wishlist/remove";

  String get token => (box.read<String>("auth_token") ?? "").trim();

  @override
  void onInit() {
    super.onInit();

        fetchWishlist();
  }

  /// ================= FETCH =================
  Future<void> fetchWishlist() async {
    try {
      isLoading(true);

      final response = await http.get(
        Uri.parse(getUrl),
        headers: {
          "Accept": "application/json",
          "Authorization": "Bearer $token",
        },
      );

      debugPrint("📦 Wishlist GET status: ${response.statusCode}");
      debugPrint("📦 Wishlist body: ${response.body}");

      if (response.statusCode == 200) {
        final body = jsonDecode(response.body);

        if (body['status'] == "1" || body['status'] == 1) {
          final List data = body['data'] ?? [];
          wishlist.value = data.map((e) {
            try {
              return WishlistItem.fromJson(e);
            } catch (err) {
              return null;
            }
          }).whereType<WishlistItem>().toList();
        } else {
          wishlist.clear();
        }
      } else {
        final error = ApiErrorHandler.handleResponse(response);
        AppSnackbar.error(error);
      }
    } catch (e) {

      final error = ApiErrorHandler.handleException(e);
      AppSnackbar.error(error);
    } finally {
      isLoading(false);
    }
  }

  /// ================= CHECK =================
  bool isInWishlist(int productId) {
    return wishlist.any((e) => e.productId == productId);
  }

  /// ✅ Get wishlist_id for a given productId (needed for remove API)
  int? getWishlistId(int productId) {
    try {
      return wishlist.firstWhere((e) => e.productId == productId).wishlistId;
    } catch (_) {
      return null;
    }
  }

  /// ================= TOGGLE =================
  /// [type]: 0 = normal product, 1 = offer product
  Future<void> toggleWishlist(int productId, {int type = 0}) async {
    if (isInWishlist(productId)) {
      await removeFromWishlist(productId);
    } else {
      await addToWishlist(productId, type: type);
    }
  }

  /// ================= ADD =================
  Future<void> addToWishlist(int productId, {int type = 0}) async {
    try {
      final response = await http.post(
        Uri.parse(addUrl),
        headers: {
          "Accept": "application/json",
          "Authorization": "Bearer $token",
          "Content-Type": "application/json",
        },
        body: jsonEncode({
          "product_id": productId,
          "type": type, // ✅ 0 for normal, 1 for offer
        }),
      );

      if (response.statusCode == 200) {
        final body = jsonDecode(response.body);

        if (body['status'] == true ||
            body['status'] == "1" ||
            body['status'] == 1) {
          await fetchWishlist();
        }
      } else {
        final error = ApiErrorHandler.handleResponse(response);
        AppSnackbar.error(error);
      }
    } catch (e) {
      final error = ApiErrorHandler.handleException(e);
      AppSnackbar.error(error);
    }
  }
  Future<void> removeFromWishlist(int productId) async {
    final wishlistId = getWishlistId(productId);

    if (wishlistId == null) {

      return;
    }

    try {
      final response = await http.post(
        Uri.parse(removeUrl),
        headers: {
          "Accept": "application/json",
          "Authorization": "Bearer $token",
          "Content-Type": "application/json",
        },
        body: jsonEncode({"wishlist_id": wishlistId}), // ✅ correct field
      );

      if (response.statusCode == 200) {
        final body = jsonDecode(response.body);

        if (body['status'] == "1" ||
            body['status'] == 1 ||
            body['status'] == true) {
          await fetchWishlist();
        }
      } else {
        final error = ApiErrorHandler.handleResponse(response);
        AppSnackbar.error(error);
      }
    } catch (e) {
      debugPrint("❌ removeFromWishlist exception: $e");
      final error = ApiErrorHandler.handleException(e);
      AppSnackbar.error(error);
    }
  }

  /// ================= CLEAR =================
  void clearWishlist() {
    wishlist.clear();
  }
}