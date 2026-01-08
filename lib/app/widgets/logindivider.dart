import 'package:flutter/material.dart';
import '../common/style/app_colors.dart';

class LoginDivider extends StatelessWidget {
  const  LoginDivider({ required this.dividertext});
  final String dividertext;

  @override
  Widget build(BuildContext context) {
    return  Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Flexible(
            child: Divider(color: AppColors.grayButton,indent: 60,endIndent: 5,thickness: 0.5,)),
        Text(dividertext,style: Theme.of(context).textTheme.labelMedium,),
        Flexible(
            child: Divider(color: AppColors.grayButton,indent: 5,endIndent: 60,thickness: 0.5,)),

      ],
    );
  }
}
