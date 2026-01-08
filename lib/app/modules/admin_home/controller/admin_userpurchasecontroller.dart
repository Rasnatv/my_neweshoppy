import 'package:get/get.dart';

class UserPurchaseController extends GetxController {
  final String userId;

  UserPurchaseController(this.userId);

  var purchasedProducts = <Map<String, dynamic>>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadPurchasedProducts();
  }

  void loadPurchasedProducts() {
    // TODO: Fetch products from backend using userId
    purchasedProducts.addAll([
      {
        "productName": "Bluetooth Speaker",
        "price": 999,
        "date": "2025-01-12",
        "img": "https://via.placeholder.com/150"
      },
      {
        "productName": "Laptop Bag",
        "price": 1499,
        "date": "2025-01-10",
        "img": "https://via.placeholder.com/150"
      },
    ]);
  }
}
