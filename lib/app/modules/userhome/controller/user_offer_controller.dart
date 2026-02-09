import 'dart:convert';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import '../../../data/models/usermerchantoffermodel.dart';


class UserOfferController extends GetxController {
  var isLoading = false.obs;
  var offerList = <UserOfferModel>[].obs;

  final box = GetStorage();

  final String apiUrl =
      'https://rasma.astradevelops.in/e_shoppyy/public/api/getofferuser';

  @override
  void onInit() {
    super.onInit();
    fetchOffers();
  }

  Future<void> fetchOffers() async {
    try {
      isLoading(true);

      final token = box.read('auth_token'); // 🔑 auth_token from storage

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

          offerList.value =
              data.map((e) => UserOfferModel.fromJson(e)).toList();
        } else {
          Get.snackbar('Error', decoded['message']);
        }
      } else {
        Get.snackbar('Error', 'Server error');
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to load offers');
    } finally {
      isLoading(false);
    }
  }
}
