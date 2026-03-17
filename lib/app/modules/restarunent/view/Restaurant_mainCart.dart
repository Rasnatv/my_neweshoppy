//
//
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
//
// import '../../../data/models/restaurantmaincartmodel.dart';
// import '../controller/restaurant_maincartcontroller.dart';
//
//
// // ── BINDINGS (optional: use in routes) ────────────────────────────────────────
// class CartBinding extends Bindings {
//   @override
//   void dependencies() {
//     Get.lazyPut<MainCartController>(() => MainCartController());
//   }
// }
//
// // ── MAIN CART PAGE ────────────────────────────────────────────────────────────
// class RestaurantMainCart extends StatelessWidget {
//   RestaurantMainCart({super.key});
//
//   final MainCartController controller = Get.put(MainCartController());
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFFF2F4F3),
//       appBar: AppBar(
//         leading:IconButton(onPressed: ()=>Get.back(),icon:Icon(Icons.arrow_back)),
//         backgroundColor: const Color(0xFF0F5151),
//         foregroundColor: Colors.white,
//         elevation: 0,
//         title: const Text(
//           'My Cart',
//           style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
//         ),
//         actions: [
//           Obx(() {
//             final count = controller.restaurants.length;
//             if (count == 0) return const SizedBox.shrink();
//             return Container(
//               margin: const EdgeInsets.only(right: 16),
//               padding:
//               const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
//               decoration: BoxDecoration(
//                 color: Colors.white.withOpacity(0.2),
//                 borderRadius: BorderRadius.circular(20),
//               ),
//               child: Text(
//                 '$count restaurants',
//                 style: const TextStyle(
//                     fontSize: 12,
//                     color: Colors.white,
//                     fontWeight: FontWeight.w600),
//               ),
//             );
//           }),
//         ],
//       ),
//       body: Obx(() {
//         // ── Loading ──────────────────────────────────────────────────
//         if (controller.isLoading.value) {
//           return const Center(
//             child: CircularProgressIndicator(
//               color: Color(0xFF0F5151),
//             ),
//           );
//         }
//
//         // ── Error ────────────────────────────────────────────────────
//         if (controller.errorMessage.value.isNotEmpty &&
//             controller.restaurants.isEmpty) {
//           return _ErrorView(
//             message: controller.errorMessage.value,
//             onRetry: controller.fetchCart,
//           );
//         }
//
//         // ── Empty ────────────────────────────────────────────────────
//         if (controller.isEmpty) {
//           return const _EmptyCartView();
//         }
//
//         // ── Cart List ────────────────────────────────────────────────
//         return ListView.builder(
//           padding: const EdgeInsets.only(bottom: 130),
//           itemCount: controller.restaurants.length,
//           itemBuilder: (context, index) {
//             final restaurant = controller.restaurants[index];
//             return _RestaurantSection(
//               restaurant: restaurant,
//               onRemoveRestaurant: () =>
//                   _confirmRemoveRestaurant(context, restaurant),
//             );
//           },
//         );
//       }),
//
//       // ── BOTTOM BAR ───────────────────────────────────────────────────
//       bottomNavigationBar: Obx(() {
//         if (controller.isLoading.value || controller.isEmpty) {
//           return const SizedBox(height: 0);
//         }
//         return _PlaceOrderBar(
//           total: controller.grandTotal.value,
//           restaurantCount: controller.restaurants.length,
//           itemCount: controller.totalItemCount,
//         );
//       }),
//     );
//   }
//
//   void _confirmRemoveRestaurant(
//       BuildContext context, MainCartRestaurantModel restaurant) {
//     showModalBottomSheet(
//       context: context,
//       backgroundColor: Colors.white,
//       shape: const RoundedRectangleBorder(
//         borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
//       ),
//       builder: (_) => Padding(
//         padding: const EdgeInsets.fromLTRB(24, 12, 24, 36),
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             Container(
//               width: 40,
//               height: 4,
//               decoration: BoxDecoration(
//                   color: Colors.grey.shade300,
//                   borderRadius: BorderRadius.circular(2)),
//             ),
//             const SizedBox(height: 24),
//             Container(
//               padding: const EdgeInsets.all(18),
//               decoration: BoxDecoration(
//                 color: Colors.red.withOpacity(0.08),
//                 shape: BoxShape.circle,
//               ),
//               child: const Icon(Icons.delete_sweep_rounded,
//                   color: Colors.red, size: 34),
//             ),
//             const SizedBox(height: 16),
//             const Text(
//               'Remove Restaurant?',
//               style: TextStyle(
//                   fontSize: 20,
//                   fontWeight: FontWeight.bold,
//                   color: Colors.black87),
//             ),
//             const SizedBox(height: 8),
//             Text(
//               'All items from "${restaurant.restaurantName}" will be removed.',
//               textAlign: TextAlign.center,
//               style:
//               TextStyle(fontSize: 14, color: Colors.grey.shade600),
//             ),
//             const SizedBox(height: 28),
//             Row(
//               children: [
//                 Expanded(
//                   child: OutlinedButton(
//                     onPressed: () => Get.back(),
//                     style: OutlinedButton.styleFrom(
//                       padding: const EdgeInsets.symmetric(vertical: 14),
//                       shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(14)),
//                       side: BorderSide(color: Colors.grey.shade300),
//                     ),
//                     child: const Text('Cancel',
//                         style: TextStyle(
//                             color: Colors.black87,
//                             fontWeight: FontWeight.w600)),
//                   ),
//                 ),
//                 const SizedBox(width: 12),
//                 Expanded(
//                   child: ElevatedButton(
//                     onPressed: () {
//                       Get.back();
//                       controller
//                           .removeRestaurant(restaurant.restaurantId);
//                     },
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: Colors.red,
//                       padding: const EdgeInsets.symmetric(vertical: 14),
//                       shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(14)),
//                       elevation: 0,
//                     ),
//                     child: const Text('Remove',
//                         style: TextStyle(
//                             color: Colors.white,
//                             fontWeight: FontWeight.bold)),
//                   ),
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
//
// // ── RESTAURANT SECTION ────────────────────────────────────────────────────────
// class _RestaurantSection extends StatelessWidget {
//   final MainCartRestaurantModel restaurant;
//   final VoidCallback onRemoveRestaurant;
//
//   const _RestaurantSection({
//     required this.restaurant,
//     required this.onRemoveRestaurant,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       margin: const EdgeInsets.fromLTRB(16, 16, 16, 0),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(22),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.06),
//             blurRadius: 16,
//             offset: const Offset(0, 4),
//           ),
//         ],
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           // ── RESTAURANT HEADER ──────────────────────────────────────
//           Container(
//             padding: const EdgeInsets.all(16),
//             decoration: const BoxDecoration(
//               gradient: LinearGradient(
//                 colors: [Color(0xFF0F5151), Color(0xFF1B7A6D)],
//                 begin: Alignment.topLeft,
//                 end: Alignment.bottomRight,
//               ),
//               borderRadius:
//               BorderRadius.vertical(top: Radius.circular(22)),
//             ),
//             child: Row(
//               children: [
//                 Container(
//                   width: 48,
//                   height: 48,
//                   decoration: BoxDecoration(
//                     color: Colors.white.withOpacity(0.15),
//                     borderRadius: BorderRadius.circular(14),
//                   ),
//                   child: const Icon(Icons.restaurant_rounded,
//                       color: Colors.white, size: 24),
//                 ),
//                 const SizedBox(width: 12),
//                 Expanded(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         restaurant.restaurantName,
//                         style: const TextStyle(
//                           fontSize: 16,
//                           fontWeight: FontWeight.bold,
//                           color: Colors.white,
//                         ),
//                       ),
//                       const SizedBox(height: 3),
//                       Row(
//                         children: [
//                           const Icon(Icons.location_on_rounded,
//                               size: 11, color: Colors.white60),
//                           const SizedBox(width: 3),
//                           Expanded(
//                             child: Text(
//                               restaurant.restaurantLocation,
//                               style: const TextStyle(
//                                   fontSize: 11, color: Colors.white60),
//                               overflow: TextOverflow.ellipsis,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ],
//                   ),
//                 ),
//                 // Remove restaurant button
//                 GestureDetector(
//                   onTap: onRemoveRestaurant,
//                   child: Container(
//                     padding: const EdgeInsets.all(8),
//                     decoration: BoxDecoration(
//                       color: Colors.red.withOpacity(0.2),
//                       borderRadius: BorderRadius.circular(10),
//                     ),
//                     child: const Icon(Icons.delete_outline_rounded,
//                         color: Colors.white, size: 18),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//
//           // ── ITEMS LIST ─────────────────────────────────────────────
//           ListView.separated(
//             shrinkWrap: true,
//             physics: const NeverScrollableScrollPhysics(),
//             padding: const EdgeInsets.all(14),
//             itemCount: restaurant.items.length,
//             separatorBuilder: (_, __) => const Divider(
//                 height: 20,
//                 thickness: 1,
//                 color: Color(0xFFF5F5F5)),
//             itemBuilder: (context, index) {
//               final item = restaurant.items[index];
//               return _CartItemRow(
//                 item: item,
//                 restaurantId: restaurant.restaurantId,
//               );
//             },
//           ),
//
//           // ── RESTAURANT SUBTOTAL ────────────────────────────────────
//           Container(
//             padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
//             child: Container(
//               padding: const EdgeInsets.symmetric(
//                   horizontal: 14, vertical: 10),
//               decoration: BoxDecoration(
//                 color: const Color(0xFF0F5151).withOpacity(0.06),
//                 borderRadius: BorderRadius.circular(12),
//               ),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Text(
//                     '${restaurant.itemCount} items subtotal',
//                     style: TextStyle(
//                       fontSize: 13,
//                       fontWeight: FontWeight.w500,
//                       color: Colors.grey.shade700,
//                     ),
//                   ),
//                   Text(
//                     '₹${_formatPrice(restaurant.subtotal)}',
//                     style: const TextStyle(
//                       fontSize: 15,
//                       fontWeight: FontWeight.bold,
//                       color: Color(0xFF0F5151),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   String _formatPrice(double price) =>
//       price % 1 == 0 ? price.toInt().toString() : price.toStringAsFixed(2);
// }
//
// // ── CART ITEM ROW ─────────────────────────────────────────────────────────────
// class _CartItemRow extends StatelessWidget {
//   final MainCartItemModel item;
//   final int restaurantId;
//
//   const _CartItemRow(
//       {required this.item, required this.restaurantId});
//
//   MainCartController get _controller => Get.find<MainCartController>();
//
//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       children: [
//         // Image
//         ClipRRect(
//           borderRadius: BorderRadius.circular(12),
//           child: Image.network(
//             item.image,
//             width: 68,
//             height: 68,
//             fit: BoxFit.cover,
//             errorBuilder: (_, __, ___) => Container(
//               width: 68,
//               height: 68,
//               decoration: BoxDecoration(
//                 color: const Color(0xFF0F5151).withOpacity(0.08),
//                 borderRadius: BorderRadius.circular(12),
//               ),
//               child: const Icon(Icons.fastfood_rounded,
//                   size: 28, color: Color(0xFF0F5151)),
//             ),
//           ),
//         ),
//         const SizedBox(width: 12),
//
//         // Info
//         Expanded(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Row(
//                 children: [
//                   Expanded(
//                     child: Text(
//                       item.itemName,
//                       style: const TextStyle(
//                         fontSize: 13,
//                         fontWeight: FontWeight.w600,
//                         color: Colors.black87,
//                       ),
//                       maxLines: 2,
//                       overflow: TextOverflow.ellipsis,
//                     ),
//                   ),
//                   // Delete button
//                   GestureDetector(
//                     onTap: () =>
//                         _controller.removeItem(restaurantId, item.itemName),
//                     child: Container(
//                       padding: const EdgeInsets.all(4),
//                       decoration: BoxDecoration(
//                         color: Colors.red.withOpacity(0.08),
//                         borderRadius: BorderRadius.circular(7),
//                       ),
//                       child: const Icon(Icons.close_rounded,
//                           size: 14, color: Colors.red),
//                     ),
//                   ),
//                 ],
//               ),
//               const SizedBox(height: 6),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Text(
//                     '₹${_formatPrice(item.totalPrice)}',
//                     style: const TextStyle(
//                       fontSize: 15,
//                       fontWeight: FontWeight.bold,
//                       color: Color(0xFF0F5151),
//                     ),
//                   ),
//                   // Qty controls
//                   Container(
//                     decoration: BoxDecoration(
//                       color: const Color(0xFF0F5151).withOpacity(0.08),
//                       borderRadius: BorderRadius.circular(10),
//                     ),
//                     child: Row(
//                       mainAxisSize: MainAxisSize.min,
//                       children: [
//                         GestureDetector(
//                           onTap: () => _controller.decrementItem(
//                               restaurantId, item.itemName),
//                           child: Container(
//                             width: 32,
//                             height: 32,
//                             alignment: Alignment.center,
//                             child: Icon(
//                               item.quantity == 1
//                                   ? Icons.delete_outline_rounded
//                                   : Icons.remove_rounded,
//                               size: 15,
//                               color: item.quantity == 1
//                                   ? Colors.red
//                                   : const Color(0xFF0F5151),
//                             ),
//                           ),
//                         ),
//                         SizedBox(
//                           width: 26,
//                           child: Center(
//                             child: Text(
//                               '${item.quantity}',
//                               style: const TextStyle(
//                                 fontSize: 13,
//                                 fontWeight: FontWeight.bold,
//                                 color: Color(0xFF0F5151),
//                               ),
//                             ),
//                           ),
//                         ),
//                         GestureDetector(
//                           onTap: () => _controller.incrementItem(
//                               restaurantId, item.itemName),
//                           child: Container(
//                             width: 32,
//                             height: 32,
//                             alignment: Alignment.center,
//                             child: const Icon(Icons.add_rounded,
//                                 size: 15, color: Color(0xFF0F5151)),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//             ],
//           ),
//         ),
//       ],
//     );
//   }
//
//   String _formatPrice(double price) =>
//       price % 1 == 0 ? price.toInt().toString() : price.toStringAsFixed(2);
// }
//
// // ── PLACE ORDER BAR ───────────────────────────────────────────────────────────
// class _PlaceOrderBar extends StatelessWidget {
//   final double total;
//   final int restaurantCount;
//   final int itemCount;
//
//   const _PlaceOrderBar({
//     required this.total,
//     required this.restaurantCount,
//     required this.itemCount,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     final totalDisplay =
//     total % 1 == 0 ? total.toInt().toString() : total.toStringAsFixed(2);
//
//     return Container(
//       padding: const EdgeInsets.fromLTRB(20, 14, 20, 28),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.08),
//             blurRadius: 16,
//             offset: const Offset(0, -4),
//           ),
//         ],
//       ),
//       child: SafeArea(
//         top: false,
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       'Grand Total',
//                       style: TextStyle(
//                           fontSize: 12,
//                           color: Colors.grey.shade500,
//                           fontWeight: FontWeight.w500),
//                     ),
//                     const SizedBox(height: 2),
//                     Text(
//                       '₹$totalDisplay',
//                       style: const TextStyle(
//                         fontSize: 24,
//                         fontWeight: FontWeight.bold,
//                         color: Color(0xFF0F5151),
//                       ),
//                     ),
//                   ],
//                 ),
//                 Column(
//                   crossAxisAlignment: CrossAxisAlignment.end,
//                   children: [
//                     Text(
//                       '$restaurantCount restaurants',
//                       style: TextStyle(
//                           fontSize: 11, color: Colors.grey.shade500),
//                     ),
//                     const SizedBox(height: 2),
//                     Text(
//                       '$itemCount items • incl. GST',
//                       style: const TextStyle(
//                           fontSize: 11,
//                           fontWeight: FontWeight.w600,
//                           color: Color(0xFF0F5151)),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//             const SizedBox(height: 14),
//             SizedBox(
//               width: double.infinity,
//               child: ElevatedButton(
//                 onPressed: () {
//                   // TODO: Navigate to checkout / place order API call
//                 },
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: const Color(0xFF0F5151),
//                   foregroundColor: Colors.white,
//                   padding: const EdgeInsets.symmetric(vertical: 16),
//                   shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(18)),
//                   elevation: 0,
//                 ),
//                 child: const Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     Icon(Icons.calendar_month_rounded, size: 20),
//                     SizedBox(width: 10),
//                     Text(
//                       'Place Order',
//                       style: TextStyle(
//                           fontSize: 16,
//                           fontWeight: FontWeight.bold,
//                           letterSpacing: 0.3),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
//
// // ── EMPTY CART ────────────────────────────────────────────────────────────────
// class _EmptyCartView extends StatelessWidget {
//   const _EmptyCartView();
//
//   @override
//   Widget build(BuildContext context) {
//     return Center(
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Container(
//             padding: const EdgeInsets.all(28),
//             decoration: BoxDecoration(
//               color: const Color(0xFF0F5151).withOpacity(0.08),
//               shape: BoxShape.circle,
//             ),
//             child: const Icon(Icons.shopping_cart_outlined,
//                 size: 60, color: Color(0xFF0F5151)),
//           ),
//           const SizedBox(height: 24),
//           const Text('Your cart is empty',
//               style: TextStyle(
//                   fontSize: 22,
//                   fontWeight: FontWeight.bold,
//                   color: Colors.black87)),
//           const SizedBox(height: 8),
//           Text('Add items from restaurants to get started',
//               style:
//               TextStyle(fontSize: 14, color: Colors.grey.shade500)),
//           const SizedBox(height: 32),
//           ElevatedButton.icon(
//             onPressed: () => Get.back(),
//             icon: const Icon(Icons.arrow_back_rounded, size: 18),
//             label: const Text('Browse Menu',
//                 style:
//                 TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
//             style: ElevatedButton.styleFrom(
//               backgroundColor: const Color(0xFF0F5151),
//               foregroundColor: Colors.white,
//               padding: const EdgeInsets.symmetric(
//                   horizontal: 28, vertical: 14),
//               shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(14)),
//               elevation: 0,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
//
// // ── ERROR VIEW ────────────────────────────────────────────────────────────────
// class _ErrorView extends StatelessWidget {
//   final String message;
//   final VoidCallback onRetry;
//
//   const _ErrorView({required this.message, required this.onRetry});
//
//   @override
//   Widget build(BuildContext context) {
//     return Center(
//       child: Padding(
//         padding: const EdgeInsets.all(32),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Container(
//               padding: const EdgeInsets.all(22),
//               decoration: BoxDecoration(
//                 color: Colors.red.withOpacity(0.08),
//                 shape: BoxShape.circle,
//               ),
//               child: const Icon(Icons.wifi_off_rounded,
//                   size: 48, color: Colors.red),
//             ),
//             const SizedBox(height: 20),
//             const Text('Something went wrong',
//                 style: TextStyle(
//                     fontSize: 20,
//                     fontWeight: FontWeight.bold,
//                     color: Colors.black87)),
//             const SizedBox(height: 8),
//             Text(
//               message,
//               textAlign: TextAlign.center,
//               style:
//               TextStyle(fontSize: 14, color: Colors.grey.shade500),
//             ),
//             const SizedBox(height: 28),
//             ElevatedButton.icon(
//               onPressed: onRetry,
//               icon: const Icon(Icons.refresh_rounded, size: 18),
//               label: const Text('Try Again',
//                   style: TextStyle(
//                       fontWeight: FontWeight.bold, fontSize: 15)),
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: const Color(0xFF0F5151),
//                 foregroundColor: Colors.white,
//                 padding: const EdgeInsets.symmetric(
//                     horizontal: 28, vertical: 14),
//                 shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(14)),
//                 elevation: 0,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
// ── Restaurant_mainCart.dart ──────────────────────────────────────────────────
//
// Navigate here like:
//   Get.to(() => RestaurantMainCart(restaurantId: 60));
//   Get.offAll(() => RestaurantMainCart(restaurantId: 60));
//
// ─────────────────────────────────────────────────────────────────────────────

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../data/models/restaurantmaincartmodel.dart';
import '../controller/restaurant_maincartcontroller.dart';

class RestaurantMainCart extends StatelessWidget {
  final int restaurantId;

  RestaurantMainCart({super.key, required this.restaurantId}) {
    // Delete stale instance, create fresh one with correct restaurantId
    if (Get.isRegistered<MainCartController>()) {
      Get.delete<MainCartController>(force: true);
    }
    Get.put(MainCartController(restaurantId: restaurantId));
  }

  MainCartController get _c => Get.find<MainCartController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F4F3),
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 18),
        ),
        backgroundColor: const Color(0xFF0F5151),
        foregroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'My Cart',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
        actions: [
          Obx(() {
            final data = _c.cartData.value;
            if (data == null) return const SizedBox.shrink();
            return Container(
              margin: const EdgeInsets.only(right: 8),
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.20),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                '${data.totalItemCount} items',
                style: const TextStyle(
                    fontSize: 12,
                    color: Colors.white,
                    fontWeight: FontWeight.w600),
              ),
            );
          }),
          IconButton(
            icon: const Icon(Icons.refresh_rounded, size: 20),
            onPressed: () => _c.fetchCart(),
          ),
        ],
      ),

      // ── Body ──────────────────────────────────────────────────────────────
      body: Obx(() {
        // Loading
        if (_c.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(color: Color(0xFF0F5151)),
          );
        }

        // Error (no data at all)
        if (_c.errorMessage.value.isNotEmpty && _c.cartData.value == null) {
          return _ErrorView(
            message: _c.errorMessage.value,
            onRetry: _c.fetchCart,
          );
        }

        // Empty cart
        if (_c.isEmpty) {
          return const _EmptyCartView();
        }

        final data = _c.cartData.value!;

        return RefreshIndicator(
          color: const Color(0xFF0F5151),
          onRefresh: _c.fetchCart,
          child: ListView(
            padding: const EdgeInsets.only(bottom: 140),
            children: [
              // ── Booking summary ────────────────────────────────
              if (data.bookingDetails != null)
                _BookingSummaryCard(
                  restaurant: data.restaurant,
                  details:    data.bookingDetails!,
                ),

              const SizedBox(height: 6),

              // ── Section header ─────────────────────────────────
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 10, 16, 4),
                child: Row(
                  children: [
                    const Icon(Icons.shopping_bag_outlined,
                        color: Color(0xFF0F5151), size: 18),
                    const SizedBox(width: 8),
                    const Text(
                      'Cart Items',
                      style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF2D2D2D)),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: const Color(0xFF0F5151).withOpacity(0.12),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        '${data.cartItems.length}',
                        style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF0F5151)),
                      ),
                    ),
                  ],
                ),
              ),

              // ── Items card ─────────────────────────────────────
              Container(
                margin: const EdgeInsets.fromLTRB(16, 8, 16, 0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(22),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.06),
                      blurRadius: 16,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  padding: const EdgeInsets.all(14),
                  itemCount: data.cartItems.length,
                  separatorBuilder: (_, __) => const Divider(
                      height: 20, thickness: 1, color: Color(0xFFF5F5F5)),
                  itemBuilder: (_, i) => _CartItemRow(
                    item:       data.cartItems[i],
                    controller: _c,
                  ),
                ),
              ),

              // ── Totals ─────────────────────────────────────────
              _GrandTotalCard(data: data),
            ],
          ),
        );
      }),

      // ── Bottom bar ────────────────────────────────────────────────────────
      bottomNavigationBar: Obx(() {
        if (_c.isLoading.value || _c.isEmpty) return const SizedBox.shrink();
        return _PlaceOrderBar(
          total:     _c.cartData.value!.grandTotal,
          itemCount: _c.cartData.value!.totalItemCount,
        );
      }),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// BOOKING SUMMARY CARD
