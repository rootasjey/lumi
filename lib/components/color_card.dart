import 'package:flutter/material.dart';
import 'package:supercharged/supercharged.dart';

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

class _ColorCardState extends State<ColorCard> with TickerProviderStateMixin {
  Animation<double> _scaleAnimation;
  AnimationController _scaleAnimationController;

  double _elevation = 4.0;

  @override
  initState() {
    super.initState();

    _scaleAnimationController = AnimationController(
      lowerBound: 0.8,
      upperBound: 1.0,
      duration: 250.milliseconds,
      vsync: this,
    );

    _scaleAnimation = CurvedAnimation(
      parent: _scaleAnimationController,
      curve: Curves.fastOutSlowIn,
    );
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _scaleAnimation,
      child: SizedBox(
        width: 100.0,
        height: 100.0,
        child: Card(
          elevation: _elevation,
          color: widget.color,
          child: InkWell(
            onTap: widget.onTap,
            onHover: (isHover) {
              if (isHover) {
                _scaleAnimationController.forward();
                setState(() => _elevation = 8.0);
                return;
              }

              _scaleAnimationController.reverse();
              setState(() => _elevation = 4.0);
            },
          ),
        ),
      ),
    );
  }
}
