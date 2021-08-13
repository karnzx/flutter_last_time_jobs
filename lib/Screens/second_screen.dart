import 'package:flutter/material.dart';

class SecondScreen extends StatefulWidget {
  static const routeName = '/secondScreen';

  SecondScreen({Key? key}) : super(key: key);

  @override
  _SecondScreenState createState() => _SecondScreenState();
}

class _SecondScreenState extends State<SecondScreen> {
  @override
  Widget build(BuildContext context) {
    // final arg = ModalRoute.of(context)?.settings.arguments ?? 'no arguments';
    // print(arg);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Screen'),
      ),
      body: Center(
        child: ElevatedButton(
          // Within the SecondScreen widget
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text('Go back!'),
        ),
      ),
    );
  }
}
