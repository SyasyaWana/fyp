import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:systemfyp/assessor2_fyp2.dart';
import 'package:systemfyp/evaluationform2_AS.dart';
import 'package:systemfyp/fyp2_evaluationAS2.dart';
import 'package:systemfyp/viewstudentSV2.dart';

class STUDENTFYP2EVALUATION extends StatefulWidget {
  const STUDENTFYP2EVALUATION({super.key});

  @override
  State<STUDENTFYP2EVALUATION> createState() => _STUDENTFYP2EVALUATIONState();
}

class _STUDENTFYP2EVALUATIONState extends State<STUDENTFYP2EVALUATION> {

  List<Map<String, String>> students = [];
  int counter = 1;

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final ref = FirebaseDatabase.instance.ref('students FYP 2');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: const Text("Student"),
        backgroundColor: Colors.purple,
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
            "FINAL YEAR PROJECT 2",
            style: TextStyle(
              color: Colors.purple,
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
          const SizedBox(height: 30),
          const Text(
            "As Assessor 1",
            style: TextStyle(
              color: Colors.black,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 10), // Add spacing between image and buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const AS2_2(), // Navigate to the result screen
                    ),
                  );
                },
                child: const Text(
                  "Change To Assessor 2",
                  style: TextStyle(
                    color: Colors.purple, // Choose a color for the link text
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 30),
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
                                builder: (context) => ViewResult2(
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
                                builder: (context) => EvaluationForm2_AS(studentName: studentName),
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