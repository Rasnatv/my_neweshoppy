// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
//
// // ── DUMMY MODELS ──────────────────────────────────────────────────────────────
// class DummyCartItem {
//   final int id;
//   final String name;
//   final String image;
//   final double price;
//   int quantity;
//
//   DummyCartItem({
//     required this.id,
//     required this.name,
//     required this.image,
//     required this.price,
//     required this.quantity,
//   });
//
//   double get totalPrice => price * quantity;
// }
//
// class DummyRestaurant {
//   final int id;
//   final String name;
//   final String location;
//   final String rating;
//   final List<DummyCartItem> items;
//
//   DummyRestaurant({
//     required this.id,
//     required this.name,
//     required this.location,
//     required this.rating,
//     required this.items,
//   });
//
//   double get subTotal =>
//       items.fold(0, (sum, item) => sum + item.totalPrice);
//   double get tax => subTotal * 0.05;
//   double get total => subTotal + tax;
//   int get itemCount => items.fold(0, (sum, item) => sum + item.quantity);
// }
//
// // ── DUMMY DATA ────────────────────────────────────────────────────────────────
// final dummyRestaurants = [
//   DummyRestaurant(
//     id: 1,
//     name: 'Spice Garden Kitchen',
//     location: 'MG Road, Kozhikode',
//     rating: '4.8',
//     items: [
//       DummyCartItem(
//         id: 1,
//         name: 'Butter Chicken Masala',
//         image: 'https://images.unsplash.com/photo-1603894584373-5ac82b2ae398?w=200',
//         price: 320,
//         quantity: 2,
//       ),
//       DummyCartItem(
//         id: 2,
//         name: 'Garlic Naan Basket',
//         image: 'https://images.unsplash.com/photo-1601050690597-df0568f70950?w=200',
//         price: 80,
//         quantity: 3,
//       ),
//       DummyCartItem(
//         id: 3,
//         name: 'Mango Lassi',
//         image: 'https://images.unsplash.com/photo-1571091718767-18b5b1457add?w=200',
//         price: 120,
//         quantity: 1,
//       ),
//     ],
//   ),
//   DummyRestaurant(
//     id: 2,
//     name: 'The Biryani House',
//     location: 'Beach Road, Calicut',
//     rating: '4.6',
//     items: [
//       DummyCartItem(
//         id: 4,
//         name: 'Chicken Dum Biryani',
//         image: 'https://images.unsplash.com/photo-1563379091339-03b21ab4a4f8?w=200',
//         price: 280,
//         quantity: 1,
//       ),
//       DummyCartItem(
//         id: 5,
//         name: 'Raita Bowl',
//         image: 'https://images.unsplash.com/photo-1571091718767-18b5b1457add?w=200',
//         price: 60,
//         quantity: 2,
//       ),
//     ],
//   ),
//   DummyRestaurant(
//     id: 3,
//     name: 'Pizza Paradiso',
//     location: 'SM Street, Kozhikode',
//     rating: '4.5',
//     items: [
//       DummyCartItem(
//         id: 6,
//         name: 'Margherita Pizza (M)',
//         image: 'https://images.unsplash.com/photo-1604382354936-07c5d9983bd3?w=200',
//         price: 350,
//         quantity: 1,
//       ),
//       DummyCartItem(
//         id: 7,
//         name: 'Garlic Bread',
//         image: 'https://images.unsplash.com/photo-1573140247632-f8fd74997d5c?w=200',
//         price: 120,
//         quantity: 2,
//       ),
//     ],
//   ),
// ].obs;
//
// // ── MAIN CART PAGE ────────────────────────────────────────────────────────────
// class RestaurantMainCart extends StatelessWidget {
//   const RestaurantMainCart ({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     final grandTotal = dummyRestaurants.fold(
//         0.0, (sum, r) => sum + r.total);
//     final totalItems = dummyRestaurants.fold(
//         0, (sum, r) => sum + r.itemCount);
//
//     return Scaffold(
//       backgroundColor: const Color(0xFFF2F4F3),
//       appBar: AppBar(
//         backgroundColor: const Color(0xFF0F5151),
//         foregroundColor: Colors.white,
//         elevation: 0,
//         title: const Text(
//           'My Cart',
//           style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
//         ),
//         actions: [
//           Obx(() {
//             final count = dummyRestaurants.length;
//             return Container(
//               margin: const EdgeInsets.only(right: 16),
//               padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
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
//         if (dummyRestaurants.isEmpty) {
//           return const _EmptyCartView();
//         }
//
//         return ListView.builder(
//           padding: const EdgeInsets.only(bottom: 130),
//           itemCount: dummyRestaurants.length,
//           itemBuilder: (context, index) {
//             final restaurant = dummyRestaurants[index];
//             return _RestaurantSection(
//               restaurant: restaurant,
//               onRemoveRestaurant: () =>
//                   _confirmRemoveRestaurant(context, restaurant),
//             );
//           },
//         );
//       }),
//
//       // ── BOTTOM PLACE ORDER ────────────────────────────────────────
//       bottomNavigationBar: Obx(() {
//         if (dummyRestaurants.isEmpty) return const SizedBox(height: 0);
//         final grandTotal = dummyRestaurants.fold(
//             0.0, (sum, r) => sum + r.total);
//         final totalItems = dummyRestaurants.fold(
//             0, (sum, r) => sum + r.itemCount);
//         return _PlaceOrderBar(
//           total: grandTotal,
//           restaurantCount: dummyRestaurants.length,
//           itemCount: totalItems,
//         );
//       }),
//     );
//   }
//
//   void _confirmRemoveRestaurant(
//       BuildContext context, DummyRestaurant restaurant) {
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
//               width: 40, height: 4,
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
//             const Text('Remove Restaurant?',
//                 style: TextStyle(
//                     fontSize: 20,
//                     fontWeight: FontWeight.bold,
//                     color: Colors.black87)),
//             const SizedBox(height: 8),
//             Text(
//               'All items from "${restaurant.name}" will be removed.',
//               textAlign: TextAlign.center,
//               style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
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
//                       dummyRestaurants
//                           .removeWhere((r) => r.id == restaurant.id);
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
//   final DummyRestaurant restaurant;
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
//               borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
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
//                         restaurant.name,
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
//                           Text(
//                             restaurant.location,
//                             style: const TextStyle(
//                                 fontSize: 11, color: Colors.white60),
//                           ),
//                           const SizedBox(width: 8),
//                           const Icon(Icons.star_rounded,
//                               size: 11, color: Colors.amber),
//                           const SizedBox(width: 2),
//                           Text(
//                             restaurant.rating,
//                             style: const TextStyle(
//                                 fontSize: 11, color: Colors.white70),
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
//                 height: 20, thickness: 1, color: Color(0xFFF5F5F5)),
//             itemBuilder: (context, index) {
//               final item = restaurant.items[index];
//               return _CartItemRow(
//                 item: item,
//                 restaurantId: restaurant.id,
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
//                     '₹${restaurant.subTotal % 1 == 0 ? restaurant.subTotal.toInt() : restaurant.subTotal.toStringAsFixed(2)}',
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
// }
//
// // ── CART ITEM ROW ─────────────────────────────────────────────────────────────
// class _CartItemRow extends StatelessWidget {
//   final DummyCartItem item;
//   final int restaurantId;
//
//   const _CartItemRow({required this.item, required this.restaurantId});
//
//   void _increment() {
//     final rest =
//     dummyRestaurants.firstWhere((r) => r.id == restaurantId);
//     final idx = rest.items.indexWhere((i) => i.id == item.id);
//     if (idx != -1) {
//       rest.items[idx].quantity++;
//       dummyRestaurants.refresh();
//     }
//   }
//
//   void _decrement() {
//     final rest =
//     dummyRestaurants.firstWhere((r) => r.id == restaurantId);
//     final idx = rest.items.indexWhere((i) => i.id == item.id);
//     if (idx != -1) {
//       if (rest.items[idx].quantity > 1) {
//         rest.items[idx].quantity--;
//       } else {
//         rest.items.removeAt(idx);
//         if (rest.items.isEmpty) {
//           dummyRestaurants.removeWhere((r) => r.id == restaurantId);
//         }
//       }
//       dummyRestaurants.refresh();
//     }
//   }
//
//   void _delete() {
//     final rest =
//     dummyRestaurants.firstWhere((r) => r.id == restaurantId);
//     rest.items.removeWhere((i) => i.id == item.id);
//     if (rest.items.isEmpty) {
//       dummyRestaurants.removeWhere((r) => r.id == restaurantId);
//     }
//     dummyRestaurants.refresh();
//   }
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
//                       item.name,
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
//                     onTap: _delete,
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
//                     '₹${item.totalPrice % 1 == 0 ? item.totalPrice.toInt() : item.totalPrice.toStringAsFixed(2)}',
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
//                           onTap: _decrement,
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
//                           onTap: _increment,
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
//     final totalDisplay = total % 1 == 0
//         ? total.toInt().toString()
//         : total.toStringAsFixed(2);
//
//     return Container(
//       padding: const EdgeInsets.fromLTRB(20, 14, 20, 28),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius:
//         const BorderRadius.vertical(top: Radius.circular(24)),
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
//                 onPressed: () {},
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
//                 style: TextStyle(
//                     fontWeight: FontWeight.bold, fontSize: 15)),
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
// ── CART PAGE (API-Connected UI) ───────────────────────────────────────────────
// File: lib/views/restaurant_main_cart.dart
//
// Dependencies: get, http
// Run: flutter pub add get http

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../data/models/restaurantmaincartmodel.dart';
import '../controller/restaurant_maincartcontroller.dart';


