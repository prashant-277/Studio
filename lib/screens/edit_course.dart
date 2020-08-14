import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:studio/globals.dart';
import 'package:studio/icons.dart';
import 'package:studio/models/course.dart';
import 'package:studio/widgets/label.dart';

import '../colors.dart';

class EditCourseScreen extends StatefulWidget {

  static const id = 'edit_course';
  final Course data;

  EditCourseScreen({ this.data });

  @override
  _EditCourseScreenState createState() => _EditCourseScreenState();
}

class _EditCourseScreenState extends State<EditCourseScreen> {

  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  String selectedIcon;
  String name;

  Widget iconButton(String icon) {

    List<Widget> widgets = List();
    if(selectedIcon == icon) {
      widgets.add(
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          bottom: 0,
          child: Container(
            decoration: BoxDecoration(
              color: kAccentColor,
              shape: BoxShape.circle,
            ),
        )        
      ));
    }

    widgets.add(      
      Image(
        image: AssetImage('assets/icons/$icon'),
      )
    );

    return FlatButton(
      child: Stack(
        fit: StackFit.loose,
        children: widgets
      ),
      onPressed: () {
        setState(() {
          selectedIcon = icon;
        });
      },
    ); 
  }

  _displaySnackBar(BuildContext context, String text) {
    final snackBar = SnackBar(content: Text(text));
    _scaffoldKey.currentState.showSnackBar(snackBar);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(widget.data == null ? 'Add course' : 'Edit course'),
      ),
      backgroundColor: kBackgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(
              horizontal: 16
          ),
          child: Form(
            key: _formKey,
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    TextFormField(
                      autofocus: true,
                      decoration: InputDecoration(
                          labelText: 'Enter the name of the course'
                      ),
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please enter some text';
                        }
                        return null;
                      },
                      onChanged: (text) {
                        setState(() {
                          name = text;
                        });
                      },
                    ),
                    Label(text: 'Choose an icon:',
                      padding: const EdgeInsets.symmetric(
                        vertical: 12
                      ),
                    ),
                    GridView.count(
                      crossAxisCount: 4,
                      shrinkWrap: true,
                      children: kIcons.map((e) => iconButton(e)).toList(),
                    ),
                  ]
              ),
          ),
        )
      ),
      bottomNavigationBar: BottomAppBar(
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              FlatButton(
                child: Text('SAVE'),
                onPressed: () async {
                  if(selectedIcon == null) {
                    _displaySnackBar(context, 'Choose an icon');
                    return;
                  }
                  if (_formKey.currentState.validate()) {

                    Course course = Course();
                    course.name = name;
                    course.icon = selectedIcon;
                    if(widget.data != null)
                      course.id = widget.data.id;

                    final ProgressDialog pr = _getProgress(context);
                    pr.update(message: "Please wait...");
                    await pr.show();
                    Globals.coursesStore.saveCourse(course).then((value) async {
                      await Globals.authStore.loadStats();
                      pr.hide();
                      Globals.coursesStore.loadCourses().then((value) => Navigator.pop(context));
                    });
                  }
                },
                color: kAccentColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18.0),
                ),
              )
            ],
          )
      ),
    );
  }

  ProgressDialog _getProgress(BuildContext context) {
    return ProgressDialog(context);
  }
}
