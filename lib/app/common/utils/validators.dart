
class DValidator{

  //empty textvalidation
  static String? validateEmptyText(String? fielname,String? value){
    if(value==null || value.isEmpty){
      return'$fielname is required';
    }
  }


  static String? validateEmail(String? value){
    if(value==null || value.isEmpty){
      return 'Email is required';
    }
    final emailRegExp=RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if(!emailRegExp.hasMatch(value)){
      return 'invalid email address';
    }
    return null;
  }
  static String? validatePassword(String? value){
    if(value==null || value.isEmpty){
      return 'password is required';
    }
    //check minimum password length
    if(value.length<6){
      return'password must be 6 character or long';
    }
    if(!value.contains(RegExp(r'[A-Z]'))){
      return 'password must be contain atleast one Uppercase letter';
    }
    if(!value.contains(RegExp(r'[0-9]'))){
      return 'password contain atleast one number';
    }
    if(!value.contains(RegExp(r'[!@#$%^&*(),.?":{}<>]'))){
      return 'password contain atleast one Special character';
    }
    return null;
  }
  static String? validatePhoneNumber(String? value){
    if(value==null || value.isEmpty) {
      return 'phonenumber is required';
    }
    final phoneRegExp = RegExp(r'^\d{10}$');
    if(!phoneRegExp.hasMatch(value)){
      return' invalid phonenumber format(10 digits required).';
    }
    return null;
  }
}

