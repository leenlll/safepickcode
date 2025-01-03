import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // For exiting the app
import 'package:safepick/database_helper.dart';
import 'package:safepick/screens/auth/sign_in_screen.dart';
import 'package:safepick/screens/auth/sign_up_screen.dart';
import 'package:safepick/screens/parent_child_info_screen.dart';
import 'package:safepick/screens/view_profile_screen.dart';
import 'package:safepick/screens/notification_screen.dart';
import 'package:safepick/screens/reset_password_screen.dart';
import 'package:safepick/screens/faq_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Ensure Flutter is ready before anything async

  // Test database connection
  bool dbConnected = false;
  try {
    await DatabaseHelper().connect(); // Connect to the database
    dbConnected = true;
    print('✅ Database connected successfully!');
  } catch (e) {
    print('❌ Database connection failed: $e');
  }

  runApp(SafePickApp(dbConnected: dbConnected)); // Pass the connection status
}

class SafePickApp extends StatelessWidget {
  final bool dbConnected;

  SafePickApp({required this.dbConnected});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SafePick',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: dbConnected
          ? SignInScreen() // Navigate to SignInScreen if DB is connected
          : SplashScreen(dbConnected: dbConnected), // Show SplashScreen if DB isn't connected
      routes: {
        '/signIn': (context) => SignInScreen(),
        '/signUp': (context) => SignUpScreen(),
        '/parentChildInfo': (context) => ParentChildInfoScreen(),
        '/notifications': (context) => NotificationScreen(),
        '/viewProfile': (context) => ViewProfileScreen(), // Define the ViewProfile route
        '/faq': (context) => FAQScreen(), // Add the FAQ route
      },
      onGenerateRoute: (settings) {
        // Handle dynamic routes
        if (settings.name == '/resetPassword') {
          final args = settings.arguments as Map<String, String>?;
          if (args != null && args.containsKey('email')) {
            final email = args['email']!;
            return MaterialPageRoute(
              builder: (context) => ResetPasswordScreen(email: email), // Pass email to ResetPasswordScreen
            );
          }
          return MaterialPageRoute(
            builder: (context) => Scaffold(
              appBar: AppBar(title: Text('Error')),
              body: Center(
                child: Text(
                  'Missing or invalid arguments for Reset Password',
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ),
          );
        }
        return null; // Return null for unhandled routes
      },
    );
  }
}

class SplashScreen extends StatefulWidget {
  final bool dbConnected;

  SplashScreen({required this.dbConnected});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateToNextScreen();
  }

  // Navigate after a short delay to give the splash screen a moment
  Future<void> _navigateToNextScreen() async {
    await Future.delayed(Duration(seconds: 2)); // Display splash screen for 2 seconds
    if (widget.dbConnected) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => SignInScreen()), // Use pushReplacement to replace splash screen
      );
    } else {
      _showDatabaseErrorDialog();
    }
  }

  // Show dialog if DB connection fails
  void _showDatabaseErrorDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Database Connection Failed'),
          content: Text('Could not connect to the database. Please check your connection and try again.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                // Exit the app if the DB connection fails
                SystemNavigator.pop();
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFDF7FE),
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}

class FAQScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('FAQ'),
        backgroundColor: Color(0xFFEED4FA),
        foregroundColor: Colors.black,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            ListTile(
              title: Text('How do I sign up as a parent?'),
              subtitle: Text(
                'To sign up as a parent, you will need to create an account by providing your email address and creating a password. After signing in, you can add information about your child(ren) to start managing their details.',
              ),
            ),
            ListTile(
              title: Text('How can I view my child\'s information?'),
              subtitle: Text(
                'Once logged in, you can view your child\'s details such as their name, grade, and class under the "Parent & Child Info" section. You can select a specific child to see their individual details.',
              ),
            ),
            ListTile(
              title: Text('How can I add my child to the system?'),
              subtitle: Text(
                'During the sign-up process or through the "Parent & Child Info" section, you can add your child\'s name and grade. This will create a profile for each child associated with your account.',
              ),
            ),
            ListTile(
              title: Text('Can I view my child’s grade history?'),
              subtitle: Text(
                'Currently, you can view the child\'s grade during the process of selecting them in the app. Future versions of the app may include detailed grade history for each child.',
              ),
            ),
            ListTile(
              title: Text('How do I navigate between screens?'),
              subtitle: Text(
                'Use the navigation menu at the top right of the screen to move between sections like "Parent & Child Info," "Notifications," and "View Profile." You can also use the bottom navigation bar for quick access to key areas.',
              ),
            ),
            ListTile(
              title: Text('Can I log out of the app?'),
              subtitle: Text(
                'Yes, you can log out from the app by navigating to the settings menu and selecting "Log Out."',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
