import 'dart:async';

import 'package:chatgo/helper/sharedPref.dart';
import 'package:chatgo/screens/splash/nextSplash.dart';
import 'package:chatgo/utils/colors.dart';
import 'package:chatgo/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colors.backgroundColor,
      body: SizedBox(
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 180,
              height: 180,
              alignment: Alignment.center,
              child: Image.asset("assets/logos/splash_logo.png"),
            ),
            Text(utils.appName,style: TextStyle(fontFamily: utils.fontFamily,fontSize: 26,fontWeight: FontWeight.w500,color: Colors.white),)
          ],
        ),
      ),
    );
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUserData();
  }

  void getUserData()async{
    final Map<String,dynamic> userDataMap = await sharedPref().getUserData();
    utils.customPrint(userDataMap);
    userDataMap['islogin']==true?Timer(Duration(seconds: 2), () => Get.offNamed("/home"),):Timer(Duration(seconds: 2), () => Get.offNamed("/nextSplash"),);
  }
}
