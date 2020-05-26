import 'package:flutter/material.dart';
import 'package:line_awesome_icons/line_awesome_icons.dart';
import 'package:studio/models/course.dart';
import 'package:studio/screens/subjects/subjects_screen.dart';
import 'package:studio/widgets/course_title.dart';
import 'package:studio/widgets/drawer.dart';
import 'package:studio/widgets/shadow_container.dart';

import '../../constants.dart';
import '../../courses_store.dart';
import '../books_screen.dart';
import 'edit_course_screen.dart';

class CourseScreen extends StatefulWidget {
  final String id = "course_screen";
  final CoursesStore store;
  final Course course;

  const CourseScreen(this.store, this.course);

  @override
  _CourseScreenState createState() => _CourseScreenState();
}

class _CourseScreenState extends State<CourseScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: MainDrawer(widget.store),
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        iconTheme: IconThemeData(color: kDarkBlue),
        title: CourseTitle(widget.store, widget.course),
        backgroundColor: kLightGrey,
        actions: <Widget>[
          PopupMenuButton<int>(
            onSelected: (int) {
              switch (int) {
                case kActionEdit:
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              EditCourseScreen(widget.store, widget.course)));
                  break;
                case kActionDelete:
                  showDialog(
                      context: context,
                      builder: (_) => AlertDialog(
                            title: Text('Confirm'),
                            content: Text('Do you really want to delete '
                                'course ${widget.course.name} and all '
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
                                  await widget.store
                                      .deleteCourse(widget.course.id);
                                  Navigator.pop(context);
                                },
                              )
                            ],
                          ));
                  break;
                case kActionBooks:
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              BooksScreen(widget.store, widget.course)));
                  break;
              }
            },
            offset: Offset(0, 40),
            elevation: 20,
            itemBuilder: (context) => [
              PopupMenuItem(
                value: kActionBooks,
                child: Text(
                  "Books",
                  style: TextStyle(
                    color: kDarkGrey,
                  ),
                ),
              ),
              PopupMenuItem(
                value: kActionEdit,
                child: Text(
                  "Edit course",
                  style: TextStyle(
                    color: kDarkGrey,
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
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(0, 30, 0, 0),
          child: Column(
            children: <Widget>[
              CourseScreenItem(
                title: 'Subjects',
                icon: LineAwesomeIcons.graduation_cap,
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(
                      builder: (context) => SubjectsScreen(widget.store, widget.course)
                  ));
                },
              ),
              CourseScreenItem(
                title: 'Books',
                icon: LineAwesomeIcons.book,
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(
                      builder: (context) => BooksScreen(widget.store, widget.course)
                  ));
                },
              ),
              CourseScreenItem(
                title: 'Test',
                icon: LineAwesomeIcons.list_ol,
                onTap: () {

                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CourseScreenItem extends StatelessWidget {

  final String title;
  final IconData icon;
  final Function onTap;

  CourseScreenItem({ this.title, this.icon, this.onTap });

  @override
  Widget build(BuildContext context) {
    return ShadowContainer(
      padding: EdgeInsets.symmetric(vertical: 22, horizontal: 0),
      child: ListTile(
        leading: CircleAvatar(
          child: Icon(
            icon,
            size: 30,
          ),
          radius: 30,
          backgroundColor: Colors.blueGrey.shade900,
          foregroundColor: Colors.white,
        ),
        title: Text(
          title,
          style: TextStyle(fontSize: 20,
            color: kDarkBlue
          ),
        ),
        onTap: onTap,
      ),
    );
  }
}
