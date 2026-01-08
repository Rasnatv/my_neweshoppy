

import 'package:eshoppy/app/modules/product/widgtet/productpriceratingbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../common/constants/app_images.dart';
import '../../userhome/controller/district _controller.dart';
import '../view/prodductdetailscreen.dart';
import 'favicon.dart';


class ProductCard extends StatelessWidget {
  const ProductCard({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Get.to(() => ProductDetailPage()),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 5,
              spreadRadius: 1,
              offset: Offset(2, 4),
            ),
          ],
        ),
        child:Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: Stack(
                children: [
                  Container(width: double.infinity,height:200,
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(10),color: Colors.grey.withOpacity(0.1)),
                child:Image.asset(AppImages.prduct2,fit: BoxFit.cover,),),
                  Positioned(
                    top: 6,
                    right: 6,
                    child:FavoriteIconButton(
                      productId: "101",
                      name: "Chitrarekha Pretty Kurti",
                      image: AppImages.prduct2,
                      price: 799,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(4.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "chitrarekha pretty kurti",
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 4),
                  ProductPriceRating(),
                ],
              ),
            ),
          ],
        ),
      ),

    );
  }
}



