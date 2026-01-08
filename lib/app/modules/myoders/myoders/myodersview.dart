
import 'package:flutter/material.dart';

import '../../../common/style/app_colors.dart';
import '../../../common/style/app_text_style.dart';

class  Myodersview extends StatelessWidget {
  Myodersview({super.key});

  final List<Map<String, dynamic>> orders = [
    {
      "orderId": "ORD12345",
      "date": "10 Dec 2025",
      "total": 1249,
      "items": [
        {"name": "Nike Shoes", "qty": 1},
        {"name": "T-Shirt", "qty": 2},
      ]
    },
    {
      "orderId": "ORD12346",
      "date": "08 Dec 2025",
      "total": 2499,
      "items": [
        {"name": "Smart Watch", "qty": 1},
      ]
    },
    {
      "orderId": "ORD12347",
      "date": "01 Dec 2025",
      "status": "Pending",
      "total": 899,
      "items": [
        {"name": "Bluetooth Speaker", "qty": 1},
      ]
    },
  ];


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(" Orders",style:AppTextStyle.rTextNunitoWhite17w700),
        backgroundColor: AppColors.kPrimary,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: orders.length,
        itemBuilder: (context, index) {
          var order = orders[index];
          return Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                    color: Colors.black12, blurRadius: 6, offset: Offset(0, 3))
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Order ID and Status
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "#${order['orderId']}",
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.bold),
                    ),

                  ],
                ),

                const SizedBox(height: 6),
                Text(
                  "Ordered on ${order['date']}",
                  style: TextStyle(color: Colors.grey.shade700),
                ),

                const SizedBox(height: 12),

                // Items section
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: List.generate(order['items'].length, (i) {
                    var item = order['items'][i];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 4),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("${item['name']}"),
                          Text("x${item['qty']}"),
                        ],
                      ),
                    );
                  }),
                ),

                const Divider(height: 25),

                // Total + Button
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Total: ₹${order['total']}",
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    ])

              ],
            ));
        },
      ),
    );
  }
}
