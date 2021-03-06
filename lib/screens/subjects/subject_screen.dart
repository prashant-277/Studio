import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:line_awesome_icons/line_awesome_icons.dart';


import '../../constants.dart';
import '../../courses_store.dart';
import '../../models/course.dart';
import '../notes/edit_note_screen.dart';
import '../notes/notes_screen.dart';
import '../questions/edit_question_screen.dart';
import '../questions/questions_screen.dart';
import 'edit_subject_screen.dart';

class SubjectScreen extends StatefulWidget {
  SubjectScreen(this.store, this.course);

  final Course course;
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
  int currentIndex = 0;

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
  Widget build(BuildContext context) => Observer(builder: (_) {
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
                LineAwesomeIcons.project_diagram,
                color: currentTab == kTabMindmap
                    ? kPrimaryColor
                    : Colors.blueGrey[800],
              ),
            ),
          ],
        ),
        title: Text(
          widget.store.subject.name,
          style: TextStyle(
            color: kDarkBlue
          ),
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
                                            widget.store.subject)));
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
                                            'subject ${widget.store.subject.name} and all '
                                            'its notes and questions?'),
                                    actions: <Widget>[
                                      FlatButton(
                                        child: Text('Yes'),
                                        textColor: Colors.red,
                                        onPressed: () async {
                                          Navigator.pop(context);
                                          await widget.store.deleteSubject(
                                              widget.store.subject.id,
                                              widget.course.id);
                                          Navigator.pop(context);
                                          widget.store.loadSubjects(
                                              widget.course.id);
                                        },
                                      ),
                                      FlatButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        child: Text('No'),
                                      ),
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
                        widget.store, null)));
          }
          if(currentTab == kTabQuestions) {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => QuestionEdit(
                        widget.store, widget.course, widget.store.subject, null)));
          }
        },
      ),
      body: TabBarView(
        controller: _tabController,
        children: <Widget>[
          NoteList(widget.store, widget.course, widget.store.subject, currentMode, (mode, i) {
            setState(() {
              print("change mode $mode");
              currentMode = mode;
              currentIndex = i;
            });
          }, currentIndex),
          QuestionList(widget.store, widget.course, widget.store.subject, currentMode),
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
  });
}
