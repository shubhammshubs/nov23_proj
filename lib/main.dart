import 'package:flutter/material.dart';

import 'User_Credential/Login.dart';
import 'User_Credential/Signup_Screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Curd Operation',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: RegistrationPage(mobileNumber: '',),
    );
  }
}