

import 'package:eshoppy/app/modules/userhome/widget/usercategories.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../../common/style/app_text_style.dart';
import '../view/categoriesofshoplist.dart';

class FlipkartStyleCategories extends StatelessWidget {
  const FlipkartStyleCategories({super.key});

  @override
  Widget build(BuildContext context) {
    final pairs = <List<Map<String, String>>>[];

    // Create pairs of 2 categories (for 2 rows)
    for (var i = 0; i < UserCategories.list.length; i += 2) {
      pairs.add(
        UserCategories.list.sublist(
          i,
          (i + 2 > UserCategories.list.length) ? UserCategories.list.length : i + 2,
        ),
      );
    }

    return SizedBox(
      height: 210,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: pairs.length,
        padding: const EdgeInsets.symmetric(horizontal: 10),
        itemBuilder: (context, index) {
          final pair = pairs[index]; // ✔ FIXED: pair is defined here

          return Padding(
            padding: const EdgeInsets.only(right: 6),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: pair.map((item) {
                return SizedBox(
                  height: 100, // ✔ FIXED HEIGHT FOR EACH ITEM
                  width: 80,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // ICON BOX
                      InkWell(onTap: ()=>Get.to(()=>Categoriesofshoplist()),child:Container(
                        height: 65,
                        width: 65,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(color: Colors.grey.shade300),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.shade200,
                              blurRadius: 4,
                              spreadRadius: 1,
                            )
                          ],
                        ),
                        padding: const EdgeInsets.all(12),
                        child: Image.asset(item["icon"]!, fit: BoxFit.contain),
                      ),),

                      // TEXT AREA (FIXED HEIGHT → no disorder)
                      SizedBox(
                        width: 70,
                        height: 30,
                        child: Text(
                          item["name"]!,
                          textAlign: TextAlign.center,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: AppTextStyle.rTextNunitoBlack10w400,
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          );
        },
      ),
    );
  }
}
