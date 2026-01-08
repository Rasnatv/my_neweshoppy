//
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import '../controller/buynow_controller.dart';
//
// class BuyNowPage extends StatelessWidget {
//   final BuyNowController controller = Get.put(BuyNowController());
//
//   final String productName = "Stylish Shoes";
//   final List<String> productImages = [
//     "https://via.placeholder.com/250",
//     "https://via.placeholder.com/251",
//     "https://via.placeholder.com/252",
//   ];
//   final double price = 1299;
//   final double discount = 200; // Example
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text('Buy Now'), backgroundColor: Colors.deepOrange),
//       bottomNavigationBar: Container(
//         padding: EdgeInsets.all(16),
//         color: Colors.white,
//         child: Obx(() {
//           double total = (price - discount) * controller.quantity.value;
//           return ElevatedButton(
//             onPressed: controller.placeOrder,
//             style: ElevatedButton.styleFrom(
//               padding: EdgeInsets.symmetric(vertical: 16),
//               backgroundColor: Colors.deepOrange,
//               shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
//             ),
//             child: Text("Place Order - ₹${total.toStringAsFixed(0)}", style: TextStyle(fontSize: 18)),
//           );
//         }),
//       ),
//       body: SingleChildScrollView(
//         child: Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               // Product Images Carousel
//               SizedBox(
//                 height: 250,
//                 child: PageView.builder(
//                   itemCount: productImages.length,
//                   itemBuilder: (context, index) {
//                     return Card(
//                       elevation: 4,
//                       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//                       child: ClipRRect(
//                         borderRadius: BorderRadius.circular(12),
//                         child: Image.network(productImages[index], fit: BoxFit.cover),
//                       ),
//                     );
//                   },
//                 ),
//               ),
//               SizedBox(height: 16),
//
//               // Product Info Card
//               Card(
//                 elevation: 4,
//                 shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//                 child: Padding(
//                   padding: EdgeInsets.all(16),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(productName, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
//                       SizedBox(height: 8),
//                       Row(
//                         children: [
//                           Text("₹${price - discount}", style: TextStyle(fontSize: 18, color: Colors.green, fontWeight: FontWeight.bold)),
//                           SizedBox(width: 8),
//                           if (discount > 0)
//                             Text("₹$price", style: TextStyle(fontSize: 16, color: Colors.grey, decoration: TextDecoration.lineThrough)),
//                           SizedBox(width: 8),
//                           if (discount > 0)
//                             Text("${discount.toInt()} OFF", style: TextStyle(fontSize: 16, color: Colors.red)),
//                         ],
//                       ),
//                       SizedBox(height: 16),
//
//                       // Quantity Selector
//                       Row(
//                         children: [
//                           Text("Quantity:", style: TextStyle(fontSize: 16)),
//                           SizedBox(width: 16),
//                           Obx(() => Row(
//                             children: [
//                               IconButton(onPressed: controller.decrement, icon: Icon(Icons.remove)),
//                               Text('${controller.quantity.value}', style: TextStyle(fontSize: 16)),
//                               IconButton(onPressed: controller.increment, icon: Icon(Icons.add)),
//                             ],
//                           )),
//                         ],
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//
//               SizedBox(height: 16),
//
//               // Delivery Address Card
//               Card(
//                 elevation: 4,
//                 shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//                 child: Padding(
//                   padding: EdgeInsets.all(16),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text("Delivery Address", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
//                       SizedBox(height: 8),
//                       TextField(
//                         controller: controller.addressController,
//                         decoration: InputDecoration(
//                           hintText: "Enter your address",
//                           border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//
//               SizedBox(height: 16),
//
//               // Payment Options Card
//               Card(
//                 elevation: 4,
//                 shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//                 child: Padding(
//                   padding: EdgeInsets.all(16),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text("Payment Method", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
//                       Obx(() => Column(
//                         children: [
//                           RadioListTile(
//                             title: Text("UPI"),
//                             value: "UPI",
//                             groupValue: controller.selectedPayment.value,
//                             onChanged: (value) => controller.selectedPayment.value = value.toString(),
//                           ),
//                           RadioListTile(
//                             title: Text("Credit/Debit Card"),
//                             value: "Card",
//                             groupValue: controller.selectedPayment.value,
//                             onChanged: (value) => controller.selectedPayment.value = value.toString(),
//                           ),
//                           RadioListTile(
//                             title: Text("Cash on Delivery"),
//                             value: "COD",
//                             groupValue: controller.selectedPayment.value,
//                             onChanged: (value) => controller.selectedPayment.value = value.toString(),
//                           ),
//                         ],
//                       )),
//                     ],
//                   ),
//                 ),
//               ),
//
//               SizedBox(height: 80), // Extra space for bottom button
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }