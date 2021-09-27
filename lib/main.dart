import 'package:flutter/material.dart';
import 'package:application_client/turn_angle_input.dart';
import 'package:application_client/speed_input.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Robot Grimpeur',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HomePage(title: 'Robot Grimpeur'),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  Widget build(BuildContext context) {
    bool isScreenWide = MediaQuery.of(context).size.width >= 600;

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Flex(
            mainAxisAlignment: MainAxisAlignment.center,
            direction: isScreenWide ? Axis.horizontal : Axis.vertical,
            children: const [TurnAngleInput(), SpeedInput()],
          ),
        ),
      ),
    );
  }
}
