// import 'package:flutter/material.dart';
//
// class FavoriteIconButton extends StatelessWidget {
//
//
//   const FavoriteIconButton({super.key,});
//
//   @override
//   Widget build(BuildContext context) {
//
//
//     return InkWell(
//         onTap: () {},
//         child: Container(
//           decoration: BoxDecoration(
//             color: Colors.white.withOpacity(0.9),
//             shape: BoxShape.circle,
//           ),
//           padding: const EdgeInsets.all(5),
//           child: Icon(
//              Icons.favorite_border_outlined,
//             color: Colors.grey,
//             size: 18,
//           ),
//         ),
//       );
//
//   }
// }
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../favourate/controller/favourate controller.dart';


class FavoriteIconButton extends StatelessWidget {
  final String productId;
  final String name;
  final String image;
  final double price;

  const FavoriteIconButton({
    super.key,
    required this.productId,
    required this.name,
    required this.image,
    required this.price,
  });

  @override
  Widget build(BuildContext context) {
    final FavouriteController controller = Get.put(FavouriteController());

    return Obx(() {
      final bool isFav = controller.isFavourite(productId);

      return InkWell(
        onTap: () {
          controller.toggleFavourite(
            id: productId,
            name: name,
            image: image,
            price: price,
          );
        },
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.9),
            shape: BoxShape.circle,
          ),
          padding: const EdgeInsets.all(5),
          child: Icon(
            isFav ? Icons.favorite : Icons.favorite_border_outlined,
            color: isFav ? Colors.red : Colors.grey,
            size: 18,
          ),
        ),
      );
    });
  }
}

