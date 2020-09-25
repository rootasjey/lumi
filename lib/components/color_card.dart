import 'package:flutter/material.dart';

class ColorCard extends StatefulWidget {
  final Color color;
  final VoidCallback onTap;

  ColorCard({
    @required this.color,
    this.onTap,
  });

  @override
  _ColorCardState createState() => _ColorCardState();
}

class _ColorCardState extends State<ColorCard> {
  double elevation = 4.0;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 100.0,
      height: 100.0,
      child: Card(
        elevation: elevation,
        color: widget.color,
        child: InkWell(
          onTap: widget.onTap,
          onHover: (isHover) {
            setState(() {
              elevation = isHover
                ? 8.0
                : 4.0;
            });
          },
        ),
      ),
    );
  }
}
