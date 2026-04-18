
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
  // ✅ Use the same singleton instance, not a new one
  final GetStorage box = GetStorage();

  var wishlist = <WishlistItem>[].obs;
  var isLoading = false.obs;

  final String addUrl =
      "https://rasma.astradevelops.in/e_shoppyy/public/api/wishlist/add";
  final String getUrl =
      "https://rasma.astradevelops.in/e_shoppyy/public/api/wishlist/get";
  final String removeUrl =
      "https://rasma.astradevelops.in/e_shoppyy/public/api/wishlist/remove";

  // ✅ Trim token to avoid whitespace issues
  String get token => (box.read<String>("auth_token") ?? "").trim();

  @override
  void onInit() {
    super.onInit();

    ever(Get.find<NetworkService>().reconnectTrigger, (isOnline) {
      if (isOnline == true && token.isNotEmpty) {
        fetchWishlist();
      }
    });

    if (token.isNotEmpty) {
      fetchWishlist();
    } else {
      debugPrint("⚠️ WishlistController: No auth token found");
    }
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
          // ✅ Wrap each fromJson in try-catch to skip bad items
          wishlist.value = data.map((e) {
            try {
              return WishlistItem.fromJson(e);
            } catch (err) {
              debugPrint("❌ Failed to parse wishlist item: $e → $err");
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
      debugPrint("❌ fetchWishlist exception: $e");
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

  /// ================= TOGGLE =================
  Future<void> toggleWishlist(int productId) async {
    if (isInWishlist(productId)) {
      await removeFromWishlist(productId);
    } else {
      await addToWishlist(productId);
    }
  }

  /// ================= ADD =================
  Future<void> addToWishlist(int productId) async {

    try {
      final response = await http.post(
        Uri.parse(addUrl),
        headers: {
          "Accept": "application/json",
          "Authorization": "Bearer $token",
          "Content-Type": "application/json",
        },
        body: jsonEncode({"product_id": productId}),
      );

      debugPrint("➕ Add wishlist status: ${response.statusCode}");
      debugPrint("➕ Add wishlist body: ${response.body}");

      if (response.statusCode == 200) {
        final body = jsonDecode(response.body);

        // ✅ API returns status as String "1", not bool
        if (body['status'] == "1" || body['status'] == 1) {
          AppSnackbar.success(body['message'] ?? "Added to wishlist");
          await fetchWishlist();
        } else {
          AppSnackbar.warning(body['message'] ?? "Failed to add");
        }
      } else {
        final error = ApiErrorHandler.handleResponse(response);
        AppSnackbar.error(error);
      }
    } catch (e) {
      debugPrint("❌ addToWishlist exception: $e");
      final error = ApiErrorHandler.handleException(e);
      AppSnackbar.error(error);
    }
  }

  /// ================= REMOVE =================
  Future<void> removeFromWishlist(int productId) async {
    try {
      final response = await http.post(
        Uri.parse(removeUrl),
        headers: {
          "Accept": "application/json",
          "Authorization": "Bearer $token",
          "Content-Type": "application/json",
        },
        body: jsonEncode({"product_id": productId}),
      );

      debugPrint("🗑 Remove wishlist status: ${response.statusCode}");

      if (response.statusCode == 200) {
        final body = jsonDecode(response.body);

        if (body['status'] == "1" || body['status'] == 1) {
          AppSnackbar.success(body['message'] ?? "Removed from wishlist");
          await fetchWishlist();
        } else {
          AppSnackbar.warning(body['message'] ?? "Failed to remove");
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