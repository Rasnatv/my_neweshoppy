

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../common/style/app_colors.dart';
import '../../../common/style/app_text_style.dart';
import '../../../data/models/merchant_offerbannermodel.dart';
import '../controller/merchant_offerbanner_controller.dart';
import 'merchant_createoffer.dart';
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
            onTap: () => Get.to(() => CreateOfferPage()),
            child: Container(
              margin: const EdgeInsets.only(right: 12),
              padding:
              const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.orange,
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Row(
                children: [
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
      body: Obx(() {
        if (controller.isLoading.value) {
          return _loadingView();
        }

        if (controller.offer.isEmpty) {
          return _emptyView();
        }

        return RefreshIndicator(
          onRefresh: controller.fetchOffers,
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: controller.offer.length,
            itemBuilder: (_, index) {
              final offer = controller.offer[index];
              return _offerCard(offer, index);
            },
          ),
        );
      }),
    );
  }

  Widget _offerCard(MerchantOffersviewmodel offer, int index) {
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
          /// BANNER IMAGE
          ClipRRect(
            borderRadius:
            const BorderRadius.vertical(top: Radius.circular(18)),
            child: offer.offerBanner.isNotEmpty
                ? Image.network(
              offer.offerBanner,
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
                child: Center(
                    child: Icon(Icons.broken_image, size: 60)),
              ),
            )
                : const SizedBox(
              height: 180,
              child: Center(
                  child: Icon(Icons.image_not_supported,
                      size: 60, color: Colors.grey)),
            ),
          ),

          const SizedBox(height: 10),

          /// OFFER ID + DISCOUNT BADGE
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.green.shade50,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.green.shade200),
                  ),
                  child: Text(
                    // toStringAsFixed(0) removes ".00" → shows "25%" not "25.0%"
                    "Flat ${offer.discountPercentage.toStringAsFixed(0)}% OFF",
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: Colors.green,
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 14),

          /// BUTTONS
          Padding(
            padding:
            const EdgeInsets.only(left: 16, right: 16, bottom: 16),
            child: Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      // offerId is now int — pass directly
                      Get.to(() => OfferProductScreen(offerId: offer.offerId));
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
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.update, color: Colors.blue),
                    label: const Text(
                      "Update",
                      style: TextStyle(color: Colors.blue),
                    ),
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Colors.blue),
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
  Widget _loadingView() {
    return const Center(child: CircularProgressIndicator());
  }

  Widget _emptyView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          Icon(Icons.local_offer_outlined, size: 70, color: Colors.grey),
          SizedBox(height: 12),
          Text(
            "No offers available",
            style: TextStyle(fontSize: 16, color: Colors.grey),
          ),
        ],
      ),
    );
  }
}