// ─────────────────────────────────────────────────────────────────────────────
class _BookingSummaryCard extends StatelessWidget {
  final FinalCartRestaurant     restaurant;
  final FinalCartBookingDetails details;

  const _BookingSummaryCard(
      {required this.restaurant, required this.details});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF0F5151), Color(0xFF1B7A6D)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0F5151).withOpacity(0.28),
            blurRadius: 14,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          // ── Restaurant header ────────────────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(18, 18, 18, 14),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.18),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.restaurant_rounded,
                      color: Colors.white, size: 22),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        restaurant.restaurantName,
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 3),
                      Row(
                        children: [
                          const Icon(Icons.location_on_rounded,
                              size: 11, color: Colors.white60),
                          const SizedBox(width: 3),
                          Expanded(
                            child: Text(
                              restaurant.address,
                              style: const TextStyle(
                                  fontSize: 11, color: Colors.white60),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.20),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    '# ${details.bookingId}',
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w700),
                  ),
                ),
              ],
            ),
          ),

          Divider(color: Colors.white.withOpacity(0.20), height: 1),

          // ── Info tiles ───────────────────────────────────────
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Row(children: [
                  _InfoTile(
                      icon: Icons.calendar_today_rounded,
                      label: 'Date',
                      value: _niceDate(details.bookingDate)),
                  const SizedBox(width: 10),
                  _InfoTile(
                      icon: Icons.access_time_rounded,
                      label: 'Time',
                      value: details.timeSlot),
                ]),
                const SizedBox(height: 10),
                Row(children: [
                  _InfoTile(
                      icon: Icons.table_bar_rounded,
                      label: 'Table',
                      value: details.tableNo),
                  const SizedBox(width: 10),
                  _InfoTile(
                      icon: Icons.people_alt_rounded,
                      label: 'Guests',
                      value: details.guests),
                ]),
                const SizedBox(height: 10),
                Row(children: [
                  _InfoTile(
                      icon: Icons.restaurant_menu_rounded,
                      label: 'Meal',
                      value: details.mealLabel),
                  const SizedBox(width: 10),
                  _InfoTile(
                      icon: Icons.chair_alt_rounded,
                      label: 'Seating',
                      value: details.seatingLabel),
                ]),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _niceDate(String raw) {
    try {
      final p  = raw.split('-');
      final dt = DateTime(
          int.parse(p[0]), int.parse(p[1]), int.parse(p[2]));
      const m = ['Jan','Feb','Mar','Apr','May','Jun',
        'Jul','Aug','Sep','Oct','Nov','Dec'];
      return '${dt.day} ${m[dt.month - 1]} ${dt.year}';
    } catch (_) {
      return raw;
    }
  }
}

