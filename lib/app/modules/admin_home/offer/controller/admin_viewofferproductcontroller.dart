// import 'dart:convert';
// import 'package:get/get.dart';
// import 'package:get_storage/get_storage.dart';
// import 'package:http/http.dart' as http;
// import '../../../../data/models/adminofferproductmodel.dart';
//
// class AdminOfferProductController extends GetxController {
//   // ── State ────────────────────────────────────────────────
//   final RxList<AdminOfferProductModel> products = <AdminOfferProductModel>[].obs;
//   final RxBool isLoading     = false.obs;
//   final RxBool hasError      = false.obs;
//   final RxString errorMessage = ''.obs;
//
//   late final int offerId;
//
//   final _box = GetStorage();
//
//   // ── Lifecycle ─────────────────────────────────────────────
//   @override
//   void onInit() {
//     super.onInit();
//     offerId = (Get.arguments is int)
//         ? Get.arguments as int
//         : int.tryParse(Get.arguments.toString()) ?? 0;
//     fetchProducts();
//   }
//
//   // ── API ───────────────────────────────────────────────────
//   Future<void> fetchProducts() async {
//     try {
//       isLoading.value    = true;
//       hasError.value     = false;
//       errorMessage.value = '';
//
//       // ✅ Read token from GetStorage — same place your login saves it
//       final token = _box.read<String>('auth_token') ?? '';
//
//       final response = await http.post(
//         Uri.parse(
//           'https://rasma.astradevelops.in/e_shoppyy/public/api/offer-products',
//         ),
//         headers: {
//           'Content-Type': 'application/json',
//           'Accept': 'application/json',
//           'Authorization': 'Bearer $token',
//         },
//         body: jsonEncode({'offer_id': offerId}),
//       );
//
//       if (response.statusCode == 200) {
//         final decoded = jsonDecode(response.body);
//
//         List<dynamic> rawList;
//
//         if (decoded is List) {
//           rawList = decoded;
//         } else if (decoded is Map && decoded.containsKey('data')) {
//           rawList = decoded['data'] as List<dynamic>;
//         } else if (decoded is Map && decoded.containsKey('products')) {
//           rawList = decoded['products'] as List<dynamic>;
//         } else {
//           rawList = [];
//         }
//
//         products.value = rawList
//             .map((e) => AdminOfferProductModel.fromJson(e as Map<String, dynamic>))
//             .toList();
//       } else {
//         _setError('Server error: ${response.statusCode}');
//       }
//     } catch (e) {
//       _setError('Something went wrong. Please try again.');
//     } finally {
//       isLoading.value = false;
//     }
//   }
//
//   Future<void> refreshProducts() async => fetchProducts();
//
//   void _setError(String message) {
//     hasError.value     = true;
//     errorMessage.value = message;
//   }
// }
import 'dart:convert';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

import '../../../../data/errors/api_error.dart';
import '../../../../data/models/adminofferproductmodel.dart';

import '../../../merchantlogin/widget/successwidget.dart';

class AdminOfferProductController extends GetxController {
  // ── State ────────────────────────────────────────────────
  final RxList<AdminOfferProductModel> products =
      <AdminOfferProductModel>[].obs;
  final RxBool isLoading = false.obs;
  final RxBool hasError = false.obs;
  final RxString errorMessage = ''.obs;

  late final int offerId;

  final _box = GetStorage();

  // ── AUTH CHECK ───────────────────────────────────────────
  bool _checkAuth() {
    final token = _box.read('auth_token');

    if (token == null || token.toString().isEmpty) {
      Get.offAllNamed('/login');
      return false;
    }
    return true;
  }

  Map<String, String> _headers() {
    final token = _box.read<String>('auth_token') ?? '';
    return {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    };
  }

  // ── Lifecycle ─────────────────────────────────────────────
  @override
  void onInit() {
    super.onInit();
    offerId = (Get.arguments is int)
        ? Get.arguments as int
        : int.tryParse(Get.arguments.toString()) ?? 0;

    fetchProducts();
  }

  // ── API ───────────────────────────────────────────────────
  Future<void> fetchProducts() async {
    if (!_checkAuth()) return;

    try {
      isLoading.value = true;
      hasError.value = false;
      errorMessage.value = '';

      final response = await http.post(
        Uri.parse(
          'https://rasma.astradevelops.in/e_shoppyy/public/api/offer-products',
        ),
        headers: _headers(),
        body: jsonEncode({'offer_id': offerId}),
      );

      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);

        List<dynamic> rawList;

        // ✅ KEEP YOUR FLEXIBLE PARSING
        if (decoded is List) {
          rawList = decoded;
        } else if (decoded is Map && decoded.containsKey('data')) {
          rawList = decoded['data'] as List<dynamic>;
        } else if (decoded is Map && decoded.containsKey('products')) {
          rawList = decoded['products'] as List<dynamic>;
        } else {
          rawList = [];
        }

        products.value = rawList
            .map((e) => AdminOfferProductModel.fromJson(
            e as Map<String, dynamic>))
            .toList();
      } else {
        _setError(ApiErrorHandler.handleResponse(response));
        AppSnackbar.error(errorMessage.value);
      }
    } catch (e) {
      _setError(ApiErrorHandler.handleException(e));
      AppSnackbar.error(errorMessage.value);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> refreshProducts() async => fetchProducts();

  // ── ERROR HANDLER ─────────────────────────────────────────
  void _setError(String message) {
    hasError.value = true;
    errorMessage.value = message;
  }
}