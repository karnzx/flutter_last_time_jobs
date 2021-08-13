import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'Screens/first_screen.dart';
import 'Screens/second_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  // var box = await Hive.openBox('settings');
  // print('${box.length}, ${box.isNotEmpty}');
  // for (var i in box.keys) {
  //   print('Name: ${box.get(i)}');
  // }
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter | Hive & Navigate',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      // home: MyHomePage(title: 'HomePage'),
      initialRoute: FirstScreen.routeName,
      routes: {
        FirstScreen.routeName: (context) => const FirstScreen(),
        SecondScreen.routeName: (context) => const SecondScreen(),
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _currentIndex = 0;
  final List<List> _widgetScreens = [
    // group of screens and its buttons
    [
      FirstScreen(),
      BottomNavigationBarItem(icon: Icon(Icons.home), label: 'First Screen'),
    ],
    [
      SecondScreen(),
      BottomNavigationBarItem(
          icon: Icon(Icons.favorite), label: 'Second Screen'),
    ]
  ];

  void onItemTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _widgetScreens.elementAt(_currentIndex).elementAt(0),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        fixedColor: Colors.deepPurple,
        onTap: (index) {
          onItemTapped(index);
        },
        items: List.generate(_widgetScreens.length,
            (index) => _widgetScreens[index][1] as BottomNavigationBarItem),
      ),
    );
  }
}