class _InfoTile extends StatelessWidget {
  final IconData icon;
  final String   label;
  final String   value;
  const _InfoTile(
      {required this.icon, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.15),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: [
            Icon(icon, color: Colors.white70, size: 14),
            const SizedBox(width: 7),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(label,
                      style: const TextStyle(
                          color: Colors.white60,
                          fontSize: 10,
                          fontWeight: FontWeight.w500)),
                  const SizedBox(height: 2),
                  Text(
                    value.isNotEmpty ? value : '—',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w700),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// CART ITEM ROW
// ─────────────────────────────────────────────────────────────────────────────
class _CartItemRow extends StatelessWidget {
  final FinalCartItem      item;
  final MainCartController controller;
  const _CartItemRow({required this.item, required this.controller});

  static const _imgBase =
      'https://rasma.astradevelops.in/e_shoppyy/public/';

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Image
        ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: item.image.isNotEmpty
              ? Image.network(
            '$_imgBase${item.image}',
            width: 68, height: 68, fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => _placeholder(),
          )
              : _placeholder(),
        ),
        const SizedBox(width: 12),

        // Details
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Name + remove button
              Row(
                children: [
                  Expanded(
                    child: Text(
                      item.itemName,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87),
                    ),
                  ),
                  GestureDetector(
                    onTap: () => controller.removeItem(item.id),
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: Colors.red.withOpacity(0.08),
                        borderRadius: BorderRadius.circular(7),
                      ),
                      child: const Icon(Icons.close_rounded,
                          size: 14, color: Colors.red),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                '₹${_fmt(item.price)} × ${item.quantity}',
                style: TextStyle(fontSize: 11, color: Colors.grey.shade500),
              ),
              const SizedBox(height: 6),

              // Total + stepper
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '₹${_fmt(item.totalPrice)}',
                    style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF0F5151)),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFF0F5151).withOpacity(0.08),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        GestureDetector(
                          onTap: () => controller.decrementItem(item.id),
                          child: Container(
                            width: 32, height: 32,
                            alignment: Alignment.center,
                            child: Icon(
                              item.quantity == 1
                                  ? Icons.delete_outline_rounded
                                  : Icons.remove_rounded,
                              size: 15,
                              color: item.quantity == 1
                                  ? Colors.red
                                  : const Color(0xFF0F5151),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 26,
                          child: Center(
                            child: Text(
                              '${item.quantity}',
                              style: const TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF0F5151)),
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () => controller.incrementItem(item.id),
                          child: Container(
                            width: 32, height: 32,
                            alignment: Alignment.center,
                            child: const Icon(Icons.add_rounded,
                                size: 15, color: Color(0xFF0F5151)),
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
      ],
    );
  }

  Widget _placeholder() => Container(
    width: 68, height: 68,
    decoration: BoxDecoration(
      color: const Color(0xFF0F5151).withOpacity(0.08),
      borderRadius: BorderRadius.circular(12),
    ),
    child: const Icon(Icons.fastfood_rounded,
        size: 28, color: Color(0xFF0F5151)),
  );

  String _fmt(double v) =>
      v % 1 == 0 ? v.toInt().toString() : v.toStringAsFixed(2);
}

