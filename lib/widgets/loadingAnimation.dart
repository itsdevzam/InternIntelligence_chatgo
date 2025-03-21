import 'package:chatgo/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class loadingAnimation extends StatelessWidget {
  const loadingAnimation({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      width: 60,
      height: 60,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.fromBorderSide(
          BorderSide(
            width: 1.5,
            color: colors.greyColor,
          ),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: LoadingAnimationWidget.discreteCircle(color: Colors.white, size: 30,),
      ),
    ) ;
  }
}
