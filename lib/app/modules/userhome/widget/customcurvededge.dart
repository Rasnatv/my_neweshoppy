import 'package:flutter/material.dart';
class CustomCurvedEdge extends CustomClipper<Path>{

  @override
  Path getClip(Size size) {
    var path=Path();
    path.lineTo(0,size.height);
    final firstCurve =Offset(0,size.height-10);
    final lastCurve =Offset(30,size.height-10);
    path.quadraticBezierTo(firstCurve.dx,lastCurve.dy, lastCurve.dx,firstCurve.dy );

    final secondfirstCurve =Offset(0,size.height-20);
    final secondlastCurve =Offset(size.width-30,size.height-20);
    path.quadraticBezierTo( secondfirstCurve.dx,secondfirstCurve.dy, secondlastCurve.dx,secondlastCurve.dy );

    final thirdfirstCurve =Offset(size.width,size.height-20);
    final thirdlastcurve =Offset(size.width,size.height);
    path.quadraticBezierTo(thirdfirstCurve.dx,thirdfirstCurve.dy,thirdlastcurve.dx,thirdlastcurve.dy );



    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper oldClipper) {

    return true;
  }}