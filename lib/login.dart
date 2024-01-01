import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:systemfyp/admin.dart';
import 'package:systemfyp/constant.dart';
import 'package:systemfyp/setrole.dart';
import 'package:systemfyp/signup.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';

class LoginScreen extends StatefulWidget {
  static String id = "login_screen";

  const LoginScreen({Key? key}) : super(key: key);

  @override
  LoginScreenState createState() => LoginScreenState();
}

class LoginScreenState extends State<LoginScreen> {
  bool showSpinner = false;
  String email = '';
  String password = '';
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    final FirebaseAnalytics analytics = FirebaseAnalytics.instance;
    final FirebaseAnalyticsObserver observer = FirebaseAnalyticsObserver(analytics: analytics);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text('Login'),
        backgroundColor: Colors.deepPurple, // Set the background color of the app bar
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            TextField(
              textAlign: TextAlign.center,
              keyboardType: TextInputType.emailAddress,
              onChanged: (value) {
                email = value;
              },
              decoration: kTextFieldDecoration.copyWith(hintText: 'Enter your email '),
            ),
            const SizedBox(
              height: 8.0,
            ),
            TextField(
              textAlign: TextAlign.center,
              obscureText: true,
              onChanged: (value) {
                password = value;
              },
              decoration: kTextFieldDecoration.copyWith(hintText: 'Enter your password '),
            ),
            const SizedBox(
              height: 24.0,
            ),
            ElevatedButton(
              child: const Text('Login'),
              onPressed: () async {
                setState(() {
                  showSpinner = true;
                });

                try {
                  await _auth.signInWithEmailAndPassword(email: email, password: password).then((value) {
                    setState(() {
                      showSpinner = false;
                    });

                    analytics.logEvent(
                      name: 'login_success',
                      parameters: <String, dynamic>{
                        'user_email': email,
                      },
                    );
                    if (email == 'inurina@unikl.edu.my' && password == '123456') {
                      // Navigate to SetRoleScreen for admin
                      Navigator.push(context, MaterialPageRoute(builder: (context) => SetRoleScreen(userEmail: email))).then((value) {
                        // After SetRoleScreen, allow user to click and display AdminScreen
                        Navigator.push(context, MaterialPageRoute(builder: (context) => const AdminScreen()));
                      });
                    } else {
                      // For other users, navigate to SetRoleScreen directly
                      Navigator.push(context, MaterialPageRoute(builder: (context) => SetRoleScreen(userEmail: email))).then((value) {
                        // Handle the completion if needed
                      });
                    }

                    print('Successfully Logged In');

                  });
                } catch (e) {
                  analytics.logEvent(
                    name: 'login_failure',
                    parameters: <String, dynamic>{
                      'user_email': email,
                      'error_message': e.toString(),
                    },
                  );
                  print(e);
                }
              },
            ),
            const SizedBox(height: 10),
            Center(
              child: GestureDetector(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const RegistrationScreen()));
                },
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      "No account?",
                      style: TextStyle(
                        fontSize: 18.0,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(width: 8),
                    Text(
                      "Sign Up",
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