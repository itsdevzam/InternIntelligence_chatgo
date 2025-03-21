import 'package:chatgo/provider/chatProvider.dart';
import 'package:chatgo/provider/homeProvider.dart';
import 'package:chatgo/provider/loginProvider.dart';
import 'package:chatgo/provider/nextSplashProvider.dart';
import 'package:chatgo/provider/profileProvider.dart';
import 'package:chatgo/provider/searchProvider.dart';
import 'package:chatgo/provider/settingScreenProvider.dart';
import 'package:chatgo/provider/signupProvider.dart';
import 'package:chatgo/screens/home/homeScreen.dart';
import 'package:chatgo/screens/login/loginScreen.dart';
import 'package:chatgo/screens/profile/profileScreen.dart';
import 'package:chatgo/screens/search/searchScreen.dart';
import 'package:chatgo/screens/settings/settingsScreen.dart';
import 'package:chatgo/screens/signup/signupScreen.dart';
import 'package:chatgo/screens/splash/SplashScreen.dart';
import 'package:chatgo/screens/splash/nextSplash.dart';
import 'package:chatgo/utils/colors.dart';
import 'package:chatgo/utils/utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lifecycle/lifecycle.dart';
import 'package:provider/provider.dart';
import 'screens/chat/chatScreen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Firebase.initializeApp();
    FirebaseFirestore.instance.settings = Settings(persistenceEnabled: true,);
    utils.customPrint("Firebase initialization Successful");
  } catch (e) {
    utils.customPrint("Firebase initialization error: $e");
  }
  runApp(
    MultiProvider(providers: [
      ChangeNotifierProvider(create: (context) => signupProvider(),),
      ChangeNotifierProvider(create: (context) => settingScreenProvider(),),
      ChangeNotifierProvider(create: (context) => profileProvider(),),
      ChangeNotifierProvider(create: (context) => searchProvider(),),
      ChangeNotifierProvider(create: (context) => nextSplashProvider(),),
      ChangeNotifierProvider(create: (context) => loginProvider(),),
      ChangeNotifierProvider(create: (context) => chatProvider(),),
      ChangeNotifierProvider(create: (context) => homeProvider(),),
    ],
    child: const MyApp(),)
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.delayed(Duration.zero, () {
      final homepro = Provider.of<homeProvider>(context, listen: false);
      homepro.updateStatus("online");
    });
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    final homepro = Provider.of<homeProvider>(context, listen: false);
    if (state == AppLifecycleState.inactive || state == AppLifecycleState.paused) {
      homepro.updateStatus("offline");
    } else if (state == AppLifecycleState.resumed) {
      homepro.updateStatus("online");
    }
  }

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      initialRoute: "/",
      getPages: [
        GetPage(name: "/", page: () => SplashScreen()),
        GetPage(name: "/nextSplash", page: () => nextSplash(), transition: Transition.circularReveal,transitionDuration: Duration(milliseconds: 1500)),
        GetPage(name: "/login", page: () => loginScreen(), transition: Transition.rightToLeft,),
        GetPage(name: "/signup", page: () => signupScreen(), transition: Transition.rightToLeft,),
        GetPage(name: "/home", page: () => homeScreen(), transition: Transition.circularReveal,transitionDuration: Duration(milliseconds: 1500)),
        // GetPage(name: "/chat", page: () => chatScreen(), transition: Transition.rightToLeft,),
        GetPage(name: "/settings", page: () => settingsScreen(), transition: Transition.rightToLeft,),
        GetPage(name: "/profile", page: () => profileScreen(), transition: Transition.rightToLeft,),
        GetPage(name: "/search", page: () => searchScreen(), transition: Transition.rightToLeft,),
      ],
      title: utils.appName,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: colors.primaryColor),
      ),
    );
  }
}


