import 'package:chatgo/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';


class setting_item extends StatelessWidget {
  IconData icon;
  String title,subtitle;
  VoidCallback callback;
  setting_item({super.key,required this.icon,required this.title,required this.subtitle,required this.callback});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 20,top: 20,right: 20),
      decoration: BoxDecoration(
          color: colors.primaryColor,
          borderRadius: BorderRadius.circular(20)
      ),
      child: ListTile(
        onTap: callback,
        leading: Icon(icon,color: Colors.white,size: 30,),
        title: Text(title,style: TextStyle(color: Colors.white,fontSize: 18,fontFamily: 'Caros',fontWeight: FontWeight.w700),),
        subtitle: Text(subtitle,style: TextStyle(color: Colors.white,fontSize: 14,fontFamily: 'Caros'),),
      ),
    );
  }
}
