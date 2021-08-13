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
            child: ValueListenableBuilder<Box<LastTime>>(
          valueListenable: Hive.box<LastTime>('lastTimes').listenable(),
          builder: (context, box, widget) => lasTimeList(
              box.values.toList().reversed.toList().cast<LastTime>()),
        )),
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

Widget lasTimeList(List<LastTime> lastTimes) {
  if (lastTimes.isEmpty) {
    return Text(
      'No History yet',
      style: TextStyle(
          fontWeight: FontWeight.bold, fontSize: 30, color: Colors.red),
    );
  } else {
    return Column(
      children: <Widget>[
        SizedBox(height: 10),
        Text('History count : ${lastTimes.length} items',
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 30,
                color: Colors.lightBlue)),
        SizedBox(height: 30),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(10),
            itemCount: lastTimes.length,
            itemBuilder: (context, index) {
              final lastTime = lastTimes[index];
              return Card(
                  child: ListTile(
                leading: Container(
                  width: 48,
                  height: 48,
                  padding: const EdgeInsets.symmetric(vertical: 4.0),
                  alignment: Alignment.center,
                  child: const Icon(Icons.done),
                ),
                title: Text(
                  lastTime.job,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
                subtitle: Text(lastTime.category),
                trailing: IconButton(
                  onPressed: () {
                    print('clicked');
                  },
                  icon: Icon(Icons.more_vert),
                ),
                onTap: () {},
              ));
            },
          ),
        ),
      ],
    );
  }
}

Future addLastTime(String job, String category) async {
  final lastTime = LastTime()
    ..job = job
    ..category = category
    ..createdDate = DateTime.now();

  final box = Hive.box<LastTime>('lastTimes');
  box.add(lastTime);
  print('$box, $lastTime');
}
