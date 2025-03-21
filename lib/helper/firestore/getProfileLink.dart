import 'package:chatgo/utils/utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class getProfileLink{

  Future<String> getProfileImage(String uid) async {
    String? profileImgUrl;

    try {
      // Fetch user document from Firestore
      DocumentSnapshot userDoc = await FirebaseFirestore.instance.collection("users").doc(uid).get();

      // Check if the document exists and has the profileimg field
      if (userDoc.exists && userDoc.data() != null) {
        Map<String, dynamic> userData = userDoc.data() as Map<String, dynamic>;
        profileImgUrl = userData["profileImage"];
        utils.customPrint("object");
        utils.customPrint(profileImgUrl!);// Get profile image URL
      }
    } catch (e) {
      print("Error fetching profile image: $e");
    }

    return profileImgUrl??"404";
  }

  Future<String> getProfileName(String uid) async {
    String? name;

    try {
      // Fetch user document from Firestore
      DocumentSnapshot userDoc = await FirebaseFirestore.instance.collection("users").doc(uid).get();

      // Check if the document exists and has the profileimg field
      if (userDoc.exists && userDoc.data() != null) {
        Map<String, dynamic> userData = userDoc.data() as Map<String, dynamic>;
        name = userData["name"];
        utils.customPrint(name!);// Get profile image URL
      }
    } catch (e) {
      print("Error fetching profile image: $e");
    }

    return name??"404";
  }

}