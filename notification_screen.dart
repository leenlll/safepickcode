import 'package:flutter/material.dart';

class NotificationScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Retrieve the child name passed as an argument from the previous screen
    final String? childName = ModalRoute.of(context)?.settings.arguments as String?;

    // Handle the case where no child name is provided
    if (childName == null) {
      return Scaffold(
        backgroundColor: Color(0xFFFDF7FE),
        appBar: AppBar(
          title: Text('Notifications'),
          backgroundColor: Color(0xFFEED4FA),
          foregroundColor: Colors.black,
        ),
        body: Center(
          child: Text(
            "Child name not found!",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Color(0xFFFDF7FE),
      appBar: AppBar(
        title: Text('$childName - Notifications'),
        backgroundColor: Color(0xFFEED4FA),
        foregroundColor: Colors.black,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Notification instructions
            Text(
              'Please choose the current status for $childName:',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),

            // "On the Way" Button
            ElevatedButton(
              onPressed: () {
                // Navigate to StatusScreen with "On the Way" message
                _navigateToStatusScreen(context, '$childName is on the way.');
              },
              child: Text('On the Way'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                foregroundColor: Colors.white,
                minimumSize: Size(double.infinity, 60),
              ),
            ),
            SizedBox(height: 20),

            // "Arrived" Button
            ElevatedButton(
              onPressed: () {
                // Navigate to StatusScreen with "Arrived" message
                _navigateToStatusScreen(context, '$childName has arrived.');
              },
              child: Text('Arrived'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
                minimumSize: Size(double.infinity, 60),
              ),
            ),
            SizedBox(height: 20),

            // "Late" Button
            ElevatedButton(
              onPressed: () {
                // Navigate to StatusScreen with "Late" message
                _navigateToStatusScreen(context, '$childName is late.');
              },
              child: Text('Late'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent,
                foregroundColor: Colors.white,
                minimumSize: Size(double.infinity, 60),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Method to navigate to the StatusScreen
  void _navigateToStatusScreen(BuildContext context, String status) {
    Navigator.pushNamed(
      context,
      '/StatusWindowScreen', // Make sure this route is defined in your MaterialApp
      arguments: status, // Pass the status message as an argument
    );
  }
}
