// // ============================================================
// //  OFFER PRODUCT MODELS
// // ============================================================
//
// // ─── CATEGORY MODELS ─────────────────────────────────────────────────────────
//
// class dOfferCategoryConfig {
//   final int id;
//   final List<String> commonAttributes;
//   final List<String> variantAttributes;
//
//   dOfferCategoryConfig({
//     required this.id,
//     required this.commonAttributes,
//     required this.variantAttributes,
//   });
// }
//
// class dOfferCategoryApiModel {
//   final int id;
//   final String name;
//   final String image;
//   final List<String> commonAttributes;
//   final List<String> variantAttributes;
//
//   dOfferCategoryApiModel({
//     required this.id,
//     required this.name,
//     required this.image,
//     required this.commonAttributes,
//     required this.variantAttributes,
//   });
// }
//
// // ─── VARIANT MODEL (used in the form) ────────────────────────────────────────
//
// class dOfferProductVariant {
//   Map<String, String> attributes;
//   double? price;
//   double? offerPrice;
//   int? stock;
//   String? imagePath;
//
//   dOfferProductVariant({
//     required this.attributes,
//     this.price,
//     this.offerPrice,
//     this.stock,
//     this.imagePath,
//   });
//
//   String getDisplayName() {
//     if (attributes.isEmpty) return "Variant";
//     return attributes.values.join(" - ");
//   }
// }
//
// // ─── CREATE OFFER RESPONSE ───────────────────────────────────────────────────
// // POST /offers/create
// // Response:
// // {
// //   "status": 1,
// //   "message": "Offer created successfully",
// //   "data": {
// //     "offer_id": 252,
// //     "discount_percentage": 20,
// //     "offer_banner": "https://..."
// //   }
// // }
//
// class dCreateOfferResponse {
//   final int status;
//   final String message;
//   final dCreateOfferData data;
//
//   dCreateOfferResponse({
//     required this.status,
//     required this.message,
//     required this.data,
//   });
//
//   factory dCreateOfferResponse.fromJson(Map<String, dynamic> json) {
//     return dCreateOfferResponse(
//       status: json['status'] is int
//           ? json['status']
//           : int.parse(json['status'].toString()),
//       message: json['message']?.toString() ?? '',
//       data: dCreateOfferData.fromJson(json['data']),
//     );
//   }
// }
//
// class dCreateOfferData {
//   final int offerId;
//   final int discountPercentage;
//   final String offerBanner;
//
//   dCreateOfferData({
//     required this.offerId,
//     required this.discountPercentage,
//     required this.offerBanner,
//   });
//
//   factory dCreateOfferData.fromJson(Map<String, dynamic> json) {
//     return dCreateOfferData(
//       offerId: json['offer_id'] is int
//           ? json['offer_id']
//           : int.parse(json['offer_id'].toString()),
//       discountPercentage: json['discount_percentage'] is int
//           ? json['discount_percentage']
//           : int.parse(json['discount_percentage'].toString()),
//       offerBanner: json['offer_banner']?.toString() ?? '',
//     );
//   }
// }
//
// // ─── ADD OFFER PRODUCT RESPONSE ──────────────────────────────────────────────
// // POST /offers/add-products
// // Response:
// // {
// //   "status": 1,
// //   "message": "Products added to offer successfully",
// //   "data": [
// //     {
// //       "product": {
// //         "id": 284,
// //         "product_id": "32",
// //         "name": "Men T-Shirt",
// //         "description": "hjjh",
// //         "category_id": "19",
// //         "price": "1000.00",
// //         "discount_amount": "200.00",
// //         "common_attributes": { "material": "Cotton", "brand": "Nike", "type": "Casual" },
// //         "variants": [
// //           { "attributes": { "color": "Red", "size": "M" }, "price": 1000, "stock": 10 }
// //         ]
// //       }
// //     }
// //   ]
// // }
//
// class dAddOfferProductResponse {
//   final int status;
//   final String message;
//   final List<dAddedOfferProduct> products;
//
//   dAddOfferProductResponse({
//     required this.status,
//     required this.message,
//     required this.products,
//   });
//
//   factory dAddOfferProductResponse.fromJson(Map<String, dynamic> json) {
//     final List<dAddedOfferProduct> products = [];
//
//     if (json['data'] != null && json['data'] is List) {
//       for (var item in json['data']) {
//         try {
//           if (item['product'] != null) {
//             products.add(dAddedOfferProduct.fromJson(item['product']));
//           }
//         } catch (_) {}
//       }
//     }
//
//     return dAddOfferProductResponse(
//       status: json['status'] is int
//           ? json['status']
//           : int.parse(json['status'].toString()),
//       message: json['message']?.toString() ?? '',
//       products: products,
//     );
//   }
// }
//
// class dAddedOfferProduct {
//   final int id;
//   final String productId;
//   final String name;
//   final String? description;
//   final String categoryId;
//   final String price;
//   final String discountAmount;
//   final Map<String, String> commonAttributes;
//   final List<dAddedOfferProductVariant> variants;
//
//   dAddedOfferProduct({
//     required this.id,
//     required this.productId,
//     required this.name,
//     this.description,
//     required this.categoryId,
//     required this.price,
//     required this.discountAmount,
//     required this.commonAttributes,
//     required this.variants,
//   });
//
//   factory dAddedOfferProduct.fromJson(Map<String, dynamic> json) {
//     // Parse common_attributes map
//     final Map<String, String> attrs = {};
//     if (json['common_attributes'] != null &&
//         json['common_attributes'] is Map) {
//       (json['common_attributes'] as Map).forEach((k, v) {
//         attrs[k.toString()] = v?.toString() ?? '';
//       });
//     }
//
//
//     final List<dAddedOfferProductVariant> variants = [];
//     if (json['variants'] != null && json['variants'] is List) {
//       for (var v in json['variants']) {
//         try {
//           variants.add(dAddedOfferProductVariant.fromJson(v));
//         } catch (_) {}
//       }
//     }
//
//     return dAddedOfferProduct(
//       id: json['id'] is int
//           ? json['id']
//           : int.parse(json['id'].toString()),
//       productId: json['product_id']?.toString() ?? '',
//       name: json['name']?.toString() ?? '',
//       description: json['description']?.toString(),
//       categoryId: json['category_id']?.toString() ?? '',
//       price: json['price']?.toString() ?? '0',
//       discountAmount: json['discount_amount']?.toString() ?? '0',
//       commonAttributes: attrs,
//       variants: variants,
//     );
//   }
// }
//
// class dAddedOfferProductVariant {
//   final Map<String, String> attributes;
//   final int price;
//   final int stock;
//
//   dAddedOfferProductVariant({
//     required this.attributes,
//     required this.price,
//     required this.stock,
//   });
//
//   factory dAddedOfferProductVariant.fromJson(Map<String, dynamic> json) {
//     // Parse attributes map
//     final Map<String, String> attrs = {};
//     if (json['attributes'] != null && json['attributes'] is Map) {
//       (json['attributes'] as Map).forEach((k, v) {
//         attrs[k.toString()] = v?.toString() ?? '';
//       });
//     }
//
//     return dAddedOfferProductVariant(
//       attributes: attrs,
//       price: json['price'] is int
//           ? json['price']
//           : int.tryParse(json['price'].toString()) ?? 0,
//       stock: json['stock'] is int
//           ? json['stock']
//           : int.tryParse(json['stock'].toString()) ?? 0,
//     );
//   }
// }