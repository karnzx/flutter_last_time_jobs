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
              return Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      gradient: LinearGradient(
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                        colors: [
                          Color(0xFF0D47A1),
                          Color(0xFF1976D2),
                          Color(0xFF42A5F5),
                        ],
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black,
                          blurRadius: 5,
                        )
                      ]),
                  child: Column(
                    children: [
                      ListTile(
                        leading: Container(
                          width: 48,
                          height: 48,
                          padding: const EdgeInsets.symmetric(vertical: 4.0),
                          alignment: Alignment.center,
                          child: const Icon(Icons.done, color: Colors.white),
                        ),
                        title: Text(
                          lastTime.job,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 22,
                            color: Colors.white,
                          ),
                        ),
                        subtitle: Text(lastTime.category,
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 15,
                            )),
                        trailing: IconButton(
                          onPressed: () {
                            print('three dot clicked');
                          },
                          icon: Icon(Icons.more_vert, color: Colors.white70),
                        ),
                        onTap: () {
                          print('tile clicked');
                        },
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          TextButton(
                            style: TextButton.styleFrom(
                              primary: Colors.white,
                              textStyle: const TextStyle(fontSize: 16),
                            ),
                            child: const Text('Edit'),
                            onPressed: () {},
                          ),
                          const SizedBox(width: 8),
                          TextButton(
                            style: TextButton.styleFrom(
                              primary: Colors.white,
                              textStyle: const TextStyle(fontSize: 16),
                            ),
                            child: const Text('Remove'),
                            onPressed: () {},
                          ),
                          const SizedBox(width: 8),
                        ],
                      )
                    ],
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
