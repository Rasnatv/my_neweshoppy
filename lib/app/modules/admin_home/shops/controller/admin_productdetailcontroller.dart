
import 'dart:convert';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

import '../../../../data/errors/api_error.dart';
import '../../../../data/models/admin_shopproductdetailsmodel.dart';

import '../../../merchantlogin/widget/successwidget.dart';

class mAdminProductDetailController extends GetxController {
  final GetStorage box = GetStorage();

  final Rx<mAdminProductDetailModel?> productDetailResponse =
  Rx<mAdminProductDetailModel?>(null);

  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;
  final RxInt selectedVariantIndex = 0.obs;

  static const String _baseUrl =
      'https://eshoppy.co.in/api/product/detailss';

  static const String _authTokenKey = 'auth_token';
  static const String authTokenKey = _authTokenKey;

  /// ✅ AUTH CHECK (EMPTY TOKEN)
  // bool _checkAuth() {
  //   final token = box.read(_authTokenKey);
  //
  //   if (token == null || token.toString().isEmpty) {
  //     Get.offAllNamed('/login');
  //     return false;
  //   }
  //   return true;
  // }

  String? get authToken => box.read<String>(_authTokenKey);

  void saveAuthToken(String token) {
    box.write(_authTokenKey, token);
  }

  Map<String, String> _headers() {
    final token = authToken ?? '';
    return {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
      'Accept': 'application/json',
    };
  }

  mProductDetail? get product => productDetailResponse.value?.data;

  mProductVariant? get selectedVariant {
    final variants = product?.variants;
    if (variants == null || variants.isEmpty) return null;

    final index = selectedVariantIndex.value;
    return index < variants.length ? variants[index] : null;
  }

  @override
  void onInit() {
    super.onInit();

    final args = Get.arguments;
    if (args != null && args is Map && args['product_id'] != null) {
      fetchProductDetail(productId: args['product_id']);
    }
  }

  /// ✅ FETCH PRODUCT (WITH 401 AUTO LOGOUT)
  Future<void> fetchProductDetail({required int productId}) async {

    try {
      isLoading.value = true;
      errorMessage.value = '';

      final response = await http.post(
        Uri.parse(_baseUrl),
        headers: _headers(),
        body: jsonEncode({'product_id': productId}),
      );

      /// 🔥 IMPORTANT FIX
      if (response.statusCode == 401) {
        ApiErrorHandler.handleResponse(response); // triggers logout
        return;
      }

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body) as Map<String, dynamic>;
        final model = mAdminProductDetailModel.fromJson(json);

        if (model.status) {
          productDetailResponse.value = model;
          selectedVariantIndex.value = 0;
        } else {
          errorMessage.value = model.message;
          AppSnackbar.error(errorMessage.value);
        }
      } else {
        errorMessage.value =
            ApiErrorHandler.handleResponse(response);
        AppSnackbar.error(errorMessage.value);
      }
    } catch (e) {
      errorMessage.value =
          ApiErrorHandler.handleException(e);
      AppSnackbar.error(errorMessage.value);
    } finally {
      isLoading.value = false;
    }
  }

  void selectVariant(int index) {
    selectedVariantIndex.value = index;
  }

  void clearProductDetail() {
    productDetailResponse.value = null;
    errorMessage.value = '';
    selectedVariantIndex.value = 0;
  }
}