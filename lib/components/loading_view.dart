import 'package:flutter/material.dart';
import 'package:lumi/components/loading_animation.dart';

class LoadingView extends StatelessWidget {
  final String title;

  LoadingView({
    this.title = 'Loading...',
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(60.0),
      child: Column(
        children: [
          LoadingAnimation(
            textTitle: title,
          ),
        ],
      ),
    );
  }
}
