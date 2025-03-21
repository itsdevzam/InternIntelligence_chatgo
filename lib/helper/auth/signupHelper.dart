import 'dart:io';
import 'package:chatgo/helper/firestore/firestoreHelper.dart';
import 'package:chatgo/services/auth/authServices.dart';
import 'package:chatgo/utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:provider/provider.dart';

class signupHelper{
  String name,email,password,confirmpassword;
  BuildContext context;
  String emailPattern = r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$';
  File? imgFile;
  String? _uid;
  signupHelper({required this.name,required this.email,required this.password,required this.confirmpassword,required this.context,required this.imgFile}){
    if(_verifyTextInput()){
      utils.customPrint("Signup process start");
      signupStart();
    }
  }


  void signupStart()async{
    _uid = await authServices().firebaseSignup(context: context, email: email, password: password);
    if(_uid!=null){
      await firestoreHelper().uploadUserData(name: name, email: email, uid: _uid,imgFile: imgFile,context: context)?Get.offNamed("/login"):null;
    }
  }

  bool _verifyTextInput(){
    RegExp regex = RegExp(emailPattern);
    if(name.isEmpty){
      utils.showToast(context: context, msg: "Please enter your name");
      return false;
    }
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
    if(confirmpassword.isEmpty||confirmpassword.length<6){
      confirmpassword.length<6?utils.showToast(context: context, msg: "Enter minimum 6 digits confirm password"):utils.showToast(context: context, msg: "Please confirm your password");
      return false;
    }
    if(password!=confirmpassword){
      utils.showToast(context: context, msg: "Password and confirm password does not match");
      return false;
    }
    if(imgFile==null){
      utils.showToast(context: context, msg: "Please select profile image");
      return false;
    }
    return true;
  }

}