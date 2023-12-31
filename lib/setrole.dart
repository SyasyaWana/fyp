import 'package:flutter/material.dart';
import 'package:systemfyp/admin.dart';
import 'package:systemfyp/assessor.dart';
import 'package:systemfyp/supervisor.dart';

class SetRoleScreen extends StatefulWidget {
  static String id = "setRole_screen";
  final String userEmail;

  const SetRoleScreen({Key? key, required this.userEmail}) : super(key: key);

  @override
  _SetRoleScreenState createState() => _SetRoleScreenState();
}

class _SetRoleScreenState extends State<SetRoleScreen> {
  String email = '';
  String password = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(" "),
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Row(
          children: [
            Expanded(
              child: Center(
                child: Column(
                  children: [
                    const SizedBox(height: 20),
                    const Text(
                      "Final Year Project Evaluation Apps",
                      style: TextStyle(
                        color: Colors.deepPurple,
                        fontSize: 38,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      "Bachelor of Computing & Business Management with Honours",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 50),
                    const Text(
                      "Select The Role",
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 25),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            GestureDetector(
                              onTap: () {
                                // Navigate to Supervisor screen
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const SupervisorScreen(),
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
                                        color: Colors.indigo, // Set the background color to indigo
                                        border: Border.all(color: Colors.indigo),
                                      ),
                                      child: Column(
                                        children: [
                                          const Text(
                                            "SUPERVISOR",
                                            style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white, // Set the text color to white
                                            ),
                                          ),
                                          const SizedBox(height: 10),
                                          Image.asset(
                                            "assets/png_images/supervisor.png",
                                            width: 80,
                                            height: 60,
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
                              onTap: () {},
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
                        const SizedBox(height: 10),
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
                                // Navigate to Assessor screen
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const AssessorScreen(),
                                  ),
                                );
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(40),
                                child: Container(
                                  padding: const EdgeInsets.all(40),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    color: Colors.purple, // Set the background color to indigo
                                    border: Border.all(color: Colors.purple),
                                  ),
                                  child: Column(
                                    children: [
                                      const Text(
                                        "ASSESSOR",
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                      ),
                                      const SizedBox(height: 10),
                                      Image.asset(
                                        "assets/png_images/assessor.png",
                                        width: 90,
                                        height: 60,
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
                                if (widget.userEmail == 'inurina@unikl.edu.my') {
                                  // Navigate to AdminScreen only for admin user
                                  Navigator.push(context, MaterialPageRoute(builder: (context) => const AdminScreen()));
                                } else {
                                  // Show a warning message or handle accordingly for non-admin users
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: const Text('Warning'),
                                        content: const Text('You do not have permission to access Admin Screen.'),
                                        actions: <Widget>[
                                          TextButton(
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                            child: const Text('OK'),
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                }
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(20),
                                child: Column(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.all(40),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(20),
                                        color: Colors.deepPurple, // Set the background color to indigo
                                        border: Border.all(color: Colors.deepPurple),
                                      ),
                                      child: Column(
                                        children: [
                                          const Text(
                                            "ADMIN",
                                            style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white,
                                            ),
                                          ),
                                          const SizedBox(height: 10),
                                          Image.asset(
                                            "assets/png_images/admin.png",
                                            width: 80,
                                            height: 60,
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
                              onTap: () {},
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
}