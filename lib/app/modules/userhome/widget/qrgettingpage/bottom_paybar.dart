import '../../../../common/style/app_colors.dart';
import '../../../../data/models/resaturantqrmodel.dart';

import 'package:flutter/material.dart';

import '../../../restarunent/view/userrestaurantqrgettingpage.dart';
class BottomPayBar extends StatelessWidget {
  final double total;
  final List<PaymentDetailModel> data;
  const BottomPayBar({required this.total, required this.data});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFFF7F8FA),
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 55),
      child: Column(
        children: [
          Container(
            padding:
            EdgeInsets.fromLTRB(20, 20, 20, 55),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                  color: const Color(0xFFE5E7EB), width: 0.5),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('GRAND TOTAL',
                    style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF9CA3AF),
                        letterSpacing: 1.0)),
                Text(
                  '₹${total.toStringAsFixed(2)}',
                  style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF111111),
                      letterSpacing: -0.5),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => handlePay(data, context),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.restaurantclr,
                foregroundColor: Colors.white,
                elevation: 0,
                padding: const EdgeInsets.symmetric(vertical: 15),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14)),
              ),
              child: const Text(
                'Confirm & Pay All',
                style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.2),
              ),
            ),
          ),
        ],
      ),
    );
  }
}