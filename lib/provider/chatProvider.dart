
import 'package:chatgo/utils/utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

import '../helper/sharedPref.dart';

class chatProvider extends ChangeNotifier{

  Map<String, dynamic> _userData={};
  Map<String, dynamic> get chatSharedPref => _userData;

  chatProvider() {
    getSharedPref();
  }

  void getSharedPref()async{
    _userData=await sharedPref().getUserData();
    notifyListeners();
  }

  void sendMessage({required String message,required String receiverUsername,
    required String receiverName, required String senderId,required timeStamp,
    required String receiverUID,required String receiverProfilePic})async{
    utils.customPrint("Message send start");
    String chatID = generateChatID(receiverUsername, senderId);
    // Reference to the chat document
    DocumentReference chatDocRef = FirebaseFirestore.instance.collection('chats').doc(chatID);
    // Check if the chat document exists
    DocumentSnapshot chatDoc = await chatDocRef.get();
    if (!chatDoc.exists) {
      // If chat doesn't exist, create it and store the user array
      await chatDocRef.set({
        'users': [receiverUsername, senderId], // Store users as an array
        'createdAt': FieldValue.serverTimestamp(),
        "receiverUID":receiverUID,
        "receiverName":receiverName,
        "receiverProfilePic":receiverProfilePic,
        "receiverUsername":receiverUsername,
        "senderUID":_userData['uid'],
        "senderName":_userData['name'],
        "senderProfilePic":_userData['profileImg'],
        "senderUsername":_userData['username'],
      });
    }
    await chatDocRef.collection('messages').add({
      'message':message,
      'receiverId':receiverUsername,
      'senderId':senderId,
      'read':false,
      'timeStamp':timeStamp,
    });
    utils.customPrint("Message send end");
  }

  String generateChatID(String receiverId,String senderId){
    List<String> users = [receiverId, senderId]..sort();  // Ensures consistency
    return "${users[0]}_${users[1]}";  // Example: userA_userB
  }

}