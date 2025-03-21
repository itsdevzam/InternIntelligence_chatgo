import 'package:chatgo/utils/utils.dart';
import 'package:flutter/material.dart';


class custom_back_appbar extends StatelessWidget {
  String title;
  custom_back_appbar({super.key,required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 40.0,left: 10,right: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(onPressed: (){Navigator.pop(context);}, icon: Icon(Icons.arrow_back_rounded,color: Colors.white,)),
          Text(
            title,
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white,fontSize: 22),
          ),
          SizedBox(height: 10,width: 40,)
        ],
      ),
    );
  }
}
