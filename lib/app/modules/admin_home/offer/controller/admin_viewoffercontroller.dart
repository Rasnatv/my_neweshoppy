
import 'dart:convert';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

import '../../../../data/errors/api_error.dart';
import '../../../../data/models/admin_offerviewmodel.dart';
import '../../../merchantlogin/widget/successwidget.dart';

class AdminViewOfferController extends GetxController {
  final RxList<AdminViewOfferModel> offers = <AdminViewOfferModel>[].obs;
  final RxBool isLoading = false.obs;
  final RxBool hasError = false.obs;
  final RxString errorMessage = ''.obs;

  final GetStorage box = GetStorage();

  static const String _baseUrl =
      'https://eshoppy.co.in/api/offers';


  String? get _authToken => box.read('auth_token');

  Map<String, String> get _headers => {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
    if (_authToken != null && _authToken!.isNotEmpty)
      'Authorization': 'Bearer $_authToken',
  };

  // ── LIFECYCLE ──────────────────────────────────────
  @override
  void onInit() {
    super.onInit();
    fetchOffers();
  }

  // ── API CALL ───────────────────────────────────────
  Future<void> fetchOffers() async {

    try {
      isLoading.value = true;
      hasError.value = false;
      errorMessage.value = '';

      final response = await http.get(
        Uri.parse(_baseUrl),
        headers: _headers,
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonData =
        json.decode(response.body);

        if (jsonData['status'] == 1) {
          final List<dynamic> data = jsonData['data'];

          offers.value = data
              .map((item) => AdminViewOfferModel.fromJson(item))
              .toList();
        } else {
          hasError.value = true;
          errorMessage.value =
              jsonData['message'] ?? 'Failed to fetch offers.';

          AppSnackbar.error(errorMessage.value);
        }
      } else {
        hasError.value = true;
        errorMessage.value =
            ApiErrorHandler.handleResponse(response);

        AppSnackbar.error(errorMessage.value);
      }
    } catch (e) {
      hasError.value = true;
      errorMessage.value =
          ApiErrorHandler.handleException(e);

      AppSnackbar.error(errorMessage.value);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> refreshOffers() async {
    await fetchOffers();
  }

  // ── UNAUTHORIZED HANDLER ───────────────────────────
  void _handleUnauthorized() {
    box.remove('auth_token');
    box.remove('role');
    box.remove('user_data');
    box.write('is_logged_in', false);

    Get.offAllNamed('/login');
  }

  // ── COMPUTED GETTERS ───────────────────────────────
  Map<String, List<AdminViewOfferModel>> get groupedOffers {
    final Map<String, List<AdminViewOfferModel>> grouped = {};
    for (final offer in offers) {
      grouped.putIfAbsent(offer.shopName, () => []).add(offer);
    }
    return grouped;
  }

  int get totalOffers => offers.length;

  List<String> get shopNames =>
      offers.map((o) => o.shopName).toSet().toList();
}