
import 'package:chatgo/helper/sharedPref.dart';
import 'package:chatgo/utils/utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

class homeProvider extends ChangeNotifier{
  Map<String, dynamic> _userData={};
  Map<String, dynamic> get homeSharedPref => _userData;

  homeProvider(){
    getSharedPref();
  }

  void getSharedPref()async{
    _userData=await sharedPref().getUserData();
    notifyListeners();
  }

  String generateChatID(String receiverId,String senderId){
    List<String> users = [receiverId, senderId]..sort();  // Ensures consistency
    return "${users[0]}_${users[1]}";  // Example: userA_userB
  }

  void updateStatus(String status) async {
    await FirebaseFirestore.instance.collection("users").doc(FirebaseAuth.instance.currentUser!.uid).update(
       {
         "status": status == "offline" ? FieldValue.serverTimestamp() : status,
       }
    );
  }
}