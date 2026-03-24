
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../../product/controller/cartcontroller.dart';
import '../../product/view/cartscreen.dart';
import '../../restarunent/view/restarnent_list.dart';
import '../controller/district _controller.dart';
import '../controller/usercategory_controller.dart';
import '../widget/categorygrid.dart';
import '../widget/promotionbanner.dart';
import '../view/selectlocationpage.dart';
import '../view/user_eventsection.dart';
import '../widget/user_offer.dart';

const kPurplePrimary = Color(0xFF00796B);
const kPurpleMid     = Color(0xFF00796B);
const kPurpleLight   = Color(0xFF00796B);


class ShimmerBox extends StatefulWidget {
  final double width;
  final double height;
  final double borderRadius;
  const ShimmerBox({
    super.key,
    required this.width,
    required this.height,
    this.borderRadius = 12,
  });

  @override
  State<ShimmerBox> createState() => _ShimmerBoxState();
}

class _ShimmerBoxState extends State<ShimmerBox>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    )..repeat();
    _animation = Tween<double>(begin: -2, end: 2).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOutSine),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (_, __) {
        return Container(
          width: widget.width,
          height: widget.height,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(widget.borderRadius),
            gradient: LinearGradient(
              begin: Alignment(_animation.value - 1, 0),
              end: Alignment(_animation.value + 1, 0),
              colors: const [
                Color(0xFFE8E8E8),
                Color(0xFFF5F5F5),
                Color(0xFFFFFFFF),
                Color(0xFFF5F5F5),
                Color(0xFFE8E8E8),
              ],
            ),
          ),
        );
      },
    );
  }
}

