import 'package:flutter/material.dart';
import 'package:multi_window/multi_window.dart';

class StatusWindowScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Get the data passed to the new window
    final arguments = MultiWindow.arguments;
    final String statusMessage = arguments['status'] ?? 'No status provided';

    return Scaffold(
      appBar: AppBar(
        title: Text('Status Window'),
      ),
      body: Center(
        child: Text(
          statusMessage,
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
