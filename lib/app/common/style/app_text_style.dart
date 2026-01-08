import 'package:flutter/material.dart';

import 'app_colors.dart';
import 'dimens.dart';

abstract class AppTextStyle {
  //NunitoSans
  static const TextStyle _textStyleNunito = TextStyle(fontFamily: 'NunitoSans', height: 1.0);
  static final TextStyle _textNunitoBlack = _textStyleNunito.copyWith(color: AppColors.black);
  static final TextStyle _textNunitoBlue = _textStyleNunito.copyWith(color: AppColors.grayButton);
  static final TextStyle _textNunitoWhite = _textStyleNunito.copyWith(color: AppColors.white);
  static final TextStyle _textNunitogreywhite = _textStyleNunito.copyWith(color: AppColors.grayText);

//raleway
  static const TextStyle _textStyleRaleway = TextStyle(fontFamily: 'Raleway', height: 1.0);
  static final TextStyle _textRalewayBlack = _textStyleRaleway.copyWith(color: AppColors.black);
  static final TextStyle _textRalewayBlue = _textStyleRaleway.copyWith(color: AppColors.kPrimary);
  static final TextStyle _textRalewayWhite = _textStyleRaleway.copyWith(color: AppColors.white);

  //nunitogreywhite
  static final TextStyle rTextNunitogrey10w700 = _textNunitoBlue.copyWith(fontSize: Dimens.fontSize12,);


  static final TextStyle rTextNunitoBlack10w400 = _textNunitoBlack.copyWith(fontSize: Dimens.fontSize10, fontWeight: FontWeight.w400);
  static final TextStyle rTextNunitoBlack10w500 = _textNunitoBlack.copyWith(fontSize: Dimens.fontSize10, fontWeight: FontWeight.w500);
  static final TextStyle rTextNunitoBlack10w600 = _textNunitoBlack.copyWith(fontSize: Dimens.fontSize10, fontWeight: FontWeight.w600);
  static final TextStyle rTextNunitoBlack10w700 = _textNunitoBlack.copyWith(fontSize: Dimens.fontSize10, fontWeight: FontWeight.w700);

  static final TextStyle rTextNunitoBlack12w400 = _textNunitoBlack.copyWith(fontSize: Dimens.fontSize12, fontWeight: FontWeight.w400);
  static final TextStyle rTextNunitoBlack12w500 = _textNunitoBlack.copyWith(fontSize: Dimens.fontSize12, fontWeight: FontWeight.w500);
  static final TextStyle rTextNunitoBlack12w600 = _textNunitoBlack.copyWith(fontSize: Dimens.fontSize12, fontWeight: FontWeight.w600);
  static final TextStyle rTextNunitoBlack12w700 = _textNunitoBlack.copyWith(fontSize: Dimens.fontSize12, fontWeight: FontWeight.w700);

  static final TextStyle rTextNunitoBlack13w400 = _textNunitoBlack.copyWith(fontSize: Dimens.fontSize13, fontWeight: FontWeight.w400);
  static final TextStyle rTextNunitoBlack13w500 = _textNunitoBlack.copyWith(fontSize: Dimens.fontSize13, fontWeight: FontWeight.w500);
  static final TextStyle rTextNunitoBlack13w600 = _textNunitoBlack.copyWith(fontSize: Dimens.fontSize13, fontWeight: FontWeight.w600);
  static final TextStyle rTextNunitoBlack13w700 = _textNunitoBlack.copyWith(fontSize: Dimens.fontSize13, fontWeight: FontWeight.w700);

  static final TextStyle rTextNunitoBlack14w400 = _textNunitoBlack.copyWith(fontSize: Dimens.fontSize14, fontWeight: FontWeight.w400);
  static final TextStyle rTextNunitoBlack14w500 = _textNunitoBlack.copyWith(fontSize: Dimens.fontSize14, fontWeight: FontWeight.w500);
  static final TextStyle rTextNunitoBlack14w600 = _textNunitoBlack.copyWith(fontSize: Dimens.fontSize14, fontWeight: FontWeight.w600);
  static final TextStyle rTextNunitoBlack14w700 = _textNunitoBlack.copyWith(fontSize: Dimens.fontSize14, fontWeight: FontWeight.w700);

  static final TextStyle rTextNunitogreywhite12w700 = _textNunitogreywhite.copyWith(fontSize: Dimens.fontSize14, fontWeight: FontWeight.w700);
  static final TextStyle rTextNunitoBlack15w000 = _textNunitoBlack.copyWith(fontSize: Dimens.fontSize15);
  static final TextStyle rTextNunitoBlack15w400 = _textNunitoBlack.copyWith(fontSize: Dimens.fontSize15, fontWeight: FontWeight.w400);
  static final TextStyle rTextNunitoBlack15w500 = _textNunitoBlack.copyWith(fontSize: Dimens.fontSize15, fontWeight: FontWeight.w500);
  static final TextStyle rTextNunitoBlack15w600 = _textNunitoBlack.copyWith(fontSize: Dimens.fontSize15, fontWeight: FontWeight.w600);
  static final TextStyle rTextNunitoBlack15w700 = _textNunitoBlack.copyWith(fontSize: Dimens.fontSize15, fontWeight: FontWeight.w700);

  static final TextStyle rTextNunitoBlack16w400 = _textNunitoBlack.copyWith(fontSize: Dimens.fontSize16, fontWeight: FontWeight.w400);
  static final TextStyle rTextNunitoBlack16w500 = _textNunitoBlack.copyWith(fontSize: Dimens.fontSize16, fontWeight: FontWeight.w500);
  static final TextStyle rTextNunitoBlack16w600 = _textNunitoBlack.copyWith(fontSize: Dimens.fontSize16, fontWeight: FontWeight.w600);
  static final TextStyle rTextNunitoBlack16w700 = _textNunitoBlack.copyWith(fontSize: Dimens.fontSize16, fontWeight: FontWeight.w700);

  static final TextStyle rTextNunitoBlack17w400 = _textNunitoBlack.copyWith(fontSize: Dimens.fontSize17, fontWeight: FontWeight.w400);
  static final TextStyle rTextNunitoBlack17w500 = _textNunitoBlack.copyWith(fontSize: Dimens.fontSize17, fontWeight: FontWeight.w500);
  static final TextStyle rTextNunitoBlack17w600 = _textNunitoBlack.copyWith(fontSize: Dimens.fontSize17, fontWeight: FontWeight.w600);
  static final TextStyle rTextNunitoBlack17w700 = _textNunitoBlack.copyWith(fontSize: Dimens.fontSize17, fontWeight: FontWeight.w700);

  static final TextStyle rTextNunitoBlack18w400 = _textNunitoBlack.copyWith(fontSize: Dimens.fontSize18, fontWeight: FontWeight.w400);
  static final TextStyle rTextNunitoBlack18w500 = _textNunitoBlack.copyWith(fontSize: Dimens.fontSize18, fontWeight: FontWeight.w500);
  static final TextStyle rTextNunitoBlack18w600 = _textNunitoBlack.copyWith(fontSize: Dimens.fontSize18, fontWeight: FontWeight.w600);
  static final TextStyle rTextNunitoBlack18w700 = _textNunitoBlack.copyWith(fontSize: Dimens.fontSize18, fontWeight: FontWeight.w700);

