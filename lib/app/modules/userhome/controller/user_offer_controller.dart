
import 'dart:convert';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

import '../../../data/errors/api_error.dart';
import '../../../data/models/usermerchantoffermodel.dart';
import '../../../widgets/network_trihgiger.dart';
import '../../merchantlogin/widget/successwidget.dart';

class UserOfferController extends GetxController {
  var isLoading = false.obs;
  var offerList = <UserOfferModel>[].obs;

  final box = GetStorage();

  final String apiUrl =
      'https://rasma.astradevelops.in/e_shoppyy/public/api/getofferuser';

  @override
  void onInit() {
    super.onInit();

    ever(Get.find<NetworkService>().reconnectTrigger, (_) {
      refresh();
    });

    fetchOffers();
  }

  Future<void> refresh() async {
    offerList.clear();
    await fetchOffers();
  }

  Future<void> fetchOffers() async {
    try {
      isLoading(true);

      final token = box.read('auth_token');

      final response = await http.get(
        Uri.parse(apiUrl),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);

        if (decoded['status'] == 1) {
          final List data = decoded['data'];
          offerList.value = data
              .map((e) => UserOfferModel.fromJson(e))
              .where((offer) =>
          offer.merchantId != null && offer.shopName != null)
              .toList();
        } else {
          offerList.clear();

          // ✅ LOGICAL ERROR (status != 1)
          final message = decoded['message'] ?? "Failed to load offers";
          AppSnackbar.error(message);
        }
      } else {
        offerList.clear();

        // ✅ API ERROR HANDLER
        final errorMessage = ApiErrorHandler.handleResponse(response);
        AppSnackbar.error(errorMessage);
      }
    } catch (e) {
      offerList.clear();

      // ✅ EXCEPTION HANDLER (Socket, etc.)
      final errorMessage = ApiErrorHandler.handleException(e);
      AppSnackbar.error(errorMessage);

      print('fetchOffers error: $e');
    } finally {
      isLoading(false);
    }
  }
}