import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:studio/courses_store.dart';
import 'package:studio/models/course.dart';
import 'package:studio/models/subject.dart';
import 'package:studio/screens/edit_subject_screen.dart';

import '../constants.dart';
import 'note_edit_screen.dart';
import 'note_screen.dart';

const int kTabNotes = 0;
const int kTabQuestions = 1;

class SubjectScreen extends StatefulWidget {
  SubjectScreen(this.store, this.course, this.subject);

  final Course course;
  final Subject subject;
  final CoursesStore store;
  static final id = 'subject_screen';

  @override
  _SubjectScreenState createState() => _SubjectScreenState();
}

class _SubjectScreenState extends State<SubjectScreen>
    with SingleTickerProviderStateMixin {
  TabController _tabController;
  int currentTab = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
        vsync: this,
        length: 3);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(color: kDarkBlue),
          centerTitle: true,
          bottom: TabBar(
            controller: _tabController,
            labelColor: kDarkBlue,
            indicatorColor: kPrimaryColor,
            isScrollable: false,
            onTap: (index) {
              setState(() {
                currentTab = index;
              });
            },
            tabs: <Widget>[
              Tab(
                //text: 'Notes',
                icon: Icon(Icons.edit),
              ),
              Tab(
                //text: 'Questions',
                icon: Icon(Icons.question_answer),
              ),
              Tab(
                //text: 'Mind map',
                icon: Icon(Icons.call_split),
              ),
            ],
          ),
          title: Text(
            widget.subject.name,
          ),
          actions: <Widget>[
            FlatButton(
              child: Icon(Icons.more_vert),
              onPressed: () {
                showModalBottomSheet(
                    context: context,
                    builder: (BuildContext bc) {
                      return Container(
                        child: new Wrap(
                          children: <Widget>[
                            new ListTile(
                                leading: new Icon(Icons.edit),
                                title: new Text('Edit subject'),
                                onTap: () {
                                  Navigator.pop(context);
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              EditSubjectScreen(
                                                  widget.store,
                                                  widget.course,
                                                  widget.subject)));
                                }),
                            new ListTile(
                              leading: new Icon(
                                Icons.delete_forever,
                                color: Colors.red,
                              ),
                              title: new Text(
                                'Delete subject',
                                style: TextStyle(
                                    color: Colors.red,
                                    fontWeight: FontWeight.w600),
                              ),
                              onTap: () {
                                Navigator.pop(context);
                                showDialog(context: context,
                                builder: (_) => AlertDialog(
                                  title: Text('Confirm'),
                                  content: Text('Do you really want to delete '
                                      'subject ${widget.subject.name} and all '
                                      'its notes and questions?'),
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
                                        await widget.store.deleteSubject(widget.subject.id, widget.course.id);
                                        Navigator.pop(context);
                                        widget.store.loadSubjects(widget.course.id);
                                      },
                                    )
                                  ],
                                )
                                );
                              },
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
          backgroundColor: kPrimaryColor,
          child: Icon(Icons.add),
          onPressed: () {
            if(currentTab == kTabNotes) {
              Navigator.push(context, MaterialPageRoute(
                  builder: (context) => NoteEdit(widget.store, widget.course, widget.subject, null)
              ));
            }
          },
        ),
        body: TabBarView(
          controller: _tabController,
          children: <Widget>[
            NotesView(widget.store, widget.course, widget.subject),
            QuestionsView(),
            Text('Mind map'),
          ],
        ));
  }
}



class QuestionsView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