// ── BINDINGS (optional: use in routes) ────────────────────────────────────────
class CartBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MainCartController>(() => MainCartController());
  }
}

// ── MAIN CART PAGE ────────────────────────────────────────────────────────────
class RestaurantMainCart extends StatelessWidget {
  RestaurantMainCart({super.key});

  final MainCartController controller = Get.put(MainCartController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F4F3),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0F5151),
        foregroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'My Cart',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
        actions: [
          Obx(() {
            final count = controller.restaurants.length;
            if (count == 0) return const SizedBox.shrink();
            return Container(
              margin: const EdgeInsets.only(right: 16),
              padding:
              const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                '$count restaurants',
                style: const TextStyle(
                    fontSize: 12,
                    color: Colors.white,
                    fontWeight: FontWeight.w600),
              ),
            );
          }),
        ],
      ),
      body: Obx(() {
        // ── Loading ──────────────────────────────────────────────────
        if (controller.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(
              color: Color(0xFF0F5151),
            ),
          );
        }

        // ── Error ────────────────────────────────────────────────────
        if (controller.errorMessage.value.isNotEmpty &&
            controller.restaurants.isEmpty) {
          return _ErrorView(
            message: controller.errorMessage.value,
            onRetry: controller.fetchCart,
          );
        }

        // ── Empty ────────────────────────────────────────────────────
        if (controller.isEmpty) {
          return const _EmptyCartView();
        }

        // ── Cart List ────────────────────────────────────────────────
        return ListView.builder(
          padding: const EdgeInsets.only(bottom: 130),
          itemCount: controller.restaurants.length,
          itemBuilder: (context, index) {
            final restaurant = controller.restaurants[index];
            return _RestaurantSection(
              restaurant: restaurant,
              onRemoveRestaurant: () =>
                  _confirmRemoveRestaurant(context, restaurant),
            );
          },
        );
      }),

      // ── BOTTOM BAR ───────────────────────────────────────────────────
      bottomNavigationBar: Obx(() {
        if (controller.isLoading.value || controller.isEmpty) {
          return const SizedBox(height: 0);
        }
        return _PlaceOrderBar(
          total: controller.grandTotal.value,
          restaurantCount: controller.restaurants.length,
          itemCount: controller.totalItemCount,
        );
      }),
    );
  }

  void _confirmRemoveRestaurant(
      BuildContext context, MainCartRestaurantModel restaurant) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => Padding(
        padding: const EdgeInsets.fromLTRB(24, 12, 24, 36),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2)),
            ),
            const SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: Colors.red.withOpacity(0.08),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.delete_sweep_rounded,
                  color: Colors.red, size: 34),
            ),
            const SizedBox(height: 16),
            const Text(
              'Remove Restaurant?',
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87),
            ),
            const SizedBox(height: 8),
            Text(
              'All items from "${restaurant.restaurantName}" will be removed.',
              textAlign: TextAlign.center,
              style:
              TextStyle(fontSize: 14, color: Colors.grey.shade600),
            ),
            const SizedBox(height: 28),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Get.back(),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14)),
                      side: BorderSide(color: Colors.grey.shade300),
                    ),
                    child: const Text('Cancel',
                        style: TextStyle(
                            color: Colors.black87,
                            fontWeight: FontWeight.w600)),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Get.back();
                      controller
                          .removeRestaurant(restaurant.restaurantId);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14)),
                      elevation: 0,
                    ),
                    child: const Text('Remove',
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold)),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// ── RESTAURANT SECTION ────────────────────────────────────────────────────────
class _RestaurantSection extends StatelessWidget {
  final MainCartRestaurantModel restaurant;
  final VoidCallback onRemoveRestaurant;

