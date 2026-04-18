part of 'app_pages.dart';

abstract class Routes {
  Routes._();
  static const ADMINLOGIN = _Paths.ADMINLOGIN;
  static const PRODUCT = _Paths.PRODUCT;
  static const FORGOTPSWD = _Paths.FORGOTPSWD;
  static const USERHOME = _Paths.USERHOME;
  static const LOGIN=_Paths.LOGIN;
  static const SPLASH=_Paths.SPLASH;

  static const NewPSWD = _Paths.NewPSWD;
  static const SIGNUP = _Paths.SIGNUP;
  static const CART = _Paths.CART;
  static const PROFILE = _Paths.PROFILE;
  static const CATEGORYS = _Paths.CATEGORYS;
  static const CHECKEMAIL = _Paths.CHECKEMAIL;
  static const DISTRICTADMINHOME= _Paths.DISTRICTADMINHOME;
  static const ADMINADVERTISMENTUPDATION= _Paths.ADMINADVERTISMENTUPDATION;
  static const DISTRICTADMINADVUPDATION= _Paths. DISTRICTADMINADVUPDATION;
  static const QRPAYMENT= _Paths.QRPAYMENT;
  static const  MYADVERTISMENT= _Paths. MYADVERTISMENT;
  static const  MERCHANTOFFERVIEW= _Paths. MERCHANTOFFERVIEW;
  static const PURCHASEDPRODUCT=_Paths.PURCHASEDPRODUCT;
  static const MANAGEPRODUCT=_Paths.MANAGEPRODUCT;
  static const  OFFERPRODUCTS=_Paths.OFFERPRODUCTS;




}

abstract class _Paths {
  _Paths._();
  static const ADMINLOGIN = '/adminlogin';
  static const FORGOTPSWD = '/forgotpswd';
  static const PRODUCT = '/product';
  static const NewPSWD = '/newpswd';
  static const USERHOME = '/home';
  static const LOGIN = '/login';
  static const WISHLIST = '/wishlist';
  static const SIGNUP = '/signup';
  static const CART = '/cart';
  static const PROFILE = '/profile';
  static const CATEGORYS= '/category';
  static const SPLASH ='/splash';
  static const CHECKEMAIL='/checkemail';
  static const DISTRICTADMINHOME='/districtadminhome';
  static const ADMINADVERTISMENTUPDATION='/adminadvertismentupdation';
  static const DISTRICTADMINADVUPDATION='/districtadminadvupdation';
  static const QRPAYMENT='/payment';
  static const MYADVERTISMENT='/myadvertisment';
  static const MERCHANTOFFERVIEW='/merchantofferview';
  static const PURCHASEDPRODUCT='/purchased-products';
  static const MANAGEPRODUCT='/manageproduct';
  static const OFFERPRODUCTS='/offerproduct';

}
