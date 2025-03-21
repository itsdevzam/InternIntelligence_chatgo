import 'package:chatgo/provider/homeProvider.dart';
import 'package:chatgo/screens/chat/chatScreen.dart';
import 'package:chatgo/screens/profile/chatProfile.dart';
import 'package:chatgo/screens/profile/profileScreen.dart';
import 'package:chatgo/utils/colors.dart';
import 'package:chatgo/utils/lang_en.dart';
import 'package:chatgo/utils/utils.dart';
import 'package:chatgo/widgets/statusItem.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:provider/provider.dart';

class homeScreen extends StatelessWidget {
  homeScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colors.primaryColor,
      body: Padding(
        padding: const EdgeInsets.only(top: 50.0),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: customAppbar(),
            ),
            SizedBox(height: 30),
            // statusView(),
            SizedBox(height: 10),
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
                width: double.infinity,
                child: ClipRRect(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(50),
                    topRight: Radius.circular(50),
                  ),
                  child: Consumer<homeProvider>(
                    builder: (context, value, child) {
                      value.getSharedPref();
                      if(value.homeSharedPref['username']==null){
                        return Center(child: CircularProgressIndicator());
                      }
                      String currentUsername = value.homeSharedPref['username'];
                      return StreamBuilder(
                          stream: FirebaseFirestore.instance.collection("chats").where("users",arrayContains: currentUsername).snapshots(includeMetadataChanges: false),
                          builder: (context, snapshot) {
                            if(snapshot.connectionState == ConnectionState.waiting && !snapshot.hasData){
                              return Center(child: CircularProgressIndicator());
                            }
                            if(snapshot.hasError){
                              return Center(child: Text("Error: ${snapshot.error}",style: TextStyle(color: Colors.white),),);
                            }
                            if(!snapshot.hasData || snapshot.data!.docs.isEmpty){
                              return Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Center(
                                    child: Text("Start Chating with someone",
                                      style: TextStyle(color: Colors.white,fontFamily: utils.fontFamily,fontSize: 16)
                                    ,textAlign: TextAlign.center,),),
                                  SizedBox(height: 10,),
                                  Icon(Iconsax.message_add_1,color: Colors.white,size: 35,),
                                  TextButton(onPressed: (){
                                    Navigator.pushNamed(context, "search");
                                  }, child: Text("Search Now",
                                    style: TextStyle(color: Colors.white,fontFamily: utils.fontFamily,fontSize: 16),),),
                                ],
                              );
                            }
                            return ListView.builder(
                                padding: EdgeInsets.only(top: 10),
                                physics: BouncingScrollPhysics(),
                                itemBuilder: (context, index) {
                                  var data = snapshot.data!.docs;
                                  List<Map<String,dynamic>> chatData = data.map((e){
                                    var chat = e.data();
                                    String currentUserUID = value.homeSharedPref['uid'];
                                    bool isCurrentUserSender = chat['receiverUID'] != currentUserUID;
                                    return {
                                      'receiverUID': isCurrentUserSender ? chat['receiverUID'] : chat['senderUID'],
                                      'receiverProfilePic': isCurrentUserSender ? chat['receiverProfilePic'] : chat['senderProfilePic'],
                                      'receiverName': isCurrentUserSender ? chat['receiverName'] : chat['senderName'],
                                      'receiverUsername': isCurrentUserSender ? chat['receiverUsername'] : chat['senderUsername'],
                                    };
                                  }).toList();
                                  return GestureDetector(
                                    onTap: ()=> Get.to(()=>chatScreen(receiverUID: chatData[index]['receiverUID'],
                                    receiverprofilepic: chatData[index]['receiverProfilePic'],receivername: chatData[index]['receiverName'],
                                    receiverusername: chatData[index]['receiverUsername'],),transition: Transition.rightToLeft),
                                    child: Container(
                                      margin: EdgeInsets.only(top:  8,bottom: 8,right: 20,left: 20),
                                      decoration: BoxDecoration(
                                        color: colors.primaryColor,
                                        shape: BoxShape.rectangle,
                                        borderRadius: BorderRadius.circular(20)
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(7),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            GestureDetector(
                                              onTap:(){
                                                Get.to(()=>chatProfile(
                                                  image: chatData[index]['receiverProfilePic'],
                                                  name: chatData[index]['receiverName'],
                                                  username: chatData[index]['receiverUsername'],
                                                ),transition: Transition.rightToLeft);
                                              },
                                              child: Container(
                                                width: 60,
                                                height: 60,
                                                decoration: BoxDecoration(
                                                  color: Colors.black.withValues(alpha: 0.7),
                                                  shape: BoxShape.circle,
                                                  border: Border.all(
                                                    width: 1.5,
                                                    color: colors.primaryColor,
                                                  ),
                                                ),
                                                child: Padding(
                                                  padding: EdgeInsets.all(5),
                                                  child: ClipRRect(borderRadius: BorderRadius.circular(50),child: Image.network(chatData[index]['receiverProfilePic'],height: 50,width: 50,)),
                                                ),
                                              ),
                                            ),
                                            SizedBox(width: 10,),
                                            Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  chatData[index]['receiverName']??lang_en.dummyName,
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontFamily: utils.fontFamily,
                                                    fontWeight: FontWeight.w500,
                                                    fontSize: 16,
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: 120,
                                                  child: StreamBuilder(
                                                    stream: FirebaseFirestore.instance
                                                        .collection("chats")
                                                        .doc(value.generateChatID(chatData[index]['receiverUsername'], value.homeSharedPref['username']))
                                                        .collection("messages")
                                                        .orderBy("timeStamp", descending: true)
                                                        .snapshots(includeMetadataChanges: false),
                                                    builder: (context, snapshot) {
                                                      if (snapshot.connectionState == ConnectionState.waiting && !snapshot.hasData) {
                                                        return Text(
                                                          "Loading...",
                                                          style: TextStyle(
                                                            color: Colors.grey.shade300,
                                                            fontFamily: utils.fontFamily,
                                                            fontWeight: FontWeight.w500,
                                                            fontSize: 14,
                                                            overflow: TextOverflow.ellipsis,
                                                          ),
                                                        );
                                                      }

                                                      if (snapshot.hasError) {
                                                        return Text(
                                                          "Something went wrong...",
                                                          style: TextStyle(
                                                            color: Colors.grey.shade300,
                                                            fontFamily: utils.fontFamily,
                                                            fontWeight: FontWeight.w500,
                                                            fontSize: 14,
                                                            overflow: TextOverflow.ellipsis,
                                                          ),
                                                        );
                                                      }

                                                      if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                                                        return Text(
                                                          "No messages yet...",
                                                          style: TextStyle(
                                                            color: Colors.grey.shade300,
                                                            fontFamily: utils.fontFamily,
                                                            fontWeight: FontWeight.w500,
                                                            fontSize: 14,
                                                            overflow: TextOverflow.ellipsis,
                                                          ),
                                                        );
                                                      }

                                                      var lastMessage = snapshot.data!.docs.first.data();
                                                      return Text(
                                                        lastMessage["message"],
                                                        style: TextStyle(
                                                          color: Colors.grey.shade300,
                                                          fontFamily: utils.fontFamily,
                                                          fontWeight: FontWeight.w500,
                                                          fontSize: 14,
                                                          overflow: TextOverflow.ellipsis,
                                                        ),
                                                      );
                                                    },
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Spacer(),

                                            Column(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              children: [
                                                // StreamBuilder(
                                                //   stream: FirebaseFirestore.instance
                                                //       .collection('chats')
                                                //       .doc(chatData[index]['chatId']) // Ensure chatId is correct
                                                //       .collection('messages')
                                                //       .where('receiverId', isEqualTo: currentUsername)
                                                //       .where('read', isEqualTo: false)
                                                //       .snapshots(includeMetadataChanges: false),
                                                //   builder: (context, snapshot) {
                                                //     if (snapshot.connectionState == ConnectionState.waiting && !snapshot.hasData) {
                                                //       Text(
                                                //        "Loading",
                                                //         style: TextStyle(
                                                //           color: colors.primaryColor,
                                                //           fontSize: 12,
                                                //           fontWeight: FontWeight.bold,
                                                //         ),
                                                //       );
                                                //     }
                                                //     int unreadCount = 0;
                                                //     if (snapshot.hasData) {
                                                //       unreadCount = snapshot.data!.docs.length;
                                                //     }
                                                //
                                                //     return unreadCount > 0 ? CircleAvatar(
                                                //       radius: 12,
                                                //       backgroundColor: Colors.white,
                                                //       child: Text(
                                                //         unreadCount.toString(),
                                                //         style: TextStyle(
                                                //           color: colors.primaryColor,
                                                //           fontSize: 12,
                                                //           fontWeight: FontWeight.bold,
                                                //         ),
                                                //       ),
                                                //     ) : SizedBox(); // Hide if no unread messages
                                                //   },
                                                // ),
                                                SizedBox(height: 5,),
                                                StreamBuilder(
                                                    stream: FirebaseFirestore.instance.collection("users").doc(chatData[index]['receiverUID']).snapshots(includeMetadataChanges: false),
                                                    builder: (context, snapshot) {
                                                      if (snapshot.connectionState == ConnectionState.waiting && !snapshot.hasData) {
                                                        return Text(
                                                          "Loading...",
                                                          style: TextStyle(
                                                            color: Colors.grey.shade300,
                                                            fontFamily: utils.fontFamily,
                                                            fontWeight: FontWeight.w500,
                                                            fontSize: 14,
                                                            overflow: TextOverflow.ellipsis,
                                                          ),
                                                        );
                                                      }

                                                      if (snapshot.hasError) {
                                                        return Text(
                                                          "Something went wrong...",
                                                          style: TextStyle(
                                                            color: Colors.grey.shade300,
                                                            fontFamily: utils.fontFamily,
                                                            fontWeight: FontWeight.w500,
                                                            fontSize: 14,
                                                            overflow: TextOverflow.ellipsis,
                                                          ),
                                                        );
                                                      }
                                                      if(snapshot.hasData) {
                                                        var status = snapshot.data?.data();
                                                        return SizedBox(
                                                          width: 70,
                                                          child: Text(
                                                          status!['status']=="online"?"online":"offline",
                                                          style: TextStyle(
                                                            color: status!['status']=="online"?Colors.limeAccent:Colors.white,
                                                            fontFamily: utils.fontFamily,
                                                            fontWeight: FontWeight.w500,
                                                            fontSize: 14,
                                                            overflow: TextOverflow.ellipsis,
                                                          ),
                                                            softWrap: true,
                                                            maxLines: 2,
                                                            textAlign: TextAlign.center,
                                                          ),
                                                        );
                                                      }
                                                      return Text(
                                                        "Loading...",
                                                        style: TextStyle(
                                                          color: Colors.grey.shade300,
                                                          fontFamily: utils.fontFamily,
                                                          fontWeight: FontWeight.w500,
                                                          fontSize: 14,
                                                          overflow: TextOverflow.ellipsis,
                                                        ),
                                                      );
                                                    },
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              itemCount: snapshot.data!.docs.length,
                            );
                          },
                      );
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class customAppbar extends StatelessWidget {
  const customAppbar({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        ///Leading
        Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(width: 1.5, color: colors.greyColor),
          ),
          child: IconButton(
            onPressed: () {
              Navigator.pushNamed(context, "settings");
            },
            icon: Icon(Iconsax.setting_2, color: Colors.white, size: 25),
          ),
        ),

        ///Title
        Text(
          lang_en.home,
          style: TextStyle(
            color: Colors.white,
            fontFamily: utils.fontFamily,
            fontWeight: FontWeight.w500,
            fontSize: 24,
          ),
        ),

        ///action
        Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(width: 1.5, color: colors.greyColor),
          ),
          child: IconButton(
            onPressed: () {
              Navigator.pushNamed(context, "search");
            },
            icon: Icon(
              Iconsax.search_normal_1_copy,
              color: Colors.white,
              size: 25,
            ),
          ),
        ),
      ],
    );
  }
}

class statusView extends StatelessWidget {
  const statusView({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      width: double.infinity,
      height: 110,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        shrinkWrap: true,
        itemBuilder: (context, index) {
          if (index == 0) {
            return statusItem(name: 0, isStatus: true);
          } else {
            return statusItem(name: index - 1);
          }
        },
        itemCount: 9,
      ),
    );
  }
}
