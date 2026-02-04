
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../common/constants/app_images.dart';
import '../../../common/style/app_colors.dart';
import '../../../common/style/app_text_style.dart';
import 'addofferproduct.dart';

class MerchantOffer {
  final String offerName;
  final String offerType;
  final String bannerImage;
  final List<MerchantOfferProduct> products;

  MerchantOffer({
    required this.offerName,
    required this.offerType,
    required this.bannerImage,
    required this.products,
  });
}

class MerchantOfferProduct {
  final String name;
  final double price;
  final String image;

  MerchantOfferProduct({
    required this.name,
    required this.price,
    required this.image,
  });
}

/// =====================
/// CONTROLLER
/// =====================
class MerchantOfferController extends GetxController {
  final RxList<MerchantOffer> offers = <MerchantOffer>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadMerchantOffers();
  }

  void loadMerchantOffers() {
    offers.assignAll([
      MerchantOffer(
        offerName: "Weekend Sale",
        offerType: "Flat 15% OFF",
        bannerImage: AppImages.banner1,
        products: [
          MerchantOfferProduct(
            name: "Burger",
            price: 150,
            image: AppImages.prduct2,
          ),
          MerchantOfferProduct(
            name: "Pizza",
            price: 250,
            image: AppImages.prduct2,
          ),
        ],
      ),
      MerchantOffer(
        offerName: "Combo Offer",
        offerType: "Buy 1 Get 1",
        bannerImage: AppImages.banner1,
        products: [
          MerchantOfferProduct(
            name: "Coffee",
            price: 50,
            image: AppImages.prduct2,
          ),
          MerchantOfferProduct(
            name: "Tea",
            price: 30,
            image: AppImages.prduct2,
          ),
        ],
      ),
    ]);
  }

  /// DELETE OFFER
  void deleteOffer(int index) {
    offers.removeAt(index);
  }

  /// DELETE PRODUCT FROM OFFER
  void deleteProduct(int offerIndex, int productIndex) {
    offers[offerIndex].products.removeAt(productIndex);
    offers.refresh();
  }
}

/// =====================
/// PAGE
/// =====================
class MerchantOfferViewPage extends StatelessWidget {
  MerchantOfferViewPage({super.key});

