import 'package:flutter/material.dart';

class custom_text_field extends StatelessWidget {
  TextEditingController textEditingController;
  String labelText,hintText;
  bool? isobscure;
  custom_text_field({super.key,required this.textEditingController,required this.labelText,required this.hintText,this.isobscure=false});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25.0),
      child: TextField(
        obscureText: isobscure!,
        controller: textEditingController,
        style: TextStyle(color: Colors.white),
        decoration: InputDecoration(
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(7)),
            labelText: labelText,
            hintText: hintText,
        ),
      ),
    );
  }
}
