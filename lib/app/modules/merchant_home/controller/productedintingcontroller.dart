
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import '../../../data/errors/api_error.dart';
import '../../../data/models/merchnatupdateproductmodel.dart'; // adjust path
import '../../merchantlogin/widget/successwidget.dart';
import 'manageproduct_controller.dart';

class merchantProductDetailController extends GetxController {
  final box = GetStorage();
  final _picker = ImagePicker();

  // ── Observables ──────────────────────────────────────────────────────────────
  final isLoading = false.obs;
  final isUpdating = false.obs;
  final product = Rxn<ProductModel>();

  // ── Form controllers for basic fields ────────────────────────────────────────
  final nameCtrl = TextEditingController();
  final descCtrl = TextEditingController();

  // ── Common-attribute controllers (key → TextEditingController) ───────────────
  final RxMap<String, TextEditingController> attrCtrls =
      <String, TextEditingController>{}.obs;

  // ── Variant list ──────────────────────────────────────────────────────────────
  final RxList<VariantForm> variantForms = <VariantForm>[].obs;

  // ── API base ──────────────────────────────────────────────────────────────────
  static const _base = 'https://rasma.astradevelops.in/e_shoppyy/public/api';

  // ─────────────────────────────────────────────────────────────────────────────
  @override
  void onInit() {
    super.onInit();
    final int? productId = _resolveProductId(Get.arguments);
    if (productId != null) fetchProduct(productId);
  }

  @override
  void onClose() {
    nameCtrl.dispose();
    descCtrl.dispose();
    for (final c in attrCtrls.values) c.dispose();
    for (final v in variantForms) v.dispose();
    super.onClose();
  }

  // ── Resolve product_id ────────────────────────────────────────────────────────
  int? _resolveProductId(dynamic args) {
    if (args == null) return null;
    if (args is int) return args;
    if (args is Map) return int.tryParse(args['product_id']?.toString() ?? '');
    try {
      return (args as dynamic).productId as int?;
    } catch (_) {
      return null;
    }
  }

  // ── Helpers ───────────────────────────────────────────────────────────────────
  String get _token => box.read('auth_token') ?? '';

  Map<String, String> get _headers => {
    'Content-Type': 'application/json',
    'Authorization': 'Bearer $_token',
  };
  Future<void> fetchProduct(int productId) async {
    try {
      isLoading(true);
      final resp = await http.post(
        Uri.parse('$_base/product/details'),
        headers: _headers,
        body: jsonEncode({'product_id': productId}),
      );

      if (resp.statusCode != 200) {
        AppSnackbar.error(ApiErrorHandler.handleResponse(resp));
        return;
      }

      final json = jsonDecode(resp.body) as Map<String, dynamic>;

      if (json['status'] == true) {
        // ── FIX: handle both List and Map from API ──
        final rawData = json['data'];
        final Map<String, dynamic> productMap = rawData is List
            ? rawData.first as Map<String, dynamic>
            : rawData as Map<String, dynamic>;

        final p = ProductModel.fromJson(productMap);
        product(p);
        _populateForms(p);
      } else {
        AppSnackbar.error(json['message'] ?? 'Failed to load product');
      }
    } catch (e) {
      AppSnackbar.error(ApiErrorHandler.handleException(e));
    } finally {
      isLoading(false);
    }
  }

  // ── Populate forms ────────────────────────────────────────────────────────────
  void _populateForms(ProductModel p) {
    nameCtrl.text = p.name;
    descCtrl.text = p.description;

    for (final c in attrCtrls.values) c.dispose();
    attrCtrls.clear();
    p.commonAttributes.forEach((key, value) {
      attrCtrls[key] = TextEditingController(text: value.toString());
    });

    for (final v in variantForms) v.dispose();
    variantForms.clear();
    for (final v in p.variants) {
      variantForms.add(VariantForm.fromVariant(v));
    }
  }

