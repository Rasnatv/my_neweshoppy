
import 'package:cached_network_image/cached_network_image.dart';
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
        duration: const Duration(milliseconds: 260),
      ),
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) => setState(() => _pressed = false),
      onTapCancel: () => setState(() => _pressed = false),
      child: AnimatedScale(
        scale: _pressed ? 0.985 : 1.0,
        duration: const Duration(milliseconds: 120),
        curve: Curves.easeOut,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 120),
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: _pressed
                  ? AppColors.kPrimary.withOpacity(0.25)
                  : const Color(0xFFE8ECF0),
              width: 1,
            ),
            boxShadow: _pressed
                ? []
                : [
              BoxShadow(
                color: Colors.black.withOpacity(0.06),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            child: Row(
              children: [
                // ── Shop Image ──────────────────────────────────────────
                Container(
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: const Color(0xFFF1F4F8),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: CachedNetworkImage(
                      imageUrl: widget.shop.image,
                      width: 64,
                      height: 64,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => Container(
                        color: const Color(0xFFF1F4F8),
                        child: const Center(
                          child: SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Color(0xFFCBD5E0),
                            ),
                          ),
                        ),
                      ),
                      errorWidget: (context, url, error) => Container(
                        color: const Color(0xFFF1F4F8),
                        child: const Center(
                          child: Icon(
                            Icons.storefront_outlined,
                            color: Color(0xFFADB5BD),
                            size: 28,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),

                const SizedBox(width: 14),

                // ── Shop Info ────────────────────────────────────────────
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.shop.shopName,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700, // was w600
                          color: Color(0xFF1A202C),
                          letterSpacing: -0.2,
                          height: 1.3,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Row(
                        children: [
                          const Icon(
                            Icons.location_on_outlined,
                            size: 13,
                            color: Color(0xFF9AA5B1),
                          ),
                          const SizedBox(width: 3),
                          Expanded(
                            child: Text(
                              widget.shop.location,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w500, // was w400
                                color: Color(0xFF6B7280),
                                letterSpacing: 0.1,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(width: 10),

                // ── Chevron ──────────────────────────────────────────────
                const Icon(
                  Icons.chevron_right_rounded,
                  size: 22,
                  color: Color(0xFFCBD5E0),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}