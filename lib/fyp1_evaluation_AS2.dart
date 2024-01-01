import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:systemfyp/assessor2_fyp1.dart';
import 'package:systemfyp/student_fyp1_evaluation.dart';
import 'package:systemfyp/viewstudentSV.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AS2 extends StatefulWidget {
  const AS2({super.key});

  @override
  State<AS2> createState() => _AS2State();
}

class _AS2State extends State<AS2> {

  List<Map<String, String>> students = [];
  int counter = 1;

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final ref = FirebaseDatabase.instance.ref('students FYP 1');
  String fullName = ''; // Added to store the full name
  late FirebaseAuth _auth; // Declare FirebaseAuth instance
  late User loggedInUser; // Declare User instance
  late FirebaseFirestore _firestore; // Declare FirebaseFirestore instance

  @override
  void initState() {
    super.initState();
    _auth = FirebaseAuth.instance;
    _firestore = FirebaseFirestore.instance;
    getCurrentUser();
  }

  void getCurrentUser() async {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        loggedInUser = user;

        // Fetch user data from Firestore
        await fetchUserData(loggedInUser.email!);

        setState(() {}); // Trigger a rebuild to update UI with the retrieved full name
      }
    } catch (e) {
      print(e);
    }
  }

  // Method to fetch user data from Firestore
  Future<void> fetchUserData(String email) async {
    try {
      final userData = await _firestore.collection('users').where(
          'email', isEqualTo: email).get();
      if (userData.docs.isNotEmpty) {
        // Assuming 'full name' is a field in your Firestore document
        fullName = userData.docs.first['full name'];
      }
    } catch (e) {
      print(e);
    }
  }

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
        actions: [
          TextButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const STUDENTFYP1EVALUATION(),
                ),
              );
            },
            child: const Text(
              "Change as Assessor 1",
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),

      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(height: 50),
          const Text(
            "FINAL YEAR PROJECT 1",
            style: TextStyle(
              color: Colors.purple,
              fontSize: 38,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          Text(
            "WELCOME, $fullName", // Display the full name
            style: const TextStyle(
              color: Colors.purple,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),
          Image.asset(
            "assets/png_images/student.png",
            width: 150,
            height: 150,
          ),
          const SizedBox(height: 30),
          const Text(
            "Currently As Assessor 2",
            style: TextStyle(
              color: Colors.black,
              fontSize: 16,
              fontWeight: FontWeight.bold,
              decoration: TextDecoration.underline,
            ),
            textAlign: TextAlign.center,
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

                String assessor2Name = snapshot.child('Assessor 2 Name')
                    .value
                    .toString();

                if (assessor2Name.trim().toLowerCase() == fullName.trim().toLowerCase()) {

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
                        Text("${counter++}"),
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
                                builder: (context) => assesor2_fyp1(studentName: studentName),
                              ),
                            );
                          },
                          child: const Text("Evaluation"),
                        ),
                      ],
                    ),
                  ),
                );
              } else {
                  return Container();
                }
              }
            ),
          ),
        ],
      ),
    );
  }
}
