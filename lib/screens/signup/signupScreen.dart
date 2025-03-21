import 'dart:io';
import 'package:chatgo/helper/auth/signupHelper.dart';
import 'package:chatgo/helper/imagePickerHelper.dart';
import 'package:chatgo/provider/signupProvider.dart';
import 'package:chatgo/utils/colors.dart';
import 'package:chatgo/utils/lang_en.dart';
import 'package:chatgo/utils/utils.dart';
import 'package:chatgo/widgets/custom_back_appbar.dart';
import 'package:chatgo/widgets/rectangular_animated_btn.dart';
import 'package:chatgo/widgets/custom_rectangular_button.dart';
import 'package:chatgo/widgets/custom_text_field.dart';
import 'package:chatgo/widgets/signup_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class signupScreen extends StatelessWidget {
  signupScreen({super.key});

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passController = TextEditingController();
  final TextEditingController _confirmpassController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  // final TextEditingController _usernameController = TextEditingController();
  String? _imgPath;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size(utils.getDeviceWidth(context), 50),
        child: custom_back_appbar(title: ""),
      ),
      resizeToAvoidBottomInset: true,
      backgroundColor: colors.backgroundColor,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 30),
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
                    lang_en.signup_text,
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
              lang_en.sigiUpSubtitile,
              style: TextStyle(
                color: Colors.white,
                fontFamily: utils.fontFamily,
                fontSize: 16,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),

            ///select image container
            Consumer<signupProvider>(
              builder: (context, value, child) {
                return GestureDetector(
                  onTap: () {
                    showModalBottomSheet(
                      backgroundColor: colors.backgroundColor,
                      context: context,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(20),
                        ),
                      ),
                      builder: (context) {
                        return signup_bottom_sheet(
                          CameraonTap: () async {
                            _imgPath = await imagePickerHelper().pickImage(
                              ImageSource.camera,
                            );
                            if (_imgPath != null) {
                              value.isImgNull = false;
                            }
                            Navigator.pop(context);
                          },
                          GalleryonTap: () async {
                            _imgPath = await imagePickerHelper().pickImage(
                              ImageSource.gallery,
                            );
                            if (_imgPath != null) {
                              value.isImgNull = false;
                            }
                            Navigator.pop(context);
                          },
                        );
                      },
                    );
                  },
                  child:
                      value.isImgNull ? Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: colors.primaryColor, // Use your colors.primaryColor
                            ),
                            height: 120,
                            width: 120,
                            child: Icon(
                              Icons.add_a_photo_rounded,
                              color: Colors.white,
                              size: 30,
                            ),
                          )
                          : SizedBox(),
                );
              },
            ),

            ///delete image container
            Consumer<signupProvider>(
              builder: (context, value, child) {
                return value.isImgNull == false
                    ? Container(
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color:
                            colors.primaryColor, // Use your colors.primaryColor
                      ),
                      height: 120,
                      width: 120,
                      child: Stack(
                        children: [
                          Positioned(
                            left: 0,
                            right: 0,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(100),
                              child: Image.file(
                                File(_imgPath.toString()),
                                fit: BoxFit.cover,
                                height: 120,
                                width: 120,
                              ),
                            ),
                          ),
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: IconButton(
                              onPressed: () {
                                value.isImgNull = true;
                                _imgPath=null;
                              },
                              icon: Icon(
                                Icons.delete,
                                color: Colors.white,
                                size: 30,
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                    : SizedBox();
              },
            ),

            SizedBox(height: 30),
            custom_text_field(
              textEditingController: _nameController,
              labelText: lang_en.name,
              hintText: lang_en.nameHint,
            ),
            // SizedBox(height: 30),
            // custom_text_field(
            //   textEditingController: _usernameController,
            //   labelText: lang_en.username,
            //   hintText: lang_en.usernamehint,
            // ),
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
            custom_text_field(
              textEditingController: _confirmpassController,
              labelText: lang_en.confirmpassword,
              hintText: lang_en.passwordHint,
              isobscure: true,
            ),
            SizedBox(height: 50),
            // signup Buttton
            Consumer<signupProvider>(
              builder: (context, value, child) {
                return value.isloading==false?custom_rectangular_button(
                  text: lang_en.signup,
                  bgcolor: colors.primaryColor,
                  textcolor: Colors.white,
                  onTap: () {
                    signupHelper(
                      name: _nameController.text,
                      email: _emailController.text,
                      password: _passController.text,
                      confirmpassword: _confirmpassController.text,
                      imgFile: _imgPath!=null?File(_imgPath!):null,
                      context: context,
                    );
                  },
                ):rectangular_animated_btn(bgcolor: colors.primaryColor, animationColor: Colors.white);
              },
            ),
            SizedBox(height: 50),
          ],
        ),
      ),
    );
  }

}
