import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Gridviewlayout extends StatelessWidget {
  const Gridviewlayout({super.key, required this.itemcount,
    //this.mainaxisextend=250,
    required this.itembuilder});

  final int itemcount;
  //final double? mainaxisextend;
  final Widget? Function(BuildContext,int) itembuilder;

  @override
  Widget build(BuildContext context,) {
    return GridView.builder(
        padding: const EdgeInsets.all(8.0),
        itemCount: itemcount,
        shrinkWrap: true,

        // padding: EdgeInsets.zero,
        physics: NeverScrollableScrollPhysics(),
        gridDelegate:SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 10.w,
          crossAxisSpacing: 10.w,
          childAspectRatio: 0.7,
          // mainAxisExtent: mainaxisextend,

        ) , itemBuilder:itembuilder);
  }
}
