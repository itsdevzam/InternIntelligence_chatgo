import 'package:chatgo/utils/colors.dart';
import 'package:chatgo/utils/utils.dart';
import 'package:flutter/material.dart';

class statusItem extends StatelessWidget {
  int name;
  bool? isStatus;

  statusItem({super.key, required this.name, this.isStatus=false});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 90,
      padding: const EdgeInsets.symmetric(horizontal: 5.0),
      child: Column(
        children: [
          Container(
            width: 65,
            height: 65,
            decoration: BoxDecoration(
              color: Colors.black.withValues(alpha: 0.7),
              shape: BoxShape.circle,
              border: Border.all(width: 1.5, color: Colors.white),
            ),
            child: Padding(
              padding: EdgeInsets.all(5),
              child: Image.asset('assets/images/profile.png'),
            ),
          ),
          SizedBox(height: 5),
          isStatus!
              ? Text(
                "My Status",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  fontFamily: utils.fontFamily,
                  overflow: TextOverflow.ellipsis,
                ),
              )
              : Text(
                "Status ${name+1}",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  fontFamily: utils.fontFamily,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
        ],
      ),
    );
  }
}
