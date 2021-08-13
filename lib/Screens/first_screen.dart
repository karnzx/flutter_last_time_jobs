import 'package:flutter/material.dart';
import 'package:flutter_hive_navigate/models/last_time.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'second_screen.dart';

class FirstScreen extends StatefulWidget {
  static const routeName = '/firstScreen';

  const FirstScreen({Key? key}) : super(key: key);

  @override
  _FirstScreenState createState() => _FirstScreenState();
}

class _FirstScreenState extends State<FirstScreen> {
  @override
  void dispose() {
    Hive.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Last Time History'),
        ),
        body: Center(
            child: Column(
          children: [
            Text('hell'),
          ],
        )
            // child: ElevatedButton(
            //   // Within the `FirstScreen` widget
            //   onPressed: () {
            //     // Navigate to the second screen using a named route.
            //     Navigator.pushNamed(context, SecondScreen.routeName,
            //         arguments: 'args');
            //   },
            //   child: const Text('Launch screen'),
            // ),
            ),
        floatingActionButton: FloatingActionButton(
          elevation: 10,
          tooltip: 'add',
          child: Icon(
            Icons.add,
            size: 40.0,
            color: Colors.white,
          ),
          onPressed: () => showDialog(
            context: context,
            builder: (context) => SecondScreen(onFinish: addLastTime),
          ),
        ));
  }
}

Future addLastTime(String job, String category) async {
  final lastTime = LastTime()
    ..job = job
    ..category = category
    ..createdDate = DateTime.now();

  final box = Hive.box<LastTime>('lastTimes');
  box.add(lastTime);
}