  // ── Image picker for a variant ────────────────────────────────────────────────
  Future<void> pickVariantImage(int variantIndex) async {
    try {
      final picked = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 80,
        maxWidth: 800,
      );
      if (picked != null) {
        variantForms[variantIndex].pickedImage.value = File(picked.path);
      }
    } catch (e) {
      AppSnackbar.error('Could not pick image: $e');
    }
  }

  // ── Update product ────────────────────────────────────────────────────────────
  Future<void> updateProduct() async {
    final p = product.value;
    if (p == null) return;

    // Build variants payload (include base64 image only if new image picked)
    final List<Map<String, dynamic>> variantsPayload = [];
    for (final vf in variantForms) {
      final map = vf.toJson();
      final file = vf.pickedImage.value;
      if (file != null) {
        final bytes = await file.readAsBytes();
        final base64Str = base64Encode(bytes);
        final ext = file.path
            .split('.')
            .last
            .toLowerCase();
        map['image'] = 'data:image/$ext;base64,$base64Str';
      }
      variantsPayload.add(map);
    }

    // Build common_attributes payload
    final Map<String, dynamic> commonAttrs = {};
    attrCtrls.forEach((key, ctrl) {
      commonAttrs[key] = ctrl.text.trim();
    });

    final body = {
      'product_id': p.productId,
      'name': nameCtrl.text.trim(),
      'description': descCtrl.text.trim(),
      'common_attributes': commonAttrs,
      'variants': variantsPayload,
    };

    try {
      isUpdating(true);
      final resp = await http.post(
        Uri.parse('$_base/product/update'),
        headers: _headers,
        body: jsonEncode(body),
      );

      if (resp.statusCode != 200) {
        AppSnackbar.error(ApiErrorHandler.handleResponse(resp));
        return;
      }

      final json = jsonDecode(resp.body) as Map<String, dynamic>;

      if (json['status'] == true) {
        // ── FIX: same guard here too ──
        final rawData = json['data'];
        final Map<String, dynamic> productMap = rawData is List
            ? rawData.first as Map<String, dynamic>
            : rawData as Map<String, dynamic>;

        final updated = ProductModel.fromJson(productMap);
        product(updated);
        _populateForms(updated);
        AppSnackbar.success(json['message'] ?? 'Product updated successfully');
        Get.delete<ManageproductController>();
        Get.offNamed('/manageproduct');
      } else {
        AppSnackbar.error(json['message'] ?? 'Update failed');
      }
    } catch (e) {
      AppSnackbar.error(ApiErrorHandler.handleException(e));
    } finally {
      isUpdating(false);
    }
  }}

// ── Variant form-state helper ─────────────────────────────────────────────────
class VariantForm {
  int? id;
  String? existingImageUrl;

  final Rx<File?> pickedImage = Rx<File?>(null);
  final RxMap<String, TextEditingController> attrCtrls =
      <String, TextEditingController>{}.obs;
  final TextEditingController priceCtrl;
  final TextEditingController stockCtrl;

  VariantForm({
    this.id,
    this.existingImageUrl,
    required Map<String, dynamic> attributes,
    required double price,
    required int stock,
  })
      : priceCtrl = TextEditingController(text: price.toStringAsFixed(2)),
        stockCtrl = TextEditingController(text: stock.toString()) {
    attributes.forEach((k, v) {
      attrCtrls[k] = TextEditingController(text: v.toString());
    });
  }

  factory VariantForm.fromVariant(VariantModel v) =>
      VariantForm(
        id: v.id,
        existingImageUrl: v.image,
        attributes: v.attributes,
        price: v.price,
        stock: v.stock,
      );

  factory VariantForm.empty() =>
      VariantForm(
        attributes: {'size': '', 'color': ''},
        price: 0,
        stock: 0,
      );

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> attrs = {};
    attrCtrls.forEach((k, c) => attrs[k] = c.text.trim());
    final map = <String, dynamic>{
      'attributes': attrs,
      'price': double.tryParse(priceCtrl.text) ?? 0.0,
      'stock': int.tryParse(stockCtrl.text) ?? 0,
    };
    if (id != null) map['id'] = id;
    return map;
  }

  void dispose() {
    for (final c in attrCtrls.values)
      c.dispose();
    priceCtrl.dispose();
    stockCtrl.dispose();
  }
}
