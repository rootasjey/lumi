import 'package:flutter/material.dart';
import 'package:lumi/components/loading_animation.dart';

class FullPageLoading extends StatelessWidget {
  final String title;

  FullPageLoading({
    this.title = 'Loading...',
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      child: LoadingAnimation(textTitle: title),
    );
  }
}
