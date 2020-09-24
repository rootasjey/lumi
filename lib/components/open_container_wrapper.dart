import 'package:animations/animations.dart';
import 'package:flutter/material.dart';

class OpenContainerWrapper extends StatelessWidget {
  const OpenContainerWrapper({
    @required this.closedBuilder,
    this.transitionType,
    this.onClosed,
    @required this.openBuilder,
    this.tappable = true,
  });

  final OpenContainerBuilder closedBuilder;
  final ContainerTransitionType transitionType;
  final ClosedCallback<bool> onClosed;
  final OpenContainerBuilder openBuilder;
  final bool tappable;

  @override
  Widget build(BuildContext context) {
    return OpenContainer<bool>(
      transitionType: transitionType,
      openBuilder: openBuilder,
      // openBuilder: (BuildContext context, VoidCallback _) {
      //   return const DetailsPage();
      // },
      onClosed: onClosed,
      tappable: tappable,
      closedBuilder: closedBuilder,
    );
  }
}
