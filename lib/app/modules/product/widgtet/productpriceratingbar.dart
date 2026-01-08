import 'package:flutter/material.dart';
import '../../../data/models/productmodel.dart';

class ProductPriceRating extends StatelessWidget {


  const ProductPriceRating({super.key, });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "₹ 500",
          style: const TextStyle(
            color: Colors.green,
            fontWeight: FontWeight.w600,
            fontSize: 13,
          ),
        ),
        const SizedBox(height: 6),
        // Container(
        //   width: 55,
        //   padding: const EdgeInsets.all(4),
        //   decoration: BoxDecoration(
        //     color: Colors.amber.withOpacity(0.2),
        //     borderRadius: BorderRadius.circular(12),
        //   ),
        //   child: Row(
        //     children: [
        //       const Icon(Icons.star, color: Colors.amber, size: 14),
        //       const SizedBox(width: 4),
        //       Text(
        //         "4",
        //         style: const TextStyle(
        //           fontSize: 12,
        //           fontWeight: FontWeight.w500,
        //         ),
        //       ),
            ],

    );
  }
}
