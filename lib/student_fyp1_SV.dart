import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:systemfyp/evaluationform1_SV.dart';
import 'package:systemfyp/resultSV.dart';
import 'package:systemfyp/viewstudentSV.dart';

class STUDENTFYP1SV extends StatefulWidget {
  const STUDENTFYP1SV({super.key});

  @override
  State<STUDENTFYP1SV> createState() => _STUDENTFYP1SVState();
}

class _STUDENTFYP1SVState extends State<STUDENTFYP1SV> {

  List<Map<String, String>> students = [];
  int counter = 1;

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final ref = FirebaseDatabase.instance.ref('students FYP 1');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: const Text("Student"),
        backgroundColor: Colors.indigo,
        iconTheme: const IconThemeData(color: Colors.white),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),

      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(height: 50),
          const Text(
            "FINAL YEAR PROJECT 1",
            style: TextStyle(
              color: Colors.indigo,
              fontSize: 38,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: 20),
          Image.asset(
            "assets/png_images/student.png",
            width: 150,
            height: 150,
          ),
          const SizedBox(height: 10), // Add spacing between image and buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const FYP1RESULTSV(), // Navigate to the result screen
                    ),
                  );
                },
                child: const Text("Result"),
              ),
            ],
          ),
          const SizedBox(height: 40),
          const Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(width: 60),
              Text(
                "ID",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(width: 60),
              Text(
                "Student Name",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),

          Expanded(
            child: FirebaseAnimatedList(
              query: ref,
              itemBuilder: (BuildContext context, DataSnapshot snapshot, Animation<double> animation, int index) {
                // Extract studentName from the snapshot
                String studentName = snapshot.child('Student Name').value.toString();
                String id = snapshot.child('ID').value.toString();
                String projectTitle = snapshot.child('Project Title').value.toString();
                String supervisorName = snapshot.child('Supervisor Name').value.toString();
                String assessor1Name = snapshot.child('Assessor 1 Name').value.toString();
                String assessor2Name = snapshot.child('Assessor 2 Name').value.toString();

                return Card(
                  margin: const EdgeInsets.all(10),
                  child: ListTile(
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("${index + 1}"), // Index starts from 0, so add 1
                        const SizedBox(width: 10),
                        Text("$id"),
                        const SizedBox(width: 20),
                        Text(" $studentName"),
                        const Expanded(child: SizedBox()), // Spacer to push buttons to the end
                        ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ViewResult1(
                                    studentName: studentName,
                                    id: id,
                                    projectTitle: projectTitle,
                                    supervisorName: supervisorName,
                                  assessor1Name: assessor1Name,
                                  assessor2Name: assessor2Name,
                                ),
                              ),
                            );
                          },
                          child: const Text("View"),
                        ),
                        const SizedBox(width: 10),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => EvaluationForm1_SV(studentName: studentName),
                              ),
                            );
                          },
                          child: const Text("Evaluation"),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}