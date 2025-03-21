
import 'package:chatgo/utils/utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_sign_in/google_sign_in.dart';

class googleSignin{


  Future<dynamic> signInWithGoogle() async {

    utils.customPrint('Sign in with google starts');
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      final GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );
      utils.customPrint('Sign in with google finish');
      return await FirebaseAuth.instance.signInWithCredential(credential);
    } on Exception catch (e) {
      // TODO
      utils.customPrint('exception->$e');

    }
  }

  Future<void> signOut() async {
    await GoogleSignIn().signOut();
    utils.customPrint('User signed out from Google');
  }


}