

import 'package:eshoppy/app/modules/product/view/productdetail_buynowpreview.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../common/style/app_colors.dart';
import '../../../data/models/usercartmodel.dart';
import '../../../widgets/iconwithbadge.dart';
import '../../product/controller/cartcontroller.dart';
import '../../restarunent/view/restaurantcartpage.dart';
import 'buynow.dart';
import 'cartscreen.dart';


class ProductDetailPage extends StatelessWidget {
  ProductDetailPage({super.key});

  final CartController cartController = Get.put(CartController());


  // Product images
  final List<String> images = [
    "assets/images/products/images1.jpg",
    "assets/images/products/image2.jpg",
    "assets/images/products/images1.jpg",
  ];

  final String productName = "Indore Fashion T-Shirt";
  final double originalPrice = 699;
  final bool inStock = true;

  final List<String> features = [
    "Premium cotton fabric",
    "Soft and breathable",
    "Summer cool wear",
    "Stylish fit",
    "Durable material",
  ];

  final Map<String, String> attributesLeft = {
    "Brand": "Indore Fashion",
    "Material": "Cotton",
    "Color": "Black",
    "Fit": "Regular",
    "Warranty": "6 Months",
  };

  final Map<String, String> attributesRight = {
    "Size": "M, L, XL",
    "Weight": "250 g",
    "Country": "India",
    "Rating": "4.6 / 5",
    "Item Code": "TSH-2241",
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: AppColors.kPrimary,
        elevation: 0,
        actions: [
          Obx(() => IconWithBadge(
            icon: Icons.shopping_cart_outlined,
            badgeCount: cartController.cartItems.length,
            iconColor: Colors.white,
            onPressed: () => Get.to(() => CartPage()),
          )),
          const SizedBox(width: 12),
        ],
        //title: const Text("Product Details"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // ---------------- IMAGE CAROUSEL ----------------
            SizedBox(
              height: 300,
              child: PageView.builder(
                itemCount: images.length,
                itemBuilder: (context, index) {
                  return Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage(images[index]),
                        fit: BoxFit.cover,
                      ),
                    ),
                  );
                },
              ),
            ),

            // ---------------- MAIN CARD ----------------
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(22),
                    topRight: Radius.circular(22)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Product Name
                  Text(productName,
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                      )),
                  const SizedBox(height: 10),

                  // Price & Stock
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "₹$originalPrice",
                        style: const TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                            color: Colors.green),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: inStock ? Colors.green.shade100 : Colors.red.shade100,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          inStock ? "In Stock" : "Out of Stock",
                          style: TextStyle(
                            color: inStock ? Colors.green.shade900 : Colors.red.shade900,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Features
                  const Text("Features", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
                  const SizedBox(height: 10),
                  ...features.map((f) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 2),
                    child: Text("• $f",
                        style: const TextStyle(color: Colors.black87, height: 1.4)),
                  )),

                  const SizedBox(height: 20),

                  // Attributes
                  const Text("Product Specifications", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: attributesLeft.entries.map((e) => _attr(e.key, e.value)).toList(),
                          ),
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: attributesRight.entries.map((e) => _attr(e.key, e.value)).toList(),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ],
        ),
      ),

      // ---------------- BOTTOM BUTTONS ----------------
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(14),
        decoration: const BoxDecoration(
          color: Colors.white,
          boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 6)],
        ),
        child: Row(
          children: [
            // Add to Cart
            Expanded(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                onPressed: () {
                  cartController.addToCart(CartItemModel(
                    name: productName,
                    price: originalPrice.toInt(),
                    qty: 1,
                    img: images[0],
                  ));
                  Get.snackbar("Added", "$productName added to cart",
                      backgroundColor: Colors.teal, colorText: Colors.white);
                },
                child: const Text("Add to Cart", style: TextStyle(fontSize: 18, color: Colors.white)),
              ),
            ),
            const SizedBox(width: 10),

            // Buy Now
            Expanded(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                onPressed: () {
                  Get.to(() => BuynowPreviewPage.init(products: [
                    BuyNowProduct(name: productName, image: images[0], price: originalPrice),
                  ]));
                  // Get.to(() => BuynowPreviewPage (
                  // ));
                },
                child: const Text("Buy Now", style: TextStyle(fontSize: 18, color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Attribute Row
  Widget _attr(String title, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("$title : ", style: const TextStyle(fontWeight: FontWeight.w700, color: Colors.black87)),
          Expanded(child: Text(value, style: const TextStyle(color: Colors.black87))),
        ],
      ),
    );
  }
}
