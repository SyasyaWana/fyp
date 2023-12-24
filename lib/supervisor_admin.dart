import 'package:flutter/material.dart';
import 'package:systemfyp/supervisor_student_list.dart';
import 'package:firebase_database/firebase_database.dart';

class SupervisorAdmin extends StatefulWidget {
  const SupervisorAdmin({super.key});

  @override
  State<SupervisorAdmin> createState() => _SupervisorAdminState();
}

class _SupervisorAdminState extends State<SupervisorAdmin> {

  final DatabaseReference _databaseReference = FirebaseDatabase.instance.reference().child('supervisors');

  List<Map<String, String>> supervisors = [];

  int counter = 1; // Initialize the counter variable here

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final TextEditingController _supervisorNameController = TextEditingController();


  bool _validateForm() {
    if (_supervisorNameController.text.isEmpty) {
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
            if (value is Map<dynamic, dynamic> && value.containsKey('Supervisor Name')) {
              dataList.add({
                'key': key,
                'Supervisor Name': value['Supervisor Name'].toString(),
              });
            }
          });

          setState(() {
            supervisors = dataList;
          });
        }
      }
    });
  }

  void _openAddSupervisorForm() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
            ),
            child: _buildAddSupervisorForm()
        );
      },
    );
  }

  void _openEditSupervisorForm(Map<String, String> supervisor) {
    _supervisorNameController.text = supervisor['Supervisor Name'] ?? '';

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: _buildEditSupervisorForm(supervisor), // Use an edit form for editing
        );
      },
    );
  }

  void _deleteData(String key) {
    // Remove the data from the local list
    setState(() {
      supervisors.removeWhere((supervisor) => supervisor['key'] == key);
    });

    // Remove the data from the Firebase Realtime Database
    _databaseReference.child(key).remove();
  }

  Widget _buildEditSupervisorForm(Map<String, String> supervisor) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text("Edit Supervisor", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          TextFormField(
            controller: _supervisorNameController,
            decoration: const InputDecoration(labelText: "Supervisor Name"),
            onChanged: (text) {
              if (text != null) {
                // Automatically convert text to uppercase
                _supervisorNameController.text = text.toUpperCase();
                // Move the cursor to the end of the text
                _supervisorNameController.selection = TextSelection.fromPosition(TextPosition(offset: _supervisorNameController.text.length));
              }
            },
          ),

          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              if (_validateForm()) {
                // Handle updating the assessor's information here
                String updatedSupervisorName = _supervisorNameController.text;

                String key = supervisor['key'] ??
                    ''; // Get the key from the student data

                setState(() {
                  // Update the student's information in the local list
                  supervisor['Supervisor Name'] = updatedSupervisorName;
                });
                // Update the student in the Firebase Realtime Database with the existing key
                _databaseReference.child(key).update({
                  'Supervisor Name': updatedSupervisorName,
                });

                // Clear the text controller and close the bottom sheet
                _supervisorNameController.clear();
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

  Widget _buildAddSupervisorForm() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text("Add Supervisor", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          TextFormField(
            controller: _supervisorNameController,
            decoration: const InputDecoration(labelText: "Supervisor Name"),
            onChanged: (text) {
              if (text != null) {
                // Automatically convert text to uppercase
                _supervisorNameController.text = text.toUpperCase();
                // Move the cursor to the end of the text
                _supervisorNameController.selection = TextSelection.fromPosition(TextPosition(offset: _supervisorNameController.text.length));
              }
            },
          ),

          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              if (_validateForm()) {
                // Handle form submission here
                String supervisorName = _supervisorNameController.text;

                String key = _databaseReference.push().key ?? ''; // Generate a unique key

                setState(() {
                  supervisors.add({
                    'key': key,
                    'Supervisor Name': supervisorName,

                  });

                  _databaseReference.child(key).set({
                    'Supervisor Name': supervisorName,
                  });

                  // Clear the text controllers after submission
                  _supervisorNameController.clear();
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
        title: const Text("Manage Supervisor"),
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
                          "Supervisor",
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
                    onPressed: _openAddSupervisorForm,
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
                    "Supervisor",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            _buildSupervisorInfoDisplay(),
          ],
        ),
      ),
    );
  }

  Widget _buildSupervisorInfoDisplay() {
    return Column(
      children: supervisors.asMap().entries.map((entry) {
        final int index = entry.key;
        final Map<String, String> supervisor = entry.value;
        counter = index + 1; // Increment the counter for each item
        final String key = supervisor['key'] ?? ''; // Use the key from the local list

        return Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    "$counter. ${supervisor['Supervisor Name']}", // Display the counter here
                  ),
                ),

                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => StudentListSV(
                          supervisorName: supervisor['Supervisor Name'],
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
                    _openEditSupervisorForm(supervisor);
                  },
                ),

                IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () {
                    setState(() {
                      supervisors.remove(supervisor);
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