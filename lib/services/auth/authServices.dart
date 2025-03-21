

import 'package:chatgo/helper/firestore/getProfileLink.dart';
import 'package:chatgo/helper/sharedPref.dart';
import 'package:chatgo/provider/homeProvider.dart';
import 'package:chatgo/provider/signupProvider.dart';
import 'package:chatgo/services/auth/googleSignin.dart';
import 'package:chatgo/utils/utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:provider/provider.dart';

import '../../provider/homeProvider.dart';

class authServices {
  FirebaseAuth auth = FirebaseAuth.instance;

  Future<String?> firebaseSignup({required BuildContext context,required String email,required String password})async{
    final loadingProvider =  Provider.of<signupProvider>(context,listen: false);
    utils.customPrint("Registration process start");
    try {
      loadingProvider.isSignupLoading=true;
      UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: email,
          password: password
      );
      utils.customPrint("Registration completed");

      if (userCredential.user != null) {
        await userCredential.user!.sendEmailVerification();
        utils.showToast(context: context,msg: "Verification mail send");
        utils.customPrint("Verification mail send");
      }
      return userCredential.user!.uid;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        loadingProvider.isSignupLoading=false;
        utils.showToast(context: context,msg: 'The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        loadingProvider.isSignupLoading=false;
        utils.showToast(context: context,msg: 'The account already exists for that email.');
      }
      return null;
    } catch (e) {
      loadingProvider.isSignupLoading=false;
      utils.customPrint(e);
      return null;
    }
  }

   Future<bool> firebaseSignin({required BuildContext context,required String email,required String password})async{
     final myprovider = Provider.of<homeProvider>(context,listen: false);
     final loadingProvider =  Provider.of<signupProvider>(context,listen: false);
     loadingProvider.isSignupLoading=true;
    utils.customPrint("Login process start");
    try {
      if(!(await isemailVerified(context: context))){
        return false;
      }
      UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: email,
          password: password
      );
      String? profileImg = await getProfileLink().getProfileImage(userCredential.user!.uid);
      await sharedPref().setUserData(name: await getProfileLink().getProfileName(userCredential.user!.uid), email: userCredential.user!.email,
          uid: userCredential.user!.uid,username: utils.generateUsername(userCredential.user!.email!),profileImg: profileImg);
      utils.customPrint("name ${await getProfileLink().getProfileName(userCredential.user!.uid)} email ${userCredential.user!.email} uid ${userCredential.user!.uid} username ${utils.generateUsername(userCredential.user!.email!)} profile ${profileImg}");
      utils.customPrint("Login completed");
      myprovider.updateStatus("offline");
      loadingProvider.isSignupLoading=false;
      return true;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        loadingProvider.isSignupLoading=false;
        utils.showToast(context: context,msg: 'No user found for that email.');
      } else if (e.code == 'wrong-password') {
        loadingProvider.isSignupLoading=false;
        utils.showToast(context: context,msg: 'Password is incorrect');
      }else{
        loadingProvider.isSignupLoading=false;
        utils.showToast(msg: e.code, context: context);
      }
      loadingProvider.isSignupLoading=false;
      return false;
    }
  }

   Future<bool> isemailVerified({required BuildContext context}) async {

    utils.customPrint("is email verified called");
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      await user.reload(); // ✅ Refresh user data
      user = FirebaseAuth.instance.currentUser; // ✅ Get updated user object

      if (user != null && !user.emailVerified) {
        utils.showToast(context: context, msg: "Please verify your email");

        return false;
      }
    }

    return true;
  }

  Future<void> forgotPassword({required String email,required BuildContext context})async{
    FirebaseAuth _auth = FirebaseAuth.instance;
    try {
      await _auth.sendPasswordResetEmail(email: email);
      utils.customPrint("✅ Password reset email sent to $email");
      utils.showToast(context: context, msg: "✅ Password reset email sent to $email");
    } catch (e) {
      utils.customPrint("❌ Error sending reset email: $e");
      utils.showToast(context: context, msg: "❌ Error sending reset email: $e");
    }
  }

  Future<void> firebaseLogout({required BuildContext context})async{
    final myprovider = Provider.of<homeProvider>(context,listen: false);
    myprovider.updateStatus("offline");
    await FirebaseAuth.instance.signOut();
    googleSignin().signOut();
    sharedPref().setLogoutData();
    utils.showToast(context: context, msg: "Logout successfully");
    Get.offNamed('/nextSplash');
  }

}