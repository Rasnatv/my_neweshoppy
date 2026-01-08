import 'package:get/get.dart';
import '../../../data/models/usercartmodel.dart';
import '../../../data/models/restaruantcartmodel.dart';

class Restaurantcartcontroller extends GetxController {
  RxList<RestaurantCartModel> cartItems = <RestaurantCartModel>[].obs;

  // ADD TO CART
  void addToCart(RestaurantCartModel item) {
    cartItems.add(item);
  }

  // INCREASE QTY
  void increaseQty(int index) {
    cartItems[index].qty++;
    cartItems.refresh();
  }

  // DECREASE QTY
  void decreaseQty(int index) {
    if (cartItems[index].qty > 1) {
      cartItems[index].qty--;
    } else {
      cartItems.removeAt(index);
    }
    cartItems.refresh();
  }

  // TOTAL PRICE GETTER
  int get totalPrice {
    int total = 0;
    for (var item in cartItems) {
      total += item.price * item.qty;
    }
    return total;
  }
}
