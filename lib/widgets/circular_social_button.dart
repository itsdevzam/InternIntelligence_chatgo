import 'package:chatgo/utils/colors.dart';
import 'package:flutter/material.dart';

class circular_social_button extends StatelessWidget {
  VoidCallback  onTap;
  String iconPath;
  circular_social_button({super.key,required this.onTap,required this.iconPath});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.all(Radius.circular(50)),
      onTap:onTap,
      child: Container(
        width: 60,
        height: 60,
        decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.fromBorderSide(BorderSide(width: 1.5,color: colors.greyColor,))
        ),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Image.asset(iconPath,),
        ),
      ),
    );
  }
}
