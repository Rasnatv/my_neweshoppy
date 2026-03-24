//
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import '../../../common/style/app_colors.dart';
// import '../../../data/models/categoryshoplistmodel.dart';
// import '../view/shopview.dart';
//
// class Shopscard extends StatefulWidget {
//   final ShoplistModel shop;
//   const Shopscard({super.key, required this.shop});
//
//   @override
//   State<Shopscard> createState() => _ShopscardState();
// }
//
// class _ShopscardState extends State<Shopscard> {
//   bool _pressed = false;
//
//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: () => Get.to(
//             () => ShopDetailPage(merchantId: widget.shop.merchantId),
//         transition: Transition.fadeIn,
//         duration: const Duration(milliseconds: 280),
//       ),
//       onTapDown: (_) => setState(() => _pressed = true),
//       onTapUp: (_) => setState(() => _pressed = false),
//       onTapCancel: () => setState(() => _pressed = false),
//       child: AnimatedScale(
//         scale: _pressed ? 0.97 : 1.0,
//         duration: const Duration(milliseconds: 120),
//         curve: Curves.easeOut,
//         child: Container(
//           margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
//           padding: const EdgeInsets.all(12),
//           decoration: BoxDecoration(
//             color: Colors.white,
//             borderRadius: BorderRadius.circular(16),
//             border: Border.all(
//               color: AppColors.kPrimary.withOpacity(0.08),
//               width: 1,
//             ),
//             boxShadow: [
//               BoxShadow(
//                 color: AppColors.kPrimary.withOpacity(0.07),
//                 blurRadius: 16,
//                 offset: const Offset(0, 6),
//                 spreadRadius: -2,
//               ),
//               BoxShadow(
//                 color: Colors.black.withOpacity(0.04),
//                 blurRadius: 6,
//                 offset: const Offset(0, 2),
//               ),
//             ],
//           ),
//           child: Row(
//             children: [
//               // ── Shop image ─────────────────────────────────────────────
//               SizedBox(
//                 width: 56,
//                 height: 56,
//                 child: ClipRRect(
//                   borderRadius: BorderRadius.circular(14),
//                   child: Image.network(
//                     widget.shop.image,
//                     width: 56,
//                     height: 56,
//                     fit: BoxFit.cover,
//                     errorBuilder: (_, __, ___) => Container(
//                       width: 56,
//                       height: 56,
//                       decoration: BoxDecoration(
//                         color: AppColors.kPrimary.withOpacity(0.08),
//                         borderRadius: BorderRadius.circular(14),
//                       ),
//                       child: Icon(
//                         Icons.store_outlined,
//                         color: AppColors.kPrimary.withOpacity(0.5),
//                         size: 26,
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//
//               const SizedBox(width: 14),
//
//               // ── Shop info ──────────────────────────────────────────────
//               Expanded(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       widget.shop.shopName,
//                       maxLines: 1,
//                       overflow: TextOverflow.ellipsis,
//                       style: const TextStyle(
//                         fontSize: 14,
//                         fontWeight: FontWeight.w700,
//                         color: Color(0xFF1A1A2E),
//                         letterSpacing: 0.1,
//                       ),
//                     ),
//                     const SizedBox(height: 4),
//                     Row(
//                       children: [
//                         Icon(
//                           Icons.location_on_outlined,
//                           size: 12,
//                           color: AppColors.kPrimary.withOpacity(0.7),
//                         ),
//                         const SizedBox(width: 3),
//                         Expanded(
//                           child: Text(
//                             widget.shop.location,
//                             maxLines: 1,
//                             overflow: TextOverflow.ellipsis,
//                             style: TextStyle(
//                               fontSize: 12,
//                               fontWeight: FontWeight.w400,
//                               color: Colors.grey.shade500,
//                               letterSpacing: 0.1,
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),
//               ),
//
//               const SizedBox(width: 8),
//
//               // ── Arrow ──────────────────────────────────────────────────
//               Container(
//                 width: 32,
//                 height: 32,
//                 decoration: BoxDecoration(
//                   color: AppColors.kPrimary.withOpacity(0.08),
//                   borderRadius: BorderRadius.circular(10),
//                 ),
//                 child: Icon(
//                   Icons.arrow_forward_ios_rounded,
//                   size: 13,
//                   color: AppColors.kPrimary,
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../common/style/app_colors.dart';
import '../../../data/models/categoryshoplistmodel.dart';
import '../view/shopview.dart';