  static final TextStyle rTextNunitoBlack20w400 = _textNunitoBlack.copyWith(fontSize: Dimens.fontSize20, fontWeight: FontWeight.w400);
  static final TextStyle rTextNunitoBlack20w500 = _textNunitoBlack.copyWith(fontSize: Dimens.fontSize20, fontWeight: FontWeight.w500);
  static final TextStyle rTextNunitoBlack20w600 = _textNunitoBlack.copyWith(fontSize: Dimens.fontSize20, fontWeight: FontWeight.w600);
  static final TextStyle rTextNunitoBlack20w700 = _textNunitoBlack.copyWith(fontSize: Dimens.fontSize20, fontWeight: FontWeight.w700);

  static final TextStyle rTextNunitoBlack22w400 = _textNunitoBlack.copyWith(fontSize: Dimens.fontSize22, fontWeight: FontWeight.w400);
  static final TextStyle rTextNunitoBlack22w500 = _textNunitoBlack.copyWith(fontSize: Dimens.fontSize22, fontWeight: FontWeight.w500);
  static final TextStyle rTextNunitoBlack22w600 = _textNunitoBlack.copyWith(fontSize: Dimens.fontSize22, fontWeight: FontWeight.w600);
  static final TextStyle rTextNunitoBlack22w700 = _textNunitoBlack.copyWith(fontSize: Dimens.fontSize22, fontWeight: FontWeight.w700);

  static final TextStyle rTextNunitoBlack24w400 = _textNunitoBlack.copyWith(fontSize: Dimens.fontSize24, fontWeight: FontWeight.w400);
  static final TextStyle rTextNunitoBlack24w500 = _textNunitoBlack.copyWith(fontSize: Dimens.fontSize24, fontWeight: FontWeight.w500);
  static final TextStyle rTextNunitoBlack24w600 = _textNunitoBlack.copyWith(fontSize: Dimens.fontSize24, fontWeight: FontWeight.w600);
  static final TextStyle rTextNunitoBlack24w700 = _textNunitoBlack.copyWith(fontSize: Dimens.fontSize24, fontWeight: FontWeight.w700);

  static final TextStyle rTextNunitoBlack26w400 = _textNunitoBlack.copyWith(fontSize: Dimens.fontSize26, fontWeight: FontWeight.w400);
  static final TextStyle rTextNunitoBlack26w500 = _textNunitoBlack.copyWith(fontSize: Dimens.fontSize26, fontWeight: FontWeight.w500);
  static final TextStyle rTextNunitoBlack26w600 = _textNunitoBlack.copyWith(fontSize: Dimens.fontSize26, fontWeight: FontWeight.w600);
  static final TextStyle rTextNunitoBlack26w700 = _textNunitoBlack.copyWith(fontSize: Dimens.fontSize26, fontWeight: FontWeight.w700);

  static final TextStyle rTextNunitoBlack28w400 = _textNunitoBlack.copyWith(fontSize: Dimens.fontSize28, fontWeight: FontWeight.w400);
  static final TextStyle rTextNunitoBlack28w500 = _textNunitoBlack.copyWith(fontSize: Dimens.fontSize28, fontWeight: FontWeight.w500);
  static final TextStyle rTextNunitoBlack28w600 = _textNunitoBlack.copyWith(fontSize: Dimens.fontSize28, fontWeight: FontWeight.w600);
  static final TextStyle rTextNunitoBlack28w700 = _textNunitoBlack.copyWith(fontSize: Dimens.fontSize36, fontWeight: FontWeight.w700);

  static final TextStyle rTextNunitoBlue10w400 = _textNunitoBlue.copyWith(fontSize: Dimens.fontSize10, fontWeight: FontWeight.w400);
  static final TextStyle rTextNunitoBlue10w500 = _textNunitoBlue.copyWith(fontSize: Dimens.fontSize10, fontWeight: FontWeight.w500);
  static final TextStyle rTextNunitoBlue10w600 = _textNunitoBlue.copyWith(fontSize: Dimens.fontSize10, fontWeight: FontWeight.w600);
  static final TextStyle rTextNunitoBlue10w700 = _textNunitoBlue.copyWith(fontSize: Dimens.fontSize10, fontWeight: FontWeight.w700);

  static final TextStyle rTextNunitoBlue12w400 = _textNunitoBlue.copyWith(fontSize: Dimens.fontSize12, fontWeight: FontWeight.w400);
  static final TextStyle rTextNunitoBlue12w500 = _textNunitoBlue.copyWith(fontSize: Dimens.fontSize12, fontWeight: FontWeight.w500);
  static final TextStyle rTextNunitoBlue12w600 = _textNunitoBlue.copyWith(fontSize: Dimens.fontSize12, fontWeight: FontWeight.w600);
  static final TextStyle rTextNunitoBlue12w700 = _textNunitoBlue.copyWith(fontSize: Dimens.fontSize12, fontWeight: FontWeight.w700);

  static final TextStyle rTextNunitoBlue13w400 = _textNunitoBlue.copyWith(fontSize: Dimens.fontSize13, fontWeight: FontWeight.w400);
  static final TextStyle rTextNunitoBlue13w500 = _textNunitoBlue.copyWith(fontSize: Dimens.fontSize13, fontWeight: FontWeight.w500);
  static final TextStyle rTextNunitoBlue13w600 = _textNunitoBlue.copyWith(fontSize: Dimens.fontSize13, fontWeight: FontWeight.w600);
  static final TextStyle rTextNunitoBlue13w700 = _textNunitoBlue.copyWith(fontSize: Dimens.fontSize13, fontWeight: FontWeight.w700);

  static final TextStyle rTextNunitoBlue14w400 = _textNunitoBlue.copyWith(fontSize: Dimens.fontSize14, fontWeight: FontWeight.w400);
  static final TextStyle rTextNunitoBlue14w500 = _textNunitoBlue.copyWith(fontSize: Dimens.fontSize14, fontWeight: FontWeight.w500);
  static final TextStyle rTextNunitoBlue14w600 = _textNunitoBlue.copyWith(fontSize: Dimens.fontSize14, fontWeight: FontWeight.w600);
  static final TextStyle rTextNunitoBlue14w700 = _textNunitoBlue.copyWith(fontSize: Dimens.fontSize14, fontWeight: FontWeight.w700);

  static final TextStyle rTextNunitoBlue15w400 = _textNunitoBlue.copyWith(fontSize: Dimens.fontSize15, fontWeight: FontWeight.w400);
  static final TextStyle rTextNunitoBlue15w500 = _textNunitoBlue.copyWith(fontSize: Dimens.fontSize15, fontWeight: FontWeight.w500);
  static final TextStyle rTextNunitoBlue15w600 = _textNunitoBlue.copyWith(fontSize: Dimens.fontSize15, fontWeight: FontWeight.w600);
  static final TextStyle rTextNunitoBlue15w700 = _textNunitoBlue.copyWith(fontSize: Dimens.fontSize15, fontWeight: FontWeight.w700);

