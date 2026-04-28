import 'package:eshoppy/app/common/style/app_colors.dart';
import 'package:eshoppy/app/widgets/networkconnection_checkpage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../data/models/admin_offerviewmodel.dart';
import '../controller/admin_viewoffercontroller.dart';


class OffersListingScreen extends StatelessWidget {
  const OffersListingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final AdminViewOfferController controller = Get.put(AdminViewOfferController());

    return NetworkAwareWrapper(child:Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      appBar: _buildAppBar(controller),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const _LoadingView();
        }
        if (controller.hasError.value) {
          return _ErrorView(
            message: controller.errorMessage.value,
            onRetry: controller.refreshOffers,
          );
        }
        if (controller.offers.isEmpty) {
          return const _EmptyView();
        }
        return _OffersContent(controller: controller);
      }),
    ));
  }

  PreferredSizeWidget _buildAppBar(AdminViewOfferController controller) {
    return AppBar(
      elevation: 0,
      backgroundColor: AppColors.kPrimary,
     iconTheme: IconThemeData(color: Colors.white),
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Offers Management',
            style: TextStyle(
              color: Colors.white,
              fontSize: 17,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.1,
            ),
          ),
          Obx(() => Text(
            '${controller.totalOffers} active offers',
            style: const TextStyle(
              fontSize: 12,
              color: Color(0xFF9CA3AF),
              fontWeight: FontWeight.w400,
            ),
          )),
        ],
      ),
      actions: [
        Obx(() => IconButton(
          icon: controller.isLoading.value
              ? const SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: Color(0xFF6366F1),
            ),
          )
              : const Icon(Icons.refresh_rounded),
          onPressed: controller.isLoading.value
              ? null
              : controller.refreshOffers,
          tooltip: 'Refresh',
        )),
        const SizedBox(width: 8),
      ],
    );
  }
}

// ─────────────────────────────────────────────
// Main Content
// ─────────────────────────────────────────────

class _OffersContent extends StatelessWidget {
  final AdminViewOfferController controller;
  const _OffersContent({required this.controller});

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      color: const Color(0xFF6366F1),
      onRefresh: controller.refreshOffers,
      child: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: _StatsRow(controller: controller),
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            sliver: Obx(() {
              final grouped = controller.groupedOffers;
              final shops = grouped.keys.toList();
              return SliverList(
                delegate: SliverChildBuilderDelegate(
                      (context, index) {
                    final shopName = shops[index];
                    final shopOffers = grouped[shopName]!;
                    return _ShopSection(
                      shopName: shopName,
                      offers: shopOffers,
                    );
                  },
                  childCount: shops.length,
                ),
              );
            }),
          ),
          const SliverPadding(padding: EdgeInsets.only(bottom: 24)),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
// Stats Row
// ─────────────────────────────────────────────

class _StatsRow extends StatelessWidget {
  final AdminViewOfferController controller;
  const _StatsRow({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final maxDiscount = controller.offers.isEmpty
          ? 0.0
          : controller.offers
          .map((o) => double.tryParse(o.discountPercentage) ?? 0.0)
          .reduce((a, b) => a > b ? a : b);

      return Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
        child: Row(
          children: [
            _StatCard(
              label: 'Total Offers',
              value: '${controller.totalOffers}',
              icon: Icons.local_offer_rounded,
              color: const Color(0xFF6366F1),
            ),
            const SizedBox(width: 12),
            _StatCard(
              label: 'Shops',
              value: '${controller.shopNames.length}',
              icon: Icons.storefront_rounded,
              color: const Color(0xFF10B981),
            ),
            const SizedBox(width: 12),
            _StatCard(
              label: 'Max Discount',
              value: '${maxDiscount.toStringAsFixed(0)}%',
              icon: Icons.trending_up_rounded,
              color: const Color(0xFFF59E0B),
            ),
          ],
        ),
      );
    });
  }
}

