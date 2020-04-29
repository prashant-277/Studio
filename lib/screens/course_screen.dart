import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mobx/mobx.dart';
import 'package:studio/courses_store.dart';
import 'package:studio/models/course.dart';
import 'package:studio/models/subject.dart';
import 'package:studio/screens/subject_screen.dart';

import '../constants.dart';

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
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        iconTheme: IconThemeData(color: kDarkBlue),
        title: Text(
          widget.course.name,
          style: TextStyle(
            color: kDarkBlue,
            fontWeight: FontWeight.bold,
          ),
        ),
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
                              onTap: () => {}),
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
      ),
      body: SafeArea(
          child: Column(
            children: <Widget>[
              SizedBox(height: 20,),
              Expanded(
                child: SubjectItemsView(widget.store, widget.course),
              )
            ],
          )),
    );
  }
}

class SubjectItemsView extends StatelessWidget {
  const SubjectItemsView(this.store, this.course);

  final CoursesStore store;
  final Course course;

  @override
  // ignore: missing_return
  Widget build(BuildContext context) => Observer(builder: (_) {
    final future = store.subjectsFuture;

    switch (future.status) {
      case FutureStatus.pending:
        print("pending");
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              CircularProgressIndicator(),
              Text('Loading items...'),
            ],
          ),
        );

      case FutureStatus.rejected:
        print("rejected");
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'Failed to load items.',
              style: TextStyle(color: Colors.red),
            ),
          ],
        );

      case FutureStatus.fulfilled:
        print("fulfilled");
        final List<Subject> items = future.result;
        return RefreshIndicator(
          onRefresh: store.fetchCourses,
          child: ListView.builder(
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
              }),
        );
    }
  });
}

