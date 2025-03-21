import 'package:chatgo/utils/colors.dart';
import 'package:chatgo/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

class chatSender extends StatelessWidget {
  String sender, time;
  bool isread;

  chatSender(
      {super.key,
      required this.sender,
      required this.time,
      required this.isread});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Padding(
          padding: const EdgeInsets.only(right: 15.0, top: 10),
          child: ConstrainedBox(
            constraints:
                BoxConstraints(maxWidth: utils.getDeviceWidth(context) - 80),
            child: IntrinsicWidth(
              child: Container(
                alignment: Alignment.centerLeft,
                decoration: BoxDecoration(
                    color: colors.primaryColor,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20),
                        bottomRight: Radius.circular(20),
                        bottomLeft: Radius.circular(20))),
                child: Padding(
                  padding: const EdgeInsets.only(
                      top: 10.0, bottom: 5, left: 20, right: 20),
                  child: Column(

                    children: [
                      Padding(
                        padding: const EdgeInsets.only(bottom: 5.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            ConstrainedBox(
                              constraints: BoxConstraints(
                                maxWidth: utils.getDeviceWidth(context)-150,
                              ),

                                child: IntrinsicWidth(
                                    child: Text(
                                  sender ?? "No message",
                                  softWrap: true,
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 18),
                                ))),
                            SizedBox(
                              width: 5,
                            ),
                            isread
                                ? Icon(
                                    Iconsax.tick_circle,
                                    color: Colors.greenAccent,
                                    size: 20,
                                  )
                                : Icon(
                                    Iconsax.tick_circle_copy,
                                    color: Colors.white,
                                    size: 18,
                                  ),
                          ],
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            time ?? "No message",
                            softWrap: true,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                            ),
                            textAlign: TextAlign.right,
                          ),
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
    ;
  }
}
