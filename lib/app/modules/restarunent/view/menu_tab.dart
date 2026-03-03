// //
// // import 'package:eshoppy/app/modules/restarunent/view/restaurantcartpage.dart';
// // import 'package:flutter/material.dart';
// // import 'package:get/get.dart';
// // import '../controller/menu_controller.dart';
// // import '../controller/restaurantcartcontroller.dart';
// //
// // // ── THEME CONSTANTS ──────────────────────────────────────────────────────────
// // class _AppTheme {
// //   static const primary = Color(0xFF0F5151);
// //   static const primaryLight = Color(0xFFE8F5F0);
// //   static const primarySoft = Color(0xFFB2DDD2);
// //   static const accent = Color(0xFFFF6B35);
// //   static const bg = Color(0xFFF8F9FA);
// //   static const cardBg = Colors.white;
// //   static const textDark = Color(0xFF1C1C1E);
// //   static const textMid = Color(0xFF6B6B6B);
// //   static const textLight = Color(0xFFAAAAAA);
// //   static const divider = Color(0xFFF0F0F0);
// // }
// //
// // class RestaurantMenuTab extends StatelessWidget {
// //   final String restaurantId;
// //
// //   RestaurantMenuTab({super.key, required this.restaurantId});
// //
// //   Restaurantcartcontroller get cartController {
// //     if (Get.isRegistered<Restaurantcartcontroller>()) {
// //       return Get.find<Restaurantcartcontroller>();
// //     }
// //     return Get.put(Restaurantcartcontroller(), permanent: true);
// //   }
// //
// //   int get _rid => int.tryParse(restaurantId) ?? 0;
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     final menuController = Get.put(
// //       RestaurantMenuController(),
// //       tag: 'menu_$restaurantId',
// //     );
// //
// //     cartController.setRestaurant(_rid);
// //
// //     WidgetsBinding.instance.addPostFrameCallback((_) {
// //       if (menuController.menuItems.isEmpty && !menuController.isLoading.value) {
// //         menuController.init(restaurantId);
// //       }
// //     });
// //
// //     return Obx(() {
// //       final hasItems = cartController.hasItemsForRestaurant(_rid);
// //       final totalItems = cartController.totalItemsForRestaurant(_rid);
// //       final totalAmount = cartController.totalAmountForRestaurant(_rid);
// //
// //       return Scaffold(
// //         backgroundColor: _AppTheme.bg,
// //         body: Stack(
// //           children: [
// //             Column(
// //               children: [
// //                 // ── MEAL TYPE CHIPS ────────────────────────────────────────
// //                 Container(
// //                   color: Colors.white,
// //                   child: Column(
// //                     children: [
// //                       const SizedBox(height: 14),
// //                       SizedBox(
// //                         height: 46,
// //                         child: ListView.builder(
// //                           padding: const EdgeInsets.symmetric(horizontal: 16),
// //                           scrollDirection: Axis.horizontal,
// //                           itemCount: menuController.mealTypes.length,
// //                           itemBuilder: (context, index) {
// //                             final type = menuController.mealTypes[index];
// //                             final isSelected =
// //                                 menuController.selectedMealType.value ==
// //                                     type['value'];
// //                             return GestureDetector(
// //                               onTap: () => menuController.changeMealType(
// //                                   restaurantId, type['value']!),
// //                               child: AnimatedContainer(
// //                                 duration: const Duration(milliseconds: 220),
// //                                 curve: Curves.easeInOut,
// //                                 margin: const EdgeInsets.only(right: 10),
// //                                 padding: const EdgeInsets.symmetric(
// //                                     horizontal: 20, vertical: 10),
// //                                 decoration: BoxDecoration(
// //                                   color: isSelected
// //                                       ? _AppTheme.primary
// //                                       : Colors.white,
// //                                   borderRadius: BorderRadius.circular(30),
// //                                   border: Border.all(
// //                                     color: isSelected
// //                                         ? _AppTheme.primary
// //                                         : _AppTheme.divider,
// //                                     width: 1.5,
// //                                   ),
// //                                   boxShadow: isSelected
// //                                       ? [
// //                                     BoxShadow(
// //                                       color: _AppTheme.primary
// //                                           .withOpacity(0.25),
// //                                       blurRadius: 10,
// //                                       offset: const Offset(0, 4),
// //                                     )
// //                                   ]
// //                                       : [],
// //                                 ),
// //                                 child: Text(
// //                                   type['label']!,
// //                                   style: TextStyle(
// //                                     color: isSelected
// //                                         ? Colors.white
// //                                         : _AppTheme.textMid,
// //                                     fontWeight: isSelected
// //                                         ? FontWeight.w700
// //                                         : FontWeight.w500,
// //                                     fontSize: 13,
// //                                     letterSpacing: 0.2,
// //                                   ),
// //                                 ),
// //                               ),
// //                             );
// //                           },
// //                         ),
// //                       ),
// //                       const SizedBox(height: 14),
// //                       Divider(
// //                           height: 1, thickness: 1, color: _AppTheme.divider),
// //                     ],
// //                   ),
// //                 ),
// //
// //                 // ── MENU LIST ──────────────────────────────────────────────
// //                 Expanded(
// //                   child: menuController.isLoading.value
// //                       ? Center(
// //                     child: Column(
// //                       mainAxisAlignment: MainAxisAlignment.center,
// //                       children: [
// //                         CircularProgressIndicator(
// //                           color: _AppTheme.primary,
// //                           strokeWidth: 2.5,
// //                         ),
// //                         const SizedBox(height: 16),
// //                         Text(
// //                           'Loading menu...',
// //                           style: TextStyle(
// //                             color: _AppTheme.textLight,
// //                             fontSize: 14,
// //                           ),
// //                         ),
// //                       ],
// //                     ),
// //                   )
// //                       : menuController.menuItems.isEmpty
// //                       ? Center(
// //                     child: Column(
// //                       mainAxisAlignment: MainAxisAlignment.center,
// //                       children: [
// //                         Container(
// //                           padding: const EdgeInsets.all(24),
// //                           decoration: BoxDecoration(
// //                             color: _AppTheme.primaryLight,
// //                             shape: BoxShape.circle,
// //                           ),
// //                           child: Icon(
// //                             Icons.restaurant_menu_rounded,
// //                             size: 48,
// //                             color: _AppTheme.primary,
// //                           ),
// //                         ),
// //                         const SizedBox(height: 20),
// //                         Text(
// //                           'No items available',
// //                           style: TextStyle(
// //                             fontSize: 16,
// //                             fontWeight: FontWeight.w600,
// //                             color: _AppTheme.textDark,
// //                           ),
// //                         ),
// //                         const SizedBox(height: 6),
// //                         Text(
// //                           'Check back later for updates',
// //                           style: TextStyle(
// //                             fontSize: 13,
// //                             color: _AppTheme.textLight,
// //                           ),
// //                         ),
// //                       ],
// //                     ),
// //                   )
// //                       : ListView.builder(
// //                     padding: EdgeInsets.only(
// //                       left: 16,
// //                       right: 16,
// //                       top: 20,
// //                       bottom: hasItems ? 100 : 24,
// //                     ),
// //                     itemCount: menuController.menuItems.length,
// //                     itemBuilder: (context, index) {
// //                       final item = menuController.menuItems[index];
// //                       return _MenuItemCard(
// //                         item: item,
// //                         cartController: cartController,
// //                         restaurantId: _rid,
// //                       );
// //                     },
// //                   ),
// //                 ),
// //               ],
// //             ),
// //
// //             // ── CART BOTTOM BAR ──────────────────────────────────────────
// //             if (hasItems)
// //               Positioned(
// //                 left: 0,
// //                 right: 0,
// //                 bottom: 0,
// //                 child: _CartBottomBar(
// //                   cartController: cartController,
// //                   restaurantId: _rid,
// //                   totalItems: totalItems,
// //                   totalAmount: totalAmount,
// //                 ),
// //               ),
// //           ],
// //         ),
// //       );
// //     });
// //   }
// // }
// //
// // // ── CART BOTTOM BAR ──────────────────────────────────────────────────────────
// // class _CartBottomBar extends StatelessWidget {
// //   final Restaurantcartcontroller cartController;
// //   final int restaurantId;
// //   final int totalItems;
// //   final double totalAmount;
// //
// //   const _CartBottomBar({
// //     required this.cartController,
// //     required this.restaurantId,
// //     required this.totalItems,
// //     required this.totalAmount,
// //   });
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     final amountDisplay = totalAmount % 1 == 0
// //         ? totalAmount.toInt().toString()
// //         : totalAmount.toStringAsFixed(2);
// //
// //     return Container(
// //       decoration: const BoxDecoration(
// //         color: Colors.white,
// //         boxShadow: [
// //           BoxShadow(
// //             color: Color(0x18000000),
// //             blurRadius: 24,
// //             offset: Offset(0, -6),
// //           ),
// //         ],
// //       ),
// //       padding: const EdgeInsets.fromLTRB(16, 12, 16, 20),
// //       child: Material(
// //         color: _AppTheme.primary,
// //         borderRadius: BorderRadius.circular(16),
// //         child: InkWell(
// //           borderRadius: BorderRadius.circular(16),
// //           splashColor: Colors.white.withOpacity(0.15),
// //           onTap: () => Get.to(
// //                 () => RestaurantCartPage(restaurantId: restaurantId),
// //           ),
// //           child: Padding(
// //             padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 15),
// //             child: Row(
// //               children: [
// //                 // Item count badge
// //                 Container(
// //                   padding:
// //                   const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
// //                   decoration: BoxDecoration(
// //                     color: Colors.white.withOpacity(0.2),
// //                     borderRadius: BorderRadius.circular(8),
// //                   ),
// //                   child: Text(
// //                     '$totalItems item${totalItems > 1 ? 's' : ''}',
// //                     style: const TextStyle(
// //                       color: Colors.white,
// //                       fontWeight: FontWeight.w700,
// //                       fontSize: 12,
// //                       letterSpacing: 0.3,
// //                     ),
// //                   ),
// //                 ),
// //                 const Expanded(
// //                   child: Text(
// //                     'View Cart',
// //                     textAlign: TextAlign.center,
// //                     style: TextStyle(
// //                       color: Colors.white,
// //                       fontWeight: FontWeight.w800,
// //                       fontSize: 15,
// //                       letterSpacing: 0.3,
// //                     ),
// //                   ),
// //                 ),
// //                 // Amount
// //                 Text(
// //                   '₹$amountDisplay',
// //                   style: const TextStyle(
// //                     color: Colors.white,
// //                     fontWeight: FontWeight.w800,
// //                     fontSize: 15,
// //                   ),
// //                 ),
// //                 const SizedBox(width: 6),
// //                 const Icon(Icons.arrow_forward_ios_rounded,
// //                     color: Colors.white, size: 13),
// //               ],
// //             ),
// //           ),
// //         ),
// //       ),
// //     );
// //   }
// // }
// //
// // // ── MENU ITEM CARD ────────────────────────────────────────────────────────────
// // class _MenuItemCard extends StatelessWidget {
// //   final dynamic item;
// //   final Restaurantcartcontroller cartController;
// //   final int restaurantId;
// //
// //   const _MenuItemCard({
// //     required this.item,
// //     required this.cartController,
// //     required this.restaurantId,
// //   });
// //
// //   int get _menuId => int.tryParse(item.id?.toString() ?? '0') ?? 0;
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     final rawPrice =
// //         double.tryParse(item.price?.toString() ?? '0') ?? 0.0;
// //     final priceDisplay =
// //     rawPrice % 1 == 0 ? rawPrice.toInt().toString() : rawPrice.toStringAsFixed(2);
// //
// //     return Obx(() {
// //       final inCart =
// //       cartController.isInCartForRestaurant(_menuId, restaurantId);
// //       final qty = cartController.itemQtyForRestaurant(_menuId, restaurantId);
// //
// //       return Container(
// //         margin: const EdgeInsets.only(bottom: 14),
// //         decoration: BoxDecoration(
// //           color: Colors.white,
// //           borderRadius: BorderRadius.circular(18),
// //           boxShadow: [
// //             BoxShadow(
// //               color: Colors.black.withOpacity(0.055),
// //               blurRadius: 14,
// //               offset: const Offset(0, 4),
// //             ),
// //           ],
// //         ),
// //         child: Row(
// //           crossAxisAlignment: CrossAxisAlignment.start,
// //           children: [
// //             // ── IMAGE ──────────────────────────────────────────────────────
// //             ClipRRect(
// //               borderRadius: const BorderRadius.only(
// //                 topLeft: Radius.circular(18),
// //                 bottomLeft: Radius.circular(18),
// //               ),
// //               child: Image.network(
// //                 item.image ?? '',
// //                 width: 108,
// //                 height: 108,
// //                 fit: BoxFit.cover,
// //                 errorBuilder: (_, __, ___) => Container(
// //                   width: 108,
// //                   height: 108,
// //                   color: _AppTheme.primaryLight,
// //                   child: Icon(Icons.fastfood_rounded,
// //                       size: 38, color: _AppTheme.primarySoft),
// //                 ),
// //                 loadingBuilder: (context, child, loadingProgress) {
// //                   if (loadingProgress == null) return child;
// //                   return Container(
// //                     width: 108,
// //                     height: 108,
// //                     color: _AppTheme.bg,
// //                     child: Center(
// //                       child: CircularProgressIndicator(
// //                         color: _AppTheme.primary,
// //                         strokeWidth: 2,
// //                       ),
// //                     ),
// //                   );
// //                 },
// //               ),
// //             ),
// //
// //             // ── DETAILS + CONTROLS ─────────────────────────────────────────
// //             Expanded(
// //               child: Padding(
// //                 padding: const EdgeInsets.fromLTRB(14, 12, 12, 12),
// //                 child: Column(
// //                   crossAxisAlignment: CrossAxisAlignment.start,
// //                   children: [
// //                     // Name
// //                     Text(
// //                       item.foodName ?? '',
// //                       style: const TextStyle(
// //                         fontSize: 15,
// //                         fontWeight: FontWeight.w700,
// //                         color: _AppTheme.textDark,
// //                         letterSpacing: -0.1,
// //                       ),
// //                       maxLines: 1,
// //                       overflow: TextOverflow.ellipsis,
// //                     ),
// //                     const SizedBox(height: 4),
// //                     // Description
// //                     Text(
// //                       item.shortDescription ?? '',
// //                       style: const TextStyle(
// //                         fontSize: 11.5,
// //                         color: _AppTheme.textLight,
// //                         height: 1.45,
// //                       ),
// //                       maxLines: 2,
// //                       overflow: TextOverflow.ellipsis,
// //                     ),
// //                     const SizedBox(height: 12),
// //                     // Price + Button Row
// //                     Row(
// //                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
// //                       crossAxisAlignment: CrossAxisAlignment.center,
// //                       children: [
// //                         Column(
// //                           crossAxisAlignment: CrossAxisAlignment.start,
// //                           children: [
// //                             Text(
// //                               '₹$priceDisplay',
// //                               style: const TextStyle(
// //                                 fontSize: 17,
// //                                 fontWeight: FontWeight.w800,
// //                                 color: _AppTheme.textDark,
// //                                 letterSpacing: -0.3,
// //                               ),
// //                             ),
// //                           ],
// //                         ),
// //                         inCart
// //                             ? _InCartControls(
// //                           qty: qty,
// //                           onIncrement: () => cartController
// //                               .updateQuantity(_menuId, 'increment'),
// //                           onDecrement: () => cartController
// //                               .updateQuantity(_menuId, 'decrement'),
// //                         )
// //                             : _AddButton(
// //                           onTap: () async {
// //                             final success = await cartController.addToCart(
// //                               restaurantId: restaurantId,
// //                               menuId: _menuId,
// //                               itemName: item.foodName ?? '',
// //                               image: item.image ?? '',
// //                               price: rawPrice,
// //                             );
// //                             if (success) {
// //                               Get.snackbar(
// //                                 '',
// //                                 '',
// //                                 titleText: const SizedBox.shrink(),
// //                                 messageText: Row(
// //                                   children: [
// //                                     Container(
// //                                       padding: const EdgeInsets.all(6),
// //                                       decoration: BoxDecoration(
// //                                         color: Colors.white
// //                                             .withOpacity(0.2),
// //                                         shape: BoxShape.circle,
// //                                       ),
// //                                       child: const Icon(
// //                                           Icons.check_rounded,
// //                                           color: Colors.white,
// //                                           size: 14),
// //                                     ),
// //                                     const SizedBox(width: 10),
// //                                     Expanded(
// //                                       child: Text(
// //                                         '${item.foodName} added to cart',
// //                                         style: const TextStyle(
// //                                           color: Colors.white,
// //                                           fontWeight: FontWeight.w600,
// //                                           fontSize: 13,
// //                                         ),
// //                                       ),
// //                                     ),
// //                                   ],
// //                                 ),
// //                                 backgroundColor: _AppTheme.primary,
// //                                 snackPosition: SnackPosition.BOTTOM,
// //                                 margin: const EdgeInsets.fromLTRB(
// //                                     16, 0, 16, 90),
// //                                 borderRadius: 14,
// //                                 duration: const Duration(seconds: 2),
// //                                 padding: const EdgeInsets.symmetric(
// //                                     horizontal: 16, vertical: 12),
// //                               );
// //                             }
// //                           },
// //                         ),
// //                       ],
// //                     ),
// //                   ],
// //                 ),
// //               ),
// //             ),
// //           ],
// //         ),
// //       );
// //     });
// //   }
// // }
// //
// // // ── ADD BUTTON ────────────────────────────────────────────────────────────────
// // class _AddButton extends StatefulWidget {
// //   final VoidCallback onTap;
// //   const _AddButton({required this.onTap});
// //
// //   @override
// //   State<_AddButton> createState() => _AddButtonState();
// // }
// //
// // class _AddButtonState extends State<_AddButton>
// //     with SingleTickerProviderStateMixin {
// //   late AnimationController _controller;
// //   late Animation<double> _scaleAnim;
// //
// //   @override
// //   void initState() {
// //     super.initState();
// //     _controller = AnimationController(
// //       vsync: this,
// //       duration: const Duration(milliseconds: 120),
// //       reverseDuration: const Duration(milliseconds: 100),
// //     );
// //     _scaleAnim = Tween<double>(begin: 1.0, end: 0.92).animate(
// //       CurvedAnimation(parent: _controller, curve: Curves.easeIn),
// //     );
// //   }
// //
// //   @override
// //   void dispose() {
// //     _controller.dispose();
// //     super.dispose();
// //   }
// //
// //   void _onTap() async {
// //     await _controller.forward();
// //     await _controller.reverse();
// //     widget.onTap();
// //   }
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     return GestureDetector(
// //       onTap: _onTap,
// //       child: ScaleTransition(
// //         scale: _scaleAnim,
// //         child: Container(
// //           padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 9),
// //           decoration: BoxDecoration(
// //             color: _AppTheme.primary,
// //             borderRadius: BorderRadius.circular(12),
// //             boxShadow: [
// //               BoxShadow(
// //                 color: _AppTheme.primary.withOpacity(0.3),
// //                 blurRadius: 10,
// //                 offset: const Offset(0, 4),
// //               ),
// //             ],
// //           ),
// //           child: Row(
// //             mainAxisSize: MainAxisSize.min,
// //             children: const [
// //               Icon(Icons.add_rounded, color: Colors.white, size: 15),
// //               SizedBox(width: 4),
// //               Text(
// //                 'ADD',
// //                 style: TextStyle(
// //                   color: Colors.white,
// //                   fontWeight: FontWeight.w800,
// //                   fontSize: 13,
// //                   letterSpacing: 0.5,
// //                 ),
// //               ),
// //             ],
// //           ),
// //         ),
// //       ),
// //     );
// //   }
// // }
// //
// // // ── IN-CART CONTROLS ──────────────────────────────────────────────────────────
// // class _InCartControls extends StatelessWidget {
// //   final int qty;
// //   final VoidCallback onIncrement;
// //   final VoidCallback onDecrement;
// //
// //   const _InCartControls({
// //     required this.qty,
// //     required this.onIncrement,
// //     required this.onDecrement,
// //   });
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     return Container(
// //       height: 36,
// //       decoration: BoxDecoration(
// //         color: _AppTheme.primaryLight,
// //         borderRadius: BorderRadius.circular(12),
// //         border: Border.all(color: _AppTheme.primarySoft, width: 1.2),
// //       ),
// //       child: Row(
// //         mainAxisSize: MainAxisSize.min,
// //         children: [
// //           _ControlBtn(
// //             icon: Icons.remove_rounded,
// //             onTap: onDecrement,
// //             isLeft: true,
// //           ),
// //           Container(
// //             width: 32,
// //             alignment: Alignment.center,
// //             child: AnimatedSwitcher(
// //               duration: const Duration(milliseconds: 180),
// //               transitionBuilder: (child, animation) => ScaleTransition(
// //                 scale: animation,
// //                 child: child,
// //               ),
// //               child: Text(
// //                 '$qty',
// //                 key: ValueKey(qty),
// //                 style: const TextStyle(
// //                   fontSize: 14,
// //                   fontWeight: FontWeight.w800,
// //                   color: _AppTheme.primary,
// //                 ),
// //               ),
// //             ),
// //           ),
// //           _ControlBtn(
// //             icon: Icons.add_rounded,
// //             onTap: onIncrement,
// //             isLeft: false,
// //           ),
// //         ],
// //       ),
// //     );
// //   }
// // }
// //
// // class _ControlBtn extends StatelessWidget {
// //   final IconData icon;
// //   final VoidCallback onTap;
// //   final bool isLeft;
// //
// //   const _ControlBtn({
// //     required this.icon,
// //     required this.onTap,
// //     required this.isLeft,
// //   });
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     return Material(
// //       color: Colors.transparent,
// //       child: InkWell(
// //         onTap: onTap,
// //         borderRadius: isLeft
// //             ? const BorderRadius.only(
// //           topLeft: Radius.circular(11),
// //           bottomLeft: Radius.circular(11),
// //         )
// //             : const BorderRadius.only(
// //           topRight: Radius.circular(11),
// //           bottomRight: Radius.circular(11),
// //         ),
// //         child: SizedBox(
// //           width: 32,
// //           height: 36,
// //           child: Icon(icon, size: 16, color: _AppTheme.primary),
// //         ),
// //       ),
// //     );
// //   }
// // }
// import 'package:eshoppy/app/modules/restarunent/view/restaurantcartpage.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import '../controller/menu_controller.dart';
// import '../controller/restaurantcartcontroller.dart';
//
// // ── THEME CONSTANTS ──────────────────────────────────────────────────────────
// class _AppTheme {
//   static const primary = Color(0xFF0F5151);
//   static const primaryLight = Color(0xFFE8F5F0);
//   static const primarySoft = Color(0xFFB2DDD2);
//   static const accent = Color(0xFFFF6B35);
//   static const bg = Color(0xFFF8F9FA);
//   static const cardBg = Colors.white;
//   static const textDark = Color(0xFF1C1C1E);
//   static const textMid = Color(0xFF6B6B6B);
//   static const textLight = Color(0xFFAAAAAA);
//   static const divider = Color(0xFFF0F0F0);
// }
//
// class RestaurantMenuTab extends StatelessWidget {
//   final String restaurantId;
//
//   RestaurantMenuTab({super.key, required this.restaurantId});
//
//   Restaurantcartcontroller get cartController {
//     if (Get.isRegistered<Restaurantcartcontroller>()) {
//       return Get.find<Restaurantcartcontroller>();
//     }
//     return Get.put(Restaurantcartcontroller(), permanent: true);
//   }
//
//   int get _rid => int.tryParse(restaurantId) ?? 0;
//
//   /// ✅ Returns only meal type tabs that have at least one item.
//   /// The "All" tab is shown only when there are items of any kind.
//   /// Every other tab is shown only if at least one item's mealType matches.
//   List<Map<String, String>> _visibleMealTypes(
//       RestaurantMenuController menuController,
//       ) {
//     final allItems = menuController.menuItems;
//
//     return menuController.mealTypes.where((type) {
//       final value = (type['value'] ?? '').toLowerCase();
//
//       // "all" tab — show only if there are any items at all
//       if (value == 'all') return allItems.isNotEmpty;
//
//       // other tabs — show only if at least one item belongs to this type
//       return allItems.any(
//             (item) =>
//         (item.mealType?.toString().toLowerCase() ?? '') == value,
//       );
//     }).toList();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final menuController = Get.put(
//       RestaurantMenuController(),
//       tag: 'menu_$restaurantId',
//     );
//
//     cartController.setRestaurant(_rid);
//
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       if (menuController.menuItems.isEmpty && !menuController.isLoading.value) {
//         menuController.init(restaurantId);
//       }
//     });
//
//     return Obx(() {
//       final hasItems = cartController.hasItemsForRestaurant(_rid);
//       final totalItems = cartController.totalItemsForRestaurant(_rid);
//       final totalAmount = cartController.totalAmountForRestaurant(_rid);
//
//       // ✅ Computed after items are loaded — only tabs with actual items
//       final visibleTypes = _visibleMealTypes(menuController);
//
//       return Scaffold(
//         backgroundColor: _AppTheme.bg,
//         body: Stack(
//           children: [
//             Column(
//               children: [
//                 // ── MEAL TYPE CHIPS ────────────────────────────────────────
//                 // Hidden while loading or if no valid tabs exist
//                 if (!menuController.isLoading.value &&
//                     visibleTypes.length > 1) ...[
//                   Container(
//                     color: Colors.white,
//                     child: Column(
//                       children: [
//                         const SizedBox(height: 14),
//                         SizedBox(
//                           height: 46,
//                           child: ListView.builder(
//                             padding: const EdgeInsets.symmetric(horizontal: 16),
//                             scrollDirection: Axis.horizontal,
//                             itemCount: visibleTypes.length,
//                             itemBuilder: (context, index) {
//                               final type = visibleTypes[index];
//                               final isSelected =
//                                   menuController.selectedMealType.value ==
//                                       type['value'];
//                               return GestureDetector(
//                                 onTap: () => menuController.changeMealType(
//                                     restaurantId, type['value']!),
//                                 child: AnimatedContainer(
//                                   duration: const Duration(milliseconds: 220),
//                                   curve: Curves.easeInOut,
//                                   margin: const EdgeInsets.only(right: 10),
//                                   padding: const EdgeInsets.symmetric(
//                                       horizontal: 20, vertical: 10),
//                                   decoration: BoxDecoration(
//                                     color: isSelected
//                                         ? _AppTheme.primary
//                                         : Colors.white,
//                                     borderRadius: BorderRadius.circular(30),
//                                     border: Border.all(
//                                       color: isSelected
//                                           ? _AppTheme.primary
//                                           : _AppTheme.divider,
//                                       width: 1.5,
//                                     ),
//                                     boxShadow: isSelected
//                                         ? [
//                                       BoxShadow(
//                                         color: _AppTheme.primary
//                                             .withOpacity(0.25),
//                                         blurRadius: 10,
//                                         offset: const Offset(0, 4),
//                                       ),
//                                     ]
//                                         : [],
//                                   ),
//                                   child: Text(
//                                     type['label']!,
//                                     style: TextStyle(
//                                       color: isSelected
//                                           ? Colors.white
//                                           : _AppTheme.textMid,
//                                       fontWeight: isSelected
//                                           ? FontWeight.w700
//                                           : FontWeight.w500,
//                                       fontSize: 13,
//                                       letterSpacing: 0.2,
//                                     ),
//                                   ),
//                                 ),
//                               );
//                             },
//                           ),
//                         ),
//                         const SizedBox(height: 14),
//                         Divider(
//                             height: 1,
//                             thickness: 1,
//                             color: _AppTheme.divider),
//                       ],
//                     ),
//                   ),
//                 ],
//
//                 // ── MENU LIST ──────────────────────────────────────────────
//                 Expanded(
//                   child: menuController.isLoading.value
//                       ? Center(
//                     child: Column(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         CircularProgressIndicator(
//                           color: _AppTheme.primary,
//                           strokeWidth: 2.5,
//                         ),
//                         const SizedBox(height: 16),
//                         Text(
//                           'Loading menu...',
//                           style: TextStyle(
//                             color: _AppTheme.textLight,
//                             fontSize: 14,
//                           ),
//                         ),
//                       ],
//                     ),
//                   )
//                       : menuController.menuItems.isEmpty
//                       ? Center(
//                     child: Column(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         Container(
//                           padding: const EdgeInsets.all(24),
//                           decoration: BoxDecoration(
//                             color: _AppTheme.primaryLight,
//                             shape: BoxShape.circle,
//                           ),
//                           child: Icon(
//                             Icons.restaurant_menu_rounded,
//                             size: 48,
//                             color: _AppTheme.primary,
//                           ),
//                         ),
//                         const SizedBox(height: 20),
//                         Text(
//                           'No items available',
//                           style: TextStyle(
//                             fontSize: 16,
//                             fontWeight: FontWeight.w600,
//                             color: _AppTheme.textDark,
//                           ),
//                         ),
//                         const SizedBox(height: 6),
//                         Text(
//                           'Check back later for updates',
//                           style: TextStyle(
//                             fontSize: 13,
//                             color: _AppTheme.textLight,
//                           ),
//                         ),
//                       ],
//                     ),
//                   )
//                       : ListView.builder(
//                     padding: EdgeInsets.only(
//                       left: 16,
//                       right: 16,
//                       top: 20,
//                       bottom: hasItems ? 100 : 24,
//                     ),
//                     itemCount: menuController.menuItems.length,
//                     itemBuilder: (context, index) {
//                       final item = menuController.menuItems[index];
//                       return _MenuItemCard(
//                         item: item,
//                         cartController: cartController,
//                         restaurantId: _rid,
//                       );
//                     },
//                   ),
//                 ),
//               ],
//             ),
//
//             // ── CART BOTTOM BAR ──────────────────────────────────────────
//             if (hasItems)
//               Positioned(
//                 left: 0,
//                 right: 0,
//                 bottom: 0,
//                 child: _CartBottomBar(
//                   cartController: cartController,
//                   restaurantId: _rid,
//                   totalItems: totalItems,
//                   totalAmount: totalAmount,
//                 ),
//               ),
//           ],
//         ),
//       );
//     });
//   }
// }
//
// // ── CART BOTTOM BAR ──────────────────────────────────────────────────────────
// class _CartBottomBar extends StatelessWidget {
//   final Restaurantcartcontroller cartController;
//   final int restaurantId;
//   final int totalItems;
//   final double totalAmount;
//
//   const _CartBottomBar({
//     required this.cartController,
//     required this.restaurantId,
//     required this.totalItems,
//     required this.totalAmount,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     final amountDisplay = totalAmount % 1 == 0
//         ? totalAmount.toInt().toString()
//         : totalAmount.toStringAsFixed(2);
//
//     return Container(
//       decoration: const BoxDecoration(
//         color: Colors.white,
//         boxShadow: [
//           BoxShadow(
//             color: Color(0x18000000),
//             blurRadius: 24,
//             offset: Offset(0, -6),
//           ),
//         ],
//       ),
//       padding: const EdgeInsets.fromLTRB(16, 12, 16, 20),
//       child: Material(
//         color: _AppTheme.primary,
//         borderRadius: BorderRadius.circular(16),
//         child: InkWell(
//           borderRadius: BorderRadius.circular(16),
//           splashColor: Colors.white.withOpacity(0.15),
//           onTap: () => Get.to(
//                 () => RestaurantCartPage(restaurantId: restaurantId),
//           ),
//           child: Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 15),
//             child: Row(
//               children: [
//                 Container(
//                   padding:
//                   const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
//                   decoration: BoxDecoration(
//                     color: Colors.white.withOpacity(0.2),
//                     borderRadius: BorderRadius.circular(8),
//                   ),
//                   child: Text(
//                     '$totalItems item${totalItems > 1 ? 's' : ''}',
//                     style: const TextStyle(
//                       color: Colors.white,
//                       fontWeight: FontWeight.w700,
//                       fontSize: 12,
//                       letterSpacing: 0.3,
//                     ),
//                   ),
//                 ),
//                 const Expanded(
//                   child: Text(
//                     'View Cart',
//                     textAlign: TextAlign.center,
//                     style: TextStyle(
//                       color: Colors.white,
//                       fontWeight: FontWeight.w800,
//                       fontSize: 15,
//                       letterSpacing: 0.3,
//                     ),
//                   ),
//                 ),
//                 Text(
//                   '₹$amountDisplay',
//                   style: const TextStyle(
//                     color: Colors.white,
//                     fontWeight: FontWeight.w800,
//                     fontSize: 15,
//                   ),
//                 ),
//                 const SizedBox(width: 6),
//                 const Icon(Icons.arrow_forward_ios_rounded,
//                     color: Colors.white, size: 13),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
//
// // ── MENU ITEM CARD ────────────────────────────────────────────────────────────
// class _MenuItemCard extends StatelessWidget {
//   final dynamic item;
//   final Restaurantcartcontroller cartController;
//   final int restaurantId;
//
//   const _MenuItemCard({
//     required this.item,
//     required this.cartController,
//     required this.restaurantId,
//   });
//
//   int get _menuId => int.tryParse(item.id?.toString() ?? '0') ?? 0;
//
//   @override
//   Widget build(BuildContext context) {
//     final rawPrice = double.tryParse(item.price?.toString() ?? '0') ?? 0.0;
//     final priceDisplay = rawPrice % 1 == 0
//         ? rawPrice.toInt().toString()
//         : rawPrice.toStringAsFixed(2);
//
//     return Obx(() {
//       final inCart =
//       cartController.isInCartForRestaurant(_menuId, restaurantId);
//       final qty = cartController.itemQtyForRestaurant(_menuId, restaurantId);
//
//       return Container(
//         margin: const EdgeInsets.only(bottom: 14),
//         decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.circular(18),
//           boxShadow: [
//             BoxShadow(
//               color: Colors.black.withOpacity(0.055),
//               blurRadius: 14,
//               offset: const Offset(0, 4),
//             ),
//           ],
//         ),
//         child: Row(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // ── IMAGE ──────────────────────────────────────────────────────
//             ClipRRect(
//               borderRadius: const BorderRadius.only(
//                 topLeft: Radius.circular(18),
//                 bottomLeft: Radius.circular(18),
//               ),
//               child: Image.network(
//                 item.image ?? '',
//                 width: 108,
//                 height: 108,
//                 fit: BoxFit.cover,
//                 errorBuilder: (_, __, ___) => Container(
//                   width: 108,
//                   height: 108,
//                   color: _AppTheme.primaryLight,
//                   child: Icon(Icons.fastfood_rounded,
//                       size: 38, color: _AppTheme.primarySoft),
//                 ),
//                 loadingBuilder: (context, child, loadingProgress) {
//                   if (loadingProgress == null) return child;
//                   return Container(
//                     width: 108,
//                     height: 108,
//                     color: _AppTheme.bg,
//                     child: Center(
//                       child: CircularProgressIndicator(
//                         color: _AppTheme.primary,
//                         strokeWidth: 2,
//                       ),
//                     ),
//                   );
//                 },
//               ),
//             ),
//
//             // ── DETAILS + CONTROLS ─────────────────────────────────────────
//             Expanded(
//               child: Padding(
//                 padding: const EdgeInsets.fromLTRB(14, 12, 12, 12),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       item.foodName ?? '',
//                       style: const TextStyle(
//                         fontSize: 15,
//                         fontWeight: FontWeight.w700,
//                         color: _AppTheme.textDark,
//                         letterSpacing: -0.1,
//                       ),
//                       maxLines: 1,
//                       overflow: TextOverflow.ellipsis,
//                     ),
//                     const SizedBox(height: 4),
//                     Text(
//                       item.shortDescription ?? '',
//                       style: const TextStyle(
//                         fontSize: 11.5,
//                         color: _AppTheme.textLight,
//                         height: 1.45,
//                       ),
//                       maxLines: 2,
//                       overflow: TextOverflow.ellipsis,
//                     ),
//                     const SizedBox(height: 12),
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       crossAxisAlignment: CrossAxisAlignment.center,
//                       children: [
//                         Text(
//                           '₹$priceDisplay',
//                           style: const TextStyle(
//                             fontSize: 17,
//                             fontWeight: FontWeight.w800,
//                             color: _AppTheme.textDark,
//                             letterSpacing: -0.3,
//                           ),
//                         ),
//                         inCart
//                             ? _InCartControls(
//                           qty: qty,
//                           onIncrement: () => cartController
//                               .updateQuantity(_menuId, 'increment'),
//                           onDecrement: () => cartController
//                               .updateQuantity(_menuId, 'decrement'),
//                         )
//                             : _AddButton(
//                           onTap: () async {
//                             final success =
//                             await cartController.addToCart(
//                               restaurantId: restaurantId,
//                               menuId: _menuId,
//                               itemName: item.foodName ?? '',
//                               image: item.image ?? '',
//                               price: rawPrice,
//                             );
//                             if (success) {
//                               Get.snackbar(
//                                 '',
//                                 '',
//                                 titleText: const SizedBox.shrink(),
//                                 messageText: Row(
//                                   children: [
//                                     Container(
//                                       padding: const EdgeInsets.all(6),
//                                       decoration: BoxDecoration(
//                                         color: Colors.white
//                                             .withOpacity(0.2),
//                                         shape: BoxShape.circle,
//                                       ),
//                                       child: const Icon(
//                                           Icons.check_rounded,
//                                           color: Colors.white,
//                                           size: 14),
//                                     ),
//                                     const SizedBox(width: 10),
//                                     Expanded(
//                                       child: Text(
//                                         '${item.foodName} added to cart',
//                                         style: const TextStyle(
//                                           color: Colors.white,
//                                           fontWeight: FontWeight.w600,
//                                           fontSize: 13,
//                                         ),
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                                 backgroundColor: _AppTheme.primary,
//                                 snackPosition: SnackPosition.BOTTOM,
//                                 margin: const EdgeInsets.fromLTRB(
//                                     16, 0, 16, 90),
//                                 borderRadius: 14,
//                                 duration: const Duration(seconds: 2),
//                                 padding: const EdgeInsets.symmetric(
//                                     horizontal: 16, vertical: 12),
//                               );
//                             }
//                           },
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ],
//         ),
//       );
//     });
//   }
// }
//
// // ── ADD BUTTON ────────────────────────────────────────────────────────────────
// class _AddButton extends StatefulWidget {
//   final VoidCallback onTap;
//   const _AddButton({required this.onTap});
//
//   @override
//   State<_AddButton> createState() => _AddButtonState();
// }
//
// class _AddButtonState extends State<_AddButton>
//     with SingleTickerProviderStateMixin {
//   late AnimationController _controller;
//   late Animation<double> _scaleAnim;
//
//   @override
//   void initState() {
//     super.initState();
//     _controller = AnimationController(
//       vsync: this,
//       duration: const Duration(milliseconds: 120),
//       reverseDuration: const Duration(milliseconds: 100),
//     );
//     _scaleAnim = Tween<double>(begin: 1.0, end: 0.92).animate(
//       CurvedAnimation(parent: _controller, curve: Curves.easeIn),
//     );
//   }
//
//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }
//
//   void _onTap() async {
//     await _controller.forward();
//     await _controller.reverse();
//     widget.onTap();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: _onTap,
//       child: ScaleTransition(
//         scale: _scaleAnim,
//         child: Container(
//           padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 9),
//           decoration: BoxDecoration(
//             color: _AppTheme.primary,
//             borderRadius: BorderRadius.circular(12),
//             boxShadow: [
//               BoxShadow(
//                 color: _AppTheme.primary.withOpacity(0.3),
//                 blurRadius: 10,
//                 offset: const Offset(0, 4),
//               ),
//             ],
//           ),
//           child: Row(
//             mainAxisSize: MainAxisSize.min,
//             children: const [
//               Icon(Icons.add_rounded, color: Colors.white, size: 15),
//               SizedBox(width: 4),
//               Text(
//                 'ADD',
//                 style: TextStyle(
//                   color: Colors.white,
//                   fontWeight: FontWeight.w800,
//                   fontSize: 13,
//                   letterSpacing: 0.5,
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
//
// // ── IN-CART CONTROLS ──────────────────────────────────────────────────────────
// class _InCartControls extends StatelessWidget {
//   final int qty;
//   final VoidCallback onIncrement;
//   final VoidCallback onDecrement;
//
//   const _InCartControls({
//     required this.qty,
//     required this.onIncrement,
//     required this.onDecrement,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       height: 36,
//       decoration: BoxDecoration(
//         color: _AppTheme.primaryLight,
//         borderRadius: BorderRadius.circular(12),
//         border: Border.all(color: _AppTheme.primarySoft, width: 1.2),
//       ),
//       child: Row(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           _ControlBtn(
//             icon: Icons.remove_rounded,
//             onTap: onDecrement,
//             isLeft: true,
//           ),
//           Container(
//             width: 32,
//             alignment: Alignment.center,
//             child: AnimatedSwitcher(
//               duration: const Duration(milliseconds: 180),
//               transitionBuilder: (child, animation) => ScaleTransition(
//                 scale: animation,
//                 child: child,
//               ),
//               child: Text(
//                 '$qty',
//                 key: ValueKey(qty),
//                 style: const TextStyle(
//                   fontSize: 14,
//                   fontWeight: FontWeight.w800,
//                   color: _AppTheme.primary,
//                 ),
//               ),
//             ),
//           ),
//           _ControlBtn(
//             icon: Icons.add_rounded,
//             onTap: onIncrement,
//             isLeft: false,
//           ),
//         ],
//       ),
//     );
//   }
// }
//
// class _ControlBtn extends StatelessWidget {
//   final IconData icon;
//   final VoidCallback onTap;
//   final bool isLeft;
//
//   const _ControlBtn({
//     required this.icon,
//     required this.onTap,
//     required this.isLeft,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return Material(
//       color: Colors.transparent,
//       child: InkWell(
//         onTap: onTap,
//         borderRadius: isLeft
//             ? const BorderRadius.only(
//           topLeft: Radius.circular(11),
//           bottomLeft: Radius.circular(11),
//         )
//             : const BorderRadius.only(
//           topRight: Radius.circular(11),
//           bottomRight: Radius.circular(11),
//         ),
//         child: SizedBox(
//           width: 32,
//           height: 36,
//           child: Icon(icon, size: 16, color: _AppTheme.primary),
//         ),
//       ),
//     );
//   }

import 'package:eshoppy/app/modules/restarunent/view/restaurantcartpage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/menu_controller.dart';
import '../controller/restaurantcartcontroller.dart';

// ── THEME CONSTANTS ──────────────────────────────────────────────────────────
class _AppTheme {
  static const primary = Color(0xFF0F5151);
  static const primaryLight = Color(0xFFE8F5F0);
  static const primarySoft = Color(0xFFB2DDD2);
  static const bg = Color(0xFFF8F9FA);
  static const textDark = Color(0xFF1C1C1E);
  static const textMid = Color(0xFF6B6B6B);
  static const textLight = Color(0xFFAAAAAA);
  static const divider = Color(0xFFF0F0F0);
}

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
      if (menuController.availableMealTypes.isEmpty &&
          !menuController.isLoading.value) {
        menuController.init(restaurantId);
      }
    });

    return Obx(() {
      final hasItems = cartController.hasItemsForRestaurant(_rid);
      final totalItems = cartController.totalItemsForRestaurant(_rid);
      final totalAmount = cartController.totalAmountForRestaurant(_rid);

      // ✅ Comes directly from controller — already probed & filtered
      final visibleTypes = menuController.availableMealTypes;

      return Scaffold(
        backgroundColor: _AppTheme.bg,
        body: Stack(
          children: [
            Column(
              children: [
                // ── MEAL TYPE CHIPS ────────────────────────────────────────
                // Only shown when more than 1 meal type has items
                if (!menuController.isLoading.value &&
                    visibleTypes.length > 1) ...[
                  Container(
                    color: Colors.white,
                    child: Column(
                      children: [
                        const SizedBox(height: 14),
                        SizedBox(
                          height: 46,
                          child: ListView.builder(
                            padding:
                            const EdgeInsets.symmetric(horizontal: 16),
                            scrollDirection: Axis.horizontal,
                            itemCount: visibleTypes.length,
                            itemBuilder: (context, index) {
                              final type = visibleTypes[index];
                              final isSelected =
                                  menuController.selectedMealType.value ==
                                      type['value'];
                              return GestureDetector(
                                onTap: () => menuController.changeMealType(
                                    restaurantId, type['value']!),
                                child: AnimatedContainer(
                                  duration:
                                  const Duration(milliseconds: 220),
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

                // ── MENU LIST ──────────────────────────────────────────────
                Expanded(
                  child: menuController.isLoading.value
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
                      ? Center(
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
                            Icons.restaurant_menu_rounded,
                            size: 48,
                            color: _AppTheme.primary,
                          ),
                        ),
                        const SizedBox(height: 20),
                        Text(
                          'No items available',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: _AppTheme.textDark,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          'Check back later for updates',
                          style: TextStyle(
                            fontSize: 13,
                            color: _AppTheme.textLight,
                          ),
                        ),
                      ],
                    ),
                  )
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

            // ── CART BOTTOM BAR ──────────────────────────────────────────
            if (hasItems)
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: _CartBottomBar(
                  cartController: cartController,
                  restaurantId: _rid,
                  totalItems: totalItems,
                  totalAmount: totalAmount,
                ),
              ),
          ],
        ),
      );
    });
  }
}

// ── CART BOTTOM BAR ──────────────────────────────────────────────────────────
class _CartBottomBar extends StatelessWidget {
  final Restaurantcartcontroller cartController;
  final int restaurantId;
  final int totalItems;
  final double totalAmount;

  const _CartBottomBar({
    required this.cartController,
    required this.restaurantId,
    required this.totalItems,
    required this.totalAmount,
  });

  @override
  Widget build(BuildContext context) {
    final amountDisplay = totalAmount % 1 == 0
        ? totalAmount.toInt().toString()
        : totalAmount.toStringAsFixed(2);

    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Color(0x18000000),
            blurRadius: 24,
            offset: Offset(0, -6),
          ),
        ],
      ),
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 20),
      child: Material(
        color: _AppTheme.primary,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          splashColor: Colors.white.withOpacity(0.15),
          onTap: () => Get.to(
                () => RestaurantCartPage(restaurantId: restaurantId),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 15),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    '$totalItems item${totalItems > 1 ? 's' : ''}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      fontSize: 12,
                      letterSpacing: 0.3,
                    ),
                  ),
                ),
                const Expanded(
                  child: Text(
                    'View Cart',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w800,
                      fontSize: 15,
                      letterSpacing: 0.3,
                    ),
                  ),
                ),
                Text(
                  '₹$amountDisplay',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w800,
                    fontSize: 15,
                  ),
                ),
                const SizedBox(width: 6),
                const Icon(Icons.arrow_forward_ios_rounded,
                    color: Colors.white, size: 13),
              ],
            ),
          ),
        ),
      ),
    );
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
      final inCart =
      cartController.isInCartForRestaurant(_menuId, restaurantId);
      final qty = cartController.itemQtyForRestaurant(_menuId, restaurantId);

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
                        Text(
                          '₹$priceDisplay',
                          style: const TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w800,
                            color: _AppTheme.textDark,
                            letterSpacing: -0.3,
                          ),
                        ),
                        inCart
                            ? _InCartControls(
                          qty: qty,
                          onIncrement: () => cartController
                              .updateQuantity(_menuId, 'increment'),
                          onDecrement: () => cartController
                              .updateQuantity(_menuId, 'decrement'),
                        )
                            : _AddButton(
                          onTap: () async {
                            final success =
                            await cartController.addToCart(
                              restaurantId: restaurantId,
                              menuId: _menuId,
                              itemName: item.foodName ?? '',
                              image: item.image ?? '',
                              price: rawPrice,
                            );
                            if (success) {
                              Get.snackbar(
                                '',
                                '',
                                titleText: const SizedBox.shrink(),
                                messageText: Row(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.all(6),
                                      decoration: BoxDecoration(
                                        color: Colors.white
                                            .withOpacity(0.2),
                                        shape: BoxShape.circle,
                                      ),
                                      child: const Icon(
                                          Icons.check_rounded,
                                          color: Colors.white,
                                          size: 14),
                                    ),
                                    const SizedBox(width: 10),
                                    Expanded(
                                      child: Text(
                                        '${item.foodName} added to cart',
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w600,
                                          fontSize: 13,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                backgroundColor: _AppTheme.primary,
                                snackPosition: SnackPosition.BOTTOM,
                                margin: const EdgeInsets.fromLTRB(
                                    16, 0, 16, 90),
                                borderRadius: 14,
                                duration: const Duration(seconds: 2),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 12),
                              );
                            }
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
    await _controller.forward();
    await _controller.reverse();
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
          _ControlBtn(icon: Icons.remove_rounded, onTap: onDecrement, isLeft: true),
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
          _ControlBtn(icon: Icons.add_rounded, onTap: onIncrement, isLeft: false),
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
            topLeft: Radius.circular(11), bottomLeft: Radius.circular(11))
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