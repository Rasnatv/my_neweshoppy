
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../common/style/app_colors.dart';
import 'addofferproduct.dart';
import 'offerproductlist.dart';

class MerchantOfferViewPage extends StatelessWidget {
  const MerchantOfferViewPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text("My Offers"),
        backgroundColor: AppColors.kPrimary,
        actions: [
          ElevatedButton(onPressed: ()=>Get.to(()=>AddOfferProductPage()),child:Text("create offers"))
        ],
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: 3,
        itemBuilder: (context, index) {
          return _offerCard(context);
        },
      ),
    );
  }

  Widget _offerCard(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 12,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// BANNER IMAGE
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(18)),
            child: Image.asset(
              "assets/images/offer3.jpg",
              height: 180,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),

          const SizedBox(height: 12),

          /// OFFER TEXT
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14),
            child: Text(
              "Flat 15% OFF",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: AppColors.kPrimary,
              ),
            ),
          ),

          const SizedBox(height: 14),

          /// BUTTONS
          Padding(
            padding: const EdgeInsets.all(14),
            child: Row(
              children: [
                /// VIEW PRODUCTS
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                   Get.to(()=>OfferProductListPage());
                    },
                    icon: const Icon(Icons.visibility),
                    label: const Text("View Products"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.kPrimary,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),

                const SizedBox(width: 12),

                /// DELETE
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {
                      _deleteDialog();
                    },
                    icon: const Icon(Icons.delete_outline, color: Colors.red),
                    label: const Text(
                      "Delete",
                      style: TextStyle(color: Colors.red),
                    ),
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Colors.red),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _deleteDialog() {
    Get.defaultDialog(
      title: "Delete Offer?",
      middleText: "This offer will be permanently removed.",
      textConfirm: "Delete",
      textCancel: "Cancel",
      confirmTextColor: Colors.white,
      buttonColor: Colors.red,
      onConfirm: () {
        Get.back();
        Get.snackbar(
          "Deleted",
          "Offer removed successfully",
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      },
    );
  }
}
