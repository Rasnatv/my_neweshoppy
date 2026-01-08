//
// import 'dart:ui';
//
// import 'package:abc/app/common/style/app_colors.dart';
// import 'package:abc/app/modules/userhome/widget/searchbar.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import '../../../common/style/app_text_style.dart';
// import '../../../widgets/Gridviewlayout.dart';
// import '../../product/widgtet/productcard.dart';
// import '../controller/district _controller.dart';
// import '../widget/categorygrid.dart';
// import '../widget/primaryheader.dart';
// import 'package:flutter/services.dart';
// import '../widget/promotionbanner.dart';
//
// class Userhome extends StatelessWidget {
//   const Userhome({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     final districtController = Get.put(DistrictController());
//
//     return Scaffold(
//       body: AnnotatedRegion<SystemUiOverlayStyle>(
//         value: const SystemUiOverlayStyle(
//           statusBarIconBrightness: Brightness.light,
//         ),
//         child: CustomScrollView(
//           slivers: [
//
//             // ---------------- SLIVER APPBAR ----------------
//             SliverAppBar(
//               backgroundColor: AppColors.kPrimary,
//               pinned: true,
//               expandedHeight: 180,
//               automaticallyImplyLeading: false,
//
//               // ---------- Top AppBar Title ----------
//               title: Text(
//                 "eShoppy",
//                 style: AppTextStyle.rTextNunitoWhite26w700,
//               ),
//
//               // ---------- Right Action Icons ----------
//               actions: const [
//                 Icon(Icons.shopping_cart, color: Colors.white),
//                 SizedBox(width: 15),
//                 Icon(Icons.person, color: Colors.white),
//                 SizedBox(width: 10),
//               ],
//
//               // ---------- Expanded Area ----------
//               flexibleSpace: FlexibleSpaceBar(
//                 background: DPrimaryHeader(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//
//                       const SizedBox(height: 50), // compact spacing
//
//                       // ---- District Row ----
//                       Padding(
//                         padding: const EdgeInsets.only(left: 16, top: 40),
//                         child: Obx(() => Row(
//                           crossAxisAlignment: CrossAxisAlignment.center,
//                           children: [
//                             const Icon(Icons.location_on, color: Colors.red, size: 20),
//
//                             // District dropdown (tight spacing)
//                             DropdownButtonHideUnderline(
//                               child: DropdownButton<String>(
//                                 value: districtController.selectedDistrict.value,
//                                 isDense: true,
//                                 padding: EdgeInsets.zero,
//                                 dropdownColor: Colors.grey.withOpacity(0.6),
//
//                                 // 🔥 Hide default arrow
//                                 icon: const SizedBox.shrink(),
//
//                                 style: AppTextStyle.rTextNunitoWhite14w700,
//
//                                 // Custom selected item → text + arrow tightly packed
//                                 selectedItemBuilder: (_) {
//                                   return districtController.districtList.map((district) {
//                                     return Row(
//                                       children: [
//                                         const SizedBox(width: 2),
//                                         Text(
//                                           district,
//                                           style: const TextStyle(color: Colors.white),
//                                         ),
//                                         const Icon(Icons.arrow_drop_down, color: Colors.white),
//                                       ],
//                                     );
//                                   }).toList();
//                                 },
//
//                                 items: districtController.districtList.map((district) {
//                                   return DropdownMenuItem(
//                                     value: district,
//                                     child: Text(
//                                       district,
//                                       style: const TextStyle(color: Colors.white),
//                                     ),
//                                   );
//                                 }).toList(),
//
//                                 onChanged: (value) {
//                                   districtController.updateDistrict(value!);
//                                 },
//                               ),
//                             ),
//                           ],
//                         )),
//                       ),
//
//                       const SizedBox(height: 6), // spacing before search bar
//
//                       // ---- Search Bar ----
//                       Padding(
//                         padding: const EdgeInsets.all(16),
//                         child: buildSearchbar(),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//
//             // ---------------- SLIVER BODY ----------------
//             SliverToBoxAdapter(
//               child: Column(
//                 children: [
//                   const SizedBox(height: 20),
//                   HomeCarouselSlider(),
//                 ],
//               ),
//             ),
//             const SliverToBoxAdapter(child: SizedBox(height: 20)),
//
//             SliverToBoxAdapter(
//               child: Padding(
//                 padding: const EdgeInsets.all(20),
//                 child: Text("Categories", style: AppTextStyle.rTextRalewayBlack19w800),
//               ),
//             ),
//             SliverToBoxAdapter(child: FlipkartStyleCategories()),
//
//             // Nearby shops
//             SliverToBoxAdapter(
//               child: Padding(
//                 padding: const EdgeInsets.all(20),
//                 child: Text("Near by shops", style: AppTextStyle.rTextRalewayBlack19w800),
//               ),
//             ),
//             SliverToBoxAdapter(
//               child: SizedBox(
//                 height: 220,
//                 child: ListView.separated(
//                   scrollDirection: Axis.horizontal,
//                   itemCount: 5,
//                   separatorBuilder: (_, __) => const SizedBox(width: 10),
//                   itemBuilder: (context, index) {
//                     return Padding(
//                       padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
//                       child: Container(
//                         width: 170,
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Container(
//                               height: 170,
//                               decoration: BoxDecoration(
//                                 borderRadius: BorderRadius.circular(10),
//                                 border: Border.all(color: Colors.grey.shade300),
//                                 boxShadow: [
//                                   BoxShadow(
//                                     color: Colors.grey.shade200,
//                                     blurRadius: 6,
//                                     spreadRadius: 1,
//                                   ),
//                                 ],
//                               ),
//                               child: Image.asset("assets/images/instore.jpg", fit: BoxFit.cover),
//                             ),
//                             const SizedBox(height: 5),
//                             Text(
//                               "Indorefashion",
//                               maxLines: 2,
//                               style: Theme.of(context).textTheme.headlineSmall!.apply(color: Colors.black),
//                             ),
//                             Text(
//                               "Athinjal,Kanhangad",
//                               maxLines: 2,
//                               style: Theme.of(context).textTheme.labelSmall!.apply(color: Colors.red),
//                             ),
//                           ],
//                         ),
//                       ),
//                     );
//                   },
//                 ),
//               ),
//             ),
//
//             // Products Grid
//             SliverToBoxAdapter(
//               child: Padding(
//                 padding: const EdgeInsets.all(20),
//                 child: Text("Products For You", style: AppTextStyle.rTextRalewayBlack19w800),
//               ),
//             ),
//             SliverToBoxAdapter(
//               child: Gridviewlayout(
//                 itemcount: 7,
//                 itembuilder: (context, index) => ProductCard(),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
//