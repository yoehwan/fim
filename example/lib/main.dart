import 'package:fim/fim.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: FimExample(),
    );
  }
}

class FimExample extends StatelessWidget {
  FimExample({Key? key}) : super(key: key);

  final FimController controller = FimController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 32,
        ),
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Fim(
              controller: controller,
              lineNumber: true,
            ),
          ),
        ),
      ),
    );
  }
}
