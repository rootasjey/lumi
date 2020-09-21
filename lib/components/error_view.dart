import 'package:flutter/material.dart';

class ErrorView extends StatelessWidget {
  final String title;
  final VoidCallback retry;

  ErrorView({
    this.title = "There was an issue",
    this.retry,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(60.0),
      child: Column(
        children: [
          Icon(
            Icons.warning,
            size: 60.0,
          ),

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

          IconButton(
            icon: Icon(
              Icons.refresh,
            ),
            onPressed: retry,
          ),
        ],
      ),
    );
  }
}
