import 'package:chatgo/utils/colors.dart';
import 'package:chatgo/utils/lang_en.dart';
import 'package:chatgo/utils/utils.dart';
import 'package:flutter/material.dart';

class customDialog extends StatelessWidget {
  VoidCallback callback;
  customDialog({super.key,required this.callback});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.transparent,
      title: Container(
        decoration: BoxDecoration(
          color: colors.backgroundColor,
          borderRadius: BorderRadius.circular(20)
        ),
        width: utils.getDeviceWidth(context),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: Column(
            children: [
              SizedBox(height: 20,),
              Text(lang_en.areyousure_logout,style: TextStyle(color: Colors.white,fontSize: 16),),
              SizedBox(height: 20,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(onPressed: callback, child: Text("YES",style: TextStyle(color: Colors.black),),),
                  ElevatedButton(onPressed: (){Navigator.pop(context);},
                      style: ElevatedButton.styleFrom(backgroundColor: colors.primaryColor),
                      child: Text("NO",style: TextStyle(color: Colors.white),)),
                ],
              ),
              SizedBox(height: 20,),
            ],
          ),
        ),
      ),
    );
  }
}
