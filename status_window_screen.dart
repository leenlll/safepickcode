import 'package:flutter/material.dart';

class StatusWindowScreen extends StatelessWidget {
  // Accept a status message as a parameter
  final String? statusMessage;

  StatusWindowScreen({this.statusMessage});

  // List of children's names and their statuses for the dashboard
  final List<Map<String, String>> childrenStatuses = [
    {'name': 'mohammad', 'status': 'On Time'},
    {'name': 'sara', 'status': 'Arrived'},
    {'name': 'leen', 'status': 'Late'},
    {'name': 'rama', 'status': 'On Time'},
    {'name': 'ahmad', 'status': 'Arrived'},
    {'name': 'dana', 'status': 'Late'},
    {'name': 'karam', 'status': 'On Time'},
  ];

  @override
  Widget build(BuildContext context) {
    // If a statusMessage is provided, update the first child's status
    if (statusMessage != null) {
      childrenStatuses[0]['status'] = statusMessage!; // Updating Emma's status
    }

    return Scaffold(
      backgroundColor: Color(0xFFFDF7FE), 
      appBar: AppBar(
        title: Text(
          'Children Status Dashboard',
          style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.deepPurple,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Status Overview:',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: childrenStatuses.length,
                itemBuilder: (context, index) {
                  final child = childrenStatuses[index];
                  return Card(
                    color: _getStatusColor(child['status']!),
                    child: ListTile(
                      title: Text(
                        child['name']!,
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      trailing: Text(
                        child['status']!,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper function to determine the card color based on the status
  Color _getStatusColor(String status) {
    switch (status) {
      case 'On Time':
        return Colors.green;
      case 'Arrived':
        return Colors.blue;
      case 'Late':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
}
