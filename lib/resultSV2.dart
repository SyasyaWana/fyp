import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:systemfyp/2resultSV.dart';
import 'package:systemfyp/viewresult.dart';
import 'package:systemfyp/viewresult2.dart';

class FYP2RESULTSV extends StatefulWidget {
  const FYP2RESULTSV({super.key});

  @override
  State<FYP2RESULTSV> createState() => _FYP2RESULTSVState();
}

class _FYP2RESULTSVState extends State<FYP2RESULTSV> {

  List<Map<String, String>> students = [];
  int counter = 1;

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final ref = FirebaseDatabase.instance.ref('students FYP 2');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: const Text("View Student Result"),
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
            "FINAL YEAR PROJECT 2",
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
                                builder: (context) => Result2SV(
                                    studentName: studentName, id: id, projectTitle: projectTitle, supervisorName: supervisorName
                                ),
                              ),
                            );
                          },
                          child: const Text("Result"),
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