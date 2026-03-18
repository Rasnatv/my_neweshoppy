
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../common/style/app_colors.dart';
import '../controller/user_offer_controller.dart';
import '../view/user_offerproductlistpage.dart';

// class UserOfferSection extends StatelessWidget {
//   UserOfferSection({super.key});
//
//   final UserOfferController controller = Get.put(UserOfferController());
//
//   @override
//   Widget build(BuildContext context) {
//     return SliverToBoxAdapter(
//       child: GetX<UserOfferController>(
//         builder: (controller) {
//           // ---------- LOADING ----------
//           if (controller.isLoading.value) {
//             return SizedBox(
//               height: 200,
//               child: Center(
//                 child: CircularProgressIndicator(
//                   strokeWidth: 2,
//                   color: AppColors.kPrimary,
//                 ),
//               ),
//             );
//           }
//
//           // ---------- EMPTY ----------
//           if (controller.offerList.isEmpty) {
//             return Padding(
//               padding: const EdgeInsets.symmetric(vertical: 40),
//               child: Center(
//                 child: Column(
//                   children: [
//                     Icon(Icons.local_offer_outlined,
//                         size: 36, color: Colors.grey.shade300),
//                     const SizedBox(height: 10),
//                     Text(
//                       "No offers available",
//                       style: TextStyle(
//                         fontSize: 13,
//                         color: Colors.grey.shade400,
//                         fontWeight: FontWeight.w500,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             );
//           }
//
//           // ---------- LIST ----------
//           return SizedBox(
//             height: 210,
//             child: ListView.builder(
//               scrollDirection: Axis.horizontal,
//               padding: const EdgeInsets.symmetric(horizontal: 20),
//               itemCount: controller.offerList.length,
//               itemBuilder: (context, index) {
//                 final offer = controller.offerList[index];
//                 return _OfferCard(offer: offer, index: index);
//               },
//             ),
//           );
//         },
//       ),
//     );
//   }
// }
//
// // ─────────────────────────────────────────────────────────────────────────────
// // Offer Card
// // ─────────────────────────────────────────────────────────────────────────────
// class _OfferCard extends StatefulWidget {
//   final dynamic offer;
//   final int index;
//
//   const _OfferCard({required this.offer, required this.index});
//
//   @override
//   State<_OfferCard> createState() => _OfferCardState();
// }
//
// class _OfferCardState extends State<_OfferCard>
//     with SingleTickerProviderStateMixin {
//   late AnimationController _ctrl;
//   late Animation<double> _fade;
//   late Animation<Offset> _slide;
//
//   bool _pressed = false;
//
//   @override
//   void initState() {
//     super.initState();
//
//     _ctrl = AnimationController(
//       vsync: this,
//       duration: const Duration(milliseconds: 500),
//     );
//
//     final delay = (widget.index * 0.15).clamp(0.0, 0.6);
//     final end   = (delay + 0.5).clamp(0.0, 1.0);
//
//     _fade = Tween<double>(begin: 0, end: 1).animate(
//       CurvedAnimation(
//         parent: _ctrl,
//         curve: Interval(delay, end, curve: Curves.easeOut),
//       ),
//     );
//     _slide = Tween<Offset>(
//       begin: const Offset(0.15, 0),
//       end: Offset.zero,
//     ).animate(
//       CurvedAnimation(
//         parent: _ctrl,
//         curve: Interval(delay, end, curve: Curves.easeOutCubic),
//       ),
//     );
//
//     _ctrl.forward();
//   }
//
//   @override
//   void dispose() {
//     _ctrl.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return FadeTransition(
//       opacity: _fade,
//       child: SlideTransition(
//         position: _slide,
//         child: Padding(
//           padding: const EdgeInsets.only(right: 16),
//           child: GestureDetector(
//             onTap: () => Get.to(
//                   () => UserOfferProductPage(
//                   offer_id: widget.offer.offer_id.toString()),
//               transition: Transition.fadeIn,
//               duration: const Duration(milliseconds: 280),
//             ),
//             onTapDown: (_) => setState(() => _pressed = true),
//             onTapUp: (_) => setState(() => _pressed = false),
//             onTapCancel: () => setState(() => _pressed = false),
//             child: AnimatedScale(
//               scale: _pressed ? 0.97 : 1.0,
//               duration: const Duration(milliseconds: 130),
//               curve: Curves.easeOut,
//               child: Container(
//                 width: 300,
//                 decoration: BoxDecoration(
//                   borderRadius: BorderRadius.circular(22),
//                   boxShadow: [
//                     BoxShadow(
//                       color: AppColors.kPrimary.withOpacity(0.12),
//                       blurRadius: 20,
//                       offset: const Offset(0, 8),
//                       spreadRadius: -4,
//                     ),
//                     BoxShadow(
//                       color: Colors.black.withOpacity(0.07),
//                       blurRadius: 8,
//                       offset: const Offset(0, 3),
//                     ),
//                   ],
//                 ),
//                 child: ClipRRect(
//                   borderRadius: BorderRadius.circular(22),
//                   child: Stack(
//                     children: [
//                       // ── Background image ─────────────────────────────────
//                       Positioned.fill(
//                         child: Image.network(
//                           widget.offer.image,
//                           fit: BoxFit.cover,
//                           errorBuilder: (_, __, ___) => Container(
//                             color: AppColors.kPrimary.withOpacity(0.08),
//                             child: Icon(
//                               Icons.store_outlined,
//                               size: 48,
//                               color: AppColors.kPrimary.withOpacity(0.3),
//                             ),
//                           ),
//                         ),
//                       ),
//
//                       // ── Gradient overlay ─────────────────────────────────
//                       Positioned.fill(
//                         child: DecoratedBox(
//                           decoration: BoxDecoration(
//                             gradient: LinearGradient(
//                               begin: Alignment.topCenter,
//                               end: Alignment.bottomCenter,
//                               colors: [
//                                 Colors.transparent,
//                                 Colors.black.withOpacity(0.55),
//                                 Colors.black.withOpacity(0.82),
//                               ],
//                               stops: const [0.3, 0.65, 1.0],
//                             ),
//                           ),
//                         ),
//                       ),
//
//                       // ── Discount badge ───────────────────────────────────
//                       Positioned(
//                         top: 14,
//                         left: 14,
//                         child: Container(
//                           padding: const EdgeInsets.symmetric(
//                               horizontal: 10, vertical: 5),
//                           decoration: BoxDecoration(
//                             color: Colors.orange,
//                             borderRadius: BorderRadius.circular(20),
//                             boxShadow: [
//                               BoxShadow(
//                                 color: AppColors.kPrimary.withOpacity(0.35),
//                                 blurRadius: 10,
//                                 offset: const Offset(0, 4),
//                               ),
//                             ],
//                           ),
//                           child: Row(
//                             mainAxisSize: MainAxisSize.min,
//                             children: [
//                               const Icon(
//                                 Icons.local_offer_rounded,
//                                 size: 11,
//                                 color: Colors.white,
//                               ),
//                               const SizedBox(width: 4),
//                               Text(
//                                 // ✅ FIXED: removes decimals — shows "30% OFF" not "30.00% OFF"
//                                 "${double.parse(widget.offer.discountPercentage.toString()).toInt()}% OFF",
//                                 style: const TextStyle(
//                                   color: Colors.white,
//                                   fontSize: 11,
//                                   fontWeight: FontWeight.w700,
//                                   letterSpacing: 0.3,
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                       ),
//
//                       // ── Bottom content ───────────────────────────────────
//                       Positioned(
//                         left: 16,
//                         right: 16,
//                         bottom: 16,
//                         child: Row(
//                           crossAxisAlignment: CrossAxisAlignment.end,
//                           children: [
//                             // Shop name + label
//                             Expanded(
//                               child: Column(
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 mainAxisSize: MainAxisSize.min,
//                                 children: [
//                                   Text(
//                                     widget.offer.shopName,
//                                     maxLines: 1,
//                                     overflow: TextOverflow.ellipsis,
//                                     style: const TextStyle(
//                                       color: Colors.white,
//                                       fontSize: 18,
//                                       fontWeight: FontWeight.w800,
//                                       letterSpacing: -0.3,
//                                       height: 1.1,
//                                     ),
//                                   ),
//                                   const SizedBox(height: 4),
//                                   Row(
//                                     children: [
//                                       Container(
//                                         width: 6,
//                                         height: 6,
//                                         decoration: BoxDecoration(
//                                           color: AppColors.kPrimary,
//                                           shape: BoxShape.circle,
//                                         ),
//                                       ),
//                                       const SizedBox(width: 5),
//                                       Text(
//                                         "Limited Time Offer",
//                                         style: TextStyle(
//                                           color: Colors.white.withOpacity(0.80),
//                                           fontSize: 11,
//                                           fontWeight: FontWeight.w500,
//                                           letterSpacing: 0.2,
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                 ],
//                               ),
//                             ),
//
//                             const SizedBox(width: 10),
//
//                             // Shop Now button
//                             Container(
//                               padding: const EdgeInsets.symmetric(
//                                   horizontal: 14, vertical: 9),
//                               decoration: BoxDecoration(
//                                 color: Colors.white,
//                                 borderRadius: BorderRadius.circular(12),
//                                 boxShadow: [
//                                   BoxShadow(
//                                     color: Colors.black.withOpacity(0.15),
//                                     blurRadius: 8,
//                                     offset: const Offset(0, 3),
//                                   ),
//                                 ],
//                               ),
//                               child: Row(
//                                 mainAxisSize: MainAxisSize.min,
//                                 children: [
//                                   Text(
//                                     "Shop Now",
//                                     style: TextStyle(
//                                       color: AppColors.kPrimary,
//                                       fontSize: 12,
//                                       fontWeight: FontWeight.w700,
//                                       letterSpacing: 0.2,
//                                     ),
//                                   ),
//                                   const SizedBox(width: 4),
//                                   Icon(
//                                     Icons.arrow_forward_rounded,
//                                     color: AppColors.kPrimary,
//                                     size: 13,
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }


class UserOfferSection extends StatelessWidget {
  UserOfferSection({super.key});

  final UserOfferController controller = Get.put(UserOfferController());

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: GetX<UserOfferController>(
        builder: (controller) {
          // ---------- LOADING ----------
          if (controller.isLoading.value) {
            return SizedBox(
              height: 210,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                itemCount: 3,
                itemBuilder: (_, i) => Padding(
                  padding: const EdgeInsets.only(right: 16),
                  child: Container(
                    width: 300,
                    height: 210,
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
            height: 210,
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

// ─────────────────────────────────────────────────────────────────────────────
// Offer Card
// ─────────────────────────────────────────────────────────────────────────────
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
                  offer_id: widget.offer.offer_id.toString()),
              transition: Transition.fadeIn,
              duration: const Duration(milliseconds: 280),
            ),
            onTapDown: (_) => setState(() => _pressed = true),
            onTapUp: (_) => setState(() => _pressed = false),
            onTapCancel: () => setState(() => _pressed = false),
            child: AnimatedScale(
              scale: _pressed ? 0.97 : 1.0,
              duration: const Duration(milliseconds: 130),
              curve: Curves.easeOut,
              child: Container(
                width: 300,
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
                      // ── Background image ──────────────────────────────
                      Positioned.fill(
                        child: Image.network(
                          widget.offer.image,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => Container(
                            color: AppColors.kPrimary.withOpacity(0.08),
                            child: Icon(
                              Icons.store_outlined,
                              size: 48,
                              color: AppColors.kPrimary.withOpacity(0.3),
                            ),
                          ),
                        ),
                      ),

                      // ── Gradient overlay ──────────────────────────────
                      Positioned.fill(
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Colors.transparent,
                                Colors.black.withOpacity(0.55),
                                Colors.black.withOpacity(0.82),
                              ],
                              stops: const [0.3, 0.65, 1.0],
                            ),
                          ),
                        ),
                      ),

                      // ── Discount badge ────────────────────────────────
                      Positioned(
                        top: 14,
                        left: 14,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 5),
                          decoration: BoxDecoration(
                            color: Colors.orange,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.kPrimary.withOpacity(0.35),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(
                                Icons.local_offer_rounded,
                                size: 11,
                                color: Colors.white,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                "${double.parse(widget.offer.discountPercentage.toString()).toInt()}% OFF",
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 11,
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: 0.3,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      // ── Bottom content ────────────────────────────────
                      Positioned(
                        left: 16,
                        right: 16,
                        bottom: 16,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            // Shop name + label
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
                                      fontSize: 18,
                                      fontWeight: FontWeight.w800,
                                      letterSpacing: -0.3,
                                      height: 1.1,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Row(
                                    children: [
                                      Container(
                                        width: 6,
                                        height: 6,
                                        decoration: BoxDecoration(
                                          color: AppColors.kPrimary,
                                          shape: BoxShape.circle,
                                        ),
                                      ),
                                      const SizedBox(width: 5),
                                      Text(
                                        "Limited Time Offer",
                                        style: TextStyle(
                                          color:
                                          Colors.white.withOpacity(0.80),
                                          fontSize: 11,
                                          fontWeight: FontWeight.w500,
                                          letterSpacing: 0.2,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),

                            const SizedBox(width: 10),

                            // Shop Now button
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 14, vertical: 9),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.15),
                                    blurRadius: 8,
                                    offset: const Offset(0, 3),
                                  ),
                                ],
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    "Shop Now",
                                    style: TextStyle(
                                      color: AppColors.kPrimary,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w700,
                                      letterSpacing: 0.2,
                                    ),
                                  ),
                                  const SizedBox(width: 4),
                                  Icon(
                                    Icons.arrow_forward_rounded,
                                    color: AppColors.kPrimary,
                                    size: 13,
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