// ─────────────────────────────────────────────
//  SHIMMER SKELETON — Full Page
// ─────────────────────────────────────────────
class HomeShimmerSkeleton extends StatelessWidget {
  const HomeShimmerSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      physics: const NeverScrollableScrollPhysics(),
      slivers: [

        // ── 1. HEADER ──────────────────────────────────────────────────────
        SliverToBoxAdapter(
          child: Container(
            decoration: const BoxDecoration(
              color: Colors.teal,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(28),
                bottomRight: Radius.circular(28),
              ),
            ),
            child: SafeArea(
              bottom: false,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(18, 10, 18, 20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              _whiteShimmer(80, 20, radius: 6),
                              const SizedBox(height: 6),
                              _whiteShimmer(150, 14, radius: 5),
                            ],
                          ),
                        ),
                        _whiteShimmer(40, 40, radius: 12),
                      ],
                    ),
                    const SizedBox(height: 16),
                    _whiteShimmer(double.infinity, 46, radius: 12),
                  ],
                ),
              ),
            ),
          ),
        ),

        const SliverToBoxAdapter(child: SizedBox(height: 24)),

        // ── 2. CAROUSEL ────────────────────────────────────────────────────
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: ShimmerBox(
                width: double.infinity, height: 170, borderRadius: 20),
          ),
        ),

        const SliverToBoxAdapter(child: SizedBox(height: 20)),

        // ── 3. CATEGORIES SECTION HEADER ───────────────────────────────────
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(children: [
                  ShimmerBox(width: 32, height: 32, borderRadius: 10),
                  const SizedBox(width: 10),
                  ShimmerBox(width: 100, height: 18, borderRadius: 6),
                ]),
                ShimmerBox(width: 55, height: 14, borderRadius: 6),
              ],
            ),
          ),
        ),

        const SliverToBoxAdapter(child: SizedBox(height: 16)),

        // ── 4. CATEGORIES GRID ─────────────────────────────────────────────
        SliverToBoxAdapter(
          child: SizedBox(
            height: 110,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              itemCount: 5,
              itemBuilder: (_, i) => Padding(
                padding: const EdgeInsets.only(right: 14),
                child: Column(
                  children: [
                    ShimmerBox(width: 62, height: 62, borderRadius: 18),
                    const SizedBox(height: 8),
                    ShimmerBox(width: 50, height: 11, borderRadius: 4),
                  ],
                ),
              ),
            ),
          ),
        ),

        const SliverToBoxAdapter(child: SizedBox(height: 20)),

        // ── 5. RESTAURANT BANNER ───────────────────────────────────────────
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: ShimmerBox(
                width: double.infinity, height: 165, borderRadius: 24),
          ),
        ),

        const SliverToBoxAdapter(child: SizedBox(height: 28)),

        // ── 6. EVENTS SECTION HEADER ───────────────────────────────────────
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(children: [
                  ShimmerBox(width: 32, height: 32, borderRadius: 10),
                  const SizedBox(width: 10),
                  ShimmerBox(width: 130, height: 18, borderRadius: 6),
                ]),
                ShimmerBox(width: 55, height: 14, borderRadius: 6),
              ],
            ),
          ),
        ),

        const SliverToBoxAdapter(child: SizedBox(height: 12)),

        // ── 7. EVENTS HORIZONTAL LIST ──────────────────────────────────────
        SliverToBoxAdapter(
          child: SizedBox(
            height: 140,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              itemCount: 4,
              itemBuilder: (_, i) => Padding(
                padding: const EdgeInsets.only(right: 14),
                child: ShimmerBox(width: 200, height: 140, borderRadius: 16),
              ),
            ),
          ),
        ),

        const SliverToBoxAdapter(child: SizedBox(height: 28)),

        // ── 8. HOT OFFERS SECTION HEADER ───────────────────────────────────
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(children: [
                  ShimmerBox(width: 32, height: 32, borderRadius: 10),
                  const SizedBox(width: 10),
                  ShimmerBox(width: 100, height: 18, borderRadius: 6),
                ]),
                ShimmerBox(width: 60, height: 14, borderRadius: 6),
              ],
            ),
          ),
        ),

        const SliverToBoxAdapter(child: SizedBox(height: 12)),

        // ── 9. HOT OFFERS HORIZONTAL LIST ─────────────────────────────────
        SliverToBoxAdapter(
          child: SizedBox(
            height: 210,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              itemCount: 3,
              itemBuilder: (_, i) => Padding(
                padding: const EdgeInsets.only(right: 16),
                child: ShimmerBox(width: 300, height: 210, borderRadius: 22),
              ),
            ),
          ),
        ),

        const SliverToBoxAdapter(child: SizedBox(height: 80)),
      ],
    );
  }

  Widget _whiteShimmer(double w, double h, {double radius = 8}) {
    return Container(
      width: w == double.infinity ? null : w,
      height: h,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.25),
        borderRadius: BorderRadius.circular(radius),
      ),
    );
  }
}

// ─────────────────────────────────────────────
//  MAIN HOME PAGE
// ─────────────────────────────────────────────
class Userhome extends StatefulWidget {
  const Userhome({super.key});

  @override
  State<Userhome> createState() => _UserhomeState();
}

class _UserhomeState extends State<Userhome> with TickerProviderStateMixin {
  bool _isLoading = true;
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _fadeAnimation =
        CurvedAnimation(parent: _fadeController, curve: Curves.easeIn);