// ─────────────────────────────────────────────────────────────────────────────
// GRAND TOTAL CARD
// ─────────────────────────────────────────────────────────────────────────────
class _GrandTotalCard extends StatelessWidget {
  final FinalCartData data;
  const _GrandTotalCard({required this.data});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 14, 16, 0),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 14,
              offset: const Offset(0, 3))
        ],
      ),
      child: Column(
        children: [
          _TotalRow(
              label: 'Subtotal',
              value: data.cartSubtotal,
              color: Colors.grey.shade700,
              fontSize: 13),
          const SizedBox(height: 6),
          Divider(color: Colors.grey.shade200),
          const SizedBox(height: 6),
          _TotalRow(
              label: 'Grand Total',
              value: data.grandTotal,
              color: const Color(0xFF0F5151),
              fontSize: 17,
              bold: true),
        ],
      ),
    );
  }
}

class _TotalRow extends StatelessWidget {
  final String label;
  final double value;
  final Color  color;
  final double fontSize;
  final bool   bold;
  const _TotalRow({
    required this.label,
    required this.value,
    required this.color,
    required this.fontSize,
    this.bold = false,
  });

  @override
  Widget build(BuildContext context) {
    final s = TextStyle(
        fontSize: fontSize,
        fontWeight: bold ? FontWeight.bold : FontWeight.w500,
        color: color);
    final v = value % 1 == 0
        ? value.toInt().toString()
        : value.toStringAsFixed(2);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [Text(label, style: s), Text('₹$v', style: s)],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// PLACE ORDER BAR
// ─────────────────────────────────────────────────────────────────────────────
class _PlaceOrderBar extends StatelessWidget {
  final double total;
  final int    itemCount;
  const _PlaceOrderBar({required this.total, required this.itemCount});

  @override
  Widget build(BuildContext context) {
    final t = total % 1 == 0
        ? total.toInt().toString()
        : total.toStringAsFixed(2);

    return Container(
      padding: const EdgeInsets.fromLTRB(20, 14, 20, 28),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 16,
              offset: const Offset(0, -4))
        ],
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Grand Total',
                        style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey.shade500,
                            fontWeight: FontWeight.w500)),
                    const SizedBox(height: 2),
                    Text('₹$t',
                        style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF0F5151))),
                  ],
                ),
                Text('$itemCount items',
                    style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF0F5151))),
              ],
            ),
            const SizedBox(height: 14),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  // TODO: navigate to checkout
                },
                icon:  const Icon(Icons.calendar_month_rounded, size: 20),
                label: const Text('Place Order',
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.3)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF0F5151),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18)),
                  elevation: 0,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// EMPTY CART
