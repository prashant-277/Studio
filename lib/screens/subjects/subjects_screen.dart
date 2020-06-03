import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:line_awesome_icons/line_awesome_icons.dart';
import 'package:mobx/mobx.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:studio/courses_store.dart';
import 'package:studio/models/course.dart';
import 'package:studio/models/subject.dart';
import 'package:studio/screens/books_screen.dart';
import 'package:studio/screens/home_screen.dart';
import 'package:studio/screens/subjects/edit_subject_screen.dart';
import 'package:studio/screens/subjects/subject_screen.dart';
import 'package:studio/widgets/course_title.dart';
import 'package:studio/widgets/drawer.dart';
import 'package:studio/widgets/main_navigation_bar.dart';

import '../../constants.dart';
import '../courses/courses_screen.dart';
import '../edit_book_screen.dart';
import '../courses/edit_course_screen.dart';

class SubjectsScreen extends StatefulWidget {
  final CoursesStore store;
  static final id = 'subjects_screen';

  const SubjectsScreen(this.store);

  @override
  _SubjectsScreenState createState() => _SubjectsScreenState();
}

class _SubjectsScreenState extends State<SubjectsScreen>
    with SingleTickerProviderStateMixin {
  @override
  void initState() {
    widget.store.loadSubjects(widget.store.course.id);
    //widget.store.loadCourse(widget.store.course.id);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //drawer: MainDrawer(widget.store),
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        iconTheme: IconThemeData(color: kDarkBlue),
        title: CourseTitle(widget.store, widget.store.course, kContrastDarkColor),
        backgroundColor: kLightGrey,
        actions: <Widget>[
          PopupMenuButton<int>(
            onSelected: (int) {
              switch(int) {
                case kActionEdit:
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => EditCourseScreen(
                              widget.store, widget.store.course)));
                  break;
                case kActionDelete:
                  showDialog(
                      context: context,
                      builder: (_) => AlertDialog(
                        title: Text('Confirm'),
                        content: Text(
                            'Do you really want to delete '
                                'course ${widget.store.course.name} and all '
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
                              await widget.store.deleteCourse(
                                  widget.store.course.id);
                              Navigator.pushReplacementNamed(context, HomeScreen.id);
                            },
                          )
                        ],
                      ));
                  break;
                case kActionBooks:
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => BooksScreen(widget.store)));
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
      floatingActionButton: SpeedDial(
          backgroundColor: kPrimaryColor,
          foregroundColor: Colors.white,
          child: Icon(LineAwesomeIcons.plus),
          children: [
            SpeedDialChild(
              child: Icon(Icons.class_),
              backgroundColor: kPrimaryColor,
              label: 'Add subject',
              labelStyle: TextStyle(fontSize: 18.0),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => EditSubjectScreen(
                            widget.store, widget.store.course, null)));
              },
            ),
            SpeedDialChild(
              child: Icon(LineAwesomeIcons.book),
              backgroundColor: kPrimaryColor,
              label: 'Add book',
              labelStyle: TextStyle(fontSize: 18.0),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            EditBookScreen(widget.store, widget.store.course, null)));
              },
            ),
          ]),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Expanded(
              child: SubjectItemsView(widget.store, widget.store.course),
            )
          ],
        ),
      ),
    );
  }

  Widget searchTextField() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 16),
      child: Container(
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(10)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withAlpha(10),
                blurRadius:
                20.0, // has the effect of softening the shadow
                spreadRadius:
                10.0, // has the effect of extending the shadow
                offset: Offset(
                  0.0, // horizontal, move right 10
                  0.0, // vertical, move down 10
                ),
              )
            ]),
        child: TextField(
          autocorrect: true,
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
              hintText: 'Search subject',
              fillColor: Colors.white,
              filled: true,
              contentPadding: EdgeInsets.all(8),
              prefixIcon: Icon(Icons.search)),
          onChanged: (text) {

          },
        ),
      ),
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
        return ModalProgressHUD(
          color: kLightGrey,
          child: resultWidget(context, store.subjects),
          inAsyncCall: store.isSubjectsLoading || store.isCourseLoading,
        );
      });

  resultWidget(BuildContext context, List<Subject> items) {
    if (!store.isSubjectsLoading && items.length == 0) {
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
            padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 10),
            child: Container(
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
              padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 10),
              margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 0),
              child: ListTile(
                onTap: () {
                  store.setSubject(item);
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              SubjectScreen(store, course)));
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
                subtitle: subjectSubtitle(item),
              ),
            ),
          );
        });
  }

  Widget subjectSubtitle(Subject item) {

    if(item.bookTitle == null || item.bookTitle == '')
      return null;

    return Wrap(
      spacing: 4,
      alignment: WrapAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.fromLTRB(0, 2, 0, 0),
          child: Icon(LineAwesomeIcons.book, size: 16, color: Colors.grey,),
        ),
        Text(item.bookTitle)
      ],
    );
  }
}
