import 'package:entenaadu/app/modules/userlogin/view/login.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../controller/menu_controller.dart';
import '../controller/restaurantcartcontroller.dart';

// ── THEME CONSTANTS ──────────────────────────────────────────────────────────
class _AppTheme {
  static const primary      = Color(0xFF0F5151);
  static const primaryLight = Color(0xFFE8F5F0);
  static const primarySoft  = Color(0xFFB2DDD2);
  static const bg           = Color(0xFFF8F9FA);
  static const textDark     = Color(0xFF1C1C1E);
  static const textMid      = Color(0xFF6B6B6B);
  static const textLight    = Color(0xFFAAAAAA);
  static const divider      = Color(0xFFF0F0F0);
}

// ── AUTH HELPER ───────────────────────────────────────────────────────────────
bool _isLoggedIn() {
  final box = GetStorage();
  final token = box.read('auth_token') ?? '';
  return token.toString().isNotEmpty;
}

void _showLoginRequiredDialog() {
  Get.dialog(
    Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      backgroundColor: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // ── ICON ──────────────────────────────────────────────────────
            Container(
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(
                color: Color(0xFFE8F5F0),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.shopping_cart_outlined,
                color: Color(0xFF0F5151),
                size: 32,
              ),
            ),
            const SizedBox(height: 16),

            // ── TITLE ─────────────────────────────────────────────────────
            const Text(
              'Sign in to add items',
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w700,
                color: Color(0xFF1C1C1E),
              ),
            ),
            const SizedBox(height: 10),

            // ── SUBTITLE ──────────────────────────────────────────────────
            const Text(
              'Please sign in or create an account to start adding items to your cart.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 13.5,
                color: Color(0xFF6B6B6B),
                height: 1.5,
              ),
            ),
            const SizedBox(height: 24),

            // ── SIGN IN BUTTON ────────────────────────────────────────────
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Get.back();
                  Get.offAll(() => LoginPageView());
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF0F5151),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 13),
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Sign in',
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 14,
                    letterSpacing: 0.2,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),



            // ── MAYBE LATER ───────────────────────────────────────────────
            TextButton(
              onPressed: () => Get.back(),
              child: const Text(
                'Maybe later',
                style: TextStyle(
                  color: Color(0xFFAAAAAA),
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    ),
    barrierDismissible: true,
  );
}

// ── MAIN TAB WIDGET ──────────────────────────────────────────────────────────
class RestaurantMenuTab extends StatelessWidget {
  final String restaurantId;

  RestaurantMenuTab({super.key, required this.restaurantId});

  Restaurantcartcontroller get cartController {
    if (Get.isRegistered<Restaurantcartcontroller>()) {
      return Get.find<Restaurantcartcontroller>();
    }
    return Get.put(Restaurantcartcontroller(), permanent: true);
  }

  int get _rid => int.tryParse(restaurantId) ?? 0;

