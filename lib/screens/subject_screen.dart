import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:line_awesome_icons/line_awesome_icons.dart';
import 'package:studio/courses_store.dart';
import 'package:studio/models/course.dart';
import 'package:studio/models/subject.dart';
import 'package:studio/screens/edit_subject_screen.dart';

import '../constants.dart';
import 'edit_note_screen.dart';
import 'notes_screen.dart';

const int kTabNotes = 0;
const int kTabQuestions = 1;
const int kTabMindmap = 2;
const int kModeList = 0;
const int kModeCarousel = 1;

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
  int currentTab = kTabNotes;
  int currentMode = kModeList;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: 3);
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
              icon: Icon(
                LineAwesomeIcons.edit,
                color: currentTab == kTabNotes
                    ? kPrimaryColor
                    : Colors.blueGrey[800],
              ),
            ),
            Tab(
              //text: 'Questions',
              icon: Icon(
                LineAwesomeIcons.question,
                color: currentTab == kTabQuestions
                    ? kPrimaryColor
                    : Colors.blueGrey[800],
              ),
            ),
            Tab(
              //text: 'Mind map',
              icon: Icon(
                LineAwesomeIcons.sitemap,
                color: currentTab == kTabMindmap
                    ? kPrimaryColor
                    : Colors.blueGrey[800],
              ),
            ),
          ],
        ),
        title: Text(
          widget.subject.name,
        ),
        actions: <Widget>[
          FlatButton(
            child: Icon(LineAwesomeIcons.ellipsis_v),
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
                                        builder: (context) => EditSubjectScreen(
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
                              showDialog(
                                  context: context,
                                  builder: (_) => AlertDialog(
                                        title: Text('Confirm'),
                                        content: Text(
                                            'Do you really want to delete '
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
                                              await widget.store.deleteSubject(
                                                  widget.subject.id,
                                                  widget.course.id);
                                              Navigator.pop(context);
                                              widget.store.loadSubjects(
                                                  widget.course.id);
                                            },
                                          )
                                        ],
                                      ));
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
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        backgroundColor: kPrimaryColor,
        child: Icon(Icons.add),
        onPressed: () {
          if (currentTab == kTabNotes) {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => NoteEdit(
                        widget.store, widget.course, widget.subject, null)));
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
      ),
      bottomNavigationBar: BottomAppBar(
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Expanded(
              child: FlatButton(
                child: Icon(
                  LineAwesomeIcons.bars,
                  color: Colors.white.withAlpha(currentMode == kModeList ? 255 : 100),
                ),
                onPressed: () {
                  print("list");
                  setState(() {
                    currentMode = kModeList;
                  });
                },
              ),
            ),
            Expanded(
              child: FlatButton(
                child: Icon(
                  LineAwesomeIcons.copy,
                  color: Colors.white.withAlpha(currentMode == kModeCarousel ? 255 : 100),
                ),
                onPressed: () {
                  print("carousel");
                  setState(() {
                    currentMode = kModeCarousel;
                  });
                },
              ),
            ),
          ],
        ),
        shape: CircularNotchedRectangle(),
        color: kDarkGrey,
        elevation: 10,
      ),
    );
  }
}

class QuestionsView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
