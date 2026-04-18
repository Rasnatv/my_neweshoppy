
import 'dart:convert';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import '../../../data/errors/api_error.dart';
import '../../../data/models/merchant_offerbannermodel.dart';
import '../../merchantlogin/widget/successwidget.dart';

class MerchantOfferBannerController extends GetxController {
  final offer     = <MerchantOffersviewmodel>[].obs;
  final isLoading = false.obs;
  final box       = GetStorage();

  static const String _offerUrl =
      "https://rasma.astradevelops.in/e_shoppyy/public/api/mercgetoffer";
  static const String _deleteUrl =
      "https://rasma.astradevelops.in/e_shoppyy/public/api/delete-Offerbanner";

  String get _token => box.read("auth_token") ?? "";

  Map<String, String> get _headers => {
    "Accept"        : "application/json",
    "Authorization" : "Bearer $_token",
  };

  @override
  void onInit() {
    super.onInit();
    fetchOffers();
  }

  // // ── Token guard ────────────────────────────────────────────
  // bool _checkToken() {
  //   if (_token.isEmpty) {
  //     AppSnackbar.error("Token missing. Please login again.");
  //     return false;
  //   }
  //   return true;
  // }

  // ── Fetch offers ───────────────────────────────────────────
  Future<void> fetchOffers() async {
    // if (!_checkToken()) return;
    isLoading.value = true;

    try {
      final response = await http.get(
        Uri.parse(_offerUrl),
        headers: _headers,
      );

      if (response.statusCode != 200 && response.statusCode != 201) {
        AppSnackbar.error(ApiErrorHandler.handleResponse(response));
        return;
      }

      final data = jsonDecode(response.body);

      if (data['status'] == 1 || data['status'] == '1') {
        final List rawList = data['data'] ?? [];
        offer.value = rawList
            .map((e) => MerchantOffersviewmodel.fromJson(e))
            .toList();
      } else {
        AppSnackbar.error(
          data['message']?.toString().isNotEmpty == true
              ? data['message']
              : 'Failed to load offers.',
        );
      }
    } catch (e) {
      AppSnackbar.error(ApiErrorHandler.handleException(e));
    } finally {
      isLoading.value = false;
    }
  }

  // ── Delete offer ───────────────────────────────────────────
  Future<void> deleteOffer(int offerId) async {
    // if (!_checkToken()) return;
    isLoading.value = true;

    try {
      final response = await http.delete(
        Uri.parse(_deleteUrl),
        headers: _headers,
        body: {"offer_id": offerId.toString()},
      );

      if (response.statusCode != 200 && response.statusCode != 201) {
        AppSnackbar.error(ApiErrorHandler.handleResponse(response));
        return;
      }

      final data = jsonDecode(response.body);

      if (data['status'] == 1 || data['status'] == '1') {
        // ✅ Remove locally — no full reload needed
        offer.removeWhere((item) => item.offerId == offerId);
        AppSnackbar.success(
          data['message']?.toString().isNotEmpty == true
              ? data['message']
              : 'Offer deleted successfully.',
        );
      } else {
        AppSnackbar.error(
          data['message']?.toString().isNotEmpty == true
              ? data['message']
              : 'Failed to delete offer.',
        );
      }
    } catch (e) {
      AppSnackbar.error(ApiErrorHandler.handleException(e));
    } finally {
      isLoading.value = false;
    }
  }
}