  const _RestaurantSection({
    required this.restaurant,
    required this.onRemoveRestaurant,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 16, 16, 0),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── RESTAURANT HEADER ──────────────────────────────────────
          Container(
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF0F5151), Color(0xFF1B7A6D)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius:
              BorderRadius.vertical(top: Radius.circular(22)),
            ),
            child: Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: const Icon(Icons.restaurant_rounded,
                      color: Colors.white, size: 24),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        restaurant.restaurantName,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Row(
                        children: [
                          const Icon(Icons.location_on_rounded,
                              size: 11, color: Colors.white60),
                          const SizedBox(width: 3),
                          Expanded(
                            child: Text(
                              restaurant.restaurantLocation,
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
                // Remove restaurant button
                GestureDetector(
                  onTap: onRemoveRestaurant,
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.red.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(Icons.delete_outline_rounded,
                        color: Colors.white, size: 18),
                  ),
                ),
              ],
            ),
          ),

          // ── ITEMS LIST ─────────────────────────────────────────────
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            padding: const EdgeInsets.all(14),
            itemCount: restaurant.items.length,
            separatorBuilder: (_, __) => const Divider(
                height: 20,
                thickness: 1,
                color: Color(0xFFF5F5F5)),
            itemBuilder: (context, index) {
              final item = restaurant.items[index];
              return _CartItemRow(
                item: item,
                restaurantId: restaurant.restaurantId,
              );
            },
          ),

          // ── RESTAURANT SUBTOTAL ────────────────────────────────────
          Container(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: Container(
              padding: const EdgeInsets.symmetric(
                  horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color: const Color(0xFF0F5151).withOpacity(0.06),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${restaurant.itemCount} items subtotal',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey.shade700,
                    ),
                  ),
                  Text(
                    '₹${_formatPrice(restaurant.subtotal)}',
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF0F5151),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _formatPrice(double price) =>
      price % 1 == 0 ? price.toInt().toString() : price.toStringAsFixed(2);
}