  @override
  Widget build(BuildContext context) {
    final menuController = Get.put(
      RestaurantMenuController(),
      tag: 'menu_$restaurantId',
    );

    cartController.setRestaurant(_rid);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!menuController.isInitialized.value) {
        menuController.init(restaurantId);
      }
    });

    return Obx(() {
      final hasItems   = cartController.hasItemsForRestaurant(_rid);
      final totalItems = cartController.totalItemsForRestaurant(_rid);
      final totalAmt   = cartController.totalAmountForRestaurant(_rid);

      final availableTypes = menuController.availableMealTypes;

      return Scaffold(
        backgroundColor: _AppTheme.bg,
        body: Stack(
          children: [
            Column(
              children: [

                // ── MEAL TYPE CHIPS ──────────────────────────────────────
                if (!menuController.isLoading.value &&
                    availableTypes.isNotEmpty) ...[
                  Container(
                    color: Colors.white,
                    child: Column(
                      children: [
                        const SizedBox(height: 14),
                        SizedBox(
                          height: 46,
                          child: ListView.builder(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            scrollDirection: Axis.horizontal,
                            itemCount: availableTypes.length,
                            itemBuilder: (context, index) {
                              final type = availableTypes[index];
                              final isSelected =
                                  menuController.selectedMealType.value ==
                                      type['value'];
                              return GestureDetector(
                                onTap: () {
                                  if (!menuController.isLoading.value) {
                                    menuController.changeMealType(
                                        restaurantId, type['value']!);
                                  }
                                },
                                child: AnimatedContainer(
                                  duration: const Duration(milliseconds: 220),
                                  curve: Curves.easeInOut,
                                  margin: const EdgeInsets.only(right: 10),
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20, vertical: 10),
                                  decoration: BoxDecoration(
                                    color: isSelected
                                        ? _AppTheme.primary
                                        : Colors.white,
                                    borderRadius: BorderRadius.circular(30),
                                    border: Border.all(
                                      color: isSelected
                                          ? _AppTheme.primary
                                          : _AppTheme.divider,
                                      width: 1.5,
                                    ),
                                    boxShadow: isSelected
                                        ? [
                                      BoxShadow(
                                        color: _AppTheme.primary
                                            .withOpacity(0.25),
                                        blurRadius: 10,
                                        offset: const Offset(0, 4),
                                      ),
                                    ]
                                        : [],
                                  ),
                                  child: Text(
                                    type['label']!,
                                    style: TextStyle(
                                      color: isSelected
                                          ? Colors.white
                                          : _AppTheme.textMid,
                                      fontWeight: isSelected
                                          ? FontWeight.w700
                                          : FontWeight.w500,
                                      fontSize: 13,
                                      letterSpacing: 0.2,
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                        const SizedBox(height: 14),
                        Divider(
                            height: 1,
                            thickness: 1,
                            color: _AppTheme.divider),
                      ],
                    ),
                  ),
                ],

                // ── MENU CONTENT AREA ────────────────────────────────────
                Expanded(
                  child: menuController.isLoading.value

                  // ── LOADING STATE ──────────────────────────────────
                      ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircularProgressIndicator(
                          color: _AppTheme.primary,
                          strokeWidth: 2.5,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Loading menu...',
                          style: TextStyle(
                            color: _AppTheme.textLight,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  )

                      : menuController.menuItems.isEmpty

                  // ── EMPTY / UNAVAILABLE STATE ──────────────────
                      ? Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 32),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(24),
                            decoration: BoxDecoration(
                              color: _AppTheme.primaryLight,
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.no_meals_rounded,
                              size: 48,
                              color: _AppTheme.primary,
                            ),
                          ),
                          const SizedBox(height: 20),
                          Text(
                            menuController.emptyMessage.value,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: _AppTheme.textDark,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 6),
                          Text(
                            availableTypes.length > 1
                                ? 'Try another meal type above'
                                : 'Check back later for updates',
                            style: TextStyle(
                              fontSize: 13,
                              color: _AppTheme.textLight,
                            ),
                          ),
                        ],
                      ),
                    ),
                  )

                  // ── MENU ITEMS LIST ────────────────────────────
                      : ListView.builder(
                    padding: EdgeInsets.only(
                      left: 16,
                      right: 16,
                      top: 20,
                      bottom: hasItems ? 100 : 24,
                    ),
                    itemCount: menuController.menuItems.length,
                    itemBuilder: (context, index) {
                      final item = menuController.menuItems[index];
                      return _MenuItemCard(
                        item: item,
                        cartController: cartController,
                        restaurantId: _rid,
                      );
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    });
  }
}

// ── MENU ITEM CARD ────────────────────────────────────────────────────────────
class _MenuItemCard extends StatelessWidget {
  final dynamic item;
  final Restaurantcartcontroller cartController;
  final int restaurantId;

  const _MenuItemCard({
    required this.item,
    required this.cartController,
    required this.restaurantId,
  });

  int get _menuId => int.tryParse(item.id?.toString() ?? '0') ?? 0;

  @override
  Widget build(BuildContext context) {
    final rawPrice = double.tryParse(item.price?.toString() ?? '0') ?? 0.0;
    final priceDisplay = rawPrice % 1 == 0
        ? rawPrice.toInt().toString()
        : rawPrice.toStringAsFixed(2);

    return Obx(() {
      final inCart = cartController.isInCartForRestaurant(_menuId, restaurantId);
      final qty    = cartController.itemQtyForRestaurant(_menuId, restaurantId);

      return Container(
        margin: const EdgeInsets.only(bottom: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.055),
              blurRadius: 14,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── FOOD IMAGE ───────────────────────────────────────────────
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(18),
                bottomLeft: Radius.circular(18),
              ),
              child: Image.network(
                item.image ?? '',
                width: 108,
                height: 108,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  width: 108,
                  height: 108,
                  color: _AppTheme.primaryLight,
                  child: Icon(Icons.fastfood_rounded,
                      size: 38, color: _AppTheme.primarySoft),
                ),
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Container(
                    width: 108,
                    height: 108,
                    color: _AppTheme.bg,
                    child: Center(
                      child: CircularProgressIndicator(
                        color: _AppTheme.primary,
                        strokeWidth: 2,
                      ),
                    ),
                  );
                },
              ),
            ),

            // ── FOOD DETAILS ─────────────────────────────────────────────
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(14, 12, 12, 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.foodName ?? '',
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: _AppTheme.textDark,
                        letterSpacing: -0.1,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      item.shortDescription ?? '',
                      style: const TextStyle(
                        fontSize: 11.5,
                        color: _AppTheme.textLight,
                        height: 1.45,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // ── PRICE ────────────────────────────────────────
                        Text(
                          '₹$priceDisplay',
                          style: const TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w800,
                            color: _AppTheme.textDark,
                            letterSpacing: -0.3,
                          ),
                        ),

                        // ── ADD / QTY CONTROLS ───────────────────────────
                        inCart
                            ? _InCartControls(
                          qty: qty,
                          onIncrement: () =>
                              cartController.updateQuantity(_menuId, 'increment'),
                          onDecrement: () =>
                              cartController.updateQuantity(_menuId, 'decrement'),
                        )
                            : _AddButton(
                          onTap: () {
                            // ── AUTH GUARD ───────────────────────
                            if (!_isLoggedIn()) {
                              _showLoginRequiredDialog();
                              return;
                            }
                            cartController.addToCart(
                              restaurantId: restaurantId,
                              menuId: _menuId,
                              itemName: item.foodName ?? '',
                              image: item.image ?? '',
                              price: rawPrice,
                            );
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    });
  }
}

// ── ADD BUTTON ────────────────────────────────────────────────────────────────
class _AddButton extends StatefulWidget {
  final VoidCallback onTap;
  const _AddButton({required this.onTap});

  @override
  State<_AddButton> createState() => _AddButtonState();
}

class _AddButtonState extends State<_AddButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnim;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 120),
      reverseDuration: const Duration(milliseconds: 100),
    );
    _scaleAnim = Tween<double>(begin: 1.0, end: 0.92).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeIn),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onTap() async {
    // Run press animation regardless — feels snappy
    await _controller.forward();
    await _controller.reverse();
    // Auth check + actual logic handled by the caller via onTap
    widget.onTap();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _onTap,
      child: ScaleTransition(
        scale: _scaleAnim,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 9),
          decoration: BoxDecoration(
            color: _AppTheme.primary,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: _AppTheme.primary.withOpacity(0.3),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: const [
              Icon(Icons.add_rounded, color: Colors.white, size: 15),
              SizedBox(width: 4),
              Text(
                'ADD',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w800,
                  fontSize: 13,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── IN-CART CONTROLS ──────────────────────────────────────────────────────────
class _InCartControls extends StatelessWidget {
  final int qty;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;

  const _InCartControls({
    required this.qty,
    required this.onIncrement,
    required this.onDecrement,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 36,
      decoration: BoxDecoration(
        color: _AppTheme.primaryLight,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: _AppTheme.primarySoft, width: 1.2),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _ControlBtn(
              icon: Icons.remove_rounded, onTap: onDecrement, isLeft: true),
          Container(
            width: 32,
            alignment: Alignment.center,
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 180),
              transitionBuilder: (child, animation) =>
                  ScaleTransition(scale: animation, child: child),
              child: Text(
                '$qty',
                key: ValueKey(qty),
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w800,
                  color: _AppTheme.primary,
                ),
              ),
            ),
          ),
          _ControlBtn(
              icon: Icons.add_rounded, onTap: onIncrement, isLeft: false),
        ],
      ),
    );
  }
}

class _ControlBtn extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final bool isLeft;

  const _ControlBtn(
      {required this.icon, required this.onTap, required this.isLeft});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: isLeft
            ? const BorderRadius.only(
            topLeft: Radius.circular(11),
            bottomLeft: Radius.circular(11))
            : const BorderRadius.only(
            topRight: Radius.circular(11),
            bottomRight: Radius.circular(11)),
        child: SizedBox(
          width: 32,
          height: 36,
          child: Icon(icon, size: 16, color: _AppTheme.primary),
        ),
      ),
    );
  }
}