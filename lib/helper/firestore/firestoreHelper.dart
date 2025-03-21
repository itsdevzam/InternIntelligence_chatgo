import 'dart:io';
import 'dart:math';
import 'package:chatgo/provider/signupProvider.dart';
import 'package:chatgo/utils/utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart' as firebase_core;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

class firestoreHelper{

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<String?> uploadImage({required String? uid,required File? imgFile})async{
    utils.customPrint("Image Upload Start");
    if (imgFile != null) {
      final storageRef = FirebaseStorage.instance.ref();
      final imageRef = storageRef.child("profile_images/$uid.jpg"); // Store image with UID
      try {
        await imageRef.putFile(imgFile!);
        utils.customPrint("Image Upload Done");
        return await imageRef.getDownloadURL();
      } on firebase_core.FirebaseException catch (e) {
        utils.customPrint(e);
        utils.customPrint("Image Upload Error");
      }
      return null;
    }
    return null;
  }

  Future<bool> uploadUserData({required String name,required String email,required String? uid,required File? imgFile,required BuildContext context})async{
    final loadingProvider =  Provider.of<signupProvider>(context,listen: false);
    // Reference to the Firestore document
    DocumentReference userDoc = _firestore.collection("users").doc(uid);
    // Check if the user document already exists
    DocumentSnapshot docSnapshot = await userDoc.get();

    if (!docSnapshot.exists) {
    utils.customPrint("User User Data Upload Start");
    String? imageUrl = await uploadImage(uid: uid, imgFile: imgFile);
    await firebase_core.FirebaseFirestore.instance.collection("users").doc(uid).set({
      "name": name,
      "email": email,
      "profileImage": imageUrl,
      "username":generateUsername(email),
      "uid":uid,
    });
    utils.customPrint("User User Data Upload Done");
    loadingProvider.isImgNull=true;
    loadingProvider.isSignupLoading=false;
    return true;
    }else{
      utils.customPrint("User already exists");
      loadingProvider.isImgNull=true;
      loadingProvider.isSignupLoading=false;
      return false;
    }
  }

  Future<void> uploadUserDatawithGoogle({required String name,required String email,required String? uid,required String? imgUrl})async{
    // Reference to the Firestore document
    DocumentReference userDoc = _firestore.collection("users").doc(uid);
    // Check if the user document already exists
    DocumentSnapshot docSnapshot = await userDoc.get();
    if (!docSnapshot.exists) {
      utils.customPrint("User User Data Upload Start");
      await firebase_core.FirebaseFirestore.instance.collection("users").doc(
          uid).set({
        "name": name,
        "email": email,
        "profileImage": imgUrl,
        "username": generateUsername(email),
        "uid":uid,
      });
      utils.customPrint("User Data Upload Done");
    }else{
      utils.customPrint("User already exists");
    }
  }


  String generateUsername(String email) {
    if (!email.contains("@")) return email;
    return email.split("@").first;
  }

}