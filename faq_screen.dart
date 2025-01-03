import 'package:flutter/material.dart';

class FAQScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFDF7FE),  // Soft background color
      appBar: AppBar(
        title: Text('FAQ'),
        backgroundColor: Color(0xFFEED4FA),
        foregroundColor: Colors.black,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildFAQItem(
                question: '1. How do I sign up as a parent?',
                answer:
                    'To sign up as a parent, you will need to create an account by providing your email address and creating a password. After signing in, you can add information about your child(ren) to start managing their details.',
              ),
              SizedBox(height: 16),
              _buildFAQItem(
                question: '2. How can I view my child\'s information?',
                answer:
                    'Once logged in, you can view your child\'s details such as their name, grade, and class under the "Parent & Child Info" section. You can select a specific child to see their individual details.',
              ),
              SizedBox(height: 16),
              _buildFAQItem(
                question: '3. How can I add my child to the system?',
                answer:
                    'During the sign-up process or through the "Parent & Child Info" section, you can add your child\'s name and grade. This will create a profile for each child associated with your account.',
              ),
              SizedBox(height: 16),
              _buildFAQItem(
                question: '4. Can I view my child’s grade history?',
                answer:
                    'Currently, you can view the child\'s grade during the process of selecting them in the app. Future versions of the app may include detailed grade history for each child.',
              ),
              SizedBox(height: 16),
              _buildFAQItem(
                question: '5. How do I navigate between screens?',
                answer:
                    'Use the navigation menu at the top right of the screen to move between sections like "Parent & Child Info," "Notifications," and "View Profile." You can also use the bottom navigation bar for quick access to key areas.',
              ),
              SizedBox(height: 16),
              _buildFAQItem(
                question: '6. Can I log out of the app?',
                answer:
                    'Yes, you can log out by navigating to the settings or profile section, where you will find the log-out option.',
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Helper method to build individual FAQ items
  Widget _buildFAQItem({required String question, required String answer}) {
    return Container(
      decoration: BoxDecoration(
        color: Color(0xFFEED4FA),  // Light purple background for each FAQ item
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 2,
            blurRadius: 5,
            offset: Offset(0, 3), // Shadow position
          ),
        ],
      ),
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            question,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          SizedBox(height: 8),
          Text(
            answer,
            style: TextStyle(
              fontSize: 16,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }
}
