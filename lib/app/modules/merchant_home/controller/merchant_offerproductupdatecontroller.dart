
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

import '../../../data/models/offer_productdetailmodel.dart';
import '../../../data/errors/api_error.dart';
import '../../merchantlogin/widget/successwidget.dart';
import 'merchant_offerproduct_view_controller.dart';

class OfferProductDetailController extends GetxController {
  final box = GetStorage();

  static const String _detailUrl =
      'https://eshoppy.co.in/api/offer-product-details';
  static const String _updateUrl =
      'https://eshoppy.co.in/api/update-offer-product';

  var isLoading = false.obs;
  var isSubmitting = false.obs;
  var errorMessage = ''.obs;

  var offerProductId = 0.obs;
  var productData = Rx<MOfferProductDetail?>(null);

  var productName = ''.obs;
  var description = ''.obs;
  var commonAttributes = <String, String>{}.obs;
  var variants = <MOfferVariant>[].obs;
  var discountPercentage = 0.obs;

  // ── Lightweight tick so ONLY the offer-price badge Obx rebuilds
  // when a price changes — does NOT trigger a full card rebuild.
  final _priceTick = 0.obs;

  // ── Display variant tracking ───────────────────────────────────
  int? _displayVariantId;
  double _originalDisplayPrice = 0.0;
  String _originalDisplayImage = '';

  double? computeOfferPrice(double price) {
    if (discountPercentage.value <= 0) return null;
    return price - (price * discountPercentage.value / 100);
  }

  final ImagePicker _picker = ImagePicker();

  String get _token => box.read<String>('auth_token') ?? '';

