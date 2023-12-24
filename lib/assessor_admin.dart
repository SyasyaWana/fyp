import 'package:flutter/material.dart';
import 'package:systemfyp/assessor_student_list.dart';
import 'package:firebase_database/firebase_database.dart';

class AssessorAdmin extends StatefulWidget {
  const AssessorAdmin({super.key});

  @override
  State<AssessorAdmin> createState() => _AssessorAdminState();
}

class _AssessorAdminState extends State<AssessorAdmin> {

  final DatabaseReference _databaseReference = FirebaseDatabase.instance.reference().child('assessors');

  List<Map<String, String>> assessors = [];

  int counter = 1; // Initialize the counter variable here

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final TextEditingController _assessorNameController = TextEditingController();

  void _openAddAssessorForm() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
            ),
            child: _buildAddAssessorForm()
        );
      },
    );
  }

  void _openEditAssessorForm(Map<String, String> assessor) {
    _assessorNameController.text = assessor['Assessor Name'] ?? '';

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: _buildEditAssessorForm(assessor), // Use an edit form for editing
        );
      },
    );
  }

  void _deleteData(String key) {
    // Remove the data from the local list
    setState(() {
      assessors.removeWhere((assessor) => assessor['key'] == key);
    });

    // Remove the data from the Firebase Realtime Database
    _databaseReference.child(key).remove();
  }

  Widget _buildEditAssessorForm(Map<String, String> assessor) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text("Edit Assessor", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          TextFormField(
            controller: _assessorNameController,
            decoration: const InputDecoration(labelText: "Assessor Name"),
            onChanged: (text) {
              if (text != null) {
                // Automatically convert text to uppercase
                _assessorNameController.text = text.toUpperCase();
                // Move the cursor to the end of the text
                _assessorNameController.selection = TextSelection.fromPosition(TextPosition(offset: _assessorNameController.text.length));
              }
            },
          ),

          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              if (_validateForm()) {
                // Handle updating the assessor's information here
                String updatedAssessorName = _assessorNameController.text;

                String key = assessor['key'] ??
                    ''; // Get the key from the student data

                setState(() {
                  // Update the student's information in the local list
                  assessor['Assessor Name'] = updatedAssessorName;
                });
                // Update the student in the Firebase Realtime Database with the existing key
                _databaseReference.child(key).update({
                  'Assessor Name': updatedAssessorName,
                });

                // Clear the text controller and close the bottom sheet
                _assessorNameController.clear();
                Navigator.pop(
                    context); // Close the bottom sheet after submission
              }
            },
            child: const Text("Update"),
          ),
        ],
      ),
    );
  }

  bool _validateForm() {
    if (_assessorNameController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fill in all required fields.'),
          duration: Duration(seconds: 2),
        ),
      );
      return false; // Form is not valid
    }
    return true; // Form is valid
  }

  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  void _initializeData() {
    _databaseReference.onValue.listen((event) {
      if (event.snapshot.value != null) {
        Map<dynamic, dynamic>? map = event.snapshot.value as Map<dynamic, dynamic>?;

        if (map != null) {
          List<Map<String, String>> dataList = [];
          map.forEach((key, value) {
            if (value is Map<dynamic, dynamic> && value.containsKey('Assessor Name')) {
              dataList.add({
                'key': key,
                'Assessor Name': value['Assessor Name'].toString(),
              });
            }
          });

          setState(() {
            assessors = dataList;
          });
        }
      }
    });
  }

  Widget _buildAddAssessorForm() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text("Add Assessor", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          TextFormField(
            controller: _assessorNameController,
            decoration: const InputDecoration(labelText: "Assessor Name"),
            onChanged: (text) {
              if (text != null) {
                // Automatically convert text to uppercase
                _assessorNameController.text = text.toUpperCase();
                // Move the cursor to the end of the text
                _assessorNameController.selection = TextSelection.fromPosition(TextPosition(offset: _assessorNameController.text.length));
              }
            },
          ),

          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              if (_validateForm()) {
                // Handle form submission here
                String assessorName = _assessorNameController.text;

                String key = _databaseReference.push().key ?? ''; // Generate a unique key

                setState(() {
                  assessors.add({
                    'key': key,
                    'Assessor Name': assessorName,

                  });

                  _databaseReference.child(key).set({
                    'Assessor Name': assessorName,
                  });

                  // Clear the text controllers after submission
                  _assessorNameController.clear();
                });

                Navigator.pop(
                    context); // Close the bottom sheet after submission
              }
            },
            child: const Text("Submit"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: const Text("Manage Assessor"),
        backgroundColor: Colors.deepPurple,
        iconTheme: const IconThemeData(color: Colors.white),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 30),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(40),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.blueGrey),
                    ),
                    child: Column(
                      children: [
                        const Text(
                          "Assessor",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Image.asset(
                          "assets/png_images/Ellipse 10.png",
                          width: 100,
                          height: 100,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  FloatingActionButton(
                    onPressed: _openAddAssessorForm,
                    backgroundColor: Colors.deepPurple,
                    child: const Icon(Icons.add),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: EdgeInsets.only(left: 20),
                  child: Text(
                    "Assessor",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            _buildAssessorInfoDisplay(),
          ],
        ),
      ),
    );
  }

  Widget _buildAssessorInfoDisplay() {
    return Column(
      children: assessors.asMap().entries.map((entry) {
        final int index = entry.key;
        final Map<String, String> assessor = entry.value;
        counter = index + 1; // Increment the counter for each item
        final String key = assessor['key'] ?? ''; // Use the key from the local list

        return Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    "$counter. ${assessor['Assessor Name']}", // Display the counter here
                  ),
                ),

                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => StudentListAS(
                          assessorName: assessor['Assessor Name'],
                        ),
                      ),
                    );
                  },
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.cyan),
                  ),
                  child: const Text("Student List"),
                ),
                const SizedBox(width: 16),
                IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () {
                    _openEditAssessorForm(assessor);
                  },
                ),

                IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () {
                    setState(() {
                      assessors.remove(assessor);
                      _deleteData(key); // Delete data from the database
                    });
                  },
                ),
              ],
            ),
            const Divider(),
          ],
        );
      }).toList(),
    );
  }
}