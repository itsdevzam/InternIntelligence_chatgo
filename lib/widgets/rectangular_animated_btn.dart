import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class rectangular_animated_btn extends StatelessWidget {
  Color bgcolor,animationColor;
   rectangular_animated_btn({super.key,required this.bgcolor,required this.animationColor});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40.0),
      child: Container(
        decoration: BoxDecoration(
          color: bgcolor,
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
        alignment: Alignment.center,
        height: 55,
        child: LoadingAnimationWidget.staggeredDotsWave(
          color: animationColor,
          size: 30,
        ),
      ),
    );
  }
}