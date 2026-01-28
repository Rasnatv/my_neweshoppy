import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import '../../../data/models/whishlistmodel.dart';


class WishlistController extends GetxController {
  final GetStorage box = GetStorage();

  var wishlist = <WishlistItem>[].obs;
  var isLoading = false.obs;

  final String addUrl =
      "https://rasma.astradevelops.in/e_shoppyy/public/api/wishlist/add";
  final String getUrl =
      "https://rasma.astradevelops.in/e_shoppyy/public/api/wishlist/get";
  final String removeUrl =
      "https://rasma.astradevelops.in/e_shoppyy/public/api/wishlist/remove";

  /// ✅ Get token EXACTLY like login flow
  String get token => box.read("auth_token") ?? "";

  @override
  void onInit() {
    super.onInit();
    if (token.isNotEmpty) {
      fetchWishlist();
    }
  }

  /// 🔹 Fetch Wishlist
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

      final body = jsonDecode(response.body);

      if (body['status'] == "1") {
        wishlist.value = (body['data'] as List)
            .map((e) => WishlistItem.fromJson(e))
            .toList();
      }
    } catch (e) {
      debugPrint("Fetch wishlist error: $e");
    } finally {
      isLoading(false);
    }
  }

  /// 🔹 Check product exists
  bool isInWishlist(int productId) {
    return wishlist.any((e) => e.productId == productId);
  }

  /// 🔹 Toggle wishlist
  Future<void> toggleWishlist(int productId) async {
    if (isInWishlist(productId)) {
      await removeFromWishlist(productId);
    } else {
      await addToWishlist(productId);
    }
  }

  /// 🔹 Add
  Future<void> addToWishlist(int productId) async {
    await http.post(
      Uri.parse(addUrl),
      headers: {
        "Accept": "application/json",
        "Authorization": "Bearer $token",
        "Content-Type": "application/json",
      },
      body: jsonEncode({"product_id": productId}),
    );
    fetchWishlist();
  }

  /// 🔹 Remove
  Future<void> removeFromWishlist(int productId) async {
    await http.post(
      Uri.parse(removeUrl),
      headers: {
        "Accept": "application/json",
        "Authorization": "Bearer $token",
        "Content-Type": "application/json",
      },
      body: jsonEncode({"product_id": productId}),
    );
    fetchWishlist();
  }

  /// 🔹 Clear on logout
  void clearWishlist() {
    wishlist.clear();
  }
}