  static final TextStyle rTextNunitoBlue16w400 = _textNunitoBlue.copyWith(fontSize: Dimens.fontSize16, fontWeight: FontWeight.w400);
  static final TextStyle rTextNunitoBlue16w500 = _textNunitoBlue.copyWith(fontSize: Dimens.fontSize16, fontWeight: FontWeight.w500);
  static final TextStyle rTextNunitoBlue16w600 = _textNunitoBlue.copyWith(fontSize: Dimens.fontSize16, fontWeight: FontWeight.w600);
  static final TextStyle rTextNunitoBlue16w700 = _textNunitoBlue.copyWith(fontSize: Dimens.fontSize16, fontWeight: FontWeight.w700);

  static final TextStyle rTextNunitoBlue17w400 = _textNunitoBlue.copyWith(fontSize: Dimens.fontSize17, fontWeight: FontWeight.w400);
  static final TextStyle rTextNunitoBlue17w500 = _textNunitoBlue.copyWith(fontSize: Dimens.fontSize17, fontWeight: FontWeight.w500);
  static final TextStyle rTextNunitoBlue17w600 = _textNunitoBlue.copyWith(fontSize: Dimens.fontSize17, fontWeight: FontWeight.w600);
  static final TextStyle rTextNunitoBlue17w700 = _textNunitoBlue.copyWith(fontSize: Dimens.fontSize17, fontWeight: FontWeight.w700);

  static final TextStyle rTextNunitoBlue18w400 = _textNunitoBlue.copyWith(fontSize: Dimens.fontSize18, fontWeight: FontWeight.w400);
  static final TextStyle rTextNunitoBlue18w500 = _textNunitoBlue.copyWith(fontSize: Dimens.fontSize18, fontWeight: FontWeight.w500);
  static final TextStyle rTextNunitoBlue18w600 = _textNunitoBlue.copyWith(fontSize: Dimens.fontSize18, fontWeight: FontWeight.w600);
  static final TextStyle rTextNunitoBlue18w700 = _textNunitoBlue.copyWith(fontSize: Dimens.fontSize18, fontWeight: FontWeight.w700);

  static final TextStyle rTextNunitoBlue20w400 = _textNunitoBlue.copyWith(fontSize: Dimens.fontSize20, fontWeight: FontWeight.w400);
  static final TextStyle rTextNunitoBlue20w500 = _textNunitoBlue.copyWith(fontSize: Dimens.fontSize20, fontWeight: FontWeight.w500);
  static final TextStyle rTextNunitoBlue20w600 = _textNunitoBlue.copyWith(fontSize: Dimens.fontSize20, fontWeight: FontWeight.w600);
  static final TextStyle rTextNunitoBlue20w700 = _textNunitoBlue.copyWith(fontSize: Dimens.fontSize20, fontWeight: FontWeight.w700);

  static final TextStyle rTextNunitoBlue22w400 = _textNunitoBlue.copyWith(fontSize: Dimens.fontSize22, fontWeight: FontWeight.w400);
  static final TextStyle rTextNunitoBlue22w500 = _textNunitoBlue.copyWith(fontSize: Dimens.fontSize22, fontWeight: FontWeight.w500);
  static final TextStyle rTextNunitoBlue22w600 = _textNunitoBlue.copyWith(fontSize: Dimens.fontSize22, fontWeight: FontWeight.w600);
  static final TextStyle rTextNunitoBlue22w700 = _textNunitoBlue.copyWith(fontSize: Dimens.fontSize22, fontWeight: FontWeight.w700);

  static final TextStyle rTextNunitoBlue24w400 = _textNunitoBlue.copyWith(fontSize: Dimens.fontSize24, fontWeight: FontWeight.w400);
  static final TextStyle rTextNunitoBlue24w500 = _textNunitoBlue.copyWith(fontSize: Dimens.fontSize24, fontWeight: FontWeight.w500);
  static final TextStyle rTextNunitoBlue24w600 = _textNunitoBlue.copyWith(fontSize: Dimens.fontSize24, fontWeight: FontWeight.w600);
  static final TextStyle rTextNunitoBlue24w700 = _textNunitoBlue.copyWith(fontSize: Dimens.fontSize24, fontWeight: FontWeight.w700);

  static final TextStyle rTextNunitoBlue26w400 = _textNunitoBlue.copyWith(fontSize: Dimens.fontSize26, fontWeight: FontWeight.w400);
  static final TextStyle rTextNunitoBlue26w500 = _textNunitoBlue.copyWith(fontSize: Dimens.fontSize26, fontWeight: FontWeight.w500);
  static final TextStyle rTextNunitoBlue26w600 = _textNunitoBlue.copyWith(fontSize: Dimens.fontSize26, fontWeight: FontWeight.w600);
  static final TextStyle rTextNunitoBlue26w700 = _textNunitoBlue.copyWith(fontSize: Dimens.fontSize26, fontWeight: FontWeight.w700);

  static final TextStyle rTextNunitoBlue28w400 = _textNunitoBlue.copyWith(fontSize: Dimens.fontSize28, fontWeight: FontWeight.w400);
  static final TextStyle rTextNunitoBlue28w500 = _textNunitoBlue.copyWith(fontSize: Dimens.fontSize28, fontWeight: FontWeight.w500);
  static final TextStyle rTextNunitoBlue28w600 = _textNunitoBlue.copyWith(fontSize: Dimens.fontSize28, fontWeight: FontWeight.w600);
  static final TextStyle rTextNunitoBlue28w700 = _textNunitoBlue.copyWith(fontSize: Dimens.fontSize28, fontWeight: FontWeight.w700);

  static final TextStyle rTextNunitoWhite10w400 = _textNunitoWhite.copyWith(fontSize: Dimens.fontSize10, fontWeight: FontWeight.w400);
  static final TextStyle rTextNunitoWhite10w500 = _textNunitoWhite.copyWith(fontSize: Dimens.fontSize10, fontWeight: FontWeight.w500);
  static final TextStyle rTextNunitoWhite10w600 = _textNunitoWhite.copyWith(fontSize: Dimens.fontSize10, fontWeight: FontWeight.w600);
  static final TextStyle rTextNunitoWhite10w700 = _textNunitoWhite.copyWith(fontSize: Dimens.fontSize10, fontWeight: FontWeight.w700);

  static final TextStyle rTextNunitoWhite12w400 = _textNunitoWhite.copyWith(fontSize: Dimens.fontSize12, fontWeight: FontWeight.w400);
  static final TextStyle rTextNunitoWhite12w500 = _textNunitoWhite.copyWith(fontSize: Dimens.fontSize12, fontWeight: FontWeight.w500);
  static final TextStyle rTextNunitoWhite12w600 = _textNunitoWhite.copyWith(fontSize: Dimens.fontSize12, fontWeight: FontWeight.w600);
  static final TextStyle rTextNunitoWhite12w700 = _textNunitoWhite.copyWith(fontSize: Dimens.fontSize12, fontWeight: FontWeight.w700);

