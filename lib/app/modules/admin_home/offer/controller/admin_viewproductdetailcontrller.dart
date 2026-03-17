
import 'dart:convert';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

import '../../../../data/models/admin_productdetailmodel.dart';

class AdminSingleOfferProductController extends GetxController {
  final Rx<AdminSingleOfferProductModel?> product =
  Rx<AdminSingleOfferProductModel?>(null);
  final RxBool isLoading       = false.obs;
  final RxBool hasError        = false.obs;
  final RxString errorMessage  = ''.obs;
  final RxInt currentImageIndex   = 0.obs;
  final RxInt selectedVariantIndex = 0.obs;

  late final int offerProductId;
  final _box = GetStorage();

  @override
  void onInit() {
    super.onInit();
    offerProductId = (Get.arguments is int)
        ? Get.arguments as int
        : int.tryParse(Get.arguments.toString()) ?? 0;
    fetchProductDetail();
  }

  Future<void> fetchProductDetail() async {
    try {
      isLoading.value          = true;
      hasError.value           = false;
      errorMessage.value       = '';
      currentImageIndex.value    = 0;
      selectedVariantIndex.value = 0;

      final token = _box.read<String>('auth_token') ?? '';

      final response = await http.post(
        Uri.parse(
          'https://rasma.astradevelops.in/e_shoppyy/public/api/single-offer-product',
        ),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({'offer_product_id': offerProductId}),
      );

      if (response.statusCode == 200) {
        final decoded =
        jsonDecode(response.body) as Map<String, dynamic>;
        if (decoded['status'] == 1 && decoded['data'] != null) {
          product.value = AdminSingleOfferProductModel.fromJson(
            decoded['data'] as Map<String, dynamic>,
          );
        } else {
          _setError(decoded['message']?.toString() ??
              'Failed to load product.');
        }
      } else {
        _setError('Server error: ${response.statusCode}');
      }
    } catch (e) {
      _setError('Something went wrong. Please try again.');
    } finally {
      isLoading.value = false;
    }
  }

  // ── Select variant → updates price card + image carousel ───
  void selectVariant(int index) {
    selectedVariantIndex.value = index;
    currentImageIndex.value    = index;
  }

  // ── Currently selected variant ─────────────────────────────
  ProductVariant? get selectedVariant {
    final variants =
        product.value?.productAttributes?.variants ?? [];
    if (variants.isEmpty) return null;
    final idx = selectedVariantIndex.value;
    return idx < variants.length ? variants[idx] : variants.first;
  }

  Future<void> refreshProduct() async => fetchProductDetail();

  void _setError(String message) {
    hasError.value     = true;
    errorMessage.value = message;
  }
}