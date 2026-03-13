
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../../../common/style/app_colors.dart';
import '../../../data/models/merchant_offerbannermodel.dart';
import '../controller/merchant_offerbanner_controller.dart';
import 'merchant_createoffer.dart';
import 'merchant_offerproductview.dart';

class MerchantOfferViewPage extends StatelessWidget {
  MerchantOfferViewPage({super.key});

  final MerchantOfferBannerController controller =
  Get.put(MerchantOfferBannerController());

  // ── Colour tokens (CreateOfferPage palette) ───────────────────────────────

  static const _primaryUltra = Color(0xFFEEF2FF);
  static const _bg           = Color(0xFFF8F9FA);
  static const _surface      = Colors.white;
  static const _border       = Color(0xFFE5E7EB);
  static const _textPrimary  = Color(0xFF1A1A1A);
  static const _textMuted    = Color(0xFF9CA3AF);
  static const _textSecond   = Color(0xFF6B7280);
  static const _success      = Color(0xFF059669);
  static const _successBg    = Color(0xFFECFDF5);

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        backgroundColor: _bg,
        appBar: _appBar(),
        body: Obx(() {
          if (controller.isLoading.value) return _loadingView();
          if (controller.offer.isEmpty)   return _emptyView();
          return _body();
        }),
      ),
    );
  }

  // ── AppBar ────────────────────────────────────────────────────────────────
  PreferredSizeWidget _appBar() => AppBar(
    backgroundColor: AppColors.kPrimary,
    elevation: 0,
    systemOverlayStyle: SystemUiOverlayStyle.light,
    foregroundColor: Colors.white,
    title: const Text(
      'My Offers',
      style: TextStyle(
        fontWeight: FontWeight.w700,
        fontSize: 17,
      ),
    ),
    centerTitle: true,
    actions: [
      Padding(
        padding: const EdgeInsets.only(right: 16),
        child: Center(
          child: GestureDetector(
            onTap: () => Get.to(() => CreateOfferPage()),
            child: Container(
              padding: const EdgeInsets.symmetric(
                  horizontal: 14, vertical: 7),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Row(
                children: [
                  Icon(Icons.add_rounded, color: AppColors.kPrimary, size: 16),
                  SizedBox(width: 4),
                  Text(
                    'Add Offer',
                    style: TextStyle(
                      color:AppColors.kPrimary,
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    ],
  );

  // ── Body ──────────────────────────────────────────────────────────────────
  Widget _body() => RefreshIndicator(
    onRefresh: controller.fetchOffers,
    color:AppColors.kPrimary,
    child: SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Gradient header card (CreateOfferPage style)
          _buildHeaderCard(),
          const SizedBox(height: 24),

          // ── Section label
          _buildSectionLabel('Active Offers'),
          const SizedBox(height: 12),

          // ── Offer cards
          ...List.generate(
            controller.offer.length,
                (i) => Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: _buildOfferCard(controller.offer[i]),
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    ),
  );

  // ── Gradient header card ──────────────────────────────────────────────────
  Widget _buildHeaderCard() {
    return Obx(() {
      final count = controller.offer.length;
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color:AppColors.kPrimary,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: AppColors.kPrimary.withOpacity(0.3),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.local_offer_rounded,
                    color: Colors.white,
                    size: 28,
                  ),
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 14, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    '$count ${count == 1 ? 'Offer' : 'Offers'}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            const Text(
              'Your Offers',
              style: TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 6),
            const Text(
              'Manage your active promotions and attract more customers.',
              style: TextStyle(
                color: Colors.white70,
                fontSize: 13,
              ),
            ),
          ],
        ),
      );
    });
  }

  // ── Section label ─────────────────────────────────────────────────────────
  Widget _buildSectionLabel(String label) => Row(
    children: [
      Container(
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: AppColors.kPrimary.withOpacity(0.1),
          borderRadius: BorderRadius.circular(6),
        ),
        child: const Icon(Icons.discount_outlined,
            color: AppColors.kPrimary, size: 14),
      ),
      const SizedBox(width: 8),
      Text(
        label.toUpperCase(),
        style: const TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w700,
          color: _textMuted,
          letterSpacing: 0.9,
        ),
      ),
      const SizedBox(width: 10),
      const Expanded(
        child: Divider(color: _border, thickness: 1, height: 1),
      ),
    ],
  );

  // ── Offer card (wrapped in CreateOfferPage section-card style) ────────────
  Widget _buildOfferCard(MerchantOffersviewmodel offer) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: _surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Banner image
          _BannerSection(url: offer.offerBanner),

          // ── Card header row (icon + title style)
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 0),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.kPrimary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(Icons.local_offer_rounded,
                      color: AppColors.kPrimary, size: 20),
                ),
                const SizedBox(width: 12),
                Text(
                  'Offer #${offer.offerId}',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: _textPrimary,
                  ),
                ),
                const Spacer(),
                // Discount badge
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: _successBg,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                        color: _success.withOpacity(0.25)),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.percent_rounded,
                          size: 12, color: _success),
                      const SizedBox(width: 4),
                      Text(
                        'Flat ${offer.discountPercentage.toStringAsFixed(0)}% OFF',
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: _success,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // ── Divider
          const Padding(
            padding: EdgeInsets.fromLTRB(16, 14, 16, 0),
            child: Divider(
                color: Color(0xFFF1F5F4), height: 1, thickness: 1),
          ),

          // ── View Products button
          Padding(
            padding: const EdgeInsets.all(16),
            child: _ViewProductsButton(
              onTap: () => Get.to(
                    () => OfferProductScreen(offerId: offer.offerId),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── Loading ───────────────────────────────────────────────────────────────
  Widget _loadingView() => const Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CircularProgressIndicator(
            color: AppColors.kPrimary, strokeWidth: 2.5),
        SizedBox(height: 18),
        Text(
          'Loading offers…',
          style: TextStyle(color: _textMuted, fontSize: 14),
        ),
      ],
    ),
  );

  // ── Empty ─────────────────────────────────────────────────────────────────
  Widget _emptyView() => Center(
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color:AppColors.kPrimary,
              boxShadow: [
                BoxShadow(
                  color: AppColors.kPrimary,
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: const Icon(
              Icons.local_offer_outlined,
              size: 48,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            'No Offers Yet',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w800,
              color: _textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Create your first offer to start attracting customers.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 13,
              color: _textMuted,
              height: 1.55,
            ),
          ),
          const SizedBox(height: 28),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () => Get.to(() => CreateOfferPage()),
              icon: const Icon(Icons.add_rounded,
                  size: 18, color: Colors.white),
              label: const Text(
                'Create Your First Offer',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                  fontSize: 15,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.kPrimary,
                padding: const EdgeInsets.symmetric(vertical: 16),
                elevation: 4,
                shadowColor: AppColors.kPrimary.withOpacity(0.4),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
            ),
          ),
        ],
      ),
    ),
  );
}

