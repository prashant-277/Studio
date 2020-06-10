import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:line_awesome_icons/line_awesome_icons.dart';
import 'package:studio/courses_store.dart';
import 'package:studio/models/course.dart';
import 'package:studio/models/question.dart';
import 'package:studio/models/subject.dart';
import 'package:studio/screens/test/test_screen.dart';
import 'package:studio/services/test_service.dart';
import 'package:studio/widgets/course_title.dart';
import 'package:studio/widgets/drawer.dart';
import 'package:studio/widgets/shadow_container.dart';

import '../../constants.dart';

class TestHomeScreen extends StatefulWidget {
  final String id = "test_home_screen";
  final CoursesStore store;

  TestHomeScreen(this.store);

  @override
  _TestHomeScreenState createState() => _TestHomeScreenState();
}

class _TestHomeScreenState extends State<TestHomeScreen> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  List<Subject> selectedSubjects;
  List<int> selectedLevels;
  int selectedQuestionsCount = 0;

  /*
  * Used only by the slider
  * */
  @deprecated
  int testLength = 0;

  @override
  void initState() {
    selectedLevels = [1, 2, 3];
    selectedSubjects = [];
    widget.store.loadSubjects(widget.store.course.id);
    widget.store.loadQuestions(courseId: widget.store.course.id);
    super.initState();
  }

  @override
  Widget build(BuildContext context) => Observer(builder: (_) {
        var withQuestions =
            widget.store.subjects.where((element) => _hasQuestions(element));
        return Scaffold(
          key: _scaffoldKey,
          drawer: MainDrawer(widget.store),
          appBar: AppBar(
              centerTitle: true,
              elevation: 0,
              iconTheme: IconThemeData(color: kDarkBlue),
              title: CourseTitle(widget.store, widget.store.course, kDarkBlue),
              backgroundColor: kLightGrey,
              bottom: PreferredSize(
                child: _progressLoading(),
              )),
          body: SafeArea(
              child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  ShadowContainer(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 0, vertical: 0),
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            'Subjects',
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                                color: kDarkBlue),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            child: Wrap(
                              spacing: 12,
                              children: withQuestions.map((element) {
                                return InputChip(
                                  avatar: CircleAvatar(
                                      backgroundColor: Colors.blueGrey.shade400,
                                      radius: 20,
                                      child: Text(
                                        _questionsInSubject(element).toString(),
                                        style: TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.white),
                                      )),
                                  isEnabled: _hasQuestions(element),
                                  label: Text(element.name),
                                  backgroundColor: Colors.blueGrey.shade100,
                                  selectedColor: Colors.blue.shade100,
                                  selected: selectedSubjects.contains(element),
                                  onSelected: (s) {
                                    setState(() {
                                      if (s) {
                                        selectedSubjects.add(element);
                                        //countQuestionsBySubjects();
                                      } else {
                                        selectedSubjects.remove(element);
                                        //countQuestionsBySubjects();
                                      }
                                    });
                                    updateCount();
                                  },
                                );
                              }).toList(),
                            ),
                          ),
                          _selectedCountText(),
                          ButtonBar(
                            children: <Widget>[
                              FlatButton(
                                child: Text('SELECT ALL'),
                                onPressed: () {
                                  setState(() {
                                    selectedSubjects = withQuestions.toList();
                                    updateCount();
                                  });
                                },
                              ),
                              FlatButton(
                                child: Text('DESELECT ALL'),
                                onPressed: () {
                                  setState(() {
                                    selectedSubjects = List();
                                    updateCount();
                                  });
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  ShadowContainer(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 0, vertical: 0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          Text(
                            'Level',
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                                color: kDarkBlue),
                          ),
                          Text(
                              'Choose the level of the questions for this test'),
                          Padding(
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              child: Wrap(
                                spacing: 12,
                                children: <Widget>[
                                  _levelChip(1),
                                  _levelChip(2),
                                  _levelChip(3),
                                ],
                              )),
                        ],
                      ),
                    ),
                  ),
                  ShadowContainer(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 0, vertical: 0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          Text(
                            'Test length: $selectedQuestionsCount questions',
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                                color: kDarkBlue),
                          ),
                        ],
                      ),
                    ),
                  ),
                  //_questionsSlider()
                ],
              ),
            ),
          )),
          bottomNavigationBar: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: RaisedButton(
              color: selectedQuestionsCount < 3 ? Colors.blueGrey.shade100 : kPrimaryColor,
              child: Text(
                'START',
                style: TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                    fontWeight: FontWeight.w600),
              ),
              onPressed: () {
                if (selectedQuestionsCount < 3) {
                  _scaffoldKey.currentState.showSnackBar(SnackBar(
                    content:
                        Text('You need at least 3 questions to start a test'),
                  ));
                } else {
                  var service = TestService(getSelectedQuestions(), selectedQuestionsCount);
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => TestScreen(widget.store, service)));
                }
              },
            ),
          ),
        );
      });

  Widget _questionsSlider() {
    if (selectedQuestionsCount < 3) {
      return ShadowContainer(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Text(
                    'Number of questions',
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: kDarkBlue),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    child: Text('You need to select at least 3 questions'),
                  )
                ]),
          ));
    }

    return ShadowContainer(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
      child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Text(
                'Number of questions',
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: kDarkBlue),
              ),
              Slider(
                min: 3,
                max: selectedQuestionsCount.toDouble(),
                divisions: max(1, selectedQuestionsCount - 3),
                label: testLength.toString(),
                value: testLength.toDouble(),
                activeColor: Colors.blueGrey,
                onChanged: (v) {
                  setState(() {
                    testLength = v.toInt();
                  });
                },
              ),
              Text("$testLength questions")
            ],
          )),
    );
  }

  bool _hasQuestions(Subject item) {
    return widget.store.questions
            .where((question) => question.subjectId == item.id)
            .length >
        0;
  }

  int _questionsInSubject(Subject item) {
    return widget.store.questions
        .where(
            (question) => question.subjectId == item.id &&
                          selectedLevels.contains(question.level)
          )
        .length;
  }

  void updateCount() {
    setState(() {
      selectedQuestionsCount = getSelectedQuestions().length;
    });
  }

  List<Question> getSelectedQuestions() {
    List<Question> list = List();
    selectedSubjects.forEach((item) {
      list.addAll(widget.store.questions
          .where((question) =>
      question.subjectId == item.id && selectedLevels.contains(question.level)));
    });
    return list;
  }



  Widget _selectedCountText() {
    var subjectIds = selectedSubjects.map((e) => e.id);
    int questionsCount = widget.store.questions
        .where((question) => subjectIds.contains(question.subjectId))
        .length;

    return Text(questionsCount > 0
        ? "$questionsCount questions in ${selectedSubjects.length} subjects"
        : "No subjects selected");
  }

  Widget _levelChip(int level) {
    return InputChip(
      avatar: CircleAvatar(
        backgroundColor: Colors.blueGrey.shade400,
        radius: 20,
        child: Icon(LineAwesomeIcons.minus),
      ),
      label: Text("Level $level"),
      backgroundColor: Colors.blueGrey.shade100,
      selectedColor: Colors.blue.shade100,
      selected: selectedLevels.contains(level),
      onSelected: (s) {
        setState(() {
          if (s) {
            selectedLevels.add(level);
          } else {
            selectedLevels.remove(level);
          }
        });
        updateCount();
      },
    );
  }

  Widget _progressLoading() {
    if (widget.store.isQuestionsLoading || widget.store.isSubjectsLoading) {
      Container(
        child: LinearProgressIndicator(),
      );
    }

    return Container();
  }
}
