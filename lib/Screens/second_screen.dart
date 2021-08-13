import 'package:flutter/material.dart';
import 'package:flutter_hive_navigate/models/last_time.dart';

class SecondScreen extends StatefulWidget {
  final LastTime? lastTime;
  final Function onFinish;
  // static const routeName = '/secondScreen';

  SecondScreen({
    Key? key,
    this.lastTime,
    required this.onFinish,
  }) : super(key: key);

  @override
  _SecondScreenState createState() => _SecondScreenState();
}

class _SecondScreenState extends State<SecondScreen> {
  final jobController = TextEditingController();
  final List<String> categoryItems = [
    'Work',
    'HomeWork',
    'Cooking',
    'Bed Room',
    'Bath Room',
    'Other',
  ];
  late String _selectedCategory;

  @override
  void initState() {
    super.initState();
    _selectedCategory = categoryItems.elementAt(0);
  }

  @override
  Widget build(BuildContext context) {
    // final args = ModalRoute.of(context)?.settings.arguments as Map;
    // final onFinish = args['onFinish'];
    // final isEditing = args['lastTime'] != null;
    // final title = isEditing ? 'Edit LastTime' : 'Add LasTime';
    // print('$onFinish \n $title');

    final isEditing = widget.lastTime != null;
    final title = isEditing ? 'Edit LastTime' : 'Add LastTime';
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      title: Text(
        title,
        textAlign: TextAlign.center,
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
      ),
      buttonPadding: const EdgeInsets.only(right: 24),
      elevation: 24.0,
      content: Form(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            jobField(),
            SizedBox(height: 10),
            categoryDropdown(),
          ],
        ),
      ),
      actions: <Widget>[
        cancelButton(context),
        addButton(context, isEditing: isEditing),
      ],
    );
  }

  Widget categoryDropdown() {
    return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          const Text('Category', style: TextStyle(fontWeight: FontWeight.bold)),
          Container(
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

  Widget jobField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const Text('Job', style: TextStyle(fontWeight: FontWeight.bold)),
        TextFormField(
          controller: jobController,
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            hintText: 'Enter Job Name',
          ),
        )
      ],
    );
  }

  Widget cancelButton(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        Navigator.of(context).pop();
      },
      child: Text('Cancel'),
      style: ElevatedButton.styleFrom(
          primary: Colors.black.withOpacity(0.8),
          textStyle: TextStyle(fontWeight: FontWeight.bold)),
    );
  }

  Widget addButton(BuildContext context, {required bool isEditing}) {
    final text = isEditing ? 'Save' : 'Add';

    return ElevatedButton(
      child: Text(text),
      onPressed: () async {
        final job = jobController.text;
        print('job name $job');
        print('cateogry $_selectedCategory');
        widget.onFinish(job, _selectedCategory);

        Navigator.of(context).pop();
      },
      style: ElevatedButton.styleFrom(
          primary: Colors.green,
          textStyle: TextStyle(fontWeight: FontWeight.bold)),
    );
  }
}