  static final TextStyle rTextNunitoWhite13w400 = _textNunitoWhite.copyWith(fontSize: Dimens.fontSize13, fontWeight: FontWeight.w400);
  static final TextStyle rTextNunitoWhite13w500 = _textNunitoWhite.copyWith(fontSize: Dimens.fontSize13, fontWeight: FontWeight.w500);
  static final TextStyle rTextNunitoWhite13w600 = _textNunitoWhite.copyWith(fontSize: Dimens.fontSize13, fontWeight: FontWeight.w600);
  static final TextStyle rTextNunitoWhite13w700 = _textNunitoWhite.copyWith(fontSize: Dimens.fontSize13, fontWeight: FontWeight.w700);

  static final TextStyle rTextNunitoWhite14w400 = _textNunitoWhite.copyWith(fontSize: Dimens.fontSize14, fontWeight: FontWeight.w400);
  static final TextStyle rTextNunitoWhite14w500 = _textNunitoWhite.copyWith(fontSize: Dimens.fontSize14, fontWeight: FontWeight.w500);
  static final TextStyle rTextNunitoWhite14w600 = _textNunitoWhite.copyWith(fontSize: Dimens.fontSize14, fontWeight: FontWeight.w600);
  static final TextStyle rTextNunitoWhite14w700 = _textNunitoWhite.copyWith(fontSize: Dimens.fontSize14, fontWeight: FontWeight.w700);

  static final TextStyle rTextNunitoWhite15w400 = _textNunitoWhite.copyWith(fontSize: Dimens.fontSize15, fontWeight: FontWeight.w400);
  static final TextStyle rTextNunitoWhite15w500 = _textNunitoWhite.copyWith(fontSize: Dimens.fontSize15, fontWeight: FontWeight.w500);
  static final TextStyle rTextNunitoWhite15w600 = _textNunitoWhite.copyWith(fontSize: Dimens.fontSize15, fontWeight: FontWeight.w600);
  static final TextStyle rTextNunitoWhite15w700 = _textNunitoWhite.copyWith(fontSize: Dimens.fontSize15, fontWeight: FontWeight.w700);

  static final TextStyle rTextNunitoWhite16w400 = _textNunitoWhite.copyWith(fontSize: Dimens.fontSize16, fontWeight: FontWeight.w400);
  static final TextStyle rTextNunitoWhite16w500 = _textNunitoWhite.copyWith(fontSize: Dimens.fontSize16, fontWeight: FontWeight.w500);
  static final TextStyle rTextNunitoWhite16w600 = _textNunitoWhite.copyWith(fontSize: Dimens.fontSize16, fontWeight: FontWeight.w600);
  static final TextStyle rTextNunitoWhite16w700 = _textNunitoWhite.copyWith(fontSize: Dimens.fontSize16, fontWeight: FontWeight.w700);

  static final TextStyle rTextNunitoWhite17w400 = _textNunitoWhite.copyWith(fontSize: Dimens.fontSize17, fontWeight: FontWeight.w400);
  static final TextStyle rTextNunitoWhite17w500 = _textNunitoWhite.copyWith(fontSize: Dimens.fontSize17, fontWeight: FontWeight.w500);
  static final TextStyle rTextNunitoWhite17w600 = _textNunitoWhite.copyWith(fontSize: Dimens.fontSize17, fontWeight: FontWeight.w600);
  static final TextStyle rTextNunitoWhite17w700 = _textNunitoWhite.copyWith(fontSize: Dimens.fontSize17, fontWeight: FontWeight.w700);

  static final TextStyle rTextNunitoWhite18w400 = _textNunitoWhite.copyWith(fontSize: Dimens.fontSize18, fontWeight: FontWeight.w400);
  static final TextStyle rTextNunitoWhite18w500 = _textNunitoWhite.copyWith(fontSize: Dimens.fontSize18, fontWeight: FontWeight.w500);
  static final TextStyle rTextNunitoWhite18w600 = _textNunitoWhite.copyWith(fontSize: Dimens.fontSize18, fontWeight: FontWeight.w600);
  static final TextStyle rTextNunitoWhite18w700 = _textNunitoWhite.copyWith(fontSize: Dimens.fontSize18, fontWeight: FontWeight.w700);

  static final TextStyle rTextNunitoWhite20w400 = _textNunitoWhite.copyWith(fontSize: Dimens.fontSize20, fontWeight: FontWeight.w400);
  static final TextStyle rTextNunitoWhite20w500 = _textNunitoWhite.copyWith(fontSize: Dimens.fontSize20, fontWeight: FontWeight.w500);
  static final TextStyle rTextNunitoWhite20w600 = _textNunitoWhite.copyWith(fontSize: Dimens.fontSize20, fontWeight: FontWeight.w600);
  static final TextStyle rTextNunitoWhite20w700 = _textNunitoWhite.copyWith(fontSize: Dimens.fontSize20, fontWeight: FontWeight.w700);

  static final TextStyle rTextNunitoWhite22w400 = _textNunitoWhite.copyWith(fontSize: Dimens.fontSize22, fontWeight: FontWeight.w400);
  static final TextStyle rTextNunitoWhite22w500 = _textNunitoWhite.copyWith(fontSize: Dimens.fontSize22, fontWeight: FontWeight.w500);
  static final TextStyle rTextNunitoWhite22w600 = _textNunitoWhite.copyWith(fontSize: Dimens.fontSize22, fontWeight: FontWeight.w600);
  static final TextStyle rTextNunitoWhite22w700 = _textNunitoWhite.copyWith(fontSize: Dimens.fontSize22, fontWeight: FontWeight.w700);

  static final TextStyle rTextNunitoWhite24w400 = _textNunitoWhite.copyWith(fontSize: Dimens.fontSize24, fontWeight: FontWeight.w400);
  static final TextStyle rTextNunitoWhite24w500 = _textNunitoWhite.copyWith(fontSize: Dimens.fontSize24, fontWeight: FontWeight.w500);
  static final TextStyle rTextNunitoWhite24w600 = _textNunitoWhite.copyWith(fontSize: Dimens.fontSize24, fontWeight: FontWeight.w600);
  static final TextStyle rTextNunitoWhite24w700 = _textNunitoWhite.copyWith(fontSize: Dimens.fontSize24, fontWeight: FontWeight.w700);

  static final TextStyle rTextNunitoWhite26w400 = _textNunitoWhite.copyWith(fontSize: Dimens.fontSize26, fontWeight: FontWeight.w400);
  static final TextStyle rTextNunitoWhite26w500 = _textNunitoWhite.copyWith(fontSize: Dimens.fontSize26, fontWeight: FontWeight.w500);
  static final TextStyle rTextNunitoWhite26w600 = _textNunitoWhite.copyWith(fontSize: Dimens.fontSize26, fontWeight: FontWeight.w600);
  static final TextStyle rTextNunitoWhite26w700 = _textNunitoWhite.copyWith(fontSize: Dimens.fontSize26, fontWeight: FontWeight.w700);

