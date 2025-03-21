import 'package:chatgo/helper/sharedPref.dart';
import 'package:chatgo/provider/profileProvider.dart';
import 'package:chatgo/utils/colors.dart';
import 'package:chatgo/utils/lang_en.dart';
import 'package:chatgo/utils/utils.dart';
import 'package:chatgo/widgets/custom_back_appbar.dart';
import 'package:chatgo/widgets/profile_item.dart';
import 'package:chatgo/widgets/setting_item.dart';
import 'package:flutter/material.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:provider/provider.dart';

class chatProfile extends StatelessWidget {
  String name,image,username;
  chatProfile({super.key,required this.name,required this.image,required this.username});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colors.primaryColor,
      appBar: PreferredSize(preferredSize: Size(utils.getDeviceWidth(context), 50),child: custom_back_appbar(title: lang_en.profile,)),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.7),
                    shape: BoxShape.circle,
                    border: Border.all(width: 1.5, color: Colors.white),
                  ),
                  child: ClipRRect(borderRadius: BorderRadius.circular(100),child:FadeInImage.assetNetwork(fit: BoxFit.cover,
                    placeholder: "assets/logos/splash_logo.png", image: image,)),
                ),
                SizedBox(height: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      name,
                      style: TextStyle(
                        color: Colors.white,
                        fontFamily: utils.fontFamily,
                        fontWeight: FontWeight.w500,
                        fontSize: 22,
                      ),
                    ),
                    SizedBox(
                      child: Text(
                        username,
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
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  spacing: 20,
                  children: [
                    IconButton(
                      onPressed: () {

                      },
                      icon: Icon(
                        Iconsax.message,
                        color: Colors.white,
                        size: 30,
                      ),
                    ),
                    IconButton(
                      onPressed: () {},
                      icon: Icon(Icons.call, color: Colors.white, size: 30),
                    ),
                    IconButton(
                      onPressed: () {},
                      icon: Icon(Iconsax.video, color: Colors.white, size: 30),
                    ),
                  ],
                ),
                SizedBox(height: 10),
              ],
            ),
          ),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: colors.backgroundColor,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(50),
                  topRight: Radius.circular(50),
                ),
              ),
              width: double.maxFinite,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(height: 10),
                    profile_item(title: lang_en.displayName, subtitle: name),
                    profile_item(title: lang_en.username, subtitle: username),
                    // profile_item(title: lang_en.email, subtitle: value.ProfileuserData['email']??lang_en.dummyEmail),
                    SizedBox(height: 30),
                  ],
                ),
              ),
            ),
          ),
        ],
      )
    );
  }
}
