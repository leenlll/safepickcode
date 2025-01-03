import 'package:flutter/material.dart';
import 'package:safepick/database_helper.dart';

class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController studentNameController = TextEditingController();
  final TextEditingController gradeController = TextEditingController();

  final List<Map<String, String>> children = [];

  void _addChild() {
    if (studentNameController.text.isNotEmpty && gradeController.text.isNotEmpty) {
      setState(() {
        children.add({
          'studentName': studentNameController.text,
          'grade': gradeController.text,
        });
      });
      studentNameController.clear();
      gradeController.clear();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please enter both child\'s name and grade')),
      );
    }
  }

  Future<void> _signUp() async {
    if (nameController.text.isEmpty ||
        emailController.text.isEmpty ||
        passwordController.text.isEmpty ||
        phoneController.text.isEmpty ||
        children.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please fill in all fields and add at least one child')),
      );
      return;
    }

    try {
      await DatabaseHelper().signUp(
        nameController.text,
        emailController.text,
        passwordController.text,
        phoneController.text,
        children,
      );

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Sign-up successful! Please log in.')),
      );
      Navigator.pushNamed(context, '/signIn');
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFDF7FE),
      appBar: AppBar(
        title: Text('Sign Up'),
        backgroundColor: Color(0xFFEED4FA),
        foregroundColor: Colors.black,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Image.asset('assets/safepicklogotrans.png', height: 300, width: 300),
              SizedBox(height: 20),
              TextField(
                controller: nameController,
                decoration: InputDecoration(labelText: 'Name', border: OutlineInputBorder()),
              ),
              SizedBox(height: 10),
              TextField(
                controller: emailController,
                decoration: InputDecoration(labelText: 'Email', border: OutlineInputBorder()),
              ),
              SizedBox(height: 10),
              TextField(
                obscureText: true,
                controller: passwordController,
                decoration: InputDecoration(labelText: 'Password', border: OutlineInputBorder()),
              ),
              SizedBox(height: 10),
              TextField(
                controller: phoneController,
                decoration: InputDecoration(labelText: 'Phone Number', border: OutlineInputBorder()),
              ),
              SizedBox(height: 10),
              TextField(
                controller: studentNameController,
                decoration: InputDecoration(labelText: 'Child\'s Name', border: OutlineInputBorder()),
              ),
              SizedBox(height: 10),
              TextField(
                controller: gradeController,
                decoration: InputDecoration(labelText: 'Grade', border: OutlineInputBorder()),
              ),
              SizedBox(height: 10),
              ElevatedButton(
                onPressed: _addChild,
                child: Text('Add Child'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFFE7C6FF),
                  foregroundColor: Colors.black,
                ),
              ),
              SizedBox(height: 20),
              if (children.isNotEmpty)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: children
                      .map((child) => Text('${child['studentName']} - Grade: ${child['grade']}'))
                      .toList(),
                ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _signUp,
                child: Text('Sign Up'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFFE7C6FF),
                  foregroundColor: Colors.black,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}