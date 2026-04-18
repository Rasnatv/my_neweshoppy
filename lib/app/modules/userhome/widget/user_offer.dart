
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../common/style/app_colors.dart';
import '../controller/user_offer_controller.dart';
import '../view/user_offerproductlistpage.dart';

class UserOfferSection extends StatefulWidget {
  const UserOfferSection({super.key});

  @override
  State<UserOfferSection> createState() => _UserOfferSectionState();
}

class _UserOfferSectionState extends State<UserOfferSection> {
  late UserOfferController controller;

  @override
  void initState() {
    super.initState();
    controller = Get.put(UserOfferController());
    controller.refresh();
  }

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: GetX<UserOfferController>(
        builder: (controller) {

          // ---------- LOADING ----------
          if (controller.isLoading.value) {
            return SizedBox(
              height: 160, // ✅ FIXED
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                itemCount: 3,
                itemBuilder: (_, i) => Padding(
                  padding: const EdgeInsets.only(right: 16),
                  child: Container(
                    width: 300,
                    height: 160, // ✅ FIXED
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(22),
                    ),
                  ),
                ),
              ),
            );
          }

          // ---------- EMPTY ----------
          if (controller.offerList.isEmpty) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 40),
              child: Center(
                child: Column(
                  children: [
                    Icon(Icons.local_offer_outlined,
                        size: 36, color: Colors.grey.shade300),
                    const SizedBox(height: 10),
                    Text(
                      "No offers available",
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey.shade400,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }

          // ---------- LIST ----------
          return SizedBox(
            height: 160, // ✅ FIXED
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              itemCount: controller.offerList.length,
              itemBuilder: (context, index) {
                final offer = controller.offerList[index];
                return _OfferCard(offer: offer, index: index);
              },
            ),
          );
        },
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
// Offer Card
// ─────────────────────────────────────────────────────────────
class _OfferCard extends StatefulWidget {
  final dynamic offer;
  final int index;

  const _OfferCard({required this.offer, required this.index});

  @override
  State<_OfferCard> createState() => _OfferCardState();
}

class _OfferCardState extends State<_OfferCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _fade;
  late Animation<Offset> _slide;

  bool _pressed = false;

  @override
  void initState() {
    super.initState();

    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    final delay = (widget.index * 0.15).clamp(0.0, 0.6);
    final end = (delay + 0.5).clamp(0.0, 1.0);

    _fade = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _ctrl,
        curve: Interval(delay, end, curve: Curves.easeOut),
      ),
    );

    _slide = Tween<Offset>(
      begin: const Offset(0.15, 0),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _ctrl,
        curve: Interval(delay, end, curve: Curves.easeOutCubic),
      ),
    );

    _ctrl.forward();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fade,
      child: SlideTransition(
        position: _slide,
        child: Padding(
          padding: const EdgeInsets.only(right: 16),
          child: GestureDetector(
            onTap: () => Get.to(
                  () => UserOfferProductPage(
                  offer_id: widget.offer.offerId.toString()),
              transition: Transition.fadeIn,
              duration: const Duration(milliseconds: 280),
            ),
            onTapDown: (_) => setState(() => _pressed = true),
            onTapUp: (_) => setState(() => _pressed = false),
            onTapCancel: () => setState(() => _pressed = false),
            child: AnimatedScale(
              scale: _pressed ? 0.97 : 1.0,
              duration: const Duration(milliseconds: 130),
              child: Container(
                width: 300,
                height: 160, // ✅ FIXED
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(22),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.kPrimary.withOpacity(0.12),
                      blurRadius: 20,
                      offset: const Offset(0, 8),
                      spreadRadius: -4,
                    ),
                    BoxShadow(
                      color: Colors.black.withOpacity(0.07),
                      blurRadius: 8,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(22),
                  child: Stack(
                    children: [
                      Positioned.fill(
                        child: Image.network(
                          widget.offer.image,
                          fit: BoxFit.cover,
                        ),
                      ),

                      // Gradient
                      Positioned.fill(
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Colors.transparent,
                                Colors.black.withOpacity(0.55),
                                Colors.black.withOpacity(0.85),
                              ],
                            ),
                          ),
                        ),
                      ),

                      // Discount Badge
                      Positioned(
                        top: 12,
                        left: 12,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 5),
                          decoration: BoxDecoration(
                            color: Colors.orange,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            "${double.parse(widget.offer.discountPercentage.toString()).toInt()}% OFF",
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),

                      // Bottom Content (FIXED)
                      Positioned(
                        left: 14,
                        right: 14,
                        bottom: 12,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    widget.offer.shopName,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w800,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    "Limited Time Offer",
                                    style: TextStyle(
                                      color: Colors.white.withOpacity(0.8),
                                      fontSize: 11,
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            const SizedBox(width: 8),

                            // ✅ FIXED BUTTON
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 7),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Row(
                                children: [
                                  Text(
                                    "Shop Now",
                                    style: TextStyle(
                                      color: AppColors.kPrimary,
                                      fontSize: 11,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  const SizedBox(width: 4),
                                  Icon(
                                    Icons.arrow_forward_rounded,
                                    size: 12,
                                    color: AppColors.kPrimary,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}