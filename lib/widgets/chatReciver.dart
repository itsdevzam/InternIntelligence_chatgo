import 'package:chatgo/utils/utils.dart';
import 'package:flutter/material.dart';

class chatReceiver extends StatelessWidget {
  String receiver,time;
  chatReceiver({super.key,required this.receiver,required this.time});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 15.0,top: 10),
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: utils.getDeviceWidth(context)-100),
            child: IntrinsicWidth(
              child: Container(
                alignment: Alignment.centerLeft,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(topRight: Radius.circular(20),bottomRight: Radius.circular(20),bottomLeft: Radius.circular(20))
                ),
                child: Padding(
                  padding: const EdgeInsets.only(top: 10.0,bottom: 5 , left: 20 ,right: 20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(bottom: 5.0),
                        child: Text( receiver ?? "No message",softWrap: true,style: TextStyle(color: Colors.black,fontSize: 16),),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text( time ?? "No message",softWrap: true,style: TextStyle(color: Colors.black,fontSize: 12),),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
