import 'package:chatgo/helper/showToast.dart';
import 'package:chatgo/provider/chatProvider.dart';
import 'package:chatgo/screens/profile/chatProfile.dart';
import 'package:chatgo/utils/colors.dart';
import 'package:chatgo/utils/lang_en.dart';
import 'package:chatgo/utils/utils.dart';
import 'package:chatgo/widgets/chatReciver.dart';
import 'package:chatgo/widgets/chatSender.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:provider/provider.dart';

class chatScreen extends StatelessWidget {
  String receiverusername, receivername, receiverprofilepic, receiverUID;

  chatScreen(
      {super.key,
      required this.receiverusername,
      required this.receivername,
      required this.receiverprofilepic,
      required this.receiverUID});

  final TextEditingController _messageController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Padding(
        padding: const EdgeInsets.only(top: 50.0),
        child: Consumer<chatProvider>(
          builder: (context, value, child) {
            value.getSharedPref();
            if (value.chatSharedPref['username'] == null) {
              return Center(child: CircularProgressIndicator());
            }
            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 0.0),
                  child: _customAppbar(
                    name: receivername,
                    profileImg: receiverprofilepic,
                    uid: receiverUID,
                    username: receiverusername,
                  ),
                ),
                Divider(),
                StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection('chats')
                      .doc(
                        value.generateChatID(
                          receiverusername,
                          value.chatSharedPref['username'],
                        ),
                      )
                      .collection('messages')
                      .orderBy('timeStamp', descending: true)
                      .snapshots(includeMetadataChanges: false),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting &&
                        !snapshot.hasData) {
                      return Expanded(
                          child: Center(
                              child:
                                  CircularProgressIndicator())); // 🔄 Show loading indicator while fetching data
                    }

                    if (snapshot.hasError) {
                      return Center(
                        child: Text(
                          "Error: ${snapshot.error}",
                          style: TextStyle(color: Colors.white),
                        ),
                      ); // ❌ Show error message if stream fails
                    }

                    if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                      return Expanded(
                          child: Center(
                              child: Text(
                        "Start Chating with $receivername",
                        style: TextStyle(color: Colors.white),
                      ))); // ℹ️ Show message when no data is available
                    }

                    if (snapshot.hasData) {
                      // 🔥 Mark all unread messages as read
                      Future.microtask(() {
                        for (var doc in snapshot.data!.docs) {
                          if (doc['receiverId'] ==
                                  value.chatSharedPref['username'] &&
                              doc['read'] == false) {
                            FirebaseFirestore.instance
                                .collection('chats')
                                .doc(value.generateChatID(receiverusername,
                                    value.chatSharedPref['username']))
                                .collection('messages')
                                .doc(doc.id)
                                .update({'read': true});
                          }
                        }
                      });

                      QuerySnapshot querySnapshot =
                          snapshot.data as QuerySnapshot;
                      List<Map<String, dynamic>> userMessges =
                          querySnapshot.docs.map((doc) {
                        return doc.data() as Map<String, dynamic>;
                      }).toList();
                      return Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 0.0),
                          child: ListView.builder(
                            reverse: true,
                            shrinkWrap: true,
                            itemBuilder: (context, index) {
                              if (value.chatSharedPref['username'] ==
                                  userMessges[index]['senderId']) {
                                return chatSender(
                                  sender: userMessges[index]['message'],
                                  time: utils.formatTimestamp(
                                      userMessges[index]['timeStamp']),
                                  isread: userMessges[index]['read'],
                                );
                              } else {
                                //receiver
                                return chatReceiver(
                                  receiver: userMessges[index]['message'],
                                  time: utils.formatTimestamp(
                                      userMessges[index]['timeStamp']),
                                );
                              }
                            },
                            itemCount: querySnapshot.docs.length,
                          ),
                        ),
                      );
                    }
                    return CircularProgressIndicator(
                      color: Colors.white,
                    );
                  },
                ),
                SendTextField(
                  mycontroller: _messageController,
                  username: receiverusername,
                  uid: receiverUID,
                  profilepic: receiverprofilepic,
                  name: receivername,
                ),
              ],
            );
          },
        ),
      ),
      backgroundColor: colors.backgroundColor,
    );
  }
}

class SendTextField extends StatefulWidget {
  final TextEditingController mycontroller;
  final String username, uid, profilepic, name;

  SendTextField({
    super.key,
    required this.mycontroller,
    required this.username,
    required this.uid,
    required this.profilepic,
    required this.name,
  });

  @override
  _SendTextFieldState createState() => _SendTextFieldState();
}

class _SendTextFieldState extends State<SendTextField> {
  bool isEmojiVisible = false;
  FocusNode textFocusNode = FocusNode(); // FocusNode for detecting TextField focus

  @override
  void initState() {
    super.initState();

    // Add a listener to hide emoji picker when the TextField gets focus
    textFocusNode.addListener(() {
      if (textFocusNode.hasFocus) {
        setState(() {
          isEmojiVisible = false; // Hide emoji picker when keyboard opens
        });
      }
    });
  }

