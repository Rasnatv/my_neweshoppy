
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

import '../../../data/errors/api_error.dart';
import '../../../data/models/userofferproductmodel.dart';
import '../../merchantlogin/widget/successwidget.dart';
import '../../product/controller/whishlistcontroller.dart';

class UserOfferProductController extends GetxController {
  final String offer_id;

  UserOfferProductController(this.offer_id);

  var isLoading = false.obs;
  var productList = <UserOfferProductModel>[].obs;
  var errorMessage = ''.obs;

  final box = GetStorage();

  // ── Mirror WishlistController's token pattern ──────────────────
  String get token => (box.read<String>('auth_token') ?? '').trim();
  bool get _hasToken => token.isNotEmpty;

  late final WishlistController wishlistController;

  @override
  void onInit() {
    super.onInit();
    wishlistController = Get.isRegistered<WishlistController>()
        ? Get.find<WishlistController>()
        : Get.put(WishlistController());

    fetchOfferProducts();
  }

  Future<void> fetchOfferProducts() async {
    try {
      isLoading(true);
      errorMessage('');

      // ── Build headers — omit Authorization entirely for guests ──
      final headers = <String, String>{
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        if (_hasToken) 'Authorization': 'Bearer $token',
      };

      debugPrint('🛍️ fetchOfferProducts — hasToken: $_hasToken');

      final response = await http.post(
        Uri.parse('https://eshoppy.co.in/api/merchant/offer-products'),
        headers: headers,
        body: jsonEncode({'offer_id': offer_id.toString()}),
      );

      debugPrint('🛍️ offer-products status: ${response.statusCode}');
      debugPrint('🛍️ offer-products body: ${response.body}');

      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);

        if (decoded['status'] == 1 ||
            decoded['status'] == '1' ||
            decoded['status'] == true) {
          final List data = decoded['data'] ?? [];
          productList.value = data
              .map((e) {
            try {
              return UserOfferProductModel.fromJson(e);
            } catch (err) {
              debugPrint('❌ UserOfferProductModel parse error: $err');
              return null;
            }
          })
              .whereType<UserOfferProductModel>()
              .toList();
        } else {
          errorMessage(decoded['message'] ?? 'Something went wrong');
          AppSnackbar.error(errorMessage.value);
        }
      } else {
        errorMessage(ApiErrorHandler.handleResponse(response));
        AppSnackbar.error(errorMessage.value);
      }
    } catch (e) {
      debugPrint('❌ fetchOfferProducts exception: $e');
      errorMessage(ApiErrorHandler.handleException(e));
      AppSnackbar.error(errorMessage.value);
    } finally {
      isLoading(false);
    }
  }
}

