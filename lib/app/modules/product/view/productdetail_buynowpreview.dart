
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../common/style/app_colors.dart';
import '../../../common/style/app_text_style.dart';
import '../../userhome/view/newaddressscreen.dart';


class BuyNowProduct {
  final String name;
  final String image;
  final double price;

  BuyNowProduct({
    required this.name,
    required this.image,
    required this.price,
  });
}

class BuynowPreviewPage extends StatelessWidget {
  final List<BuyNowProduct> products;

  BuynowPreviewPage({super.key, required this.products});

  final List<RxInt> quantities = [];

  late final RxDouble totalAmount = 0.0.obs;

  BuynowPreviewPage.init({required this.products}) {
    // Initialize quantities for each product
    for (var _ in products) {
      quantities.add(1.obs);
    }
    // Calculate initial total
    double sum = 0;
    for (int i = 0; i < products.length; i++) {
      sum += products[i].price * quantities[i].value;
    }
    totalAmount.value = sum;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.kPrimary,
          title: Text("Order Preview",style:AppTextStyle.rTextNunitoWhite17w700)),

      // Bottom Bar
      bottomNavigationBar: Obx(() {
        double sum = 0;
        for (int i = 0; i < products.length; i++) {
          sum += products[i].price * quantities[i].value;
        }
        totalAmount.value = sum;

        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [BoxShadow(color: Colors.grey.shade300, blurRadius: 5, offset: const Offset(0, -2))]),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Total: ₹${totalAmount.value}",
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),

              SizedBox(width: 150,child:ElevatedButton(
                  onPressed: () {
                    Get.snackbar("Continue", "Go to payment (dummy)");
                  },
                  child: const Text("Continue"))
              )],
          ),
        );
      }),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Delivery Address
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Delivery Address", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                TextButton.icon(
                  onPressed: () => Get.to(() => AddAddressPage()),
                  icon: const Icon(Icons.add),
                  label: const Text("Add Address"),
                )
              ],
            ),
            const SizedBox(height: 12),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.grey.shade300)),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Rasna", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  SizedBox(height: 4),
                  Text("ABC Street, Kochi"),
                  Text("Kerala - 682001"),
                  Text("Phone: 9876543210"),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Products List
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: products.length,
              itemBuilder: (context, index) {
                final product = products[index];
                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                      color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.grey.shade300)),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.asset(product.image, width: 70, height: 70, fit: BoxFit.cover),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(product.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                            const SizedBox(height: 4),
                            Obx(() => Text("₹${product.price * quantities[index].value}",
                                style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.green, fontSize: 16))),
                            const SizedBox(height: 8),
                          Obx(() =>   Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                                 Text(
                                  "Qty: ${quantities[index].value}",
                                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                ),
                            Obx(() => Row(
                              children: [
                                IconButton(
                                  onPressed: () {
                                    if (quantities[index].value > 1) quantities[index].value--;
                                  },
                                  icon: const Icon(Icons.remove_circle, size: 28, color: Colors.red),
                                ),
                                Text(quantities[index].value.toString(),
                                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                                IconButton(
                                  onPressed: () {
                                    quantities[index].value++;
                                  },
                                  icon: const Icon(Icons.add_circle, size: 28, color: Colors.green),
                                ),
                              ],
                            )),
                          ],
                        ),)])
                      ),
                    ],
                  ),
                );
              },
            )
          ],
        ),
      ),
    );
  }
}