// ─────────────────────────────────────────────────────────────────────────────
class _EmptyCartView extends StatelessWidget {
  const _EmptyCartView();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(28),
            decoration: BoxDecoration(
              color: const Color(0xFF0F5151).withOpacity(0.08),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.shopping_cart_outlined,
                size: 60, color: Color(0xFF0F5151)),
          ),
          const SizedBox(height: 24),
          const Text('Your cart is empty',
              style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87)),
          const SizedBox(height: 8),
          Text('Add items from a restaurant to get started',
              style: TextStyle(fontSize: 14, color: Colors.grey.shade500)),
          const SizedBox(height: 32),
          ElevatedButton.icon(
            onPressed: () => Get.back(),
            icon:  const Icon(Icons.arrow_back_rounded, size: 18),
            label: const Text('Browse Menu',
                style:
                TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF0F5151),
              foregroundColor: Colors.white,
              padding:
              const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14)),
              elevation: 0,
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// ERROR VIEW
// ─────────────────────────────────────────────────────────────────────────────
class _ErrorView extends StatelessWidget {
  final String       message;
  final VoidCallback onRetry;
  const _ErrorView({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(22),
              decoration: BoxDecoration(
                color: Colors.red.withOpacity(0.08),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.wifi_off_rounded,
                  size: 48, color: Colors.red),
            ),
            const SizedBox(height: 20),
            const Text('Something went wrong',
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87)),
            const SizedBox(height: 8),
            Text(message,
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 14, color: Colors.grey.shade500)),
            const SizedBox(height: 28),
            ElevatedButton.icon(
              onPressed: onRetry,
              icon:  const Icon(Icons.refresh_rounded, size: 18),
              label: const Text('Try Again',
                  style: TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 15)),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF0F5151),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                    horizontal: 28, vertical: 14),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14)),
                elevation: 0,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
