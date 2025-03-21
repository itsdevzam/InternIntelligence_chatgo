import 'package:chatgo/utils/lang_en.dart';
import 'package:flutter/material.dart';

class search_text_field extends StatelessWidget {
  TextEditingController seacrhController;
  search_text_field({super.key,required this.seacrhController});

  @override
  Widget build(BuildContext context) {
    return TextField(
      cursorColor: Colors.white,
      textAlignVertical:  TextAlignVertical.center,
      controller: seacrhController,
      style: TextStyle(color: Colors.white),
      decoration: InputDecoration(
          hintText: lang_en.searchHint,
          hintStyle: TextStyle(color: Colors.grey),
          errorBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.white),
            borderRadius: BorderRadius.circular(10),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.white),
            borderRadius: BorderRadius.circular(10),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.white),
            borderRadius: BorderRadius.circular(10),
          ),
          disabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.white),
            borderRadius: BorderRadius.circular(10),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.white),
            borderRadius: BorderRadius.circular(10),
          ),
          border: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.white),
            borderRadius: BorderRadius.circular(10),
          ),
          focusColor: Colors.white
        // suffix: Container(
        //   margin: EdgeInsets.only(top: 10),
        //   child: Icon(Icons.attach_file,),
        // )
      ),
    );
  }
}
