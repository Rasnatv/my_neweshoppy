// import 'dart:convert';
// import 'package:get/get.dart';
// import 'package:get_storage/get_storage.dart';
// import 'package:http/http.dart' as http;
//
// import '../../../data/errors/api_error.dart';
// import '../../../data/models/userofferproductmodel.dart';
// import '../../merchantlogin/widget/successwidget.dart';
//
// class UserOfferProductController extends GetxController {
//   final String offer_id;
//
//   UserOfferProductController(this.offer_id);
//
//   var isLoading = false.obs;
//   var productList = <UserOfferProductModel>[].obs;
//   var errorMessage = ''.obs;
//
//   final box = GetStorage();
//
//   @override
//   void onInit() {
//     super.onInit();
//     fetchOfferProducts();
//   }
//
//   Future<void> fetchOfferProducts() async {
//     try {
//       isLoading(true);
//       errorMessage('');
//
//       final token = box.read('auth_token');
//
//       final response = await http.post(
//         Uri.parse(
//           'https://rasma.astradevelops.in/e_shoppyy/public/api/merchant/offer-products',
//         ),
//         headers: {
//           'Authorization': 'Bearer $token',
//           'Accept': 'application/json',
//           'Content-Type': 'application/json',
//         },
//         body: jsonEncode({
//           'offer_id': offer_id.toString(),
//         }),
//       );
//
//       if (response.statusCode == 200) {
//         final decoded = jsonDecode(response.body);
//
//         if (decoded['status'] == 1) {
//           final List data = decoded['data'] ?? [];
//           productList.value =
//               data.map((e) => UserOfferProductModel.fromJson(e)).toList();
//         } else {
//           errorMessage(decoded['message'] ?? 'Something went wrong');
//
//           // ✅ LOGICAL ERROR
//           AppSnackbar.error(errorMessage.value);
//         }
//       } else {
//         errorMessage(ApiErrorHandler.handleResponse(response));
//
//         // ✅ API ERROR HANDLER
//         AppSnackbar.error(errorMessage.value);
//       }
//     } catch (e) {
//       errorMessage(ApiErrorHandler.handleException(e));
//
//       // ✅ EXCEPTION HANDLER
//       AppSnackbar.error(errorMessage.value);
//     } finally {
//       isLoading(false);
//     }
//   }
// }
import 'dart:convert';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

import '../../../data/errors/api_error.dart';
import '../../../data/models/userofferproductmodel.dart';
import '../../merchantlogin/widget/successwidget.dart';
import '../../product/controller/whishlistcontroller.dart'; // ✅ import

class UserOfferProductController extends GetxController {
  final String offer_id;

  UserOfferProductController(this.offer_id);

  var isLoading = false.obs;
  var productList = <UserOfferProductModel>[].obs;
  var errorMessage = ''.obs;

  final box = GetStorage();

  // ✅ Use the shared WishlistController — same instance used everywhere
  late final WishlistController wishlistController;

  @override
  void onInit() {
    super.onInit();

    // ✅ Find existing or create — same pattern as WishlistScreen
    wishlistController = Get.isRegistered<WishlistController>()
        ? Get.find<WishlistController>()
        : Get.put(WishlistController());

    fetchOfferProducts();
  }

  Future<void> fetchOfferProducts() async {
    try {
      isLoading(true);
      errorMessage('');

      final token = box.read('auth_token');

      final response = await http.post(
        Uri.parse(
          'https://rasma.astradevelops.in/e_shoppyy/public/api/merchant/offer-products',
        ),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({'offer_id': offer_id.toString()}),
      );

      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);

        if (decoded['status'] == 1) {
          final List data = decoded['data'] ?? [];
          productList.value =
              data.map((e) => UserOfferProductModel.fromJson(e)).toList();
        } else {
          errorMessage(decoded['message'] ?? 'Something went wrong');
          AppSnackbar.error(errorMessage.value);
        }
      } else {
        errorMessage(ApiErrorHandler.handleResponse(response));
        AppSnackbar.error(errorMessage.value);
      }
    } catch (e) {
      errorMessage(ApiErrorHandler.handleException(e));
      AppSnackbar.error(errorMessage.value);
    } finally {
      isLoading(false);
    }
  }
}