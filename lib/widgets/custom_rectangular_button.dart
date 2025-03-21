import 'package:flutter/material.dart';

class custom_rectangular_button extends StatelessWidget {
  String text;
  VoidCallback onTap;
  Color bgcolor,textcolor;
  custom_rectangular_button({super.key,required this.text,required this.onTap,required this.bgcolor,required this.textcolor});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40.0),
        child: Container(
          decoration: BoxDecoration(
            color: bgcolor,
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
          alignment: Alignment.center,
          height: 55,
          child: Text(text,style: TextStyle(fontSize: 18,color: textcolor),),
        ),
      ),
    );
  }
}
