import 'package:flutter/material.dart';
import 'package:fitness_app/fitness_tracker_home_page.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Fitness Tracker',
      home: LoginPage(),
    );
  }
}
