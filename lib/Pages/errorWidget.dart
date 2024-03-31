import 'package:flutter/material.dart';

class CustomErrorWidget extends StatelessWidget {
  final String? errorMessage;
  final VoidCallback onRetry;

  CustomErrorWidget({
    required this.errorMessage,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("$errorMessage"),
          ElevatedButton(
            onPressed: onRetry,
            child: Text('Retry'),
          ),
        ],
      ),
    );
  }
}
