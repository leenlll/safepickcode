import 'package:flutter/material.dart';
import 'package:safepick/database_helper.dart';

class SignInScreen extends StatefulWidget {
  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFDF7FE),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/safepicklogotrans.png', height: 400, width: 400),
            SizedBox(height: 20),
            TextField(
              controller: emailController,
              decoration: InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 10),
            TextField(
              obscureText: true,
              controller: passwordController,
              decoration: InputDecoration(
                labelText: 'Password',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                if (emailController.text.isEmpty || passwordController.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Please enter both email and password')),
                  );
                  return;
                }

                try {
                  var user = await DatabaseHelper().signIn(
                    emailController.text,
                    passwordController.text,
                  );

                  if (user != null) {
                    // Navigate to the next page if credentials are valid
                    Navigator.pushNamed(context, '/parentChildInfo');
                  } else {
                    // Show a warning but still navigate to the next page
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Invalid credentials. Proceeding anyway.')),
                    );

                    // Navigate to the next page even if the credentials are invalid
                    Navigator.pushNamed(context, '/parentChildInfo');
                  }
                } catch (e) {
                  // Handle specific errors but still navigate to the next page
                  if (e.toString().contains('socket') || e.toString().contains('Bad state')) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Network error: Proceeding anyway.')),
                    );
                  } else if (e.toString().contains('Timeout')) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Request timed out. Proceeding anyway.')),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Error: $e. Proceeding anyway.')),
                    );
                  }

                  // Navigate to the next page despite the error
                  Navigator.pushNamed(context, '/parentChildInfo');
                }
              },
              child: Text('Sign In'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFFEED4FA),
                foregroundColor: Colors.black,
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.pushNamed(context, '/signUp');
              },
              style: TextButton.styleFrom(foregroundColor: Colors.black),
              child: Text('Don\'t have an account? Sign Up'),
            ),
          ],
        ),
      ),
    );
  }
}
