import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class FYP2STUDENT extends StatefulWidget {
  const FYP2STUDENT({super.key});

  @override
  State<FYP2STUDENT> createState() => _FYP2STUDENTState();
}

class _FYP2STUDENTState extends State<FYP2STUDENT> {

  final DatabaseReference _databaseReference = FirebaseDatabase.instance.reference().child('students FYP 2');
  final ref = FirebaseDatabase.instance.ref('supervisors');
  final assessorsRef = FirebaseDatabase.instance.ref('assessors');

  String selectedSupervisor = ''; // Declare these variables
  String selectedAssessor1 = '';
  String selectedAssessor2 = '';

  List<Map<String, String>> supervisors = [];
  List<Map<String, String>> assessors = [];

  List<Map<String, String>> students = [
    {
      'key': 'unique_key_1', // Replace with an actual key from Firebase Realtime Database
    },
  ];

  Map<String, String>? selectedStudent;
  int counter = 1;

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  final TextEditingController _studentNameController = TextEditingController();
  final TextEditingController _idController = TextEditingController();
  final TextEditingController _projectTitleController = TextEditingController();
  final TextEditingController _supervisorController = TextEditingController();
  final TextEditingController _assessor1Controller = TextEditingController();
  final TextEditingController _assessor2Controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  void _initializeData() {
    // Fetch supervisors from the 'supervisors' node
    ref.onValue.listen((event) {
      if (event.snapshot.value != null) {
        Map<dynamic, dynamic>? supervisorMap = event.snapshot.value as Map<dynamic, dynamic>?;

        if (supervisorMap != null) {
          List<Map<String, String>> supervisorList = [];
          supervisorMap.forEach((key, value) {
            if (value is Map<dynamic, dynamic> && value.containsKey('Supervisor Name')) {
              supervisorList.add({
                'key': key,
                'Supervisor Name': value['Supervisor Name'].toString(),
              });
            }
          });

          setState(() {
            supervisors = supervisorList;
            selectedSupervisor = supervisors.isNotEmpty ? supervisors[0]['Supervisor Name'] ?? '' : '';
          });
        }
      }
    });

    // Fetch assessors from the 'assessors' node
    assessorsRef.onValue.listen((event) {
      if (event.snapshot.value != null) {
        Map<dynamic, dynamic>? assessorMap = event.snapshot.value as Map<dynamic, dynamic>?;

        if (assessorMap != null) {
          List<Map<String, String>> assessorList = [];
          assessorMap.forEach((key, value) {
            if (value is Map<dynamic, dynamic> && value.containsKey('Assessor Name')) {
              assessorList.add({
                'key': key,
                'Assessor Name': value['Assessor Name'].toString(),
              });
            }
          });

          setState(() {
            assessors = assessorList;
            selectedAssessor1 = assessors.isNotEmpty ? assessors[0]['Assessor Name'] ?? '' : '';
            selectedAssessor2 = assessors.isNotEmpty ? assessors[0]['Assessor Name'] ?? '' : '';
          });
        }
      }
    });

    // Fetch students from the 'students FYP 1' node
    _databaseReference.onValue.listen((event) {
      if (event.snapshot.value != null) {
        Map<dynamic, dynamic>? map = event.snapshot.value as Map<dynamic, dynamic>?;

        if (map != null) {
          List<Map<String, String>> dataList = [];
          map.forEach((key, value) {
            if (value is Map<dynamic, dynamic> && value.containsKey('Student Name')) {
              dataList.add({
                'key': key,
                'Student Name': value['Student Name'].toString(),
                'ID': value['ID'].toString(),
                'Project Title': value['Project Title'].toString(),
                'Supervisor Name': value['Supervisor Name'].toString(),
                'Assessor 1 Name': value['Assessor 1 Name'].toString(),
                'Assessor 2 Name': value['Assessor 2 Name'].toString(),
              });
            }
          });

          setState(() {
            students = dataList;
          });
        }
      }
    });
  }

