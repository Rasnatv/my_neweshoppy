import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../data/models/user_category model.dart';
import '../../../common/style/app_colors.dart';
import '../controller/company_controller.dart';
import '../controller/usercategory_controller.dart';
import '../view/categoriesofshoplist.dart';

class CategorySection extends StatelessWidget {
  CategorySection({super.key});

  final UserCategoryController controller = Get.put(UserCategoryController());

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      // ---------- LOADING ----------
      if (controller.isLoading.value) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 40),
          child: Center(
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: AppColors.kPrimary,
            ),
          ),
        );
      }

      // ---------- EMPTY ----------
      if (controller.categories.isEmpty) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 40),
          child: Center(
            child: Column(
              children: [
                Icon(Icons.grid_view_rounded,
                    size: 36, color: Colors.grey.shade300),
                const SizedBox(height: 10),
                Text(
                  "No categories available",
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

      // ---------- GRID ----------
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: controller.categories.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4,
            mainAxisSpacing: 20,
            crossAxisSpacing: 12,
            childAspectRatio: 0.58,
          ),
          itemBuilder: (context, index) {
            final UserCategoryModel cat = controller.categories[index];

            return _CategoryCard(
              category: cat,
              index: index,
              onTap: () {
                final companyController = Get.put(CompanyController());
                companyController.clearShops();
                companyController.fetchShopsByCategory(cat.id);
                Get.to(
                      () => const Categoriesofshoplist(),
                  transition: Transition.fadeIn,
                  duration: const Duration(milliseconds: 280),
                );
              },
            );
          },
        ),
      );
    });
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Category Card
// ─────────────────────────────────────────────────────────────────────────────
class _CategoryCard extends StatefulWidget {
  final UserCategoryModel category;
  final VoidCallback onTap;
  final int index;

  const _CategoryCard({
    required this.category,
    required this.onTap,
    required this.index,
  });

  @override
  State<_CategoryCard> createState() => _CategoryCardState();
}

class _CategoryCardState extends State<_CategoryCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _scale;
  late Animation<double> _fade;
  late Animation<Offset> _slide;

  bool _pressed = false;

  @override
  void initState() {
    super.initState();

    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 450),
    );

    // Staggered entrance based on index
    final delay = (widget.index * 0.06).clamp(0.0, 0.6);
    final end = (delay + 0.45).clamp(0.0, 1.0);

    _fade = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _ctrl,
        curve: Interval(delay, end, curve: Curves.easeOut),
      ),
    );

    _slide = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _ctrl,
        curve: Interval(delay, end, curve: Curves.easeOutCubic),
      ),
    );

    _scale = Tween<double>(begin: 0.85, end: 1).animate(
      CurvedAnimation(
        parent: _ctrl,
        curve: Interval(delay, end, curve: Curves.easeOutBack),
      ),
    );

    _ctrl.forward();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  void _onTapDown(_) => setState(() => _pressed = true);
  void _onTapUp(_) => setState(() => _pressed = false);
  void _onTapCancel() => setState(() => _pressed = false);

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fade,
      child: SlideTransition(
        position: _slide,
        child: ScaleTransition(
          scale: _scale,
          child: GestureDetector(
            onTap: widget.onTap,
            onTapDown: _onTapDown,
            onTapUp: _onTapUp,
            onTapCancel: _onTapCancel,
            child: AnimatedScale(
              scale: _pressed ? 0.93 : 1.0,
              duration: const Duration(milliseconds: 120),
              curve: Curves.easeOut,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // ── Icon bubble ──────────────────────────────────────────
                  Container(
                    height: 100,
                    width: 100,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: AppColors.kPrimary.withOpacity(0.10),
                        width: 1.5,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.kPrimary.withOpacity(0.10),
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
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(18),
                      child: Padding(
                        padding: const EdgeInsets.all(10),
                        child: Image.network(
                          widget.category.image,
                          fit: BoxFit.contain,
                          errorBuilder: (_, __, ___) => Icon(
                            Icons.category_outlined,
                            color: AppColors.kPrimary.withOpacity(0.5),
                            size: 26,
                          ),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 9),

                  // ── Label ────────────────────────────────────────────────
                  Text(
                    widget.category.name,
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF1A1A2E),
                      height: 1.3,
                      letterSpacing: 0.1,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
