import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:studio/models/course.dart';
import 'package:studio/models/subject.dart';
import 'package:studio/widgets/buttons.dart';

import '../constants.dart';
import '../courses_store.dart';

class EditSubjectScreen extends StatefulWidget {
  static final id = 'edit_subject_screen';
  CoursesStore store;
  Course course;
  Subject data;

  EditSubjectScreen(CoursesStore store, Course course, Subject data)
  {
    this.store = store;
    this.course = course;
    this.data = data;
  }

  @override
  _EditSubjectScreenState createState() => _EditSubjectScreenState();
}

class _EditSubjectScreenState extends State<EditSubjectScreen> {
  String name;
  String title = 'Add subject';
  TextEditingController textCtrl = TextEditingController();

  @override
  void initState() {
    if(widget.data != null) {
      textCtrl.text = widget.data.name;
      name = widget.data.name;
      title = 'Edit subject';
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.course.name),
        centerTitle: true,
        leading: Container(
            child: FlatButton(
              child: Icon(
                Icons.chevron_left,
                color: kDarkBlue,
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            )),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(22.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 16),
                child: Text(
                    title + ':',
                  style: TextStyle(
                    fontSize: 18
                  ),
                ),
              ),

              TextField(
                autocorrect: true,
                controller: textCtrl,
                decoration: InputDecoration(
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white, width: 0),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    border: OutlineInputBorder(
                      borderSide: BorderSide(width: 0, color: Colors.white),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(width: 0, color: Colors.white),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    hintText: 'Subject name',
                    fillColor: Colors.white,
                    filled: true,
                    contentPadding: EdgeInsets.all(8),
                    prefixIcon: Icon(Icons.chevron_right)),
                onChanged: (text) {
                  setState(() {
                    name = text;
                  });
                },
              ),
              Image(
                image: AssetImage('assets/images/new_doc.png'),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 20, 0, 10),
                child: PrimaryButton(
                  'Save', () {
                    var id = widget.data == null ? null : widget.data.id;
                    widget.store.saveSubject(id: id, name: name, courseId: widget.course.id);
                    Navigator.pop(context);
                  }
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
