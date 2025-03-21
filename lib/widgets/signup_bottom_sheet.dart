import 'package:chatgo/helper/imagePickerHelper.dart';
import 'package:chatgo/utils/lang_en.dart';
import 'package:flutter/material.dart';

class signup_bottom_sheet extends StatelessWidget {
  VoidCallback CameraonTap,GalleryonTap;
   signup_bottom_sheet({super.key,required this.GalleryonTap,required this.CameraonTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      height: 200, // Adjust height as needed
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            lang_en.select_img_src,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 16),
          ListTile(
            leading: Icon(Icons.camera, color: Colors.white),
            title: Text(
              lang_en.camer,
              style: TextStyle(color: Colors.white),
            ),
            onTap: CameraonTap,
          ),
          ListTile(
            leading: Icon(
              Icons.photo_library,
              color: Colors.white,
            ),
            title: Text(
              lang_en.gallery,
              style: TextStyle(color: Colors.white),
            ),
            onTap: GalleryonTap,
          ),
        ],
      ),
    );
  }
}
