import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:systemfyp/constant.dart';
import 'package:systemfyp/login.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RegistrationScreen extends StatefulWidget {
  static String id = "Registration_screen";

  const RegistrationScreen({super.key});

  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {

  TextEditingController fullNameController = TextEditingController();

  bool showSpinner = false;
  String email = '';
  String password = '';
  String fullName = '';
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;

  Future<void> addUserDetails(String fullName, String email, String password) async {
    await FirebaseFirestore.instance.collection('users').add({
      'full name': fullName.toUpperCase(),
      'email': email,
      'password': password,
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        // Add an AppBar with a leading back arrow button
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text('Sign Up'), // Set the title of the screen
        backgroundColor: Colors.purpleAccent, // Set the background color of the app bar
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            const SizedBox(
              height: 48.0,
            ),
            TextField(
              controller: fullNameController,
              textAlign: TextAlign.center,
              keyboardType: TextInputType.name,
              onChanged: (value) {
                setState(() {
                  fullName = value.toUpperCase(); // Convert to uppercase
                  fullNameController.text = fullName; // Update the controller's text
                });
              },
              decoration: kTextFieldDecoration.copyWith(hintText: 'Enter your full name'),
            ),

            const SizedBox(
              height: 15.0,
            ),

            TextField(
              textAlign: TextAlign.center,
              keyboardType: TextInputType.emailAddress,
              onChanged: (value) {
                email = value;
              },
              decoration:
              kTextFieldDecoration.copyWith(hintText: 'Enter your email '),
            ),

            const SizedBox(
              height: 18.0,
            ),
            TextField(
              textAlign: TextAlign.center,
              obscureText: true,
              onChanged: (value) {
                password = value;
              },
              decoration: kTextFieldDecoration.copyWith(
                  hintText: 'Enter your password '),
            ),

            const SizedBox(height: 24.0),
            ElevatedButton(
                child: const Text('Register'),
                onPressed: () async {
                  setState(() {
                    showSpinner = true;
                  });
                  //Create new Account
                  try {
                    await _auth.createUserWithEmailAndPassword(email: email, password: password)
                        .then((value)async {
                      // Get the user ID after successful registration
                      String userId = value.user!.uid;

                      // Store additional user information in Firestore
                      await addUserDetails(fullName, email, password);

                      setState(() {
                        showSpinner = false;
                      });

                      // ignore: use_build_context_synchronously
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const LoginScreen(),
                        ),
                      );
                      print('Successfully Created');
                    });
                  } catch (e) {
                    print(e);
                  }
                }),
            const SizedBox(height: 10), // Add vertical spacing between the "Login" and "Sign Up" phrases
            Center(
              child: GestureDetector(
                onTap: () {
                  // Navigate to the sign-up screen
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const LoginScreen()),
                  );
                },
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      "Already have an account?",
                      style: TextStyle(
                        fontSize: 18.0,
                        color: Colors.black, // You can change the color to your preference
                      ),
                    ),
                    SizedBox(width: 8), // Add some spacing between the texts
                    Text(
                      "Login",
                      style: TextStyle(
                        fontSize: 18.0,
                        color: Colors.deepPurpleAccent,
                      ),
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