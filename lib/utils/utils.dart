
import 'package:chatgo/utils/colors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class utils{

 static const String appName = "Chat Go";

  ///Font Name
 static const String fontFamily = "Caros";


  ///Toast
 static void showToast({required BuildContext context,required String msg}){
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg),backgroundColor: colors.primaryColor,showCloseIcon: true,));
 }

 ///static methods
 static double getDeviceWidth(BuildContext context) => MediaQuery.sizeOf(context).width*1;
 static double getDeviceHeight(BuildContext context) => MediaQuery.sizeOf(context).height*1;
 static void customPrint(Object object){if(kDebugMode)print("$appName ${object}");}
 static String generateUsername(String email) {
  if (!email.contains("@")) return email;
  return email.split("@").first;
 }

 static String formatTimestamp(dynamic status) {
  if (status is String) {
   return status;
  } else if (status is Timestamp) {
   DateTime date = status.toDate().toLocal(); // Convert to local timezone
   DateTime now = DateTime.now();

   DateTime today = DateTime(now.year, now.month, now.day);
   DateTime dateOnly = DateTime(date.year, date.month, date.day);

   Duration difference = today.difference(dateOnly);

   if (difference.inDays == 0) {
    return "Today ${DateFormat('h:mm a').format(date)}";
   } else if (difference.inDays == 1) {
    return "Yesterday ${DateFormat('h:mm a').format(date)}";
   } else if (difference.inDays < 7) {
    return "${difference.inDays} days ago";
   } else if (difference.inDays < 30) {
    return "${(difference.inDays / 7).floor()} weeks ago";
   } else {
    return DateFormat('MMM d, yyyy h:mm a').format(date);
   }
  } else {
   return "Unknown";
  }
 }

}