  final MerchantOfferController controller = Get.put(MerchantOfferController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: _buildAppBar(),
      body: Obx(() {
        if (controller.offers.isEmpty) {
          return _buildEmptyState();
        }
        return _buildOffersList();
      }),
      floatingActionButton: _buildFloatingActionButton(),
    );
  }

  /// =====================
  /// APP BAR
  /// =====================
  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      title: Text(
        "My Offers",
        style: AppTextStyle.rTextNunitoWhite17w700,
      ),
      backgroundColor: AppColors.kPrimary,
      elevation: 0,
      centerTitle: false,
    );
  }

  /// =====================
  /// FLOATING ACTION BUTTON
  /// =====================
  Widget _buildFloatingActionButton() {
    return FloatingActionButton.extended(
      onPressed: () => Get.to(() => AddOfferProductPage()),
      backgroundColor: AppColors.kPrimary,
      elevation: 4,
      icon: const Icon(Icons.add, color: Colors.white),
      label: const Text(
        "Create Offer",
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w600,
          fontSize: 15,
        ),
      ),
    );
  }

  /// =====================
  /// EMPTY STATE
  /// =====================
  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(32),
            decoration: BoxDecoration(
              color: AppColors.kPrimary.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.local_offer_outlined,
              size: 80,
              color: AppColors.kPrimary,
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            "No offers yet",
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w700,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            "Create your first offer to attract more customers",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 15,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 32),
          ElevatedButton.icon(
            onPressed: () => Get.to(() => AddOfferProductPage()),
            icon: const Icon(Icons.add, size: 20),
            label: const Text(
              "Create Your First Offer",
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.kPrimary,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 16),
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// =====================
  /// OFFERS LIST
  /// =====================
  Widget _buildOffersList() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: controller.offers.length,
      itemBuilder: (context, index) {
        final offer = controller.offers[index];
        return _buildOfferCard(context, offer, index);
      },
    );
  }

  /// =====================
  /// OFFER CARD
  /// =====================
  Widget _buildOfferCard(BuildContext context, MerchantOffer offer, int index) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 15,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// BANNER SECTION
          _buildBannerSection(context, offer, index),

          /// CONTENT SECTION
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// OFFER NAME & TYPE
                _buildOfferHeader(offer),

                const SizedBox(height: 20),

                /// DIVIDER
                Container(
                  height: 1,
                  color: Colors.grey[200],
                ),

                const SizedBox(height: 20),

                /// PRODUCTS SECTION
                _buildProductsSection(context, offer, index),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// =====================
  /// BANNER SECTION
  /// =====================
  Widget _buildBannerSection(BuildContext context, MerchantOffer offer, int index) {
    return Stack(
      children: [
        /// BANNER IMAGE
        ClipRRect(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
          child: Container(
            height: 180,
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black.withOpacity(0.3),
                  Colors.transparent,
                ],
              ),
            ),
            child: Image.asset(
              offer.bannerImage,
              fit: BoxFit.cover,
            ),
          ),
        ),

        /// DELETE BUTTON
        Positioned(
          top: 12,
          right: 12,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.15),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () => _showDeleteOfferDialog(context, index),
                borderRadius: BorderRadius.circular(50),
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Icon(
                    Icons.delete_outline,
                    color: Colors.red[600],
                    size: 22,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  /// =====================
  /// OFFER HEADER
  /// =====================
  Widget _buildOfferHeader(MerchantOffer offer) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        /// OFFER NAME
        Text(
          offer.offerName,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: Colors.black87,
            height: 1.2,
          ),
        ),

        const SizedBox(height: 10),

        /// OFFER TYPE BADGE
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                AppColors.kPrimary,
                AppColors.kPrimary.withOpacity(0.8),
              ],
            ),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: AppColors.kPrimary.withOpacity(0.3),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.local_offer,
                color: Colors.white,
                size: 16,
              ),
              const SizedBox(width: 6),
              Text(
                offer.offerType,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  /// =====================
  /// PRODUCTS SECTION
  /// =====================
  Widget _buildProductsSection(BuildContext context, MerchantOffer offer, int offerIndex) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        /// PRODUCTS HEADER
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.kPrimary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                Icons.shopping_bag_outlined,
                size: 18,
                color: AppColors.kPrimary,
              ),
            ),
            const SizedBox(width: 10),
            Text(
              "Products",
              style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 16,
                color: Colors.grey[800],
              ),
            ),
            const SizedBox(width: 6),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                "${offer.products.length}",
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: Colors.grey[700],
                ),
              ),
            ),
          ],
        ),

        const SizedBox(height: 16),

        /// PRODUCTS LIST
        ...List.generate(
          offer.products.length,
              (pIndex) => _buildProductItem(
            context,
            offer.products[pIndex],
            offerIndex,
            pIndex,
          ),
        ),
      ],
    );
  }

  /// =====================
  /// PRODUCT ITEM
  /// =====================
  Widget _buildProductItem(
      BuildContext context,
      MerchantOfferProduct product,
      int offerIndex,
      int productIndex,
      ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Row(
        children: [
          /// PRODUCT IMAGE
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 6,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.asset(
                product.image,
                fit: BoxFit.cover,
              ),
            ),
          ),

          const SizedBox(width: 14),

          /// PRODUCT INFO
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.name,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 15,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 6),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.kPrimary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    "₹ ${product.price.toStringAsFixed(0)}",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: AppColors.kPrimary,
                    ),
                  ),
                ),
              ],
            ),
          ),

          /// DELETE BUTTON
          Material(
            color: Colors.red[50],
            borderRadius: BorderRadius.circular(10),
            child: InkWell(
              onTap: () => _showDeleteProductDialog(
                context,
                offerIndex: offerIndex,
                productIndex: productIndex,
              ),
              borderRadius: BorderRadius.circular(10),
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Icon(
                  Icons.close_rounded,
                  color: Colors.red[600],
                  size: 20,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// =====================
  /// DIALOGS
  /// =====================
  void _showDeleteOfferDialog(BuildContext context, int index) {
    Get.defaultDialog(
      title: "Delete Offer?",
      titleStyle: const TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w700,
      ),
      middleText: "This action cannot be undone. The offer and all its products will be permanently deleted.",
      middleTextStyle: TextStyle(fontSize: 14, color: Colors.grey[700]),
      radius: 16,
      textCancel: "Cancel",
      textConfirm: "Delete",
      confirmTextColor: Colors.white,
      cancelTextColor: Colors.grey[700],
      buttonColor: Colors.red[600],
      barrierDismissible: false,
      onConfirm: () {
        controller.deleteOffer(index);
        Get.back();
        Get.snackbar(
          "Deleted",
          "Offer has been deleted successfully",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green[600],
          colorText: Colors.white,
          margin: const EdgeInsets.all(16),
          borderRadius: 12,
          icon: const Icon(Icons.check_circle, color: Colors.white),
          duration: const Duration(seconds: 2),
        );
      },
    );
  }

  void _showDeleteProductDialog(
      BuildContext context, {
        required int offerIndex,
        required int productIndex,
      }) {
    Get.defaultDialog(
      title: "Remove Product?",
      titleStyle: const TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w700,
      ),
      middleText: "This product will be removed from the offer.",
      middleTextStyle: TextStyle(fontSize: 14, color: Colors.grey[700]),
      radius: 16,
      textCancel: "Cancel",
      textConfirm: "Remove",
      confirmTextColor: Colors.white,
      cancelTextColor: Colors.grey[700],
      buttonColor: Colors.orange[600],
      barrierDismissible: false,
      onConfirm: () {
        controller.deleteProduct(offerIndex, productIndex);
        Get.back();
        Get.snackbar(
          "Removed",
          "Product removed from offer",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.orange[600],
          colorText: Colors.white,
          margin: const EdgeInsets.all(16),
          borderRadius: 12,
          icon: const Icon(Icons.remove_circle, color: Colors.white),
          duration: const Duration(seconds: 2),
        );
      },
    );
  }
}