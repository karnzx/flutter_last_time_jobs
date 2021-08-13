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
      title: Text(title),
      elevation: 24.0,
      content: Form(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            jobField(),
          ],
        ),
      ),
      actions: <Widget>[
        addButton(context, isEditing: isEditing),
      ],
    );
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

  Widget addButton(BuildContext context, {required bool isEditing}) {
    final text = isEditing ? 'Save' : 'Add';

    return TextButton(
      child: Text(text),
      onPressed: () async {
        final job = jobController.text;
        print(job);
        // widget.onFinish(
        //   job,
        // );

        Navigator.of(context).pop();
      },
    );
  }
}
