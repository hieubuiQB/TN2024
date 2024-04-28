
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:doantotnghiep/resourese/auth_methods.dart';

class RegisterPageBloc with ChangeNotifier {

  AuthMethods mAuthMethods = AuthMethods();

  bool isRegisterPressed = false;

  String? validateEmail(String email) {
    if (email.isEmpty) {
      return 'Please enter an email';
    } else if (!EmailValidator.validate(email)) {
      return 'Please enter a valid email';
    }
    return null;
  }
  String? validatePassword(String password) {
    if (password.isEmpty && password.length<6) {
      return 'Password should atleast contain 6 character';
    }
    return null;
  } 

  String? validatePhone(String phone) {
    if (phone.isEmpty && phone.length < 6) {
      return 'Invalid PhoneNo';
    }
    return null;
  } 

  Future<void> validateFormAndRegister(GlobalKey<FormState> formKey, String userName, String password, String phone) async {
      isRegisterPressed = true;
      notifyListeners();
      if(formKey.currentState!.validate()){
          await mAuthMethods.handleSignUp(phone, userName, password);
          isRegisterPressed = false;
          notifyListeners();
      }
  }
}