import 'package:flutter/material.dart';
import 'package:safepick/database_helper.dart';

class ParentChildInfoScreen extends StatefulWidget {
  @override
  _ParentChildInfoScreenState createState() => _ParentChildInfoScreenState();
}

class _ParentChildInfoScreenState extends State<ParentChildInfoScreen> {
  String? parentName; // Parent's name
  String? selectedChild; // Selected child
  String? selectedChildGrade; // Grade of selected child
  List<Map<String, String>> children = []; // List of children
  final TextEditingController parentNameController = TextEditingController();
  final TextEditingController classController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchParentChildData();
  }

  // Fetch parent and child data from the database
  Future<void> _fetchParentChildData() async {
    try {
      String userEmail = 'user@example.com'; // Replace with actual logged-in user's email
      var parentData = await DatabaseHelper().getParentData(userEmail);

      if (parentData != null) {
        setState(() {
          parentName = parentData['name'];
          parentNameController.text = parentData['name']; // Display parent's name
          children = List<Map<String, String>>.from(parentData['children']);
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('An error occurred while fetching data.')),
      );
    }
  }

  // Navigate to the notifications screen
  Future<void> _continueToNextScreen() async {
    String childName = selectedChild ?? "No child selected"; // Use a placeholder if no child is selected
    Navigator.pushNamed(
      context,
      '/notifications',
      arguments: childName, // Pass the selected or placeholder child to the notifications screen
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFDF7FE),
      appBar: AppBar(
        title: Text('Parent & Child Info'),
        backgroundColor: Color(0xFFEED4FA),
        foregroundColor: Colors.black,
        actions: [
          // "View Profile" Button
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: ElevatedButton.icon(
              onPressed: () {
                // Navigate to View Profile Screen
                Navigator.pushNamed(context, '/viewProfile');
              },
              icon: Icon(Icons.person, size: 24),
              label: Text('Profile', style: TextStyle(fontSize: 16)),
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFFEED4FA),
                foregroundColor: Colors.black,
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
          ),
          // "FAQ" Button
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: ElevatedButton.icon(
              onPressed: () {
                // Navigate to FAQ Screen
                Navigator.pushNamed(context, '/faq');
              },
              icon: Icon(Icons.help_outline, size: 24),
              label: Text('FAQ', style: TextStyle(fontSize: 16)),
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFFEED4FA),
                foregroundColor: Colors.black,
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (parentName != null) // Display parent's name if available
                Text(
                  'Welcome, $parentName!',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              SizedBox(height: 20),
              TextField(
                controller: parentNameController,
                decoration: InputDecoration(
                  labelText: 'Parent Name',
                  border: OutlineInputBorder(),
                ),
                readOnly: true, // Parent's name is displayed, not editable
              ),
              SizedBox(height: 10),
              DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  labelText: 'Child Name',
                  border: OutlineInputBorder(),
                ),
                value: selectedChild,
                items: children.map((child) {
                  return DropdownMenuItem<String>(
                    value: child['studentName'],
                    child: Text(child['studentName']!),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    selectedChild = value;
                    selectedChildGrade = null; // Clear the grade when a new child is selected
                  });
                },
              ),
              SizedBox(height: 10),
              if (selectedChild != null && selectedChildGrade != null)
                Text(
                  'Grade: $selectedChildGrade',
                  style: TextStyle(fontSize: 16),
                ),
              SizedBox(height: 10),
              TextField(
                controller: classController,
                decoration: InputDecoration(
                  labelText: 'Class',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 20),
              Center(
                child: ElevatedButton(
                  onPressed: _continueToNextScreen, // Proceed to the next screen
                  child: Text('Continue'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFFEED4FA),
                    foregroundColor: Colors.black,
                  ),
                ),
              ),
              SizedBox(height: 20),
              Text(
                'Added Children:',
                style: TextStyle(fontSize: 16),
              ),
              Column(
                children: children.map((child) {
                  int index = children.indexOf(child);
                  return Row(
                    children: [
                      Text('${child['studentName']} - Grade: ${child['grade']}'),
                      IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () => setState(() => children.removeAt(index)),
                      ),
                    ],
                  );
                }).toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
