import 'package:eshoppy/app/common/style/app_colors.dart';
import 'package:flutter/material.dart';
class OfferProductListPage extends StatelessWidget {
  const OfferProductListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.kPrimary,
        automaticallyImplyLeading: true,),
      body:GridView.builder(
        itemCount: 6,
          gridDelegate:SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2,
              crossAxisSpacing: 20,mainAxisSpacing: 20,),

          itemBuilder: (_,_){
          return Container(
            width: 150,
            height: 250,
            child: Column(
              children: [
                Image.asset("assets/images/offer3.jpg"),
                SizedBox(height: 5,),
                Text("Kurti"),
                SizedBox(height: 4,),
                Text("349")
              ]

            ));
          }
      )
    );
  }
}
