import 'dart:async';

import 'package:chatgo/helper/firestore/firestoreHelper.dart';
import 'package:chatgo/helper/firestore/getProfileLink.dart';
import 'package:chatgo/helper/sharedPref.dart';
import 'package:chatgo/provider/nextSplashProvider.dart';
import 'package:chatgo/services/auth/googleSignin.dart';
import 'package:chatgo/utils/colors.dart';
import 'package:chatgo/utils/lang_en.dart';
import 'package:chatgo/utils/utils.dart';
import 'package:chatgo/widgets/circular_social_button.dart';
import 'package:chatgo/widgets/custom_rectangular_button.dart';
import 'package:chatgo/widgets/loadingAnimation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';

class nextSplash extends StatefulWidget {
  const nextSplash({super.key});

  @override
  State<nextSplash> createState() => _nextSplashState();
}

class _nextSplashState extends State<nextSplash> {
  bool gradientToggle = true;
  Timer? _timer;

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult:
          (didPop, result) async => await SystemNavigator.pop(),
      child: Scaffold(
        backgroundColor: colors.backgroundColor,
        body: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 40),
              Text(
                utils.appName,
                style: TextStyle(
                  color: Colors.white,
                  fontFamily: utils.fontFamily,
                  fontWeight: FontWeight.w300,
                  fontSize: 22,
                ),
              ),
              AnimatedContainer(
                duration: Duration(seconds: 1),
                decoration: BoxDecoration(
                  gradient: RadialGradient(
                    colors:
                        gradientToggle
                            ? [
                              Colors.purple.withValues(alpha: 0.6),
                              colors.backgroundColor,
                            ]
                            : [
                              Colors.pink.withValues(alpha: 0.4),
                              colors.backgroundColor,
                            ],
                    radius: 0.55,
                  ),
                ),
                width: double.infinity,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 30.0),
                  child: Column(
                    children: [
                      SizedBox(height: 30),
                      Container(
                        width: double.maxFinite,
                        alignment: Alignment.center,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 28.0),
                          child: Text(
                            lang_en.connetFriends,
                            style: TextStyle(
                              color: Colors.white,
                              fontFamily: utils.fontFamily,
                              fontWeight: FontWeight.w300,
                              fontSize: 50,
                            ),
                          ),
                        ),
                      ),
                      Container(
                        width: double.maxFinite,
                        alignment: Alignment.center,
                        child: Text(
                          lang_en.easilyAndQuickly,
                          style: TextStyle(
                            color: Colors.white,
                            fontFamily: utils.fontFamily,
                            fontWeight: FontWeight.w700,
                            fontSize: 50,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                alignment: Alignment.center,
                child: Column(
                  children: [
                    Text(
                      lang_en.nextsplashSubtitle,
                      style: TextStyle(
                        color: Colors.white,
                        fontFamily: utils.fontFamily,
                        fontSize: 17,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 40),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      spacing: 15,
                      children: [
                        // circular_social_button(
                        //   onTap: () {},
                        //   iconPath: "assets/icons/fb_logo.png",
                        // ),
                        Consumer<nextSplashProvider>(
                          builder: (context, value, child) {
                            return value.isloading ? loadingAnimation(): circular_social_button(
                                  onTap: () async {
                                    value.setLoading(true);
                                    try {
                                      UserCredential? userCredential =
                                          await googleSignin()
                                              .signInWithGoogle();
                                      if (userCredential != null) {
                                        await firestoreHelper()
                                            .uploadUserDatawithGoogle(
                                              uid: userCredential.user?.uid,
                                              email:
                                                  userCredential.user!.email!,
                                              name:
                                                  userCredential
                                                      .user!
                                                      .displayName!,
                                              imgUrl:
                                                  userCredential
                                                      .user!
                                                      .photoURL!,
                                            );
                                        String profileImg =
                                            await getProfileLink()
                                                .getProfileImage(
                                                  userCredential.user!.uid,
                                                );
                                        sharedPref().setUserData(
                                          name:
                                              userCredential.user!.displayName,
                                          email: userCredential.user!.email,
                                          uid: userCredential.user!.uid,
                                          username: utils.generateUsername(
                                            userCredential.user!.email!,
                                          ),
                                          profileImg: profileImg!,
                                        );
                                        utils.customPrint(
                                          "name: ${userCredential.user!.displayName}, email: ${userCredential.user!.email},uid: ${userCredential.user!.uid},"
                                          "username: ${utils.generateUsername(userCredential.user!.email!)},profileImg: ${profileImg!}",
                                        );
                                        Get.offNamed("/home");
                                        utils.showToast(
                                          context: context,
                                          msg:
                                              "Signed in as: ${userCredential.user?.displayName}",
                                        );
                                      } else {
                                        utils.showToast(
                                          context: context,
                                          msg: "Google Sign-In failed",
                                        );
                                      }
                                      value.setLoading(false);
                                    } catch (e) {
                                      value.setLoading(false);
                                      utils.showToast(
                                        context: context,
                                        msg: e.toString(),
                                      );
                                    }
                                    value.setLoading(false);
                                  },
                                  iconPath: "assets/icons/google_logo.png",
                                );
                          },
                        ),

                        circular_social_button(
                          onTap: () {
                            utils.showToast(
                              context: context,
                              msg: lang_en.devicNotSupported,
                            );
                          },
                          iconPath: "assets/icons/apple_logo.png",
                        ),
                      ],
                    ),
                    SizedBox(height: 40),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 40.0),
                      child: Row(
                        children: [
                          Expanded(child: Divider(color: colors.greyColor)),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 15.0,
                            ),
                            child: Text(
                              lang_en.or,
                              style: TextStyle(
                                color: Colors.white,
                                fontFamily: utils.fontFamily,
                                fontSize: 17,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          Expanded(child: Divider(color: colors.greyColor)),
                        ],
                      ),
                    ),
                    SizedBox(height: 30),
                    custom_rectangular_button(
                      text: lang_en.continue_with_mail,
                      bgcolor: Colors.white,
                      textcolor: Colors.black,
                      onTap: () {
                        Get.toNamed("/signup");
                      },
                    ),
                    SizedBox(height: 30),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 30.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            lang_en.existingAccount,
                            style: TextStyle(
                              color: Colors.white,
                              fontFamily: utils.fontFamily,
                              fontSize: 16,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          TextButton(
                            onPressed: () {
                              Get.toNamed("/login");
                            },
                            child: Text(
                              lang_en.login,
                              style: TextStyle(
                                color: Colors.white,
                                fontFamily: utils.fontFamily,
                                fontSize: 16,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        gradientToggle = !gradientToggle;
      });
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _timer?.cancel();
  }
}
