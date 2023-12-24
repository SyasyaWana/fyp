import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:systemfyp/assessor.dart';
import 'package:systemfyp/assessor_admin.dart';
import 'package:systemfyp/dashboard_screen.dart';
import 'package:systemfyp/form1.dart';
import 'package:systemfyp/form2.dart';
import 'package:systemfyp/result_fyp1.dart';
import 'package:systemfyp/result_fyp2.dart';
import 'package:systemfyp/setting.dart';
import 'package:systemfyp/studentFYP1.dart';
import 'package:systemfyp/studentFYP2.dart';
import 'package:systemfyp/supervisor.dart';
import 'package:systemfyp/supervisor_admin.dart';
import 'package:systemfyp/welcome.dart';

class AdminScreen extends StatefulWidget {
  static String id = "admin_screen";

  const AdminScreen({Key? key}) : super(key: key);

  @override
  _AdminScreenState createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;
  late User loggedInUser;

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
        title: const Text("Admin"),
        backgroundColor: Colors.deepPurple,
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
          color: const Color(0xFF45269C), // Adjust the color as needed
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 40),
              _buildWelcomeMessage("WELCOME ADMIN"),
              const Divider(thickness: 1, color: Colors.white),
              _buildMenuItem("Dashboard"),
              _buildSubMenu("Change Role", ["Supervisor", "Assessor"]),
              _buildSubMenu("Manage Student", ["FYP 1", "FYP 2"]),
              _buildMenuItem("Manage Supervisor"),
              _buildMenuItem("Manage Assessor"),
              _buildSubMenu("Manage Evaluation Criteria", ["FYP 1 Form", "FYP 2 Form"]),
              _buildSubMenu("View Student Result", ["FYP 1 Result", "FYP 2 Result"]),
              const Divider(thickness: 1, color: Colors.white),
              _buildMenuItem("Setting"),
              _buildMenuItem("Logout"),
            ],
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Row(
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
                      color: Colors.deepPurple,
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
                  const SizedBox(height: 90),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          GestureDetector(
                            onTap: () {
                              // Navigate to FYP1STUDENT screen
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const FYP1STUDENT(),
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
                                          "Manage Student FYP 1",
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        const SizedBox(height: 20),
                                        GestureDetector(
                                          onTap: () {
                                            // Navigate to FYP1STUDENT screen
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) => const FYP1STUDENT(),
                                              ),
                                            );
                                          },
                                          child: Image.asset(
                                            "assets/png_images/student.png",
                                            width: 60,
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
                          const SizedBox(width: 10),
                          GestureDetector(
                            onTap: () {
                              // Navigate to FYP2STUDENT screen
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const FYP2STUDENT(),
                                ),
                              );
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(30),
                              child: Container(
                                padding: const EdgeInsets.all(40),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(color: Colors.blueGrey),
                                ),
                                child: Column(
                                  children: [
                                    const Text(
                                      "Manage Student FYP 2",
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 20),
                                    GestureDetector(
                                      onTap: () {
                                        // Navigate to FYP2STUDENT screen
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => const FYP2STUDENT(),
                                          ),
                                        );
                                      },
                                      child: Image.asset(
                                        "assets/png_images/student.png",
                                        width: 60,
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
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          GestureDetector(
                            onTap: () {
                              // Navigate to AssessorAdmin screen
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const AssessorAdmin(),
                                ),
                              );
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(30),
                              child: Container(
                                padding: const EdgeInsets.all(50),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(color: Colors.blueGrey),
                                ),
                                child: Column(
                                  children: [
                                    const Text(
                                      "Manage Assessor",
                                      style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 20),
                                    GestureDetector(
                                      onTap: () {
                                        // Navigate to AssessorAdmin screen
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => const AssessorAdmin(),
                                          ),
                                        );
                                      },
                                      child: Image.asset(
                                        "assets/png_images/coordinator.png",
                                        width: 60,
                                        height: 60,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 20),
                          GestureDetector(
                            onTap: () {
                              // Navigate to SupervisorAdmin screen
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const SupervisorAdmin(),
                                ),
                              );
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(30),
                              child: Container(
                                padding: const EdgeInsets.all(50),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(color: Colors.blueGrey),
                                ),
                                child: Column(
                                  children: [
                                    const Text(
                                      "Manage Supervisor",
                                      style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 20),
                                    GestureDetector(
                                      onTap: () {
                                        // Navigate to SupervisorAdmin screen
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => const SupervisorAdmin(),
                                          ),
                                        );
                                      },
                                      child: Image.asset(
                                        "assets/png_images/Ellipse 8.png",
                                        width: 60,
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
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const Form1(),
                                ),
                              );
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(30),
                              child: Container(
                                padding: const EdgeInsets.all(50),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(color: Colors.blueGrey),
                                ),
                                child: Column(
                                  children: [
                                    const Text(
                                      "Manage Evaluation",
                                      style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const Text(
                                      "Form FYP 1",
                                      style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 20),
                                    GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => const Form1(),
                                          ),
                                        );
                                      },
                                      child: Image.asset(
                                        "assets/png_images/Ellipse 12.png",
                                        width: 60,
                                        height: 60,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 20),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const Form2(),
                                ),
                              );
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(30),
                              child: Container(
                                padding: const EdgeInsets.all(50),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(color: Colors.blueGrey),
                                ),
                                child: Column(
                                  children: [
                                    const Text(
                                      "Manage Evaluation",
                                      style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const Text(
                                      "Form FYP 2",
                                      style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 20),
                                    GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => const Form2(),
                                          ),
                                        );
                                      },
                                      child: Image.asset(
                                        "assets/png_images/Ellipse 12.png",
                                        width: 60,
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
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const FYP1RESULT(),
                                ),
                              );
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(30),
                              child: Container(
                                padding: const EdgeInsets.all(50),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(color: Colors.blueGrey),
                                ),
                                child: Column(
                                  children: [
                                    const Text(
                                      "View Student Result",
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const Text(
                                      "FYP 1",
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 20),
                                    GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => const FYP1RESULT(),
                                          ),
                                        );
                                      },
                                      child: Image.asset(
                                        "assets/png_images/Ellipse 7.png",
                                        width: 60,
                                        height: 60,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 20),
                          GestureDetector(
                            onTap: () {
                              // Navigate to SupervisorAdmin screen
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const FYP2RESULT(),
                                ),
                              );
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(30),
                              child: Container(
                                padding: const EdgeInsets.all(50),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(color: Colors.blueGrey),
                                ),
                                child: Column(
                                  children: [
                                    const Text(
                                      "View Student Result",
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const Text(
                                      "FYP 2",
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 20),
                                    GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => const FYP2RESULT(),
                                          ),
                                        );
                                      },
                                      child: Image.asset(
                                        "assets/png_images/Ellipse 7.png",
                                        width: 60,
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
        if (title == 'Dashboard') {
          Navigator.push(context, MaterialPageRoute(builder: (context) => DashboardScreen()));
        } else if (title == 'Setting') {
          Navigator.push(context, MaterialPageRoute(builder: (context) => const SettingScreen()));
        } else if (title == 'Logout') {
          Navigator.push(context, MaterialPageRoute(builder: (context) => const WelcomeScreen()));
        } else if (title == 'Manage Assessor') {
          Navigator.push(context, MaterialPageRoute(builder: (context) => const AssessorAdmin()));
        } else if (title == 'Manage Supervisor') {
          Navigator.push(context, MaterialPageRoute(builder: (context) => const SupervisorAdmin()));
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
            if (subItem == 'FYP 1') {
              Navigator.push(context, MaterialPageRoute(builder: (context) => const FYP1STUDENT()));
            } else if (subItem == 'FYP 2') {
              Navigator.push(context, MaterialPageRoute(builder: (context) => const FYP2STUDENT()));
            } else if (subItem == 'FYP 1 Form') {
              Navigator.push(context, MaterialPageRoute(builder: (context) => const Form1()));
            }  else if (subItem == 'FYP 2 Form') {
              Navigator.push(context, MaterialPageRoute(builder: (context) => const Form2()));
            } else if (subItem == 'FYP 1 Result') {
              Navigator.push(context, MaterialPageRoute(builder: (context) => const FYP1RESULT()));
            } else if (subItem == 'FYP 2 Result') {
              Navigator.push(context, MaterialPageRoute(builder: (context) => const FYP2RESULT()));
            } else if (subItem == 'Supervisor') {
              Navigator.push(context, MaterialPageRoute(builder: (context) => const SupervisorScreen()));
            } else if (subItem == 'Assessor') {
              Navigator.push(context, MaterialPageRoute(builder: (context) => const AssessorScreen()));
            }
          },
        );
      }).toList(),
    );
  }
}

