
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
      'https://rasma.astradevelops.in/e_shoppyy/public/api/offer-product-details';
  static const String _updateUrl =
      'https://rasma.astradevelops.in/e_shoppyy/public/api/update-offer-product';

  var isLoading = false.obs;
  var isSubmitting = false.obs;
  var errorMessage = ''.obs;

  var offerProductId = 0.obs;
  var productData = Rx<MOfferProductDetail?>(null);

  var productName = ''.obs;
  var description = ''.obs;
  var commonAttributes = <String, String>{}.obs;
  var variants = <MOfferVariant>[].obs;

  final ImagePicker _picker = ImagePicker();

  String get _token => box.read<String>('auth_token') ?? '';

  Map<String, String> get _headers =>
      {
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
          variants.assignAll(detail.variants);
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
      variants.refresh();
    }
  }

  // ================= UPDATE FIELDS =================
  void updateCommonAttribute(String key, String value) {
    commonAttributes[key] = value;
  }

  void updateVariantPrice(int index, double price) {
    variants[index].price = price;
  }

  void updateVariantStock(int index, int stock) {
    variants[index].stock = stock;
  }

  // ================= VALIDATION =================
  bool _validate() {
    if (productName.value
        .trim()
        .isEmpty) {
      AppSnackbar.warning('Product name is required');
      return false;
    }

    if (description.value
        .trim()
        .isEmpty) {
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
          'attributes': v.attributes,
          'price': v.price,
          'stock': v.stock,
        };

        if (v.imageUpdated && v.imagePath.isNotEmpty) {
          if (!v.imagePath.startsWith('http')) {
            final bytes = await File(v.imagePath).readAsBytes();
            final ext = v.imagePath
                .split('.')
                .last
                .toLowerCase();
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
        'product_attributes': {
          'common_attributes': commonAttributes,
          'variants': variantsPayload,
        },
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

          // ✅ Find the parent controller and await refresh BEFORE going back
          try {
            final args = Get.arguments;
            final offerIdTag = args?['offer_id']
                ?.toString(); // pass offer_id in args

            if (offerIdTag != null) {
              final parentController = Get.find<MerchantOfferProductController>(
                tag: offerIdTag,
              );
              await parentController.fetchOfferProduct(); // await full refresh
            }
          } catch (_) {
            // controller not found — fallback, result: true will handle it
          }

          Get.back(result: true);
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
}