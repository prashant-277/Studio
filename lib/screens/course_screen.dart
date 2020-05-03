import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mobx/mobx.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:studio/courses_store.dart';
import 'package:studio/models/course.dart';
import 'package:studio/models/subject.dart';
import 'package:studio/screens/edit_subject_screen.dart';
import 'package:studio/screens/subject_screen.dart';

import '../constants.dart';
import 'edit_course_screen.dart';

class CourseScreen extends StatefulWidget {
  final CoursesStore store;
  final Course course;
  static final id = 'course_screen';

  const CourseScreen(this.store, this.course);

  @override
  _CourseScreenState createState() => _CourseScreenState();
}

class _CourseScreenState extends State<CourseScreen>
    with SingleTickerProviderStateMixin {

  @override
  void initState() {
    widget.store.loadSubjects(widget.course.id);
    widget.store.loadCourse(widget.course.id);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        iconTheme: IconThemeData(color: kDarkBlue),
        title: CourseTitle(widget.store, widget.course),
        backgroundColor: kLightGrey,
        actions: <Widget>[
          FlatButton(
            child: Icon(
              Icons.more_vert
            ),
            onPressed: () {
              showModalBottomSheet(
                  context: context,
                  builder: (BuildContext bc) {
                    return Container(
                      child: new Wrap(
                        children: <Widget>[
                          new ListTile(
                              leading: new Icon(Icons.edit),
                              title: new Text('Edit course'),
                              onTap: () {
                                Navigator.pop(context);
                                Navigator.push(context, MaterialPageRoute(
                                    builder: (context) => EditCourseScreen(widget.store, widget.course)
                                ));
                              }),
                          new ListTile(
                            leading: new Icon(
                              Icons.delete_forever,
                              color: Colors.red,
                            ),
                            title: new Text(
                              'Delete course',
                              style: TextStyle(
                                  color: Colors.red,
                                fontWeight: FontWeight.w600
                              ),
                            ),
                            onTap: () => {},
                          ),
                        ],
                      ),
                    );
                  });
            },
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        backgroundColor: kPrimaryColor,
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(
              builder: (context) => EditSubjectScreen(widget.store, widget.course, null)
          ));
        },
      ),
      body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Container(
                margin: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
                padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withAlpha(10),
                        blurRadius: 20.0, // has the effect of softening the shadow
                        spreadRadius: 10.0, // has the effect of extending the shadow
                        offset: Offset(
                          0.0, // horizontal, move right 10
                          0.0, // vertical, move down 10
                        ),
                      )
                    ]
                ),
                child: Row(
                  children: <Widget>[
                    Image(
                      image: AssetImage('assets/icons/${widget.course.icon}'),
                      width: 50,
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          widget.course.name,
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w600,
                            color: kDarkBlue
                          ),
                        ),
                        Text(
                          '${widget.course.subjectsCount} subjects',
                          style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.normal,
                              color: kDarkBlue
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
              SizedBox(height: 20,),
              Expanded(
                child: SubjectItemsView(widget.store, widget.course),
              )
            ],
          ),
      ),
    );
  }
}

class CourseTitle extends StatelessWidget {

  final CoursesStore store;
  final Course course;
  const CourseTitle(this.store, this.course);

  @override
  Widget build(BuildContext context) => Observer(builder: (_) {
    final future = store.courseFuture;

    switch(future.status) {
      case FutureStatus.fulfilled:
        print("fullfilled");
        return Text(future.result.name);
        break;
      case FutureStatus.pending:
        print("pending");
        return Text(this.course.name);
      default:
        print("default");
        return Text(this.course.name);
    }
  });
}

class SubjectItemsView extends StatelessWidget {
  const SubjectItemsView(this.store, this.course);

  final CoursesStore store;
  final Course course;

  @override
  // ignore: missing_return
  Widget build(BuildContext context) => Observer(builder: (_) {

    return  ModalProgressHUD(
      color: kLightGrey,
      child: resultWidget(context, store.subjects),
      inAsyncCall: store.isSubjectsLoading,
    );
  });

  resultWidget(BuildContext context, List<Subject> items) {

    if(!store.isSubjectsLoading && items.length == 0) {
      return Column(
        children: <Widget>[
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'No subjects yet, let\'s start with the first one!',
                style: TextStyle(
                  fontSize: 18,
                ),
              ),
            ),
          ),
          Image(
            image: AssetImage('assets/images/study.png'),
          ),
          Expanded(
            child: Container(),
          )
        ],
      );
    }

    return ListView.builder(
        physics: const AlwaysScrollableScrollPhysics(),
        itemCount: items.length,
        itemBuilder: (_, index) {
          final item = items[index];
          return Padding(
            padding: const EdgeInsets.symmetric(
                vertical: 4,
                horizontal: 10
            ),
            child: Container(
              child: ListTile(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(
                      builder: (context) => SubjectScreen(store, course, item)
                  ));
                },

                trailing: const Icon(
                  Icons.chevron_right,
                  color: kDarkBlue,
                ),
                title: Container(
                  child: Text(
                    item.name,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
          );
        });
  }
}

