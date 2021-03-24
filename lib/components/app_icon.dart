import 'package:flutter/material.dart';
import 'package:unicons/unicons.dart';

class AppIcon extends StatelessWidget {
  final Function onTap;
  final EdgeInsetsGeometry padding;
  final double size;

  AppIcon({
    this.onTap,
    this.padding = EdgeInsets.zero,
    this.size = 50.0,
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
          child: Icon(
            UniconsLine.lightbulb_alt,
            size: size,
          ),
        ),
      ),
    );
  }
}
