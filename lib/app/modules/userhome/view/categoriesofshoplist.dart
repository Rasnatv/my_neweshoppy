// import 'dart:ui';
//
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:get/get_core/src/get_main.dart';
//
// import '../../../common/style/app_text_style.dart';
// import '../../../data/models/companymodel.dart';
// import '../controller/company_controller.dart';
// import 'shopview.dart';
// class Categoriesofshoplist extends StatelessWidget {
//   const Categoriesofshoplist({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body:ListView.separated(
//                 padding: const EdgeInsets.only(left: 16),
//                 scrollDirection: Axis.vertical,
//                 itemCount: 5,
//                 separatorBuilder: (_, __) => const SizedBox(width: 12),
//                 itemBuilder: (context, index) {
//                   return GestureDetector(
//                     onTap: () {
//                       final controller = Get.put(CompanyController());
//                       controller.setCompany(
//                         Company(
//                           name: "Indorefashion",
//                           image: "assets/images/instore.jpg",
//                           location: "Athinjal, Kanhangad",
//                           about:
//                           "Indorefashion is a premium store offering latest fashion collections.",
//                           products: [],
//                         ),
//                       );
//                       Get.to(() => ShopDetailPage());
//                     },
//                     child: ClipRRect(
//                       borderRadius: BorderRadius.circular(16),
//                       child: BackdropFilter(
//                         filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
//                         child: Container(
//                           width: 160,
//                           decoration: BoxDecoration(
//                             borderRadius: BorderRadius.circular(16),
//                             color: Colors.white.withOpacity(0.15),
//                             border: Border.all(
//                                 color: Colors.white.withOpacity(0.25)),
//                             boxShadow: [
//                               BoxShadow(
//                                 color: Colors.black.withOpacity(0.08),
//                                 blurRadius: 6,
//                                 offset: const Offset(0, 4),
//                               ),
//                             ],
//                           ),
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               ClipRRect(
//                                 borderRadius: const BorderRadius.only(
//                                     topLeft: Radius.circular(16),
//                                     topRight: Radius.circular(16)),
//                                 child: Image.asset("assets/images/instore.jpg",
//                                     height: 140,
//                                     width: double.infinity,
//                                     fit: BoxFit.cover),
//                               ),
//                               Padding(
//                                 padding: const EdgeInsets.all(8.0),
//                                 child: Column(
//                                   crossAxisAlignment:
//                                   CrossAxisAlignment.start,
//                                   children: [
//                                     Text("Indorefashion",
//                                         maxLines: 1,
//                                         overflow: TextOverflow.ellipsis,
//                                         style: AppTextStyle
//                                             .rTextNunitoBlack14w700),
//                                     const SizedBox(height: 2),
//                                     Text("Athinjal, Kanhangad",
//                                         maxLines: 1,
//                                         overflow: TextOverflow.ellipsis,
//                                         style: AppTextStyle
//                                             .rTextNunitoBlack12w400),
//                                   ],
//                                 ),
//                               ),
//                             ],
//                           ))
//                       ))
//                       );
//                     )
//                 });
//
//
//   }
// }

import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../common/style/app_colors.dart';
import '../../../common/style/app_text_style.dart';
import '../../../data/models/companymodel.dart';
import '../controller/company_controller.dart';
import 'shopview.dart';

class Categoriesofshoplist extends StatelessWidget {
  const Categoriesofshoplist({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.kPrimary,
        title: Text("Shops",style:AppTextStyle.rTextNunitoWhite17w700),
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: 5,
        separatorBuilder: (_, __) => const SizedBox(height: 14),
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              final controller = Get.put(CompanyController());
              controller.setCompany(
                Company(
                  name: "Indorefashion",
                  image: "assets/images/instore.jpg",
                  location: "Athinjal, Kanhangad",
                  about:
                  "Indorefashion is a premium store offering latest fashion collections.",
                  products: [],
                ),
              );
              Get.to(() => ShopDetailPage());
            },
            child: _ShopListCard(),
          );
        },
      ),
    );
  }
}
class _ShopListCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            color: Colors.white.withOpacity(0.15),
            border: Border.all(color: Colors.white.withOpacity(0.25)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.08),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            children: [
              // IMAGE
              ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(16),
                  bottomLeft: Radius.circular(16),
                ),
                child: Image.asset(
                  "assets/images/instore.jpg",
                  height: 110,
                  width: 110,
                  fit: BoxFit.cover,
                ),
              ),

              // TEXT
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Indorefashion",
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyle.rTextNunitoBlack14w700,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "Athinjal, Kanhangad",
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyle.rTextNunitoBlack12w400,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

