
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../view/prodductdetailscreen.dart';

class ProductCard extends StatelessWidget {
  final String productName;
  final String? imageUrl;
  final String price;
  final int productId;

  const ProductCard({
    super.key,
    required this.productName,
    required this.imageUrl,
    required this.price,
    required this.productId,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: () {
        Get.to(() => ProductDetailPage(productId: productId));
      },
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// 🔹 PRODUCT IMAGE
            Expanded(
              child: ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(12),
                  topRight: Radius.circular(12),
                ),
                child: imageUrl == null || imageUrl!.isEmpty
                    ? Container(
                  color: Colors.grey.shade200,
                  child: const Center(
                    child: Icon(
                      Icons.image,
                      size: 40,
                      color: Colors.grey,
                    ),
                  ),
                )
                    : Image.network(
                  imageUrl!,
                  fit: BoxFit.cover,
                  width: double.infinity,
                  errorBuilder: (_, __, ___) => Container(
                    color: Colors.grey.shade200,
                    child: const Icon(Icons.broken_image),
                  ),
                ),
              ),
            ),

            /// 🔹 PRODUCT NAME
            Padding(
              padding: const EdgeInsets.all(8),
              child: Text(
                productName,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontWeight: FontWeight.w500),
              ),
            ),

            /// 🔹 PRICE
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              child: Text(
                price == "0" ? "Price on request" : "₹ $price",
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
