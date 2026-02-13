
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../common/style/app_colors.dart';
import '../../../common/style/app_text_style.dart';
import '../controller/merchant_offerbanner_controller.dart';
import 'addofferproduct.dart';
import 'merchant_offerproductview.dart';


class MerchantOfferViewPage extends StatelessWidget {
  MerchantOfferViewPage({super.key});

  final MerchantOfferBannerController controller =
  Get.put(MerchantOfferBannerController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        backgroundColor: AppColors.kPrimary,
        title: Text(
          "My Offers",
          style: AppTextStyle.rTextNunitoWhite17w700,
        ),
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          InkWell(
            onTap: () => Get.to(() => AddOfferProductPage()),
            child: Container(
              margin: const EdgeInsets.only(right: 12),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.orange,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                children: const [
                  Icon(Icons.local_offer, color: Colors.white, size: 18),
                  SizedBox(width: 6),
                  Text(
                    "Add Offer",
                    style: TextStyle(color: Colors.white),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),

      /// BODY
      body: Obx(() {
        if (controller.isLoading.value) {
          return _loadingView();
        }

        if (controller.offers.isEmpty) {
          return _emptyView();
        }

        return RefreshIndicator(
          onRefresh: controller.fetchOffers,
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: controller.offers.length,
            itemBuilder: (_, index) {
              final offer = controller.offers[index];
              return _offerCard(offer, index);
            },
          ),
        );
      }),
    );
  }

  /// OFFER CARD UI
  Widget _offerCard(offer, int index) {
    return Container(
      margin: const EdgeInsets.only(bottom: 18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// IMAGE
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(18)),
            child: Image.network(
              offer.banner,
              height: 180,
              width: double.infinity,
              fit: BoxFit.cover,
              loadingBuilder: (context, child, progress) {
                if (progress == null) return child;
                return const SizedBox(
                  height: 180,
                  child: Center(child: CircularProgressIndicator()),
                );
              },
              errorBuilder: (_, __, ___) => const SizedBox(
                height: 180,
                child: Center(child: Icon(Icons.broken_image, size: 60)),
              ),
            ),
          ),

          const SizedBox(height: 12),

          /// DISCOUNT TEXT
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              "Flat ${offer.discount}% OFF",
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
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                /// VIEW PRODUCTS
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Get.to(() => OfferProductScreen() );
                    },
                    icon: const Icon(Icons.visibility),
                    label: const Text("View Products"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.kPrimary,
                      foregroundColor: Colors.white,
                      padding:
                      const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),

                const SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => _deleteDialog(index),
                    icon: const Icon(Icons.delete_outline, color: Colors.red),
                    label: const Text(
                      "Delete",
                      style: TextStyle(color: Colors.red),
                    ),
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Colors.red),
                      padding:
                      const EdgeInsets.symmetric(vertical: 14),
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

  Widget _loadingView() {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }

  Widget _emptyView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          Icon(Icons.local_offer_outlined,
              size: 70, color: Colors.grey),
          SizedBox(height: 12),
          Text(
            "No offers available",
            style: TextStyle(fontSize: 16, color: Colors.grey),
          ),
        ],
      ),
    );
  }
  void _deleteDialog(int index) {
    Get.defaultDialog(
      title: "Delete Offer",
      middleText: "Are you sure you want to delete this offer?",
      textConfirm: "Delete",
      textCancel: "Cancel",
      confirmTextColor: Colors.white,
      buttonColor: Colors.red,
      onConfirm: () {
        controller.deleteOffer(index);
        Get.back();
        Get.snackbar(
          "Deleted",
          "Offer deleted successfully",
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      },
    );
  }
}
