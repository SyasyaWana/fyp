import 'package:flutter/material.dart';
import 'package:systemfyp/resultSV.dart';
import 'package:systemfyp/resultSV2.dart';
import 'package:systemfyp/setting.dart';
import 'package:systemfyp/student_fyp1_SV.dart';
import 'package:systemfyp/student_fyp2_SV.dart';
import 'package:systemfyp/welcome.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SupervisorScreen extends StatefulWidget {
  static String id = "supervisor_screen";

  const SupervisorScreen({Key? key}) : super(key: key);

  @override
  State<SupervisorScreen> createState() => _SupervisorScreenState();
}

class _SupervisorScreenState extends State<SupervisorScreen> {

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;
  late User loggedInUser;
  String fullName = ''; // Added to store the full name

  @override
  void initState() {
    getCurrentUser();
    super.initState();
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
      final userData = await _firestore.collection('users').where('email', isEqualTo: email).get();
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
      key: _scaffoldKey, // Assign the GlobalKey to the Scaffold
      appBar: AppBar(
        title: const Text("Supervisor"),
        backgroundColor: Colors.indigo,
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () {
              _scaffoldKey.currentState?.openDrawer();
            },
          ),
        ],
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      drawer: Drawer(
        child: Container(
          color: const Color(0xFF3F51B5), // Adjust the color as needed
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 40),
              _buildWelcomeMessage("WELCOME SUPERVISOR"), // Welcome message here
              const Divider(thickness: 1, color: Colors.white),
              _buildMenuItem("Dashboard"),
              _buildMenuItem("FYP 1 Evaluation"),
              _buildMenuItem("FYP 2 Evaluation"),
              _buildSubMenu("View Student Result", ["FYP 1 Result", "FYP 2 Result"]), // Added this line
              const Divider(thickness: 1, color: Colors.white),
              _buildMenuItem("Setting"),
              _buildMenuItem("Logout"),
            ],
          ),
        ),
      ),
      body: Row(
        children: [
          Expanded(
            child: Center(
              child: Column(
                //mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 60),
                  const Text(
                    "Final Year Project Evaluation Apps",
                    style: TextStyle(
                      color: Colors.indigo,
                      fontSize: 38,
                      fontWeight: FontWeight.bold,
                      //fontFamily: "Otomanopee", // Use the font family name
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20), // Add spacing between titles
                  const Text(
                    "Bachelor of Computing & Business Management with Honours",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 40),
                  Text(
                    "WELCOME, $fullName", // Display the full name
                    style: const TextStyle(
                      color: Colors.indigo,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 80),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          GestureDetector(
                            onTap: () {
                              // Navigate to STUDENTFYP1SV screen
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const STUDENTFYP1SV(),
                                ),
                              );
                            },
                            child: Padding(
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
                                          "FYP 1 Evaluation",
                                          style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        const SizedBox(height: 20),
                                        GestureDetector(
                                          onTap: () {
                                            // Navigate to STUDENTFYP1SV screen
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) => const STUDENTFYP1SV(),
                                              ),
                                            );
                                          },
                                          child: Image.asset(
                                            "assets/png_images/student.png",
                                            width: 80,
                                            height: 60,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(width: 20),
                          GestureDetector(
                            onTap: () {
                              // Navigate to STUDENTFYP2SV screen
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const STUDENTFYP2SV(),
                                ),
                              );
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(50),
                              child: Container(
                                padding: const EdgeInsets.all(40),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: const Color(0xFF45269C),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(30),
                            child: Container(
                              padding: const EdgeInsets.all(40),
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: const Color(0xFF45269C),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 20),
                          GestureDetector(
                            onTap: () {
                              // Navigate to STUDENTFYP2SV screen
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const STUDENTFYP2SV(),
                                ),
                              );
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(40),
                              child: Container(
                                padding: const EdgeInsets.all(40),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(color: Colors.blueGrey),
                                ),
                                child: Column(
                                  children: [
                                    const Text(
                                      "FYP 2 Evaluation",
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 20),
                                    GestureDetector(
                                      onTap: () {
                                        // Navigate to STUDENTFYP2SV screen
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => const STUDENTFYP2SV(),
                                          ),
                                        );
                                      },
                                      child: Image.asset(
                                        "assets/png_images/student.png",
                                        width: 80,
                                        height: 60,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWelcomeMessage(String message) {
    return ListTile(
      title: Text(
        message,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildMenuItem(String title) {
    return ListTile(
      title: Text(
        title,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
      onTap: () {
        if (title == 'Logout') {
          Navigator.push(context, MaterialPageRoute(builder: (context) => const WelcomeScreen()));
        } else if (title == 'Setting') {
          Navigator.push(context, MaterialPageRoute(builder: (context) => const SettingScreen()));
        } else if (title == 'FYP 1 Evaluation') {
          Navigator.push(context, MaterialPageRoute(builder: (context) => const STUDENTFYP1SV()));
        } else if (title == 'FYP 2 Evaluation') {
          Navigator.push(context, MaterialPageRoute(builder: (context) => const STUDENTFYP2SV()));
        }
      },
    );
  }

  Widget _buildSubMenu(String title, List<String> subItems) {
    return ExpansionTile(
      title: Text(
        title,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
      children: subItems.map((subItem) {
        return ListTile(
          title: Text(
            subItem,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          onTap: () {
            if (subItem == 'FYP 1 Result') {
              Navigator.push(context, MaterialPageRoute(builder: (context) => const FYP1RESULTSV()));
            } else if (subItem == 'FYP 2 Result') {
              Navigator.push(context, MaterialPageRoute(builder: (context) => const FYP2RESULTSV()));
            }
          },
        );
      }).toList(),
    );
  }
}