class Shopscard extends StatefulWidget {
  final ShoplistModel shop;
  const Shopscard({super.key, required this.shop});

  @override
  State<Shopscard> createState() => _ShopscardState();
}

class _ShopscardState extends State<Shopscard> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Get.to(
            () => ShopDetailPage(merchantId: widget.shop.merchantId),
        transition: Transition.fadeIn,
        duration: const Duration(milliseconds: 280),
      ),
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) => setState(() => _pressed = false),
      onTapCancel: () => setState(() => _pressed = false),
      child: AnimatedScale(
        scale: _pressed ? 0.975 : 1.0,
        duration: const Duration(milliseconds: 130),
        curve: Curves.easeOut,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 130),
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(22),
            boxShadow: _pressed
                ? [
              BoxShadow(
                color: AppColors.kPrimary.withOpacity(0.08),
                blurRadius: 6,
                offset: const Offset(0, 2),
              ),
            ]
                : [
              BoxShadow(
                color: AppColors.kPrimary.withOpacity(0.12),
                blurRadius: 28,
                offset: const Offset(0, 10),
                spreadRadius: -4,
              ),
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 8,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(22),
            child: Stack(
              children: [
                // ── Accent left bar ────────────────────────────────────
                Positioned(
                  left: 0,
                  top: 0,
                  bottom: 0,
                  child: Container(
                    width: 5,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          AppColors.kPrimary,
                          AppColors.kPrimary.withOpacity(0.35),
                        ],
                      ),
                    ),
                  ),
                ),

                // ── Card content ───────────────────────────────────────
                Padding(
                  padding: const EdgeInsets.fromLTRB(22, 18, 16, 18),
                  child: Row(
                    children: [
                      // ── Shop image ──────────────────────────────────
                      Container(
                        width: 76,
                        height: 76,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(18),
                          gradient: LinearGradient(
                            colors: [
                              AppColors.kPrimary.withOpacity(0.12),
                              AppColors.kPrimary.withOpacity(0.04),
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(18),
                          child: Image.network(
                            widget.shop.image,
                            width: 76,
                            height: 76,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => Center(
                              child: Icon(
                                Icons.storefront_rounded,
                                color: AppColors.kPrimary.withOpacity(0.55),
                                size: 32,
                              ),
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(width: 16),

                      // ── Shop info ───────────────────────────────────
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.shop.shopName,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.w700,
                                color: Color(0xFF0F172A),
                                letterSpacing: -0.3,
                                height: 1.2,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: AppColors.kPrimary.withOpacity(0.08),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(
                                        Icons.location_on_rounded,
                                        size: 11,
                                        color: Colors.red,
                                      ),
                                      const SizedBox(width: 4),
                                      ConstrainedBox(
                                        constraints: const BoxConstraints(
                                            maxWidth: 150),
                                        child: Text(
                                          widget.shop.location,
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w500,
                                            color: Colors.black
                                                .withOpacity(0.85),
                                            letterSpacing: 0.1,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(width: 12),

                      // ── Arrow button ────────────────────────────────
                      Container(
                        width: 42,
                        height: 42,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              AppColors.kPrimary,
                              AppColors.kPrimary.withOpacity(0.75),
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(14),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.kPrimary.withOpacity(0.35),
                              blurRadius: 12,
                              offset: const Offset(0, 5),
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.arrow_forward_ios_rounded,
                          size: 15,
                          color: Colors.white,
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
    );
  }
}