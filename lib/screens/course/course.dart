import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:line_awesome_icons/line_awesome_icons.dart';
import 'package:studio/globals.dart';
import 'package:studio/widgets/subtitle.dart';

import '../colors.dart';
import '../constants.dart';
import 'edit_course.dart';

class CourseScreen extends StatefulWidget {

  static const id = "course";

  @override
  _CourseScreenState createState() => _CourseScreenState();
}

class _CourseScreenState extends State<CourseScreen> {

  @override
  void initState() {
    Globals.coursesStore.loadSubjects(courseId: Globals.coursesStore.course.id);
    super.initState();
  }

  @override
  Widget build(BuildContext context) => Observer( builder: (_) {
    return Scaffold(
      appBar: AppBar(
        title: Text(Globals.coursesStore.course.name),
        centerTitle: true,
        backgroundColor: kBackgroundColor,
        actions: <Widget>[
          PopupMenuButton<int>(
            onSelected: (int) {
              switch (int) {
                case kActionEdit:
                  Navigator.pushNamed(context, EditCourseScreen.id);
                  break;
                case kActionDelete:
                  showDialog(
                      context: context,
                      builder: (_) => AlertDialog(
                        title: Text('Confirm'),
                        content: Text('Do you really want to delete '
                            'course ${Globals.coursesStore.course.name} and all '
                            'its subjects, notes and questions?'),
                        actions: <Widget>[
                          FlatButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: Text('No'),
                          ),
                          FlatButton(
                            child: Text('Yes'),
                            textColor: Colors.red,
                            onPressed: () async {
                              Navigator.pop(context);
                              await Globals.coursesStore.deleteCourse(Globals.coursesStore.course.id);
                              Navigator.pop(context);
                            },
                          )
                        ],
                      ));
                  break;
                case kActionBooks:
                  break;
              }
            },
            //offset: Offset(0, 40),
            elevation: 20,
            itemBuilder: (context) => [
              PopupMenuItem(
                value: kActionBooks,
                child: Text(
                  "Books",
                  style: TextStyle(
                    //color: kDarkGrey,
                  ),
                ),
              ),
              PopupMenuItem(
                value: kActionEdit,
                child: Text(
                  "Edit course",
                  style: TextStyle(
                    //color: kDarkGrey,
                  ),
                ),
              ),
              PopupMenuItem(
                value: kActionDelete,
                child: Text(
                  "Delete course",
                  style: TextStyle(
                    color: Colors.red,
                  ),
                ),
              ),
            ],
            child: Icon(Icons.more_vert),
          ),
        ],
      ),
      backgroundColor: kBackgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.max,
              children: _widgets()
            ),
        ),
      ),
    );
  });

  List<Widget> _widgets() {
    var list = List<Widget>();
    if(Globals.coursesStore.isCourseLoading) {
      list.add(LinearProgressIndicator());
    }
    list.add(
        Container(
          child: Subtitle(text: 'Subjects',))
    );

    list.addAll(Globals.coursesStore.subjects.map( (s) => Card(
      child: Padding(
          padding: const EdgeInsets.all(8),
        child: ListTile(
          title: Text(s.name),
          trailing: Icon(Icons.chevron_right),
        ),
      ),
    )
      )
    );

    return list;
  }
}
