import 'package:flutter/material.dart';
import 'package:systemfyp/login.dart';
import 'package:systemfyp/signup.dart';

class WelcomeScreen extends StatefulWidget {
  static String id = "welcome_screen";

  const WelcomeScreen({super.key});

  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.purpleAccent,
        iconTheme: const IconThemeData(color: Colors.white),
        leading: null, // No back button
      ),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Align(
              alignment: Alignment.topCenter,
              child: Container(
                alignment: Alignment.topCenter,
                child: Image.asset(
                  "assets/png_images/logo.png",
                  width: 600,
                  height: 300,
                ),
              ),
            ),
            // Add 100 units of space below the logo
            const SizedBox(height: 40),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildImageWithLabel("assets/png_images/admin.png", "Admin"),
                _buildImageWithLabel("assets/png_images/coordinator.png", "Coordinator"),
                _buildImageWithLabel("assets/png_images/supervisor.png", "Supervisor"),
                _buildImageWithLabel("assets/png_images/assessor.png", "Assessor"),
              ],
            ),
            const SizedBox(height: 30),
            const Center(
              child: DefaultTextStyle(
                style: TextStyle(
                  fontSize: 30.0,
                  fontWeight: FontWeight.w900,
                  color: Colors.deepPurple,
                ),
                child: Text('Final Year Student Evaluation Apps'),
              ),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: ((context) => const LoginScreen()),
                  ),
                );
              },
              child: const Text('Login'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: ((context) => const RegistrationScreen()),
                  ),
                );
              },
              child: const Text('Sign Up'),
            ),
          ],
        ),
      ),
    );
  }

  // You can define the _buildImageWithLabel function here
  Widget _buildImageWithLabel(String imagePath, String label) {
    return Column(
      children: [
        Image.asset(
          imagePath,
          width: 130,
          height: 150,
        ),
        Text(label),
      ],
    );
  }
}