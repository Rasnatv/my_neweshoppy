
import 'package:get/get.dart';

class ManageproductController extends GetxController {
  RxList<Map<String, dynamic>> products = <Map<String, dynamic>>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadDummyData();
  }

  void loadDummyData() {
    products.addAll([
      {
        "name": "Apple iPhone 15",
        "price": "120000",
        "image": "assets/images/products/images1.jpg",
      },
      {
        "name": "Samsung Galaxy S24",
        "price": "95000",
        "image": "assets/images/products/images1.jpg",
      },
      {
        "name": "Sony Headphones",
        "price": "8000",
        "image": "assets/images/products/images1.jpg",
      },
      {
        "name": "MacBook Air M3",
        "price": "135000",
        "image": "assets/images/products/images1.jpg",
      },
    ]);
  }

  // DELETE PRODUCT
  void deleteProduct(int index) {
    products.removeAt(index);
  }

  // UPDATE PRODUCT
  void updateProduct(int index, Map<String, dynamic> newData) {
    products[index] = newData;
    products.refresh();
  }
}