// ─────────────────────────────────────────────────────────────────────────────
//  Banner Section
// ─────────────────────────────────────────────────────────────────────────────
class _BannerSection extends StatelessWidget {
  const _BannerSection({required this.url});
  final String url;

  @override
  Widget build(BuildContext context) {
    if (url.isEmpty) return _placeholder(const _PlaceholderContent());
    return Image.network(
      url,
      height: 175,
      width: double.infinity,
      fit: BoxFit.cover,
      loadingBuilder: (_, child, progress) {
        if (progress == null) return child;
        return _placeholder(
          const CircularProgressIndicator(
              strokeWidth: 2, color: Color(0xFF6366F1)),
        );
      },
      errorBuilder: (_, __, ___) =>
          _placeholder(const _PlaceholderContent(error: true)),
    );
  }

  Widget _placeholder(Widget child) => Container(
    height: 175,
    width: double.infinity,
    color: const Color(0xFFEEF2FF),
    child: Center(child: child),
  );
}

class _PlaceholderContent extends StatelessWidget {
  const _PlaceholderContent({this.error = false});
  final bool error;

  @override
  Widget build(BuildContext context) => Column(
    mainAxisSize: MainAxisSize.min,
    children: [
      Icon(
        error
            ? Icons.broken_image_outlined
            : Icons.image_outlined,
        size: 36,
        color: const Color(0xFF9CA3AF),
      ),
      const SizedBox(height: 4),
      Text(
        error ? 'Image unavailable' : 'No banner image',
        style: const TextStyle(
            fontSize: 11, color: Color(0xFF9CA3AF)),
      ),
    ],
  );
}

// ─────────────────────────────────────────────────────────────────────────────
//  View Products Button  (press-scale + indigo gradient)
// ─────────────────────────────────────────────────────────────────────────────
class _ViewProductsButton extends StatefulWidget {
  const _ViewProductsButton({required this.onTap});
  final VoidCallback onTap;

  @override
  State<_ViewProductsButton> createState() => _ViewProductsButtonState();
}

class _ViewProductsButtonState extends State<_ViewProductsButton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 110),
      lowerBound: 0.0,
      upperBound: 1.0,
    );
    _scale = Tween<double>(begin: 1.0, end: 0.97)
        .animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeOut));
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => _ctrl.forward(),
      onTapUp: (_) {
        _ctrl.reverse();
        widget.onTap();
      },
      onTapCancel: () => _ctrl.reverse(),
      child: AnimatedBuilder(
        animation: _scale,
        builder: (_, child) =>
            Transform.scale(scale: _scale.value, child: child),
        child: Container(
          width: double.infinity,
          height: 50,
          decoration: BoxDecoration(
            color:AppColors.kPrimary,
            borderRadius: BorderRadius.circular(14),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF6366F1).withOpacity(0.4),
                blurRadius: 12,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.grid_view_rounded,
                    color: Colors.white, size: 15),
              ),
              const SizedBox(width: 10),
              const Text(
                'View Products',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.3,
                ),
              ),
              const SizedBox(width: 8),
              const Icon(Icons.arrow_forward_ios_rounded,
                  color: Colors.white54, size: 12),
            ],
          ),
        ),
      ),
    );
  }
}