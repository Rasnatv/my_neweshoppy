
import 'package:eshoppy/app/modules/restarunent/view/restaurantbookingpage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../common/style/app_colors.dart';
import '../../../common/style/app_text_style.dart';
import '../../product/controller/cartcontroller.dart';
import '../../product/view/cartscreen.dart';
import '../controller/restaurantcartcontroller.dart';

class Restaurantcartpage extends StatelessWidget {
  Restaurantcartpage ({super.key});

  final Restaurantcartcontroller cartController = Get.find<Restaurantcartcontroller>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      // bottomNavigationBar: Padding(padding: EdgeInsets.all(20),child:SizedBox(width: double.infinity,child:ElevatedButton(onPressed:(){}, child: Text("Confirmbooking"))),
      // ),
      appBar: AppBar(
        title: Text("Cart",style:AppTextStyle.rTextNunitoWhite17w700),
        backgroundColor: AppColors.kPrimary,
        elevation: 0,
      ),

      body: Obx(() {
        if (cartController.cartItems.isEmpty) {
          return const Center(
            child: Text("Your cart is empty",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          );
        }

        return Column(
          children: [
            /// ---------------- CART LIST ----------------
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(vertical: 10),
                itemCount: cartController.cartItems.length,
                itemBuilder: (context, index) {
                  var item = cartController.cartItems[index];

                  return Container(
                    margin: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                            color: Colors.black12.withOpacity(0.05),
                            blurRadius: 6)
                      ],
                    ),

                    child: ListTile(
                      leading: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.asset(
                          item.img ?? "assets/noimg.png",
                          width: 60,
                          height: 60,
                          fit: BoxFit.cover,
                        ),
                      ),

                      title: Text(item.name,
                          style: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w600)),

                      subtitle: Padding(
                        padding: const EdgeInsets.only(top: 5),
                        child: Text(
                          "₹ ${item.price} x ${item.qty} = ₹ ${item.price * item.qty}",
                          style: const TextStyle(
                              fontSize: 14, color: Colors.black87),
                        ),
                      ),

                      /// ----- QTY BUTTONS -----
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          _qtyButton(
                            Icons.remove,
                                () => cartController.decreaseQty(index),
                          ),

                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            child: Text(item.qty.toString(),
                                style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold)),
                          ),

                          _qtyButton(
                            Icons.add,
                                () => cartController.increaseQty(index),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),

            /// ---------------- BOTTOM TOTAL + BOOK NOW ----------------
            Container(
              padding: const EdgeInsets.all(18),
              decoration: const BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(color: Colors.black12, blurRadius: 10)
                  ]),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text("Total Amount",
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.w600)),
                      Obx(() => Text(
                        "₹ ${cartController.totalPrice}",
                        style: const TextStyle(
                            fontSize: 20,
                            color: Colors.teal,
                            fontWeight: FontWeight.bold),
                      )),
                    ],
                  ),

                  const SizedBox(height: 14),

                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        Get.to(()=>RestaurantBookingPage());// <-- your page route
                      },

                      child: const Text("BOOK NOW",
                          style:
                          TextStyle(color: Colors.white, fontSize: 18)),
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      }),
    );
  }

  /// ================== WIDGET FOR [+] [-] BUTTON ==================
  Widget _qtyButton(IconData icon, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: Colors.teal.withOpacity(0.1),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, size: 18, color: Colors.teal),
      ),
    );
  }
}