  static final TextStyle rTextNunitoWhite28w400 = _textNunitoWhite.copyWith(fontSize: Dimens.fontSize28, fontWeight: FontWeight.w400);
  static final TextStyle rTextNunitoWhite28w500 = _textNunitoWhite.copyWith(fontSize: Dimens.fontSize28, fontWeight: FontWeight.w500);
  static final TextStyle rTextNunitoWhite28w600 = _textNunitoWhite.copyWith(fontSize: Dimens.fontSize28, fontWeight: FontWeight.w600);
  static final TextStyle rTextNunitoWhite28w700 = _textNunitoWhite.copyWith(fontSize: Dimens.fontSize28, fontWeight: FontWeight.w700);

  //Raleway
  static final TextStyle rTextRalewayBlack10w400 = _textRalewayBlack.copyWith(fontSize: Dimens.fontSize10, fontWeight: FontWeight.w400);
  static final TextStyle rTextRalewayBlack10w500 = _textRalewayBlack.copyWith(fontSize: Dimens.fontSize10, fontWeight: FontWeight.w500);
  static final TextStyle rTextRalewayBlack10w600 = _textRalewayBlack.copyWith(fontSize: Dimens.fontSize10, fontWeight: FontWeight.w600);
  static final TextStyle rTextRalewayBlack10w700 = _textRalewayBlack.copyWith(fontSize: Dimens.fontSize10, fontWeight: FontWeight.w700);

  static final TextStyle rTextRalewayBlack12w400 = _textRalewayBlack.copyWith(fontSize: Dimens.fontSize12, fontWeight: FontWeight.w400);
  static final TextStyle rTextRalewayBlack12w500 = _textRalewayBlack.copyWith(fontSize: Dimens.fontSize12, fontWeight: FontWeight.w500);
  static final TextStyle rTextRalewayBlack12w600 = _textRalewayBlack.copyWith(fontSize: Dimens.fontSize12, fontWeight: FontWeight.w600);
  static final TextStyle rTextRalewayBlack12w700 = _textRalewayBlack.copyWith(fontSize: Dimens.fontSize12, fontWeight: FontWeight.w700);

  static final TextStyle rTextRalewayBlack13w400 = _textRalewayBlack.copyWith(fontSize: Dimens.fontSize13, fontWeight: FontWeight.w400);
  static final TextStyle rTextRalewayBlack13w500 = _textRalewayBlack.copyWith(fontSize: Dimens.fontSize13, fontWeight: FontWeight.w500);
  static final TextStyle rTextRalewayBlack13w600 = _textRalewayBlack.copyWith(fontSize: Dimens.fontSize13, fontWeight: FontWeight.w600);
  static final TextStyle rTextRalewayBlack13w700 = _textRalewayBlack.copyWith(fontSize: Dimens.fontSize13, fontWeight: FontWeight.w700);

  static final TextStyle rTextRalewayBlack14w400 = _textRalewayBlack.copyWith(fontSize: Dimens.fontSize14, fontWeight: FontWeight.w400);
  static final TextStyle rTextRalewayBlack14w500 = _textRalewayBlack.copyWith(fontSize: Dimens.fontSize14, fontWeight: FontWeight.w500);
  static final TextStyle rTex14w700tRalewayBlack14w600 = _textRalewayBlack.copyWith(fontSize: Dimens.fontSize14, fontWeight: FontWeight.w600);
  static final TextStyle rTextRalewayBlack = _textRalewayBlack.copyWith(fontSize: Dimens.fontSize14, fontWeight: FontWeight.w700);

  static final TextStyle rTextRalewayBlack15w400 = _textRalewayBlack.copyWith(fontSize: Dimens.fontSize15, fontWeight: FontWeight.w400);
  static final TextStyle rTextRalewayBlack15w500 = _textRalewayBlack.copyWith(fontSize: Dimens.fontSize15, fontWeight: FontWeight.w500);
  static final TextStyle rTextRalewayBlack15w600 = _textRalewayBlack.copyWith(fontSize: Dimens.fontSize15, fontWeight: FontWeight.w600);
  static final TextStyle rTextRalewayBlack15w700 = _textRalewayBlack.copyWith(fontSize: Dimens.fontSize15, fontWeight: FontWeight.w700);

  static final TextStyle rTextRalewayBlack16w400 = _textRalewayBlack.copyWith(fontSize: Dimens.fontSize16, fontWeight: FontWeight.w400);
  static final TextStyle rTextRalewayBlack16w500 = _textRalewayBlack.copyWith(fontSize: Dimens.fontSize16, fontWeight: FontWeight.w500);
  static final TextStyle rTextRalewayBlack16w600 = _textRalewayBlack.copyWith(fontSize: Dimens.fontSize16, fontWeight: FontWeight.w600);
  static final TextStyle rTextRalewayBlack16w700 = _textRalewayBlack.copyWith(fontSize: Dimens.fontSize16, fontWeight: FontWeight.w700);

  static final TextStyle rTextRalewayBlack17w400 = _textRalewayBlack.copyWith(fontSize: Dimens.fontSize17, fontWeight: FontWeight.w400);
  static final TextStyle rTextRalewayBlack17w500 = _textRalewayBlack.copyWith(fontSize: Dimens.fontSize17, fontWeight: FontWeight.w500);
  static final TextStyle rTextRalewayBlack17w600 = _textRalewayBlack.copyWith(fontSize: Dimens.fontSize17, fontWeight: FontWeight.w600);
  static final TextStyle rTextRalewayBlack17w700 = _textRalewayBlack.copyWith(fontSize: Dimens.fontSize17, fontWeight: FontWeight.w700);

  static final TextStyle rTextRalewayBlack18w400 = _textRalewayBlack.copyWith(fontSize: Dimens.fontSize18, fontWeight: FontWeight.w400);
  static final TextStyle rTextRalewayBlack18w500 = _textRalewayBlack.copyWith(fontSize: Dimens.fontSize18, fontWeight: FontWeight.w500);
  static final TextStyle rTextRalewayBlack18w600 = _textRalewayBlack.copyWith(fontSize: Dimens.fontSize18, fontWeight: FontWeight.w600);
  static final TextStyle rTextRalewayBlack18w700 = _textRalewayBlack.copyWith(fontSize: Dimens.fontSize18, fontWeight: FontWeight.w700);

  static final TextStyle rTextRalewayBlack19w400 = _textRalewayBlack.copyWith(fontSize: Dimens.fontSize19, fontWeight: FontWeight.w400);
  static final TextStyle rTextRalewayBlack19w500 = _textRalewayBlack.copyWith(fontSize: Dimens.fontSize19, fontWeight: FontWeight.w500);
  static final TextStyle rTextRalewayBlack19w600 = _textRalewayBlack.copyWith(fontSize: Dimens.fontSize19, fontWeight: FontWeight.w600);
  static final TextStyle rTextRalewayBlack19w800 = _textRalewayBlack.copyWith(fontSize: Dimens.fontSize19, fontWeight: FontWeight.w800);

