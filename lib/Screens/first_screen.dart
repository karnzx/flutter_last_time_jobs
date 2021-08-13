import 'package:flutter/material.dart';
import 'package:flutter_hive_navigate/models/last_time.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'second_screen.dart';
import 'package:intl/intl.dart';

class FirstScreen extends StatefulWidget {
  static const routeName = '/firstScreen';

  const FirstScreen({Key? key}) : super(key: key);

  @override
  _FirstScreenState createState() => _FirstScreenState();
}

class _FirstScreenState extends State<FirstScreen> {
  late String _selectedCategory;
  final List<String> categoryItems = [
    'all',
    'Work',
    'HomeWork',
    'Cooking',
    'Bed Room',
    'Bath Room',
    'Other',
  ];

  @override
  void initState() {
    super.initState();
    _selectedCategory = categoryItems.elementAt(0);
  }

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
        body: Column(
          children: [
            SizedBox(height: 15),
            categoryDropdown(),
            Expanded(
              child: ValueListenableBuilder<Box<LastTime>>(
                valueListenable: Hive.box<LastTime>('lastTimes').listenable(),
                builder: (context, box, widget) =>
                    lastTimeList(box.values.toList().cast<LastTime>()),
              ),
            ),
          ],
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

  Widget lastTimeList(List<LastTime> lastTimes) {
    var items = lastTimes;
    if (_selectedCategory != categoryItems.first) {
      items = lastTimes
          .where((lastTime) => lastTime.category == _selectedCategory)
          .toList();
    }
    if (lastTimes.isEmpty) {
      return Center(
        child: Text(
          'No History yet',
          style: TextStyle(
              fontWeight: FontWeight.bold, fontSize: 30, color: Colors.red),
        ),
      );
    } else {
      return Column(
        children: <Widget>[
          SizedBox(height: 10),
          Text('All items count : ${lastTimes.length} items',
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 30,
                  color: Colors.lightBlue)),
          SizedBox(height: 30),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(10),
              itemCount: items.length,
              itemBuilder: (context, index) {
                final lastTime = items.reversed.elementAt(index);
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
                  child: ListTile(
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
                    trailing: IconButton(
                      onPressed: () => showDialog(
                        context: context,
                        builder: (context) => buildDialog(context,
                            title: 'Delete lastTime | Are you Sure?',
                            onDone: lastTime.delete),
                      ),
                      icon: Icon(
                        Icons.delete_forever,
                        color: Colors.white,
                      ),
                    ),
                    subtitle: RichText(
                      text: TextSpan(
                        style: DefaultTextStyle.of(context).style,
                        children: <TextSpan>[
                          TextSpan(
                              text: '${lastTime.category}',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white70,
                                  fontSize: 17)),
                          TextSpan(
                              text: ' -- ',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white70)),
                          TextSpan(
                              text:
                                  '${DateFormat.yMd().format(lastTime.timeStamp.last)}',
                              style: TextStyle(
                                  color: Colors.white70, fontSize: 17)),
                        ],
                      ),
                    ),
                    onTap: () => showDialog(
                      context: context,
                      builder: (context) => detailDialog(context, lastTime),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      );
    }
  }

  Widget detailDialog(BuildContext context, LastTime lastTime) {
    var timeStamp = lastTime.timeStamp.reversed.toList();
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      title: Text(lastTime.job,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30)),
      content: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            RichText(
              text: TextSpan(
                style: DefaultTextStyle.of(context).style,
                children: <TextSpan>[
                  TextSpan(
                      text: 'Category : ',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
                  TextSpan(
                      text: '${lastTime.category}',
                      style: TextStyle(fontSize: 20)),
                ],
              ),
            ),
            SizedBox(width: 20),
            Container(
              height: 100.0,
              width: 200.0,
              child: ListView.builder(
                padding: const EdgeInsets.all(10),
                itemCount: timeStamp.length,
                itemBuilder: (context, index) {
                  return Text(
                      '${DateFormat.yMd().add_jm().format(timeStamp.elementAt(index))}');
                },
              ),
            )
          ],
        ),
      ),
      actions: [
        ElevatedButton(
          onPressed: () => showDialog(
              context: context,
              builder: (context) =>
                  buildDialog(context, title: 'Are you sure?', onDone: () {
                    lastTime.timeStamp.add(DateTime.now());
                    lastTime.save();
                    Navigator.of(context).pop();
                  })),
          child: Align(
              alignment: Alignment.bottomCenter,
              child: Text(
                'Stamp Time',
                textAlign: TextAlign.center,
              )),
          style: ElevatedButton.styleFrom(
              primary: Colors.green,
              textStyle: TextStyle(fontWeight: FontWeight.bold)),
        )
      ],
    );
  }

  Widget buildDialog(BuildContext context,
      {required String title, required Function onDone}) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      title: Text(title),
      actions: [
        ElevatedButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text('No'),
          style: ElevatedButton.styleFrom(
              primary: Colors.blueGrey,
              textStyle: TextStyle(fontWeight: FontWeight.bold)),
        ),
        ElevatedButton(
          onPressed: () {
            onDone();
            Navigator.of(context).pop();
          },
          child: Text('Yes'),
          style: ElevatedButton.styleFrom(
              primary: Colors.red,
              textStyle: TextStyle(fontWeight: FontWeight.bold)),
        )
      ],
    );
  }

  Future addLastTime(String job, String category) async {
    final lastTime = LastTime()
      ..job = job
      ..category = category
      ..createdDate = DateTime.now()
      ..timeStamp.add(DateTime.now());

    final box = Hive.box<LastTime>('lastTimes');
    box.add(lastTime);
    print('$box, $lastTime');
  }

  Widget categoryDropdown() {
    return Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          const Text('Category',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
          Container(
            margin: const EdgeInsets.all(15),
            padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.deepPurple)),
            child: DropdownButtonHideUnderline(
              child: DropdownButton(
                isExpanded: true,
                value: _selectedCategory,
                icon: const Icon(Icons.arrow_drop_down),
                iconSize: 24,
                elevation: 16,
                style: const TextStyle(color: Colors.black),
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedCategory = newValue!;
                  });
                },
                items:
                    categoryItems.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
            ),
          ),
        ]);
  }
}
