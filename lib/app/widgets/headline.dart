import 'package:flutter/material.dart';

import '../common/style/app_text_style.dart';
class Headline extends StatelessWidget {
  const Headline({super.key, required this.head1, required this.head2});
  final String head1;
  final String head2;
  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Text(head1,style: AppTextStyle. rTextNunitoWhite24w700,) ,
       const SizedBox(height: 8),
      Text(head2,
          textAlign: TextAlign.center,

          style: AppTextStyle.rTextNunitoBlue14w700,),
    ],);

  }
}