  static final TextStyle rTextRalewayBlack20w400 = _textRalewayBlack.copyWith(fontSize: Dimens.fontSize20, fontWeight: FontWeight.w400);
  static final TextStyle rTextRalewayBlack20w500 = _textRalewayBlack.copyWith(fontSize: Dimens.fontSize20, fontWeight: FontWeight.w500);
  static final TextStyle rTextRalewayBlack20w600 = _textRalewayBlack.copyWith(fontSize: Dimens.fontSize20, fontWeight: FontWeight.w600);
  static final TextStyle rTextRalewayBlack20w700 = _textRalewayBlack.copyWith(fontSize: Dimens.fontSize20, fontWeight: FontWeight.w700);

  static final TextStyle rTextRalewayBlack22w400 = _textRalewayBlack.copyWith(fontSize: Dimens.fontSize22, fontWeight: FontWeight.w400);
  static final TextStyle rTextRalewayBlack22w500 = _textRalewayBlack.copyWith(fontSize: Dimens.fontSize22, fontWeight: FontWeight.w500);
  static final TextStyle rTextRalewayBlack22w600 = _textRalewayBlack.copyWith(fontSize: Dimens.fontSize22, fontWeight: FontWeight.w600);
  static final TextStyle rTextRalewayBlack22w700 = _textRalewayBlack.copyWith(fontSize: Dimens.fontSize22, fontWeight: FontWeight.w700);

  static final TextStyle rTextRalewayBlack24w400 = _textRalewayBlack.copyWith(fontSize: Dimens.fontSize24, fontWeight: FontWeight.w400);
  static final TextStyle rTextRalewayBlack24w500 = _textRalewayBlack.copyWith(fontSize: Dimens.fontSize24, fontWeight: FontWeight.w500);
  static final TextStyle rTextRalewayBlack24w600 = _textRalewayBlack.copyWith(fontSize: Dimens.fontSize24, fontWeight: FontWeight.w600);
  static final TextStyle rTextRalewayBlack24w700 = _textRalewayBlack.copyWith(fontSize: Dimens.fontSize24, fontWeight: FontWeight.w700);

  static final TextStyle rTextRalewayBlack26w400 = _textRalewayBlack.copyWith(fontSize: Dimens.fontSize26, fontWeight: FontWeight.w400);
  static final TextStyle rTextRalewayBlack26w500 = _textRalewayBlack.copyWith(fontSize: Dimens.fontSize26, fontWeight: FontWeight.w500);
  static final TextStyle rTextRalewayBlack26w600 = _textRalewayBlack.copyWith(fontSize: Dimens.fontSize26, fontWeight: FontWeight.w600);
  static final TextStyle rTextRalewayBlack26w700 = _textRalewayBlack.copyWith(fontSize: Dimens.fontSize26, fontWeight: FontWeight.w700);

  static final TextStyle rTextRalewayBlack28w400 = _textRalewayBlack.copyWith(fontSize: Dimens.fontSize28, fontWeight: FontWeight.w400);
  static final TextStyle rTextRalewayBlack28w500 = _textRalewayBlack.copyWith(fontSize: Dimens.fontSize28, fontWeight: FontWeight.w500);
  static final TextStyle rTextRalewayBlack28w600 = _textRalewayBlack.copyWith(fontSize: Dimens.fontSize28, fontWeight: FontWeight.w600);
  static final TextStyle rTextRalewayBlack28w700 = _textRalewayBlack.copyWith(fontSize: Dimens.fontSize28, fontWeight: FontWeight.w900);

  static final TextStyle rTextRalewayBlue10w400 = _textRalewayBlue.copyWith(fontSize: Dimens.fontSize10, fontWeight: FontWeight.w400);
  static final TextStyle rTextRalewayBlue10w500 = _textRalewayBlue.copyWith(fontSize: Dimens.fontSize10, fontWeight: FontWeight.w500);
  static final TextStyle rTextRalewayBlue10w600 = _textRalewayBlue.copyWith(fontSize: Dimens.fontSize10, fontWeight: FontWeight.w600);
  static final TextStyle rTextRalewayBlue10w700 = _textRalewayBlue.copyWith(fontSize: Dimens.fontSize10, fontWeight: FontWeight.w700);

  static final TextStyle rTextRalewayBlue12w400 = _textRalewayBlue.copyWith(fontSize: Dimens.fontSize12, fontWeight: FontWeight.w400);
  static final TextStyle rTextRalewayBlue12w500 = _textRalewayBlue.copyWith(fontSize: Dimens.fontSize12, fontWeight: FontWeight.w500);
  static final TextStyle rTextRalewayBlue12w600 = _textRalewayBlue.copyWith(fontSize: Dimens.fontSize12, fontWeight: FontWeight.w600);
  static final TextStyle rTextRalewayBlue12w700 = _textRalewayBlue.copyWith(fontSize: Dimens.fontSize12, fontWeight: FontWeight.w700);

  static final TextStyle rTextRalewayBlue13w400 = _textRalewayBlue.copyWith(fontSize: Dimens.fontSize13, fontWeight: FontWeight.w400);
  static final TextStyle rTextRalewayBlue13w500 = _textRalewayBlue.copyWith(fontSize: Dimens.fontSize13, fontWeight: FontWeight.w500);
  static final TextStyle rTextRalewayBlue13w600 = _textRalewayBlue.copyWith(fontSize: Dimens.fontSize13, fontWeight: FontWeight.w600);
  static final TextStyle rTextRalewayBlue13w700 = _textRalewayBlue.copyWith(fontSize: Dimens.fontSize13, fontWeight: FontWeight.w700);

  static final TextStyle rTextRalewayBlue14w400 = _textRalewayBlue.copyWith(fontSize: Dimens.fontSize14, fontWeight: FontWeight.w400);
  static final TextStyle rTextRalewayBlue14w500 = _textRalewayBlue.copyWith(fontSize: Dimens.fontSize14, fontWeight: FontWeight.w500);
  static final TextStyle rTextRalewayBlue14w600 = _textRalewayBlue.copyWith(fontSize: Dimens.fontSize14, fontWeight: FontWeight.w600);
  static final TextStyle rTextRalewayBlue14w700 = _textRalewayBlue.copyWith(fontSize: Dimens.fontSize14, fontWeight: FontWeight.w700);

  static final TextStyle rTextRalewayBlue15w400 = _textRalewayBlue.copyWith(fontSize: Dimens.fontSize15, fontWeight: FontWeight.w400);
  static final TextStyle rTextRalewayBlue15w500 = _textRalewayBlue.copyWith(fontSize: Dimens.fontSize15, fontWeight: FontWeight.w500);
  static final TextStyle rTextRalewayBlue15w600 = _textRalewayBlue.copyWith(fontSize: Dimens.fontSize15, fontWeight: FontWeight.w600);
  static final TextStyle rTextRalewayBlue15w700 = _textRalewayBlue.copyWith(fontSize: Dimens.fontSize15, fontWeight: FontWeight.w700);

  static final TextStyle rTextRalewayBlue16w400 = _textRalewayBlue.copyWith(fontSize: Dimens.fontSize16, fontWeight: FontWeight.w400);
  static final TextStyle rTextRalewayBlue16w500 = _textRalewayBlue.copyWith(fontSize: Dimens.fontSize16, fontWeight: FontWeight.w500);
  static final TextStyle rTextRalewayBlue16w600 = _textRalewayBlue.copyWith(fontSize: Dimens.fontSize16, fontWeight: FontWeight.w600);
  static final TextStyle rTextRalewayBlue16w700 = _textRalewayBlue.copyWith(fontSize: Dimens.fontSize16, fontWeight: FontWeight.w700);