  Map<String, String> get _headers => {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
    'Authorization': 'Bearer $_token',
  };

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments;
    if (args != null && args['offer_product_id'] != null) {
      offerProductId.value = args['offer_product_id'];
      fetchProductDetail();
    }
  }

  // ================= FETCH =================
  Future<void> fetchProductDetail() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final response = await http.post(
        Uri.parse(_detailUrl),
        headers: _headers,
        body: jsonEncode({'product_id': offerProductId.value}),
      );

      if (response.statusCode == 200) {
        final body = jsonDecode(response.body);

        if (body['status'] == 1 || body['status'] == true) {
          final detail = MOfferProductDetail.fromJson(body['data']);
          productData.value = detail;

          productName.value = detail.productName;
          description.value = detail.description;
          commonAttributes.assignAll(detail.commonAttributes);
          discountPercentage.value = detail.discountPercentage;
          variants.assignAll(
            detail.variants.map((v) => MOfferVariant(
              variantId: v.variantId,
              attributes: Map.from(v.attributes),
              price: v.price,
              stock: v.stock,
              imagePath: v.imagePath,
              finalPrice: v.finalPrice,
            )),
          );

          // Snapshot the DISPLAY variant (variant[0] matches the card).
          if (variants.isNotEmpty) {
            _displayVariantId = variants[0].variantId;
            _originalDisplayPrice = variants[0].price;
            _originalDisplayImage = variants[0].imagePath;
          }
        } else {
          errorMessage.value =
              body['message'] ?? 'Failed to fetch product details';
          AppSnackbar.warning(errorMessage.value);
        }
      } else {
        final error = ApiErrorHandler.handleResponse(response);
        errorMessage.value = error;
        AppSnackbar.error(error);
      }
    } catch (e) {
      final error = ApiErrorHandler.handleException(e);
      errorMessage.value = error;
      AppSnackbar.error(error);
    } finally {
      isLoading.value = false;
    }
  }

  // ================= IMAGE PICK =================
  Future<void> pickImage(int index) async {
    if (index < 0 || index >= variants.length) return;

    final picked = await _picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 1920,
      maxHeight: 1920,
      imageQuality: 85,
    );

    if (picked != null) {
      variants[index].imagePath = picked.path;
      variants[index].imageUpdated = true;
      // ✅ variants.refresh() is safe here — image picker is a one-off
      // action, not called on every keystroke, so no cascade problem.
      variants.refresh();
    }
  }

  // ================= UPDATE FIELDS =================
  void updateCommonAttribute(String key, String value) {
    commonAttributes[key] = value;
  }

  // ✅ FIX: No variants.refresh() here.
  // variants.refresh() triggers a full Obx rebuild of _buildVariantsSection,
  // which re-runs _buildVariantCard for every index. Inside each card,
  // _priceCtrl(index, variant) uses putIfAbsent — it returns the already-
  // created (stale) TextEditingController whose .text no longer matches
  // variants[index].price in memory, causing visual desync on ALL cards
  // whenever ANY card's price is edited.
  //
  // Instead we increment _priceTick, which ONLY the offer-badge Obx
  // widgets subscribe to — they rebuild in isolation without touching
  // the text field controllers at all.
  void updateVariantPrice(int index, double price) {
    if (index < 0 || index >= variants.length) return;
    variants[index].price = price;
    _priceTick.value++; // ✅ Only badge Obx widgets re-render
  }

  void updateVariantStock(int index, int stock) {
    if (index < 0 || index >= variants.length) return;
    variants[index].stock = stock;
  }

  // ── Expose tick for the badge Obx in the page ─────────────────
  int get priceTick => _priceTick.value;

  // ================= VALIDATION =================
  bool _validate() {
    if (productName.value.trim().isEmpty) {
      AppSnackbar.warning('Product name is required');
      return false;
    }
    if (description.value.trim().isEmpty) {
      AppSnackbar.warning('Description is required');
      return false;
    }
    for (int i = 0; i < variants.length; i++) {
      if (variants[i].price <= 0) {
        AppSnackbar.warning('Variant ${i + 1}: valid price required');
        return false;
      }
      if (variants[i].stock < 0) {
        AppSnackbar.warning('Variant ${i + 1}: valid stock required');
        return false;
      }
    }
    return true;
  }

  // ================= UPDATE PRODUCT =================
  Future<void> updateProduct() async {
    if (!_validate()) return;

    try {
      isSubmitting.value = true;

      List<Map<String, dynamic>> variantsPayload = [];

      for (final v in variants) {
        final Map<String, dynamic> item = {
          if (v.variantId != null) 'variant_id': v.variantId,
          'attributes': v.attributes,
          'price': v.price,
          'stock': v.stock,
        };

        if (v.imageUpdated && v.imagePath.isNotEmpty) {
          if (!v.imagePath.startsWith('http')) {
            final bytes = await File(v.imagePath).readAsBytes();
            final ext = v.imagePath.split('.').last.toLowerCase();
            final mime = ext == 'png' ? 'image/png' : 'image/jpeg';
            item['image'] = 'data:$mime;base64,${base64Encode(bytes)}';
          }
        }

        variantsPayload.add(item);
      }

      final payload = {
        'offer_product_id': offerProductId.value,
        'product_name': productName.value.trim(),
        'description': description.value.trim(),
        'common_attributes': commonAttributes,
        'variants': variantsPayload,
      };

      final response = await http.put(
        Uri.parse(_updateUrl),
        headers: _headers,
        body: jsonEncode(payload),
      );

      if (response.statusCode == 200) {
        final body = jsonDecode(response.body);
        if (body['status'] == 1 || body['status'] == true) {
          AppSnackbar.success(
              body['message'] ?? 'Product updated successfully');
          _patchParentController();
          Get.back();
        } else {
          AppSnackbar.warning(body['message'] ?? 'Update failed');
        }
      } else {
        final error = ApiErrorHandler.handleResponse(response);
        AppSnackbar.error(error);
      }
    } catch (e) {
      final error = ApiErrorHandler.handleException(e);
      AppSnackbar.error(error);
    } finally {
      isSubmitting.value = false;
    }
  }

  void _patchParentController() {
    try {
      final args = Get.arguments;
      final offerIdTag = args?['offer_id']?.toString();
      if (offerIdTag == null) return;

      final parent =
      Get.find<MerchantOfferProductController>(tag: offerIdTag);

      // ✅ STEP 1: Find EXACT display variant
      final displayVariant = variants.firstWhereOrNull(
            (v) => v.variantId == _displayVariantId,
      );

      // ❌ NO FALLBACK — STOP HERE
      if (displayVariant == null) {
        parent.silentRefresh();
        return;
      }

      // ✅ STEP 2: STRICT CHECK — was THIS variant modified?
      final bool isDisplayVariantEdited =
          displayVariant.price != _originalDisplayPrice ||
              displayVariant.imagePath != _originalDisplayImage;

      // ❌ IMPORTANT: if display variant NOT touched → DO NOTHING
      if (!isDisplayVariantEdited) {
        parent.silentRefresh();
        return;
      }

      final Map<String, dynamic> patchData = {};

      // ✅ STEP 3: PATCH ONLY DISPLAY VARIANT CHANGES
      if ((displayVariant.price - _originalDisplayPrice).abs() > 0.01) {
        patchData['real_price'] = displayVariant.price;
        patchData['offer_price'] =
            computeOfferPrice(displayVariant.price) ?? displayVariant.price;
      }

      if (displayVariant.imageUpdated &&
          displayVariant.imagePath != _originalDisplayImage) {
        patchData['product_image'] = displayVariant.imagePath;
      }

      if (patchData.isNotEmpty) {
        parent.patchProductLocally(offerProductId.value, patchData);
      }

      parent.silentRefresh();
    } catch (_) {}
  }
}