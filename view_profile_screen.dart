import 'package:flutter/material.dart';
import 'package:safepick/database_helper.dart';

class ViewProfileScreen extends StatefulWidget {
  @override
  _ViewProfileScreenState createState() => _ViewProfileScreenState();
}

class _ViewProfileScreenState extends State<ViewProfileScreen> {
  Map<String, dynamic>? profileData;
  bool isLoading = true; // Track whether data is still loading
  bool hasError = false; // Track whether an error occurred

  @override
  void initState() {
    super.initState();
    _fetchProfileData();
  }

  // Fetch the profile data (parent and children) from the database
  Future<void> _fetchProfileData() async {
    try {
      // Assuming you have the parent's email stored or passed from the previous screen
      String email = 'user@example.com'; // Replace this with the actual user's email

      // Fetch data from the database
      var data = await DatabaseHelper().getParentData(email);
      setState(() {
        profileData = data;
        isLoading = false; // Data loading complete
      });
    } catch (e) {
      print('Error fetching profile data: $e');
      setState(() {
        hasError = true; // Mark that an error occurred
        isLoading = false; // Stop loading
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFDF7FE),
      appBar: AppBar(
        title: Text('Profile'),
        backgroundColor: Color(0xFFEED4FA),
        foregroundColor: Colors.black,
        actions: [
          // Reset Password Button in the AppBar
          IconButton(
            icon: Icon(Icons.lock_reset, size: 28),
            tooltip: 'Reset Password',
            onPressed: () {
              Navigator.pushNamed(context, '/resetPassword');
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Display a loading spinner while data is being fetched
            if (isLoading)
              Center(child: CircularProgressIndicator()),

            // Display an error message if data fetch fails
            if (!isLoading && hasError)
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.error, color: Colors.red, size: 60),
                    SizedBox(height: 10),
                    Text(
                      'Failed to load profile data',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
                    ),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: _fetchProfileData,
                      child: Text('Retry'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFFE7C6FF),
                        foregroundColor: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),

            // Display profile data if loaded successfully
            if (!isLoading && !hasError && profileData != null) ...[
              // Parent information
              Text(
                'Parent Name: ${profileData!['name']}',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              Text('Email: ${profileData!['email']}'),
              SizedBox(height: 10),
              Text('Phone: ${profileData!['phone']}'),
              SizedBox(height: 20),

              // Children information
              Text('Children:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              SizedBox(height: 10),
              if (profileData!['children'] != null && profileData!['children'].isNotEmpty)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: (profileData!['children'] as List).map((child) {
                    return Text('${child['child_name']} - Grade: ${child['class']}');
                  }).toList(),
                )
              else
                Text('No children data available'),
              SizedBox(height: 30),
            ],
          ],
        ),
      ),
    );
  }
}
