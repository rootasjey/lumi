import 'package:flutter/material.dart';

class LoadingAnimation extends StatelessWidget {
  final TextStyle style;
  final String textTitle;
  final Widget title;
  final double size;

  LoadingAnimation({
    this.size = 100.0,
    this.style = const TextStyle(fontSize: 20.0,),
    this.textTitle = 'Loading...',
    this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text('R'),

        title != null ?
          title :
          Padding(
            padding: const EdgeInsets.only(top: 40.0),
            child: Text(
              textTitle,
              textAlign: TextAlign.center,
              style: style
            ),
          ),
      ],
    );
  }
}
