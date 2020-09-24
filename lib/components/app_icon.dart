import 'package:flutter/material.dart';

class AppIcon extends StatefulWidget {
  final Function onTap;
  final EdgeInsetsGeometry padding;
  final double size;

  AppIcon({
    this.onTap,
    this.padding = const EdgeInsets.symmetric(vertical: 80.0),
    this.size = 60.0,
  });

  @override
  _AppIconState createState() => _AppIconState();
}

class _AppIconState extends State<AppIcon> {
  Color foreground;
  // ReactionDisposer colorDisposer;

  // @override
  // initState() {
  //   super.initState();

  //   // colorDisposer = autorun((reaction) {
  //   //   setState(() => foreground = stateColors.foreground);
  //   // });
  // }

  // @override
  // void dispose() {
  //   if (colorDisposer != null) {
  //     colorDisposer();
  //   }

  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: widget.padding,
      child: Material(
        shape: RoundedRectangleBorder(),
        clipBehavior: Clip.hardEdge,
        color: Colors.transparent,
        child: InkWell(
          onTap: widget.onTap
            ?? () {},
          // onHover: (isHover) {
          //   isHover
          //     ? setState(() => foreground = stateColors.primary)
          //     : setState(() => foreground = stateColors.foreground);
          // },
          child: Icon(
            Icons.lightbulb_outline,
            size: 50.0,
          )
        ),
      ),
    );
  }
}
