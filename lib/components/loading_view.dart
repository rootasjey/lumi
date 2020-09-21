import 'package:flutter/material.dart';

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
          CircularProgressIndicator(),

          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Opacity(
              opacity: 0.6,
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 25.0,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
