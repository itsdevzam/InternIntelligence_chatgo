import 'package:chatgo/helper/sharedPref.dart';
import 'package:chatgo/provider/settingScreenProvider.dart';
import 'package:chatgo/screens/profile/profileScreen.dart';
import 'package:chatgo/services/auth/authServices.dart';
import 'package:chatgo/utils/colors.dart';
import 'package:chatgo/utils/lang_en.dart';
import 'package:chatgo/utils/utils.dart';
import 'package:chatgo/widgets/customDialog.dart';
import 'package:chatgo/widgets/custom_back_appbar.dart';
import 'package:chatgo/widgets/setting_item.dart';
import 'package:chatgo/widgets/signup_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:provider/provider.dart';

class settingsScreen extends StatelessWidget {
  settingsScreen({super.key});


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colors.primaryColor,
      appBar: PreferredSize(preferredSize: Size(utils.getDeviceWidth(context), 50),child: custom_back_appbar(title: lang_en.settings,)),
      body: Container(
        height: double.infinity,
        margin: EdgeInsets.only(top: 30),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(topRight: Radius.circular(50),topLeft: Radius.circular(50)),
          color: colors.backgroundColor,
        ),
        width: double.infinity,
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 30.0, left: 30,bottom: 10),
                child: Consumer<settingScreenProvider>(
                  builder: (context, value, child) {
                    value.loadUserData();
                    return Row(
                      children: [
                        Container(
                          width: 70,
                          height: 70,
                          decoration: BoxDecoration(
                            color: Colors.black.withValues(alpha: 0.7),
                            shape: BoxShape.circle,
                            border: Border.all(width: 1.5, color: Colors.white),
                          ),
                          child: ClipRRect(borderRadius: BorderRadius.circular(100),
                              child: FadeInImage.assetNetwork(fit: BoxFit.cover, placeholder: "assets/logos/splash_logo.png", image: value.SettinguserData['profileImg'],)),
                        ),
                        SizedBox(width: 10),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              value.SettinguserData['name']??lang_en.dummyName,
                              style: TextStyle(
                                color: Colors.white,
                                fontFamily: utils.fontFamily,
                                fontWeight: FontWeight.w500,
                                fontSize: 20,
                              ),
                            ),
                            SizedBox(
                              child: Text(
                                value.SettinguserData['username']??lang_en.dummyUsername,
                                style: TextStyle(
                                  color: Colors.grey.shade400,
                                  fontFamily: utils.fontFamily,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 16,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    );
                  },
                ),
              ),
              setting_item(icon: Iconsax.profile_tick_copy, title: lang_en.profile, subtitle: lang_en.profileSubtitle,
                callback: ()=>Get.to(()=>profileScreen(),transition: Transition.rightToLeft),),
              setting_item(icon: Iconsax.profile_2user_copy, title: lang_en.inviteFriends, subtitle: lang_en.inviteFriendsSubtitle,callback: (){},),
              setting_item(icon: Iconsax.lock_1_copy, title: lang_en.privacypolicy, subtitle: lang_en.privacySubtitle,callback: (){}),
              setting_item(icon: Iconsax.info_circle_copy, title: lang_en.help, subtitle: lang_en.helpSubtitle,callback: (){},),
              // setting_item(icon: Iconsax.verify_copy, title: lang_en.about, subtitle: lang_en.aboutSubtitle,callback: (){},),
              setting_item(icon: Iconsax.logout_copy, title: lang_en.logout, subtitle: lang_en.areyousurelogout,callback: (){
                showDialog(context: context, builder: (context) => customDialog(callback: (){authServices().firebaseLogout(context: context);}));
              },),
              SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}

