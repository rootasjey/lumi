import 'package:flutter/material.dart';

class AppIcon extends StatelessWidget {
  final Function onTap;
  final EdgeInsetsGeometry padding;
  final double size;

  AppIcon({
    this.onTap,
    this.padding = EdgeInsets.zero,
    this.size = 40.0,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: Material(
        shape: RoundedRectangleBorder(),
        clipBehavior: Clip.hardEdge,
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          child: Image.asset(
            'assets/images/app_icon/128.png',
            width: size,
            height: size,
          ),
        ),
      ),
    );
  }
}
