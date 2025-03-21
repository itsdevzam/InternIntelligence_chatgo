

import 'package:chatgo/utils/utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class searhUser{

  Future<List<Map<String, dynamic>>> searchUsersByPrefix(String query) async {
    List<Map<String, dynamic>> userList = [];
    Set<String> uniqueEmails = {};

    try {
      QuerySnapshot snapshot = await FirebaseFirestore.instance.collection("users")
          .where("username", isGreaterThanOrEqualTo: query)
          .where("username", isLessThan: '$query\uf8ff') // Firebase Unicode trick
          .get();

      for (var doc in snapshot.docs) {
        Map<String, dynamic> userData = doc.data() as Map<String, dynamic>;

        if (uniqueEmails.add(userData["email"])) { // ✅ Adds only if email is unique
          userList.add(userData);
        }
      }
    } catch (e) {
      utils.customPrint("Error searching users: $e");
    }

    return userList;
  }

}