  void _openAddStudentForm() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: _buildAddStudentForm(),
        );
      },
    );
  }

  void _openEditStudentForm(Map<String, String> student) {
    // Initialize the text controllers with the student's information
    _studentNameController.text = student['Student Name'] ?? '';
    _idController.text = student['ID'] ?? '';
    _projectTitleController.text = student['Project Title'] ?? '';
    _supervisorController.text = student['Supervisor Name'] ?? '';
    _assessor1Controller.text = student['Assessor 1 Name'] ?? '';
    _assessor2Controller.text = student['Assessor 2 Name'] ?? '';

    // Display the edit form in a bottom sheet
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: _buildEditStudentForm(student),
        );
      },
    );
  }

  void _deleteData(String key) {
    // Remove the data from the local list
    setState(() {
      students.removeWhere((student) => student['key'] == key);
    });

    // Remove the data from the Firebase Realtime Database
    _databaseReference.child(key).remove();
  }

  bool _validateForm() {
    if (_studentNameController.text.isEmpty ||
        _idController.text.isEmpty ||
        _projectTitleController.text.isEmpty ||
        selectedSupervisor.isEmpty ||
        selectedAssessor1.isEmpty ||
        selectedAssessor2.isEmpty) {
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

  Widget _buildEditStudentForm(Map<String, String> student) {
    List<Map<String, String>> assessors = this.assessors;
    List<Map<String, String>> supervisors = this.supervisors;

    final List<String> assessorNames = assessors.map((assessor) => assessor['Assessor Name'] ?? '').toList();
    selectedAssessor1 = student['Assessor 1 Name'] ?? '';
    selectedAssessor2 = student['Assessor 2 Name'] ?? '';

    final List<String> supervisorNames = supervisors.map((supervisor) => supervisor['Supervisor Name'] ?? '').toList();
    selectedSupervisor = student['Supervisor Name'] ?? '';

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text("Edit Student", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
          TextFormField(
            controller: _studentNameController,
            decoration: const InputDecoration(labelText: "Student Name"),
            onChanged: (text) {
              if (text != null) {
                // Automatically convert text to uppercase
                _studentNameController.text = text.toUpperCase();
                // Move the cursor to the end of the text
                _studentNameController.selection = TextSelection.fromPosition(TextPosition(offset: _studentNameController.text.length));
              }
            },
          ),
          TextFormField(
            controller: _idController,
            decoration: const InputDecoration(labelText: "ID"),
            keyboardType: TextInputType.number,
          ),
          TextFormField(
            controller: _projectTitleController,
            decoration: const InputDecoration(labelText: "Project Title"),
            onChanged: (text) {
              if (text != null) {
                // Automatically convert text to uppercase
                _projectTitleController.text = text.toUpperCase();
                // Move the cursor to the end of the text
                _projectTitleController.selection = TextSelection.fromPosition(TextPosition(offset: _projectTitleController.text.length));
              }
            },
          ),

          DropdownButtonFormField<String>(
            value: selectedSupervisor,
            items: supervisorNames.map((String supervisor) {
              return DropdownMenuItem<String>(
                value: supervisor,
                child: Text(supervisor),
              );
            }).toList(),
            onChanged: (String? newValue) {
              setState(() {
                selectedSupervisor = newValue ?? '';
              });
            },
            decoration: const InputDecoration(
              labelText: 'Select Supervisor',
            ),
          ),

          DropdownButtonFormField<String>(
            value: selectedAssessor1,
            items: assessorNames.map((String assessor) {
              return DropdownMenuItem<String>(
                value: assessor,
                child: Text(assessor),
              );
            }).toList(),
            onChanged: (String? newValue) {
              setState(() {
                selectedAssessor1 = newValue ?? '';
              });
            },
            decoration: const InputDecoration(
              labelText: 'Select Assessor',
            ),
          ),
          DropdownButtonFormField<String>(
            value: selectedAssessor2,
            items: assessorNames.map((String assessor) {
              return DropdownMenuItem<String>(
                value: assessor,
                child: Text(assessor),
              );
            }).toList(),
            onChanged: (String? newValue) {
              setState(() {
                selectedAssessor2 = newValue ?? '';
              });
            },
            decoration: const InputDecoration(
              labelText: 'Select Assessor',
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              if (_validateForm()) {
                // Handle updating the student's information here
                String updatedStudentName = _studentNameController.text;
                String updatedId = _idController.text;
                String updatedProjectTitle = _projectTitleController.text;
                String updatedSupervisorName = selectedSupervisor;
                String updatedAssessor1Name = selectedAssessor1;
                String updatedAssessor2Name = selectedAssessor2;

                String key = student['key'] ?? ''; // Get the key from the student data

                setState(() {
                  // Update the student's information in the local list
                  student['Student Name'] = updatedStudentName;
                  student['ID'] = updatedId;
                  student['Project Title'] = updatedProjectTitle;
                  student['Supervisor Name'] = updatedSupervisorName;
                  student['Assessor 1 Name'] = updatedAssessor1Name;
                  student['Assessor 2 Name'] = updatedAssessor2Name;
                });

                // Update the student in the Firebase Realtime Database with the existing key
                _databaseReference.child(key).update({
                  'Student Name': updatedStudentName,
                  'ID': updatedId,
                  'Project Title': updatedProjectTitle,
                  'Supervisor Name': updatedSupervisorName,
                  'Assessor 1 Name': updatedAssessor1Name,
                  'Assessor 2 Name': updatedAssessor2Name,
                });

                // Clear the text controllers and close the bottom sheet
                _studentNameController.clear();
                _idController.clear();
                _projectTitleController.clear();
                _supervisorController.clear();
                _assessor1Controller.clear();
                _assessor2Controller.clear();

                Navigator.pop(context); // Close the bottom sheet
              }
            },
            child: const Text("Update"),
          ),
        ],
      ),
    );
  }

  Widget _buildAddStudentForm() {
    List<Map<String, String>> assessors = this.assessors;
    List<Map<String, String>> supervisors = this.supervisors;

    final List<String> assessorNames = assessors.map((assessor) => assessor['Assessor Name'] ?? '').toList();
    String? selectedAssessor1;
    String? selectedAssessor2;

    final List<String> supervisorNames = supervisors.map((supervisor) => supervisor['Supervisor Name'] ?? '').toList();
    String? selectedSupervisor;

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text("Add Student", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          TextFormField(
            controller: _studentNameController,
            decoration: const InputDecoration(labelText: "Student Name"),
            onChanged: (text) {
              if (text != null) {
                // Automatically convert text to uppercase
                _studentNameController.text = text.toUpperCase();
                // Move the cursor to the end of the text
                _studentNameController.selection = TextSelection.fromPosition(TextPosition(offset: _studentNameController.text.length));
              }
            },
          ),
          TextFormField(
            controller: _idController,
            decoration: const InputDecoration(labelText: "ID"),
            keyboardType: TextInputType.number,
          ),
          TextFormField(
            controller: _projectTitleController,
            decoration: const InputDecoration(labelText: "Project Title"),
            onChanged: (text) {
              if (text != null) {
                // Automatically convert text to uppercase
                _projectTitleController.text = text.toUpperCase();
                // Move the cursor to the end of the text
                _projectTitleController.selection = TextSelection.fromPosition(TextPosition(offset: _projectTitleController.text.length));
              }
            },
          ),
          DropdownButtonFormField<String>(
            value: selectedSupervisor,
            items: supervisorNames.map((String supervisor) {
              return DropdownMenuItem<String>(
                value: supervisor,
                child: Text(supervisor),
              );
            }).toList(),
            onChanged: (String? newValue) {
              setState(() {
                selectedSupervisor = newValue ?? '';
              });
            },
            decoration: const InputDecoration(
              labelText: 'Select Supervisor',
            ),
          ),

          DropdownButtonFormField<String>(
            value: selectedAssessor1,
            items: assessorNames.map((String assessor) {
              return DropdownMenuItem<String>(
                value: assessor,
                child: Text(assessor),
              );
            }).toList(),
            onChanged: (String? newValue) {
              setState(() {
                selectedAssessor1 = newValue ?? '';
              });
            },
            decoration: const InputDecoration(
              labelText: 'Select Assessor',
            ),
          ),
          DropdownButtonFormField<String>(
            value: selectedAssessor2,
            items: assessorNames.map((String assessor) {
              return DropdownMenuItem<String>(
                value: assessor,
                child: Text(assessor),
              );
            }).toList(),
            onChanged: (String? newValue) {
              setState(() {
                selectedAssessor2 = newValue ?? '';
              });
            },
            decoration: const InputDecoration(
              labelText: 'Select Assessor',
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              if (_validateForm()) {
                // Handle form submission here if the form is valid
                String studentName = _studentNameController.text;
                String id = _idController.text;
                String projectTitle = _projectTitleController.text;
                String supervisorName = selectedSupervisor ?? '';
                String assessor1Name = selectedAssessor1 ?? '';
                String assessor2Name = selectedAssessor2 ?? '';

                String key = _databaseReference.push().key ?? ''; // Generate a unique key

                setState(() {
                  students.add({
                    'key': key,
                    'Student Name': studentName,
                    'ID': id,
                    'Project Title': projectTitle,
                    'Supervisor Name': supervisorName,
                    'Assessor 1 Name': assessor1Name,
                    'Assessor 2 Name': assessor2Name,
                  });

                  // Add the student to the Firebase Realtime Database with the generated key
                  _databaseReference.child(key).set({
                    'Student Name': studentName,
                    'ID': id,
                    'Project Title': projectTitle,
                    'Supervisor Name': supervisorName,
                    'Assessor 1 Name': assessor1Name,
                    'Assessor 2 Name': assessor2Name,
                  });

                  // Clear the text controllers and reset dropdown values after submission
                  _studentNameController.clear();
                  _idController.clear();
                  _projectTitleController.clear();
                  selectedSupervisor = supervisorNames.isNotEmpty ? supervisorNames[0] : null;
                  selectedAssessor1 = assessorNames.isNotEmpty ? assessorNames[0] : null;
                  selectedAssessor2 = assessorNames.isNotEmpty ? assessorNames[0] : null;
                });
                Navigator.pop(context); // Close the bottom sheet after submission
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
        title: const Text("Manage Student"),
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
        child: Row(
          children: [
            Expanded(
              child: Center(
                child: Column(
                  children: [
                    const SizedBox(height: 40),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(height: 40),
                            Text(
                              "Final Year Project 2",
                              style: TextStyle(
                                color: Colors.deepPurple,
                                fontSize: 38,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),

                        const SizedBox(height: 20),
                        Image.asset(
                          "assets/png_images/student.png",
                          width: 150,
                          height: 150,
                        ),

                        const SizedBox(height: 16),
                        FloatingActionButton(
                          onPressed: _openAddStudentForm,
                          backgroundColor: Colors.deepPurple,
                          child: const Icon(Icons.add),
                        ),

                        const SizedBox(height: 50),
                        const Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            SizedBox(width: 10),
                            Text(
                              "Student",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            SizedBox(width: 100),
                            Text(
                              "ID",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            SizedBox(width: 80),
                            Text(
                              "Project Title",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            SizedBox(width: 60),
                            Text(
                              "Supervisor",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            SizedBox(width: 50),
                            Text(
                              "Assessor",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        _buildStudentInfoDisplay(),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStudentInfoDisplay() {
    return Column(
      children: students.asMap().entries.map((entry) {
        final int index = entry.key;
        final Map<String, String> student = entry.value;
        counter = index + 1; // Increment the counter for each item
        final bool isSelected = selectedStudent == student;
        final String key = student['key'] ?? ''; // Use the key from the local list

        return Column(
          children: [
            GestureDetector(
              onTap: () {
                setState(() {
                  selectedStudent = isSelected ? null : student; // Toggle selection
                });
              },
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: Text(
                        "$counter. ${student['Student Name']}",
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.only(left: 30.0),
                      child: Text(
                        "${student['ID']}",
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.only(left: 10.0),
                      child: Text(
                        "${student['Project Title']}",
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.only(left: 28.0),
                      child: Text(
                        "${student['Supervisor Name']}",
                      ),
                    ),
                  ),
                  Expanded(
                    child: Column(
                      //crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 20.0), // Add padding here
                          child:Text(
                            "1) ${student['Assessor 1 Name']}",
                          ),
                        ),
                        Padding (
                          padding: const EdgeInsets.only(left: 20.0), // Add padding here
                          child: Text(
                            "2) ${student['Assessor 2 Name']}",
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            if (isSelected)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  IconButton(
                    icon: const Icon(Icons.edit),
                    onPressed: () {
                      _openEditStudentForm(student);
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () {
                      setState(() {
                        students.remove(student);
                        selectedStudent = null; // Deselect the student
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