// import 'package:get/get.dart';
// import '../../../data/models/usercartmodel.dart';
//
// class CartController extends GetxController {
//   // Observable list of cart items
//   var cartItems = <CartItemModel>[].obs;
//
//   // Add product to cart
//   void addToCart(CartItemModel item) {
//     // Check if item already exists
//     int index = cartItems.indexWhere((element) => element.name == item.name);
//     if (index != -1) {
//       cartItems[index].qty += item.qty; // Increase quantity
//       cartItems.refresh();
//     } else {
//       cartItems.add(item);
//     }
//   }
//
//   // Increase quantity of a cart item
//   void increaseQty(int index) {
//     cartItems[index].qty++;
//     cartItems.refresh();
//   }
//
//   // Decrease quantity of a cart item
//   void decreaseQty(int index) {
//     if (cartItems[index].qty > 1) {
//       cartItems[index].qty--;
//     } else {
//       cartItems.removeAt(index); // Remove if qty = 1
//     }
//     cartItems.refresh();
//   }
//
//   // Total price of cart
//   int get totalPrice =>
//       cartItems.fold(0, (sum, item) => sum + item.price * item.qty);
// }
import 'package:get/get.dart';
import '../../../data/models/usercartmodel.dart';

class CartController extends GetxController {
  RxList<CartItemModel> cartItems = <CartItemModel>[].obs;

  /// ADD ITEM TO CART
  void addToCart(CartItemModel item) {
    int index = cartItems.indexWhere((e) => e.name == item.name);

    if (index != -1) {
      cartItems[index].qty++;
      cartItems.refresh();
    } else {
      cartItems.add(item);
    }
  }

  /// INCREASE QUANTITY
  void increaseQty(int index) {
    cartItems[index].qty++;
    cartItems.refresh();
  }

  /// DECREASE QUANTITY
  void decreaseQty(int index) {
    if (cartItems[index].qty > 1) {
      cartItems[index].qty--;
    } else {
      cartItems.removeAt(index);
    }
    cartItems.refresh();
  }

  /// REMOVE ITEM
  void removeItem(int index) {
    cartItems.removeAt(index);
    cartItems.refresh();
  }

  /// TOTAL PRICE
  int get totalPrice {
    int total = 0;
    for (var item in cartItems) {
      total += item.price * item.qty;
    }
    return total;
  }
}
