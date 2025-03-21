

import 'package:chatgo/utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../services/auth/authServices.dart';

class signinHelper{

  String email,password;
  BuildContext context;
  String emailPattern = r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$';
  signinHelper({required this.email,required this.password,required this.context}){
    if(_verifyTextInput()) {
      signinStart();
    }
  }

  void signinStart()async{
    await authServices().firebaseSignin(context: context, email: email, password: password)?Get.offNamed("/home"):null;
  }

  bool _verifyTextInput(){
    RegExp regex = RegExp(emailPattern);
    if(email.isEmpty){
      utils.showToast(context: context, msg: "Please enter your email");
      return false;
    }
    if (!regex.hasMatch(email)) { // ✅ Check email format
      utils.showToast(context: context, msg: "Please enter a valid email");
      return false;
    }
    if(password.isEmpty){
      password.length<6?utils.showToast(context: context, msg: "Enter minimum 6 digits password"):utils.showToast(context: context, msg: "Please enter your password");
      return false;
    }
    return true;
  }
}