  @override
  void dispose() {
    textFocusNode.dispose(); // Clean up the FocusNode
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final sendMessage = Provider.of<chatProvider>(context, listen: false);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Text Field Row
        Container(
          color: colors.backgroundColor,
          height: 70,
          width: utils.getDeviceWidth(context),
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: SizedBox(
                  height: 55,
                  width: utils.getDeviceWidth(context) - 80,
                  child: TextField(
                    focusNode: textFocusNode, // Assign the FocusNode
                    cursorColor: Colors.white,
                    textAlignVertical: TextAlignVertical.center,
                    controller: widget.mycontroller,
                    style: TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      hintText: lang_en.searchFiledHint,
                      hintStyle: TextStyle(color: Colors.grey),
                      border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      prefixIcon: GestureDetector(
                        onTap: () {
                          setState(() {
                            isEmojiVisible = !isEmojiVisible;
                          });

                          if (isEmojiVisible) {
                            // Hide keyboard when opening emoji picker
                            FocusScope.of(context).unfocus();
                          } else {
                            // Show keyboard when emoji picker is closed
                            textFocusNode.requestFocus();
                          }
                        },
                        child: Icon(Icons.emoji_emotions_rounded, color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  try {
                    if(widget.mycontroller.text.isNotEmpty){
                      sendMessage.sendMessage(
                        receiverName: widget.name,
                        message: widget.mycontroller.text,
                        receiverUsername: widget.username,
                        senderId: sendMessage.chatSharedPref['username'],
                        timeStamp: FieldValue.serverTimestamp(),
                        receiverUID: widget.uid,
                        receiverProfilePic: widget.profilepic,
                      );
                    }else{
                      showToast.show( context, "Write message...");
                      // utils.showToast(context: context, msg: "Write message...");
                    }
                  } catch (e) {
                    utils.customPrint(e);
                  }
                  widget.mycontroller.clear();
                },
                child: Container(
                  margin: EdgeInsets.only(right: 10),
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Iconsax.send_1_copy, color: colors.primaryColor),
                ),
              ),
            ],
          ),
        ),

        // Emoji Picker (Shows Below the TextField)
        if (isEmojiVisible)
          SizedBox(
            height: 256,
            child: EmojiPicker(
              textEditingController: widget.mycontroller,
              config: Config(
                height: 256,
                checkPlatformCompatibility: true,
                emojiViewConfig: EmojiViewConfig(emojiSizeMax: 28),
                viewOrderConfig: const ViewOrderConfig(
                  top: EmojiPickerItem.categoryBar,
                  middle: EmojiPickerItem.emojiView,
                  bottom: EmojiPickerItem.searchBar,
                ),
                skinToneConfig: const SkinToneConfig(),
                categoryViewConfig: const CategoryViewConfig(),
                bottomActionBarConfig: const BottomActionBarConfig(),
                searchViewConfig: const SearchViewConfig(),
              ),
            ),
          ),
      ],
    );
  }
}



class _customAppbar extends StatelessWidget {
  String profileImg, name, uid, username;

  _customAppbar(
      {super.key,
      required this.profileImg,
      required this.name,
      required this.uid,
      required this.username});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        ///Leading
        SizedBox(
          width: 50,
          height: 50,
          child: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(Icons.arrow_back, color: Colors.white, size: 25),
          ),
        ),
        GestureDetector(
          onTap: () => openProfile(name, username, profileImg),
          child: Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: Colors.black.withValues(alpha: 0.7),
              shape: BoxShape.circle,
              border: Border.all(width: 1.5, color: Colors.white),
            ),
            child: Padding(
              padding: EdgeInsets.all(5),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(100),
                child: FadeInImage.assetNetwork(
                  placeholder: 'assets/logos/splash_logo.png',
                  image: profileImg,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
        ),
        SizedBox(width: 10),
        GestureDetector(
          onTap: () => openProfile(name, username, profileImg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name ?? lang_en.dummyName,
                style: TextStyle(
                  color: Colors.white,
                  fontFamily: utils.fontFamily,
                  fontWeight: FontWeight.w500,
                  fontSize: 16,
                ),
              ),
              SizedBox(
                child: StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection("users")
                      .doc(uid)
                      .snapshots(includeMetadataChanges: false),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting &&
                        !snapshot.hasData) {
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
                    if (snapshot.hasData) {
                      var status = snapshot.data?.data();
                      return SizedBox(
                        width: 140,
                        child: Text(
                          utils.formatTimestamp(status!['status']),
                          style: TextStyle(
                            color: Colors.grey.shade300,
                            fontFamily: utils.fontFamily,
                            fontWeight: FontWeight.w500,
                            fontSize: 14,
                            overflow: TextOverflow.ellipsis,
                          ),
                          softWrap: true,
                          maxLines: 2,
                          textAlign: TextAlign.start,
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
              ),
            ],
          ),
        ),
        Spacer(),

        ///action
        Padding(
          padding: const EdgeInsets.only(right: 8.0),
          child: Row(
            children: [
              IconButton(
                onPressed: () {},
                icon: Icon(Icons.call, color: Colors.white, size: 25),
              ),
              IconButton(
                onPressed: () {},
                icon: Icon(Iconsax.video, color: Colors.white, size: 25),
              ),
            ],
          ),
        ),
      ],
    );
  }

  void openProfile(String name, String username, String image) {
    Get.to(
        () => chatProfile(
              image: image,
              name: name,
              username: username,
            ),
        transition: Transition.rightToLeft);
  }
}
