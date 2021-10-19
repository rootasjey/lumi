import 'package:flutter/material.dart';
import 'package:unicons/unicons.dart';
import 'package:simple_animations/simple_animations.dart';
import 'package:supercharged/supercharged.dart';

class AppIcon extends StatelessWidget {
  final Function onTap;
  final EdgeInsetsGeometry padding;
  final double size;

  AppIcon({
    this.onTap,
    this.padding = EdgeInsets.zero,
    this.size = 32.0,
  });

  @override
  Widget build(BuildContext context) {
    return MirrorAnimation<Color>(
      tween: ColorTween(begin: Colors.blue, end: Colors.amber),
      duration: 2.seconds,
      builder: (context, child, value) {
        return Padding(
          padding: padding,
          child: IconButton(
            onPressed: onTap,
            iconSize: size,
            color: value,
            icon: Icon(UniconsLine.lightbulb_alt),
          ),
        );
      },
    );
  }
}
