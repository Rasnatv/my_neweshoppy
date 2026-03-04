
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
        scale: _pressed ? 0.97 : 1.0,
        duration: const Duration(milliseconds: 120),
        curve: Curves.easeOut,
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: AppColors.kPrimary.withOpacity(0.08),
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: AppColors.kPrimary.withOpacity(0.07),
                blurRadius: 16,
                offset: const Offset(0, 6),
                spreadRadius: -2,
              ),
              BoxShadow(
                color: Colors.black.withOpacity(0.04),
                blurRadius: 6,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            children: [
              // ── Shop image ─────────────────────────────────────────────
              SizedBox(
                width: 56,
                height: 56,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(14),
                  child: Image.network(
                    widget.shop.image,
                    width: 56,
                    height: 56,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                      width: 56,
                      height: 56,
                      decoration: BoxDecoration(
                        color: AppColors.kPrimary.withOpacity(0.08),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Icon(
                        Icons.store_outlined,
                        color: AppColors.kPrimary.withOpacity(0.5),
                        size: 26,
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(width: 14),

              // ── Shop info ──────────────────────────────────────────────
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.shop.shopName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF1A1A2E),
                        letterSpacing: 0.1,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(
                          Icons.location_on_outlined,
                          size: 12,
                          color: AppColors.kPrimary.withOpacity(0.7),
                        ),
                        const SizedBox(width: 3),
                        Expanded(
                          child: Text(
                            widget.shop.location,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                              color: Colors.grey.shade500,
                              letterSpacing: 0.1,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 8),

              // ── Arrow ──────────────────────────────────────────────────
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: AppColors.kPrimary.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 13,
                  color: AppColors.kPrimary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}