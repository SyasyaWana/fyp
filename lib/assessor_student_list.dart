import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:systemfyp/viewstudentSV.dart';
import 'package:systemfyp/viewstudentSV2.dart';

class StudentListAS extends StatefulWidget {
  final String? assessorName;

  const StudentListAS({
    required this.assessorName,
  });

  @override
  State<StudentListAS> createState() => _StudentListASState();
}

class _StudentListASState extends State<StudentListAS> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final DatabaseReference _databaseReferenceFYP1 = FirebaseDatabase.instance.reference().child('students FYP 1');
  final DatabaseReference _databaseReferenceFYP2 = FirebaseDatabase.instance.reference().child('students FYP 2');
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  String selectedFYP = "FYP 1";
  String selectedAssessor = "Assessor 1";

  final Key _fyp1ListKey = UniqueKey();
  final Key _fyp2ListKey = UniqueKey();
  final Key _fyp3ListKey = UniqueKey();
  final Key _fyp4ListKey = UniqueKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: const Text("Assigned Student List"),
        backgroundColor: Colors.deepPurple,
        iconTheme: const IconThemeData(color: Colors.white),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Row(
        children: [
          Expanded(
            child: Center(
              child: Column(
                children: [
                  const SizedBox(height: 60),
                  Text(
                    "ASSESSOR: ${widget.assessorName}",
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(width: 40),
                  const SizedBox(height: 30),
                  DropdownButton<String>(
                    value: selectedFYP,
                    items: ["FYP 1", "FYP 2"].map((fyp) {
                      return DropdownMenuItem<String>(
                        value: fyp,
                        child: Text(fyp),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        selectedFYP = newValue ?? "FYP 1";
                      });
                    },
                  ),
                  DropdownButton<String>(
                    value: selectedAssessor,
                    items: ["Assessor 1", "Assessor 2"].map((assessor) {
                      return DropdownMenuItem<String>(
                        value: assessor,
                        child: Text(assessor),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        selectedAssessor = newValue ?? "Assessor 1";
                      });
                    },
                  ),
                  const SizedBox(height: 20),
                  const Divider(
                    color: Colors.deepPurple,
                  ),
                  const SizedBox(height: 20),
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(width: 50), // Add left spacing
                      Text(
                        "ID",
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(width: 100), // Add left spacing
                      Text(
                        "Student Name",
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Expanded(
                    child: (selectedFYP == "FYP 1" && selectedAssessor == "Assessor 1")
                        ? FirebaseAnimatedList(
                      key: _fyp1ListKey,
                      query: _databaseReferenceFYP1.orderByChild('Assessor 1 Name').equalTo(widget.assessorName),
                      itemBuilder: (BuildContext context, DataSnapshot snapshot, Animation<double> animation, int index) {
                        String studentName = snapshot.child('Student Name').value.toString();
                        String id = snapshot.child('ID').value.toString();
                        String projectTitle = snapshot.child('Project Title').value.toString();
                        String supervisorName = snapshot.child('Supervisor Name').value.toString();
                        String assessor1Name = snapshot.child('Assessor 1 Name').value.toString();
                        String assessor2Name = snapshot.child('Assessor 2 Name').value.toString();
                        return FutureBuilder<Map<String, dynamic>>(
                          future: getScores(studentName, 'evaluationScoresfyp1'),
                          builder: (context, snapshot) {
                            return buildExpandableListTile(studentName, id, projectTitle, supervisorName, assessor1Name, assessor2Name, 'evaluationScoresfyp1', index + 1);
                          },
                        );
                      },
                    )
                        : (selectedFYP == "FYP 2" && selectedAssessor == "Assessor 1")
                        ? FirebaseAnimatedList(
                      key: _fyp2ListKey,
                      query: _databaseReferenceFYP2.orderByChild('Assessor 1 Name').equalTo(widget.assessorName),
                      itemBuilder: (BuildContext context, DataSnapshot snapshot, Animation<double> animation, int index) {
                        String studentName = snapshot.child('Student Name').value.toString();
                        String id = snapshot.child('ID').value.toString();
                        String projectTitle = snapshot.child('Project Title').value.toString();
                        String supervisorName = snapshot.child('Supervisor Name').value.toString();
                        String assessor1Name = snapshot.child('Assessor 1 Name').value.toString();
                        String assessor2Name = snapshot.child('Assessor 2 Name').value.toString();
                        return FutureBuilder<Map<String, dynamic>>(
                          future: getScores(studentName, 'evaluationScoresfyp2'),
                          builder: (context, snapshot) {
                            return buildExpandableListTile(studentName, id, projectTitle, supervisorName, assessor1Name, assessor2Name, 'evaluationScoresfyp2', index + 1);
                          },
                        );
                      },
                    )
                        : (selectedFYP == "FYP 1" && selectedAssessor == "Assessor 2")
                        ? FirebaseAnimatedList(
                      key: _fyp3ListKey,
                      query: _databaseReferenceFYP1.orderByChild('Assessor 2 Name').equalTo(widget.assessorName),
                      itemBuilder: (BuildContext context, DataSnapshot snapshot, Animation<double> animation, int index) {
                        String studentName = snapshot.child('Student Name').value.toString();
                        String id = snapshot.child('ID').value.toString();
                        String projectTitle = snapshot.child('Project Title').value.toString();
                        String supervisorName = snapshot.child('Supervisor Name').value.toString();
                        String assessor1Name = snapshot.child('Assessor 1 Name').value.toString();
                        String assessor2Name = snapshot.child('Assessor 2 Name').value.toString();
                        return FutureBuilder<Map<String, dynamic>>(
                          future: getScores(studentName, 'evaluationScoresfyp1'),
                          builder: (context, snapshot) {
                            return buildExpandableListTile(studentName, id, projectTitle, supervisorName, assessor1Name, assessor2Name, 'evaluationScoresfyp1', index + 1);
                          },
                        );
                      },
                    )
                        : (selectedFYP == "FYP 2" && selectedAssessor == "Assessor 2")
                        ? FirebaseAnimatedList(
                      key: _fyp4ListKey,
                      query: _databaseReferenceFYP2.orderByChild('Assessor 2 Name').equalTo(widget.assessorName),
                      itemBuilder: (BuildContext context, DataSnapshot snapshot, Animation<double> animation, int index) {
                        String studentName = snapshot.child('Student Name').value.toString();
                        String id = snapshot.child('ID').value.toString();
                        String projectTitle = snapshot.child('Project Title').value.toString();
                        String supervisorName = snapshot.child('Supervisor Name').value.toString();
                        String assessor1Name = snapshot.child('Assessor 1 Name').value.toString();
                        String assessor2Name = snapshot.child('Assessor 2 Name').value.toString();

                        return FutureBuilder<Map<String, dynamic>>(
                          future: getScores(studentName, 'evaluationScoresfyp2'),
                          builder: (context, snapshot) {
                            return buildExpandableListTile(studentName, id, projectTitle, supervisorName, assessor1Name, assessor2Name, 'evaluationScoresfyp2', index + 1);
                          },
                        );
                      },
                    )
                        : Container(),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<Map<String, dynamic>> getScores(String studentName, String collectionName) async {
    CollectionReference scoresCollection = _firestore.collection(collectionName);

    try {
      QuerySnapshot querySnapshot = await scoresCollection
          .where('studentName', isEqualTo: studentName)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        // Assuming there is only one document for each student, get the first one
        DocumentSnapshot docSnapshot = querySnapshot.docs.first;
        return docSnapshot.data() as Map<String, dynamic>;
      } else {
        return {}; // Return an empty map if no scores are found
      }
    } catch (e) {
      print('Error getting scores: $e');
      return {};
    }
  }

  Widget buildExpandableListTile(String studentName, String id, String projectTitle, String supervisorName, String assessor1Name, String assessor2Name, String collectionName, int index) {
    bool allFormsCompleted = false;

    return ExpansionTile(
      title: Row(
        children: [
          Text('$index. '), // Add numbering
          Expanded(
            flex: 2,
            child: Text(id),
          ),
          Expanded(
            flex: 7,
            child: Text(studentName),
          ),
          Expanded(
            child: FutureBuilder<Map<String, dynamic>>(
              future: getScores(studentName, collectionName),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else {
                  Map<String, dynamic> scoresData = snapshot.data ?? {};

                  bool supervisorCompleted = (scoresData['totalProgressProjectFormScore'] ?? 0) >= 1 &&
                      (scoresData['totalFinalReportFormSVScore'] ?? 0) >= 1;
                  bool assessorCompleted = (scoresData['totalPresentationFormScore'] ?? 0) >= 1 &&
                      (scoresData['totalFinalReportFormScore'] ?? 0) >= 1;
                  bool assessor2Completed = (scoresData['totalPresentationForm2Score'] ?? 0) >= 1;

                  bool allFormsCompleted = supervisorCompleted && assessorCompleted && assessor2Completed;

                  return Text(
                    allFormsCompleted ? 'Complete' : 'Incomplete',
                    style: TextStyle(
                      fontSize: 9, // Adjust the font size as needed
                      fontWeight: FontWeight.normal,
                      color: allFormsCompleted ? Colors.blue : Colors.red,
                    ),
                  );
                }
              },
            ),
          ),
        ],
      ),
      children: [
        FutureBuilder<Map<String, dynamic>>(
          future: getScores(studentName, collectionName),
          builder: (context, snapshot) {
            return buildDropdowns(studentName, id, projectTitle, supervisorName, assessor1Name, assessor2Name, snapshot);
          },
        ),
      ],
    );
  }

  Widget buildDropdowns(String studentName, String id, String projectTitle, String supervisorName, String assessor1Name, String assessor2Name, AsyncSnapshot<Map<String, dynamic>> snapshot) {
    if (snapshot.connectionState == ConnectionState.waiting) {
      return const CircularProgressIndicator(); // Display loading indicator while waiting for the future to complete
    } else if (snapshot.hasError) {
      return Text('Error: ${snapshot.error}');
    } else {
      Map<String, dynamic> scoresData = snapshot.data ?? {};

      List<String> supervisorOptions = (selectedFYP == "FYP 1") ? ["Progress Project Form", "Final Report Form"] : ["Progress Project Form", "Final Report Form", "Technical Paper Form"];
      List<String> assessorOptions = (selectedFYP == "FYP 1") ? ["Presentation Form", "Final Report Form"] : ["Presentation Form", "Final Report Form"];
      List<String> assessor2Options = (selectedFYP == "FYP 1") ? ["Presentation Form"] : ["Presentation Form"];

      String selectedSupervisor = supervisorOptions[0];
      String selectedAssessor = assessorOptions[0];
      String selectedAssessor2 = assessor2Options[0];

      return Column(
        children: [
          Row(
            children: [
              const SizedBox(width: 10),
              const Text(
                "Supervisor",
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(width: 10),
              DropdownButton<String>(
                value: selectedSupervisor,
                items: supervisorOptions.map((supervisor) {
                  String scoreText;
                  if (supervisor == "Progress Project Form") {
                    scoreText = '${scoresData['totalProgressProjectFormScore'] ?? 'N/A'}';
                  } else if (supervisor == "Final Report Form") {
                    scoreText = '${scoresData['totalFinalReportFormSVScore'] ?? 'N/A'}';
                  } else {
                    scoreText = '${scoresData['totalTechnicalPaperFormScore'] ?? 'N/A'}';
                  }
                  return DropdownMenuItem<String>(
                    value: supervisor,
                    child: Text('$supervisor: $scoreText'),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    selectedSupervisor = newValue ?? supervisorOptions[0];
                  });
                },
              ),
              // Add the icon based on conditions
              (scoresData['totalProgressProjectFormScore'] == null || scoresData['totalFinalReportFormSVScore'] == null ||
                  scoresData['totalProgressProjectFormScore'] == 0 || scoresData['totalFinalReportFormSVScore'] == 0)
                  ? const Icon(Icons.close, color: Colors.red)
                  : const Icon(Icons.check, color: Colors.green),
            ],
          ),
          Row(
            children: [
              const SizedBox(width: 10),
              const Text(
                "Assessor 1",
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(width: 10),
              DropdownButton<String>(
                value: selectedAssessor,
                items: assessorOptions.map((assessor) {
                  return DropdownMenuItem<String>(
                    value: assessor,
                    child: Text('$assessor: ${assessor == "Presentation Form" ? (scoresData['totalPresentationFormScore'] ?? 'N/A') : (scoresData['totalFinalReportFormScore'] ?? 'N/A')}'),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    selectedAssessor = newValue ?? assessorOptions[0];
                  });
                },
              ),
              // Add the icon based on conditions
              (scoresData['totalPresentationFormScore'] == null || scoresData['totalFinalReportFormScore'] == null ||
                  scoresData['totalPresentationFormScore'] == 0 || scoresData['totalFinalReportFormScore'] == 0)
                  ? const Icon(Icons.close, color: Colors.red)
                  : const Icon(Icons.check, color: Colors.green),
            ],
          ),
          Row(
            children: [
              const SizedBox(width: 10),
              const Text(
                "Assessor 2",
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(width: 10),
              DropdownButton<String>(
                value: selectedAssessor2,
                items: assessor2Options.map((assessor2) {
                  return DropdownMenuItem<String>(
                    value: assessor2,
                    child: Text('$assessor2: ${assessor2 == "Presentation Form" ? scoresData['totalPresentationForm2Score'] ?? 'N/A' : ''}'),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    selectedAssessor2 = newValue ?? assessor2Options[0];
                  });
                },
              ),
              // Add the icon based on conditions
              (scoresData['totalPresentationForm2Score'] == null || scoresData['totalPresentationForm2Score'] == 0)
                  ? const Icon(Icons.close, color: Colors.red)
                  : const Icon(Icons.check, color: Colors.green),
            ],
          ),
          Row(
            children: [
              const SizedBox(width: 500), // Add some vertical spacing
              GestureDetector(
                onTap: () {
                  // Navigate to the appropriate ViewResult screen based on the selected FYP
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) {
                        if (selectedFYP == "FYP 1") {
                          return ViewResult1(
                            studentName: studentName,
                            id: id,
                            projectTitle: projectTitle,
                            supervisorName: supervisorName,
                            assessor1Name: assessor1Name,
                            assessor2Name: assessor2Name,
                            // Add other necessary parameters for ViewResult1
                          );
                        } else if (selectedFYP == "FYP 2") {
                          return ViewResult2(
                            studentName: studentName,
                            id: id,
                            projectTitle: projectTitle,
                            supervisorName: supervisorName,
                            assessor1Name: assessor1Name,
                            assessor2Name: assessor2Name,
                            // Add other necessary parameters for ViewResult2
                          );
                        } else {
                          // Handle other FYP cases if needed
                          return Container();
                        }
                      },
                    ),
                  );
                },
                child: const Text(
                  'View',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.normal,
                    color: Colors.black,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
            ],
          )
        ],
      );
    }
  }
}