// ── CART ITEM ROW ─────────────────────────────────────────────────────────────
class _CartItemRow extends StatelessWidget {
  final MainCartItemModel item;
  final int restaurantId;

  const _CartItemRow(
      {required this.item, required this.restaurantId});

  MainCartController get _controller => Get.find<MainCartController>();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Image
        ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Image.network(
            item.image,
            width: 68,
            height: 68,
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => Container(
              width: 68,
              height: 68,
              decoration: BoxDecoration(
                color: const Color(0xFF0F5151).withOpacity(0.08),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.fastfood_rounded,
                  size: 28, color: Color(0xFF0F5151)),
            ),
          ),
        ),
        const SizedBox(width: 12),

        // Info
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      item.itemName,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  // Delete button
                  GestureDetector(
                    onTap: () =>
                        _controller.removeItem(restaurantId, item.itemName),
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
              const SizedBox(height: 6),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '₹${_formatPrice(item.totalPrice)}',
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF0F5151),
                    ),
                  ),
                  // Qty controls
                  Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFF0F5151).withOpacity(0.08),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        GestureDetector(
                          onTap: () => _controller.decrementItem(
                              restaurantId, item.itemName),
                          child: Container(
                            width: 32,
                            height: 32,
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
                                color: Color(0xFF0F5151),
                              ),
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () => _controller.incrementItem(
                              restaurantId, item.itemName),
                          child: Container(
                            width: 32,
                            height: 32,
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

  String _formatPrice(double price) =>
      price % 1 == 0 ? price.toInt().toString() : price.toStringAsFixed(2);
}

// ── PLACE ORDER BAR ───────────────────────────────────────────────────────────
class _PlaceOrderBar extends StatelessWidget {
  final double total;
  final int restaurantCount;
  final int itemCount;

  const _PlaceOrderBar({
    required this.total,
    required this.restaurantCount,
    required this.itemCount,
  });

  @override
  Widget build(BuildContext context) {
    final totalDisplay =
    total % 1 == 0 ? total.toInt().toString() : total.toStringAsFixed(2);

    return Container(
      padding: const EdgeInsets.fromLTRB(20, 14, 20, 28),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 16,
            offset: const Offset(0, -4),
          ),
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
                    Text(
                      'Grand Total',
                      style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade500,
                          fontWeight: FontWeight.w500),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '₹$totalDisplay',
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF0F5151),
                      ),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '$restaurantCount restaurants',
                      style: TextStyle(
                          fontSize: 11, color: Colors.grey.shade500),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '$itemCount items • incl. GST',
                      style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF0F5151)),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 14),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  // TODO: Navigate to checkout / place order API call
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF0F5151),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18)),
                  elevation: 0,
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.calendar_month_rounded, size: 20),
                    SizedBox(width: 10),
                    Text(
                      'Place Order',
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.3),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── EMPTY CART ────────────────────────────────────────────────────────────────
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
          Text('Add items from restaurants to get started',
              style:
              TextStyle(fontSize: 14, color: Colors.grey.shade500)),
          const SizedBox(height: 32),
          ElevatedButton.icon(
            onPressed: () => Get.back(),
            icon: const Icon(Icons.arrow_back_rounded, size: 18),
            label: const Text('Browse Menu',
                style:
                TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
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
    );
  }
}

// ── ERROR VIEW ────────────────────────────────────────────────────────────────
class _ErrorView extends StatelessWidget {
  final String message;
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
            Text(
              message,
              textAlign: TextAlign.center,
              style:
              TextStyle(fontSize: 14, color: Colors.grey.shade500),
            ),
            const SizedBox(height: 28),
            ElevatedButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh_rounded, size: 18),
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