  static final TextStyle rTextRalewayBlue17w400 = _textRalewayBlue.copyWith(fontSize: Dimens.fontSize17, fontWeight: FontWeight.w400);
  static final TextStyle rTextRalewayBlue17w500 = _textRalewayBlue.copyWith(fontSize: Dimens.fontSize17, fontWeight: FontWeight.w500);
  static final TextStyle rTextRalewayBlue17w600 = _textRalewayBlue.copyWith(fontSize: Dimens.fontSize17, fontWeight: FontWeight.w600);
  static final TextStyle rTextRalewayBlue17w700 = _textRalewayBlue.copyWith(fontSize: Dimens.fontSize17, fontWeight: FontWeight.w700);

  static final TextStyle rTextRalewayBlue18w400 = _textRalewayBlue.copyWith(fontSize: Dimens.fontSize18, fontWeight: FontWeight.w400);
  static final TextStyle rTextRalewayBlue18w500 = _textRalewayBlue.copyWith(fontSize: Dimens.fontSize18, fontWeight: FontWeight.w500);
  static final TextStyle rTextRalewayBlue18w600 = _textRalewayBlue.copyWith(fontSize: Dimens.fontSize18, fontWeight: FontWeight.w600);
  static final TextStyle rTextRalewayBlue18w700 = _textRalewayBlue.copyWith(fontSize: Dimens.fontSize18, fontWeight: FontWeight.w700);

  static final TextStyle rTextRalewayBlue20w400 = _textRalewayBlue.copyWith(fontSize: Dimens.fontSize20, fontWeight: FontWeight.w400);
  static final TextStyle rTextRalewayBlue20w500 = _textRalewayBlue.copyWith(fontSize: Dimens.fontSize20, fontWeight: FontWeight.w500);
  static final TextStyle rTextRalewayBlue20w600 = _textRalewayBlue.copyWith(fontSize: Dimens.fontSize20, fontWeight: FontWeight.w600);
  static final TextStyle rTextRalewayBlue20w700 = _textRalewayBlue.copyWith(fontSize: Dimens.fontSize20, fontWeight: FontWeight.w700);

  static final TextStyle rTextRalewayBlue22w400 = _textRalewayBlue.copyWith(fontSize: Dimens.fontSize22, fontWeight: FontWeight.w400);
  static final TextStyle rTextRalewayBlue22w500 = _textRalewayBlue.copyWith(fontSize: Dimens.fontSize22, fontWeight: FontWeight.w500);
  static final TextStyle rTextRalewayBlue22w600 = _textRalewayBlue.copyWith(fontSize: Dimens.fontSize22, fontWeight: FontWeight.w600);
  static final TextStyle rTextRalewayBlue22w700 = _textRalewayBlue.copyWith(fontSize: Dimens.fontSize22, fontWeight: FontWeight.w700);

  static final TextStyle rTextRalewayBlue24w400 = _textRalewayBlue.copyWith(fontSize: Dimens.fontSize24, fontWeight: FontWeight.w400);
  static final TextStyle rTextRalewayBlue24w500 = _textRalewayBlue.copyWith(fontSize: Dimens.fontSize24, fontWeight: FontWeight.w500);
  static final TextStyle rTextRalewayBlue24w600 = _textRalewayBlue.copyWith(fontSize: Dimens.fontSize24, fontWeight: FontWeight.w600);
  static final TextStyle rTextRalewayBlue24w700 = _textRalewayBlue.copyWith(fontSize: Dimens.fontSize24, fontWeight: FontWeight.w700);

  static final TextStyle rTextRalewayBlue26w400 = _textRalewayBlue.copyWith(fontSize: Dimens.fontSize26, fontWeight: FontWeight.w400);
  static final TextStyle rTextRalewayBlue26w500 = _textRalewayBlue.copyWith(fontSize: Dimens.fontSize26, fontWeight: FontWeight.w500);
  static final TextStyle rTextRalewayBlue26w600 = _textRalewayBlue.copyWith(fontSize: Dimens.fontSize26, fontWeight: FontWeight.w600);
  static final TextStyle rTextRalewayBlue26w700 = _textRalewayBlue.copyWith(fontSize: Dimens.fontSize26, fontWeight: FontWeight.w700);

  static final TextStyle rTextRalewayBlue28w400 = _textRalewayBlue.copyWith(fontSize: Dimens.fontSize28, fontWeight: FontWeight.w400);
  static final TextStyle rTextRalewayBlue28w500 = _textRalewayBlue.copyWith(fontSize: Dimens.fontSize28, fontWeight: FontWeight.w500);
  static final TextStyle rTextRalewayBlue28w600 = _textRalewayBlue.copyWith(fontSize: Dimens.fontSize28, fontWeight: FontWeight.w600);
  static final TextStyle rTextRalewayBlue28w700 = _textRalewayBlue.copyWith(fontSize: Dimens.fontSize28, fontWeight: FontWeight.w700);

  static final TextStyle rTextRalewayWhite10w400 = _textRalewayWhite.copyWith(fontSize: Dimens.fontSize10, fontWeight: FontWeight.w400);
  static final TextStyle rTextRalewayWhite10w500 = _textRalewayWhite.copyWith(fontSize: Dimens.fontSize10, fontWeight: FontWeight.w500);
  static final TextStyle rTextRalewayWhite10w600 = _textRalewayWhite.copyWith(fontSize: Dimens.fontSize10, fontWeight: FontWeight.w600);
  static final TextStyle rTextRalewayWhite10w700 = _textRalewayWhite.copyWith(fontSize: Dimens.fontSize10, fontWeight: FontWeight.w700);

  static final TextStyle rTextRalewayWhite12w400 = _textRalewayWhite.copyWith(fontSize: Dimens.fontSize12, fontWeight: FontWeight.w400);
  static final TextStyle rTextRalewayWhite12w500 = _textRalewayWhite.copyWith(fontSize: Dimens.fontSize12, fontWeight: FontWeight.w500);
  static final TextStyle rTextRalewayWhite12w600 = _textRalewayWhite.copyWith(fontSize: Dimens.fontSize12, fontWeight: FontWeight.w600);
  static final TextStyle rTextRalewayWhite12w700 = _textRalewayWhite.copyWith(fontSize: Dimens.fontSize12, fontWeight: FontWeight.w700);

  static final TextStyle rTextRalewayWhite13w400 = _textRalewayWhite.copyWith(fontSize: Dimens.fontSize13, fontWeight: FontWeight.w400);
  static final TextStyle rTextRalewayWhite13w500 = _textRalewayWhite.copyWith(fontSize: Dimens.fontSize13, fontWeight: FontWeight.w500);
  static final TextStyle rTextRalewayWhite13w600 = _textRalewayWhite.copyWith(fontSize: Dimens.fontSize13, fontWeight: FontWeight.w600);
  static final TextStyle rTextRalewayWhite13w700 = _textRalewayWhite.copyWith(fontSize: Dimens.fontSize13, fontWeight: FontWeight.w700);

