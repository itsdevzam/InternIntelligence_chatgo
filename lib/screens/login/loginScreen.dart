import 'dart:io';

import 'package:chatgo/helper/firestore/firestoreHelper.dart';
import 'package:chatgo/helper/auth/forgotPassHelper.dart';
import 'package:chatgo/helper/firestore/getProfileLink.dart';
import 'package:chatgo/helper/sharedPref.dart';
import 'package:chatgo/provider/homeProvider.dart';
import 'package:chatgo/provider/loginProvider.dart';
import 'package:chatgo/provider/signupProvider.dart';
import 'package:chatgo/services/auth/googleSignin.dart';
import 'package:chatgo/helper/auth/signinHelper.dart';
import 'package:chatgo/utils/colors.dart';
import 'package:chatgo/utils/lang_en.dart';
import 'package:chatgo/utils/utils.dart';
import 'package:chatgo/widgets/circular_social_button.dart';
import 'package:chatgo/widgets/custom_back_appbar.dart';
import 'package:chatgo/widgets/custom_rectangular_button.dart';
import 'package:chatgo/widgets/custom_text_field.dart';
import 'package:chatgo/widgets/loadingAnimation.dart';
import 'package:chatgo/widgets/rectangular_animated_btn.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:provider/provider.dart';

class loginScreen extends StatelessWidget {
  loginScreen({super.key});

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: colors.backgroundColor,
      appBar: PreferredSize(
        preferredSize: Size(utils.getDeviceWidth(context), 50),
        child: custom_back_appbar(title: ""),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 70),
            Container(
              alignment: Alignment.center,
              width: double.infinity,
              child: Stack(
                children: [
                  Positioned(
                    bottom: 0,
                    child: Container(
                      width: 70,
                      height: 10,
                      color: colors.primaryColor,
                    ),
                  ),
                  Text(
                    lang_en.login_text,
                    style: TextStyle(
                      color: Colors.white,
                      fontFamily: utils.fontFamily,
                      fontWeight: FontWeight.w700,
                      fontSize: 22,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            Text(
              lang_en.siginInSubtitile,
              style: TextStyle(
                color: Colors.white,
                fontFamily: utils.fontFamily,
                fontSize: 16,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              spacing: 15,
              children: [
                // circular_social_button(onTap: (){}, iconPath: "assets/icons/fb_logo.png"),
                Consumer<loginProvider>(
                  builder: (context, value, child) {
                    return value.isloading
                        ? loadingAnimation()
                        : circular_social_button(
                          onTap: () async {
                            value.setLoading(true);
                            try {
                              UserCredential? userCredential =
                                  await googleSignin().signInWithGoogle();
                              if (userCredential != null) {
                                await firestoreHelper()
                                    .uploadUserDatawithGoogle(
                                      uid: userCredential.user?.uid,
                                      email: userCredential.user!.email!,
                                      name: userCredential.user!.displayName!,
                                      imgUrl: userCredential.user!.photoURL!,
                                    );
                                String profileImg = await getProfileLink()
                                    .getProfileImage(userCredential.user!.uid);
                                sharedPref().setUserData(
                                  name: userCredential.user!.displayName,
                                  email: userCredential.user!.email,
                                  uid: userCredential.user!.uid,
                                  username: utils.generateUsername(
                                    userCredential.user!.email!,
                                  ),
                                  profileImg: profileImg!,
                                );
                                Provider.of<homeProvider>(context,listen: false).updateStatus("online");
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
                                value.setLoading(false);
                              } else {
                                value.setLoading(false);
                                utils.showToast(
                                  context: context,
                                  msg: "Google Sign-In failed",
                                );
                              }
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
            SizedBox(height: 30),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 60.0),
              child: Row(
                children: [
                  Expanded(child: Divider(color: colors.greyColor)),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15.0),
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
            custom_text_field(
              textEditingController: _emailController,
              labelText: lang_en.email,
              hintText: lang_en.emailHint,
            ),
            SizedBox(height: 30),
            custom_text_field(
              textEditingController: _passController,
              labelText: lang_en.password,
              hintText: lang_en.passwordHint,
              isobscure: true,
            ),
            SizedBox(height: 30),
            //sign in button
            Consumer<signupProvider>(
              builder: (context, value, child) {
                return value.isloading
                    ? rectangular_animated_btn(
                      bgcolor: colors.primaryColor,
                      animationColor: Colors.white,
                    )
                    : custom_rectangular_button(
                      text: lang_en.login,
                      bgcolor: colors.primaryColor,
                      textcolor: Colors.white,
                      onTap: () {
                        signinHelper(
                          context: context,
                          email: _emailController.text,
                          password: _passController.text,
                        );
                      },
                    );
              },
            ),

            SizedBox(height: 30),
            InkWell(
              borderRadius: BorderRadius.circular(10),
              onTap: () {
                if (_emailController.text.isEmpty) {
                  utils.showToast(context: context, msg: "Email filed empty");
                } else {
                  forgotPassHelper(
                    context: context,
                    emailController: _emailController,
                  ).sendforgotPass();
                }
              },
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  lang_en.forgotpassword,
                  style: TextStyle(
                    color: Colors.white,
                    fontFamily: utils.fontFamily,
                    fontSize: 16,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            SizedBox(height: 50),
          ],
        ),
      ),
    );
  }
}