    Future.delayed(const Duration(milliseconds: 2200), () {
      if (mounted) {
        setState(() => _isLoading = false);
        _fadeController.forward();
      }
    });
  }

  @override
  void dispose() {
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final userLocationController = Get.put(UserLocationController());
    final categoryController =
    Get.put(UserCategoryController(), permanent: true);
    final cartController = Get.put(CartController());

    return Scaffold(
      backgroundColor: const Color(0xFFF4F6F9),
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
        ),
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 500),
          child: _isLoading
              ? const HomeShimmerSkeleton()
              : FadeTransition(
            opacity: _fadeAnimation,
            child: _buildContent(
                context, userLocationController, cartController),
          ),
        ),
      ),
    );
  }

  Widget _buildContent(
      BuildContext context,
      UserLocationController userLocationController,
      CartController cartController,
      ) {
    return CustomScrollView(
      slivers: [
        SliverAppBar(
          pinned: true,
          expandedHeight: 160,
          backgroundColor: Colors.transparent,
          automaticallyImplyLeading: false,
          elevation: 0,
          flexibleSpace: FlexibleSpaceBar(
            background: _PurpleHeader(
              locationController: userLocationController,
              cartController: cartController,
            ),
          ),
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(0),
            child: Container(color: Colors.transparent),
          ),
        ),

        const SliverToBoxAdapter(child: SizedBox(height: 28)),
        SliverToBoxAdapter(child: HomeCarouselSlider()),
        const SliverToBoxAdapter(child: SizedBox(height: 20)),

        SliverToBoxAdapter(
          child: _SectionHeader(
            icon: Icons.category_sharp,
            iconBg: Colors.orange.shade50,
            iconColor: Colors.orange.shade600,
            title: "Categories",
            actionLabel: "See All",
          ),
        ),
        const SliverToBoxAdapter(child: SizedBox(height: 5)),
        SliverToBoxAdapter(child: CategorySection()),
        const SliverToBoxAdapter(child: SizedBox(height: 5)),

        SliverToBoxAdapter(child: const _RestaurantBanner()),
        const SliverToBoxAdapter(child: SizedBox(height: 28)),

        SliverToBoxAdapter(
          child: _SectionHeader(
            icon: Icons.event_rounded,
            iconBg: Colors.purple.shade50,
            iconColor: Colors.teal,
            title: "Upcoming Events",
            actionLabel: "See All",
          ),
        ),
        const SliverToBoxAdapter(child: SizedBox(height: 12)),
        SliverToBoxAdapter(child: UpcomingEventsSection()),
        const SliverToBoxAdapter(child: SizedBox(height: 28)),

        SliverToBoxAdapter(
          child: _SectionHeader(
            icon: Icons.local_fire_department_rounded,
            iconBg: Colors.red.shade50,
            iconColor: Colors.red.shade600,
            title: "Hot Offers",
            actionLabel: "Explore",
          ),
        ),
        const SliverToBoxAdapter(child: SizedBox(height: 12)),

        // ✅ FIX: UserOfferSection already returns SliverToBoxAdapter internally
        // so we do NOT wrap it in another SliverToBoxAdapter here
        UserOfferSection(),

        const SliverToBoxAdapter(child: SizedBox(height: 80)),
      ],
    );
  }
}

// ─────────────────────────────────────────────
//  HEADER
// ─────────────────────────────────────────────
class _PurpleHeader extends StatelessWidget {
  final UserLocationController locationController;
  final CartController cartController;

  const _PurpleHeader({
    required this.locationController,
    required this.cartController,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.only(
        bottomLeft: Radius.circular(28),
        bottomRight: Radius.circular(28),
      ),
      child: Container(
        decoration: const BoxDecoration(
          color: Colors.teal,
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(28),
            bottomRight: Radius.circular(28),
          ),
        ),
        child: SafeArea(
          bottom: false,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(18, 10, 18, 18),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: InkWell(
                        onTap: () => Get.to(() => SelectLocationPage()),
                        borderRadius: BorderRadius.circular(8),
                        child: Obx(() {
                          final loc =
                              locationController.selectedMainLocation.value;
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "eShoppy",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 23,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(Icons.location_on_rounded,
                                      color: Colors.pinkAccent, size: 14),
                                  const SizedBox(width: 3),
                                  ConstrainedBox(
                                    constraints:
                                    const BoxConstraints(maxWidth: 160),
                                    child: Text(
                                      loc.isEmpty ? "Select Location" : loc,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ),
                                  const Icon(
                                      Icons.keyboard_arrow_down_rounded,
                                      color: Colors.white70,
                                      size: 16),
                                ],
                              ),
                            ],
                          );
                        }),
                      ),
                    ),
                    Obx(() => _HeaderIconButton(
                      icon: Icons.shopping_cart_outlined,
                      badgeCount: cartController.cartItems.length,
                      onTap: () => Get.to(() => CartScreen()),
                    )),
                    const SizedBox(width: 5),
                  ],
                ),
                const SizedBox(height: 14),
                Container(
                  height: 46,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.08),
                        blurRadius: 8,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      const SizedBox(width: 14),
                      Icon(Icons.search_rounded,
                          color: Colors.grey.shade400, size: 20),
                      const SizedBox(width: 8),
                      Expanded(
                        child: TextField(
                          decoration: InputDecoration(
                            hintText: "Search",
                            hintStyle: TextStyle(
                              color: Colors.grey.shade400,
                              fontSize: 14,
                            ),
                            border: InputBorder.none,
                            isDense: true,
                            contentPadding: EdgeInsets.zero,
                          ),
                        ),
                      ),
                      _SearchActionIcon(
                        icon: Icons.tune_rounded,
                        onTap: () {},
                        isPurple: true,
                      ),
                      const SizedBox(width: 6),
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