class _StatCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color color;

  const _StatCard({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: color.withOpacity(0.12),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: color, size: 16),
            ),
            const SizedBox(height: 8),
            Text(
              value,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w800,
                color: Color(0xFF1A1D26),
              ),
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: const TextStyle(
                fontSize: 11,
                color: Color(0xFF9CA3AF),
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
// Shop Section
// ─────────────────────────────────────────────

class _ShopSection extends StatelessWidget {
  final String shopName;
  final List<AdminViewOfferModel> offers;

  const _ShopSection({
    required this.shopName,
    required this.offers,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 20),
        Row(
          children: [
            const Icon(
              Icons.storefront_rounded,
              size: 16,
              color: Color(0xFF6366F1),
            ),
            const SizedBox(width: 6),
            Text(
              shopName,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w700,
                color: Color(0xFF1A1D26),
              ),
            ),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: const Color(0xFF6366F1).withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                '${offers.length} offers',
                style: const TextStyle(
                  fontSize: 11,
                  color: Color(0xFF6366F1),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        ...offers.map((offer) => _OfferCard(offer: offer)),
      ],
    );
  }
}

// ─────────────────────────────────────────────
// Offer Card
// ─────────────────────────────────────────────

class _OfferCard extends StatelessWidget {
  final AdminViewOfferModel offer;
  const _OfferCard({required this.offer});

  Color get _discountColor {
    final pct = double.tryParse(offer.discountPercentage) ?? 0;
    if (pct >= 25) return const Color(0xFF10B981);
    if (pct >= 10) return const Color(0xFFF59E0B);
    return const Color(0xFF6366F1);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 12,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Banner Image
            Stack(
              children: [
                SizedBox(
                  width: double.infinity,
                  height: 160,
                  child: Image.network(
                    offer.offerBanner,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                      color: const Color(0xFFEEF0F5),
                      child: const Center(
                        child: Icon(
                          Icons.image_not_supported_outlined,
                          color: Color(0xFFD1D5DB),
                          size: 40,
                        ),
                      ),
                    ),
                    loadingBuilder: (_, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return Container(
                        color: const Color(0xFFEEF0F5),
                        child: const Center(
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Color(0xFF6366F1),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                // Discount Badge
                Positioned(
                  top: 10,
                  right: 10,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: _discountColor,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: _discountColor.withOpacity(0.4),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Text(
                      '${double.tryParse(offer.discountPercentage)?.toStringAsFixed(0)}% OFF',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                ),
              ],
            ),

            // Card Footer
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          offer.shopName,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF1A1D26),
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'Offer ID: #${offer.offerId}',
                          style: const TextStyle(
                            fontSize: 12,
                            color: Color(0xFF9CA3AF),
                          ),
                        ),
                      ],
                    ),
                  ),
                  GestureDetector(
                  onTap: () => Get.toNamed('/offer-products', arguments: offer.offerId),child:Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: _discountColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: _discountColor.withOpacity(0.3),
                      ),
                    ),
                    child: Text(
                      'View Products',
                      style: TextStyle(
                        color: _discountColor,
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  )],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
// State Views
// ─────────────────────────────────────────────

class _LoadingView extends StatelessWidget {
  const _LoadingView();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircularProgressIndicator(color: Color(0xFF6366F1)),
          SizedBox(height: 16),
          Text(
            'Loading offers...',
            style: TextStyle(color: Color(0xFF9CA3AF), fontSize: 14),
          ),
        ],
      ),
    );
  }
}

class _ErrorView extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _ErrorView({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFFFEE2E2),
                borderRadius: BorderRadius.circular(50),
              ),
              child: const Icon(
                Icons.error_outline_rounded,
                color: Color(0xFFEF4444),
                size: 40,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Failed to load offers',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: Color(0xFF1A1D26),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 13,
                color: Color(0xFF9CA3AF),
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh_rounded, size: 18),
              label: const Text('Try Again'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF6366F1),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                    horizontal: 24, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _EmptyView extends StatelessWidget {
  const _EmptyView();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.local_offer_outlined,
              size: 64, color: Color(0xFFD1D5DB)),
          SizedBox(height: 16),
          Text(
            'No offers available',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Color(0xFF6B7280),
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Add new offers to see them here.',
            style: TextStyle(fontSize: 13, color: Color(0xFF9CA3AF)),
          ),
        ],
      ),
    );
  }
}