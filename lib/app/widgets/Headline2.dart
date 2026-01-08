// import 'package:flutter/material.dart';
//
// import '../common/style/app_text_style.dart';
// class Subheadlines extends StatelessWidget {
//   const Subheadlines({super.key, required this.head1, required this.head2});
//   final String head1;
//   final String head2;
//   @override
//   Widget build(BuildContext context) {
//     return Column(children: [
//       Text(head1,style: AppTextStyle.rTextNunitoBlack26w600 ,) ,
//       const SizedBox(height: 8),
//       Text(head2,
//         textAlign: TextAlign.center,
//         style: AppTextStyle.rTextNunitoBlue14w700,),
//     ],);
//
//   }
// }
import 'package:flutter/material.dart';
import '../common/style/app_text_style.dart';

class Subheadlines extends StatelessWidget {
  const Subheadlines({
    super.key,
    required this.head1,
    required this.head2,
    this.head2Color,        // 👈 Optional color parameter
  });

  final String head1;
  final String head2;
  final Color? head2Color;  // 👈 Accept custom color

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          head1,
          style: AppTextStyle.rTextNunitoBlack26w600,
        ),
        const SizedBox(height: 8),
        Text(
          head2,
          textAlign: TextAlign.center,
          style: AppTextStyle.rTextNunitoBlue14w700.copyWith(
            color: head2Color ?? AppTextStyle.rTextNunitoBlue14w700.color,
            // 👆 If no color passed → use default color
          ),
        ),
      ],
    );
  }
}