class _SearchActionIcon extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final bool isPurple;

  const _SearchActionIcon({
    required this.icon,
    required this.onTap,
    this.isPurple = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: isPurple ? kPurplePrimary : const Color(0xFFF3F4F6),
          borderRadius: BorderRadius.circular(9),
        ),
        child: Icon(
          icon,
          size: 18,
          color: isPurple ? Colors.white : Colors.grey.shade600,
        ),
      ),
    );
  }
}

class _HeaderIconButton extends StatelessWidget {
  final IconData icon;
  final int badgeCount;
  final VoidCallback onTap;

  const _HeaderIconButton({
    required this.icon,
    required this.onTap,
    this.badgeCount = 0,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.18),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.white.withOpacity(0.2)),
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Icon(icon, color: Colors.white, size: 22),
            if (badgeCount > 0)
              Positioned(
                top: 6,
                right: 6,
                child: Container(
                  width: 16,
                  height: 16,
                  decoration: const BoxDecoration(
                    color: Color(0xFFFF5252),
                    shape: BoxShape.circle,
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    badgeCount > 9 ? "9+" : "$badgeCount",
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 9,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final IconData icon;
  final Color iconBg;
  final Color iconColor;
  final String title;
  final String actionLabel;

  const _SectionHeader({
    required this.icon,
    required this.iconBg,
    required this.iconColor,
    required this.title,
    required this.actionLabel,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(7),
                decoration: BoxDecoration(
                  color: iconBg,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: iconColor, size: 18),
              ),
              const SizedBox(width: 10),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF1A1A2E),
                  letterSpacing: 0.2,
                ),
              ),
            ],
          ),
          GestureDetector(
            onTap: () {},
            child: Text(
              actionLabel,
              style: const TextStyle(
                color: kPurplePrimary,
                fontWeight: FontWeight.w700,
                fontSize: 13,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _RestaurantBanner extends StatelessWidget {
  const _RestaurantBanner();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        height: 165,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.12),
              blurRadius: 24,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(24),
          child: Stack(
            children: [
              Positioned.fill(
                child: Image.asset(
                  "assets/images/logo/restaurantimag.png",
                  fit: BoxFit.cover,
                ),
              ),
              Positioned.fill(
                child: Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                      colors: [Color(0xCC000000), Colors.transparent],
                    ),
                  ),
                ),
              ),
              Positioned(
                left: 22,
                top: 22,
                bottom: 22,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: kPurplePrimary,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: const Text(
                        "NEW",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 1.2,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      "Restaurant\nBooking",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.w900,
                        height: 1.2,
                        letterSpacing: 0.3,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      "Find your perfect stay",
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.85),
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              Positioned(
                right: 16,
                top: 0,
                bottom: 0,
                child: Center(
                  child: InkWell(
                    onTap: () => Get.to(() => RestaurantListPage()),
                    borderRadius: BorderRadius.circular(16),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 18, vertical: 12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.18),
                            blurRadius: 14,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            "Book Now",
                            style: TextStyle(
                              color: kPurplePrimary,
                              fontWeight: FontWeight.w800,
                              fontSize: 13,
                              letterSpacing: 0.3,
                            ),
                          ),
                          SizedBox(width: 6),
                          Icon(Icons.arrow_forward_rounded,
                              color: kPurplePrimary, size: 15),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

