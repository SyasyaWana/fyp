import 'dart:async';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:systemfyp/admin.dart';
import 'package:systemfyp/assessor.dart';
import 'package:systemfyp/setrole.dart';
import 'package:systemfyp/supervisor.dart';
import 'package:systemfyp/welcome.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const AdminScreen(),
      debugShowCheckedModeBanner: false, // Add this line to hide the debug banner
    );
  }
}