  static final TextStyle rTextRalewayWhite14w400 = _textRalewayWhite.copyWith(fontSize: Dimens.fontSize14, fontWeight: FontWeight.w400);
  static final TextStyle rTextRalewayWhite14w500 = _textRalewayWhite.copyWith(fontSize: Dimens.fontSize14, fontWeight: FontWeight.w500);
  static final TextStyle rTextRalewayWhite14w600 = _textRalewayWhite.copyWith(fontSize: Dimens.fontSize14, fontWeight: FontWeight.w600);
  static final TextStyle rTextRalewayWhite14w700 = _textRalewayWhite.copyWith(fontSize: Dimens.fontSize14, fontWeight: FontWeight.w700);

  static final TextStyle rTextRalewayWhite15w400 = _textRalewayWhite.copyWith(fontSize: Dimens.fontSize15, fontWeight: FontWeight.w400);
  static final TextStyle rTextRalewayWhite15w500 = _textRalewayWhite.copyWith(fontSize: Dimens.fontSize15, fontWeight: FontWeight.w500);
  static final TextStyle rTextRalewayWhite15w600 = _textRalewayWhite.copyWith(fontSize: Dimens.fontSize15, fontWeight: FontWeight.w600);
  static final TextStyle rTextRalewayWhite15w700 = _textRalewayWhite.copyWith(fontSize: Dimens.fontSize15, fontWeight: FontWeight.w700);

  static final TextStyle rTextRalewayWhite16w400 = _textRalewayWhite.copyWith(fontSize: Dimens.fontSize16, fontWeight: FontWeight.w400);
  static final TextStyle rTextRalewayWhite16w500 = _textRalewayWhite.copyWith(fontSize: Dimens.fontSize16, fontWeight: FontWeight.w500);
  static final TextStyle rTextRalewayWhite16w600 = _textRalewayWhite.copyWith(fontSize: Dimens.fontSize16, fontWeight: FontWeight.w600);
  static final TextStyle rTextRalewayWhite16w700 = _textRalewayWhite.copyWith(fontSize: Dimens.fontSize16, fontWeight: FontWeight.w700);

  static final TextStyle rTextRalewayWhite17w400 = _textRalewayWhite.copyWith(fontSize: Dimens.fontSize17, fontWeight: FontWeight.w400);
  static final TextStyle rTextRalewayWhite17w500 = _textRalewayWhite.copyWith(fontSize: Dimens.fontSize17, fontWeight: FontWeight.w500);
  static final TextStyle rTextRalewayWhite17w600 = _textRalewayWhite.copyWith(fontSize: Dimens.fontSize17, fontWeight: FontWeight.w600);
  static final TextStyle rTextRalewayWhite17w700 = _textRalewayWhite.copyWith(fontSize: Dimens.fontSize17, fontWeight: FontWeight.w700);

  static final TextStyle rTextRalewayWhite18w400 = _textRalewayWhite.copyWith(fontSize: Dimens.fontSize18, fontWeight: FontWeight.w400);
  static final TextStyle rTextRalewayWhite18w500 = _textRalewayWhite.copyWith(fontSize: Dimens.fontSize18, fontWeight: FontWeight.w500);
  static final TextStyle rTextRalewayWhite18w600 = _textRalewayWhite.copyWith(fontSize: Dimens.fontSize18, fontWeight: FontWeight.w600);
  static final TextStyle rTextRalewayWhite18w700 = _textRalewayWhite.copyWith(fontSize: Dimens.fontSize18, fontWeight: FontWeight.w700);

  static final TextStyle rTextRalewayWhite20w400 = _textRalewayWhite.copyWith(fontSize: Dimens.fontSize20, fontWeight: FontWeight.w400);
  static final TextStyle rTextRalewayWhite20w500 = _textRalewayWhite.copyWith(fontSize: Dimens.fontSize20, fontWeight: FontWeight.w500);
  static final TextStyle rTextRalewayWhite20w600 = _textRalewayWhite.copyWith(fontSize: Dimens.fontSize20, fontWeight: FontWeight.w600);
  static final TextStyle rTextRalewayWhite20w700 = _textRalewayWhite.copyWith(fontSize: Dimens.fontSize20, fontWeight: FontWeight.w700);

  static final TextStyle rTextRalewayWhite22w400 = _textRalewayWhite.copyWith(fontSize: Dimens.fontSize22, fontWeight: FontWeight.w400);
  static final TextStyle rTextRalewayWhite22w500 = _textRalewayWhite.copyWith(fontSize: Dimens.fontSize22, fontWeight: FontWeight.w500);
  static final TextStyle rTextRalewayWhite22w600 = _textRalewayWhite.copyWith(fontSize: Dimens.fontSize22, fontWeight: FontWeight.w600);
  static final TextStyle rTextRalewayWhite22w700 = _textRalewayWhite.copyWith(fontSize: Dimens.fontSize22, fontWeight: FontWeight.w700);

  static final TextStyle rTextRalewayWhite24w400 = _textRalewayWhite.copyWith(fontSize: Dimens.fontSize24, fontWeight: FontWeight.w400);
  static final TextStyle rTextRalewayWhite24w500 = _textRalewayWhite.copyWith(fontSize: Dimens.fontSize24, fontWeight: FontWeight.w500);
  static final TextStyle rTextRalewayWhite24w600 = _textRalewayWhite.copyWith(fontSize: Dimens.fontSize24, fontWeight: FontWeight.w600);
  static final TextStyle rTextRalewayWhite24w700 = _textRalewayWhite.copyWith(fontSize: Dimens.fontSize24, fontWeight: FontWeight.w700);

  static final TextStyle rTextRalewayWhite26w400 = _textRalewayWhite.copyWith(fontSize: Dimens.fontSize26, fontWeight: FontWeight.w400);
  static final TextStyle rTextRalewayWhite26w500 = _textRalewayWhite.copyWith(fontSize: Dimens.fontSize26, fontWeight: FontWeight.w500);
  static final TextStyle rTextRalewayWhite26w600 = _textRalewayWhite.copyWith(fontSize: Dimens.fontSize26, fontWeight: FontWeight.w600);
  static final TextStyle rTextRalewayWhite26w700 = _textRalewayWhite.copyWith(fontSize: Dimens.fontSize26, fontWeight: FontWeight.w700);

  static final TextStyle rTextRalewayWhite28w400 = _textRalewayWhite.copyWith(fontSize: Dimens.fontSize28, fontWeight: FontWeight.w400);
  static final TextStyle rTextRalewayWhite28w500 = _textRalewayWhite.copyWith(fontSize: Dimens.fontSize28, fontWeight: FontWeight.w500);
  static final TextStyle rTextRalewayWhite28w600 = _textRalewayWhite.copyWith(fontSize: Dimens.fontSize28, fontWeight: FontWeight.w600);
  static final TextStyle rTextRalewayWhite28w700 = _textRalewayWhite.copyWith(fontSize: Dimens.fontSize28, fontWeight: FontWeight.w700);
}
