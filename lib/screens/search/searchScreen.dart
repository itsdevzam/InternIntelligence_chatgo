import 'package:chatgo/provider/searchProvider.dart';
import 'package:chatgo/screens/chat/chatScreen.dart';
import 'package:chatgo/services/searhUser.dart';
import 'package:chatgo/utils/colors.dart';
import 'package:chatgo/utils/lang_en.dart';
import 'package:chatgo/utils/utils.dart';
import 'package:chatgo/widgets/custom_back_appbar.dart';
import 'package:chatgo/widgets/rectangular_animated_btn.dart';
import 'package:chatgo/widgets/search_text_field.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';

class searchScreen extends StatefulWidget {
   searchScreen({super.key});
  @override
  State<searchScreen> createState() => _searchScreenState();
}

class _searchScreenState extends State<searchScreen> {
final TextEditingController searchController = TextEditingController();
List<Map<String,dynamic>> searchUserData = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: colors.primaryColor,
      appBar:  PreferredSize(preferredSize: Size(utils.getDeviceWidth(context), 50),child: custom_back_appbar(title: lang_en.search,)),
      body: Consumer<searchProvider>(
        builder: (context, value, child) {
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 20.0,bottom: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: utils.getDeviceWidth(context)-150,
                      child: search_text_field(seacrhController: searchController),
                    ),
                    SizedBox(width: 10,),
                    GestureDetector(
                      onTap: ()async{
                        value.setLoading(true);
                        searchUserData=await searhUser().searchUsersByPrefix(searchController.text);
                        utils.customPrint(await searhUser().searchUsersByPrefix(searchController.text));
                        value.setLoading(false);
                      },
                      child: Container(
                        alignment: Alignment.center,
                        height: 50,
                        width: 80,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10)
                        ),
                        child: value.isloading?LoadingAnimationWidget.staggeredDotsWave(color: colors.primaryColor, size: 30,):Text(lang_en.search,style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold,),),
                      ),
                    )
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
                  alignment: Alignment.center,
                  width: double.maxFinite,
                  child: value.isloading?LoadingAnimationWidget.progressiveDots(color: colors.primaryColor, size: 50,)
                      :searchController.text.isEmpty?searchUsername():ClipRRect(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(50),
                      topRight: Radius.circular(50),
                    ),
                    child: searchUserData.isEmpty?userNotFound():ListView.builder(
                      itemBuilder: (context, index) {
                        String currentUserUid = FirebaseAuth.instance.currentUser!.uid;
                        return GestureDetector(
                          onTap: (){
                            if(currentUserUid==searchUserData[index]['uid']){
                              Get.offNamed("/profile");
                            }else{
                              Get.off(()=>chatScreen(receivername: searchUserData[index]['name'],
                                receiverusername: searchUserData[index]['username'],
                                receiverprofilepic: searchUserData[index]['profileImage'],
                                receiverUID: searchUserData[index]['uid'],),transition: Transition.rightToLeft);
                            }
                          },
                          child: Container(
                            margin: EdgeInsets.only(left: 20,right: 20,top: 25,),
                            decoration: BoxDecoration(
                                color: colors.primaryColor,
                                borderRadius: BorderRadius.circular(20)
                            ),
                            padding: const EdgeInsets.all(15.0),
                            child: Row(
                              children: [
                                ClipRRect(borderRadius: BorderRadius.circular(50),child: Image.network(searchUserData[index]['profileImage'],height: 50,width: 50,)),
                                SizedBox(width: 15,),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(searchUserData[index]['name'],style: TextStyle(color: Colors.white,fontFamily: utils.fontFamily,fontSize: 18),),
                                    Text(searchUserData[index]['username'],style: TextStyle(color: Colors.white,fontFamily: utils.fontFamily,fontSize: 14),),
                                  ],
                                ),
                                Spacer(),
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                                  child: Icon(Iconsax.arrow_circle_right,color: Colors.white,size: 33,),
                                )
                              ],
                            ),
                          ),
                        );
                      },itemCount: searchUserData.length,),
                  ),

                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class userNotFound extends StatelessWidget {
  userNotFound({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Iconsax.personalcard,color: Colors.white,size: 50,),
        SizedBox(height: 5,),
        Text(lang_en.userNotFound,style: TextStyle(color: Colors.white,fontFamily: utils.fontFamily,fontSize: 18),),
      ],
    );
  }
}

class searchUsername extends StatelessWidget {
  searchUsername({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Iconsax.search_normal_1_copy,color: Colors.white,size: 50,),
        SizedBox(height: 15,),
        Text(lang_en.searchHint,style: TextStyle(color: Colors.white,fontFamily: utils.fontFamily,fontSize: 18),),
      ],
    );
  }
}
