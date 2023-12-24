import 'package:flutter/material.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({super.key});

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  bool darkModeEnabled = false;
  int? notificationFrequency = 1;

  void toggleDarkMode(bool value) {
    setState(() {
      darkModeEnabled = value;
    });
  }

  ThemeData _buildTheme() {
    if (darkModeEnabled) {
      return ThemeData.dark(); // Use a predefined dark theme
    } else {
      return ThemeData.light(); // Use a predefined light theme
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: _buildTheme(),
      home: Scaffold(
        appBar: AppBar(
          title: const Text("Setting"),
          backgroundColor: Colors.deepPurple,
          iconTheme: const IconThemeData(color: Colors.white),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "App Setting",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              ListTile(
                title: const Text("Dark Mode"),
                trailing: Switch(
                  value: darkModeEnabled,
                  onChanged: toggleDarkMode,
                ),
              ),
              ListTile(
                title: const Text("Notification Frequency"),
                trailing: DropdownButton<int>(
                  value: notificationFrequency,
                  onChanged: (int? value) {
                    setState(() {
                      notificationFrequency = value;
                    });
                    // Implement logic to update notification frequency here
                  },
                  items: const [
                    DropdownMenuItem<int>(
                      value: 1,
                      child: Text("Daily"),
                    ),
                    DropdownMenuItem<int>(
                      value: 2,
                      child: Text("Weekly"),
                    ),
                    // Add more options as needed
                  ],
                ),
              ),
              // Add more settings options as needed
            ],
          ),
        ),
      ),
    );
  }
}

void main() {
  runApp(const MaterialApp(
    home: SettingScreen(),
  ));
}