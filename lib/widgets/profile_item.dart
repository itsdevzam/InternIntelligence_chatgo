import 'package:chatgo/utils/colors.dart' show colors;
import 'package:flutter/material.dart';

class profile_item extends StatelessWidget {
  String title,subtitle;
  profile_item({super.key,required this.title,required this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 20,top: 20,right: 20),
      decoration: BoxDecoration(
          color: colors.primaryColor,
          borderRadius: BorderRadius.circular(20)
      ),
      child: ListTile(
        onTap: (){},
        title: Text(title,style: TextStyle(color: Colors.white,fontSize: 14,fontFamily: 'Caros',),),
        subtitle: Text(subtitle,style: TextStyle(color: Colors.white,fontSize: 18,fontFamily: 'Caros',fontWeight: FontWeight.w700),),
      ),
    );
  }
}
