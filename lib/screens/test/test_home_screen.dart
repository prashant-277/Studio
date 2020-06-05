import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:line_awesome_icons/line_awesome_icons.dart';
import 'package:studio/courses_store.dart';
import 'package:studio/models/course.dart';
import 'package:studio/models/subject.dart';
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
  List<Subject> subjects;
  List<int> levels;
  int questions = 0;

  @override
  void initState() {
    levels = [1, 2, 3];
    subjects = [];
    widget.store.loadSubjects(widget.store.course.id);
    widget.store.loadQuestions(courseId: widget.store.course.id);
    super.initState();
  }

  @override
  Widget build(BuildContext context) => Observer(builder: (_) {
        var withQuestions =
            widget.store.subjects.where((element) => _hasQuestions(element));
        return Scaffold(
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
                                        _questionCount(element).toString(),
                                        style: TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.white),
                                      )),
                                  isEnabled: _hasQuestions(element),
                                  label: Text(element.name),
                                  backgroundColor: Colors.blueGrey.shade100,
                                  selectedColor: Colors.blue.shade100,
                                  selected: subjects.contains(element),
                                  onSelected: (s) {
                                    setState(() {
                                      if (s) {
                                        subjects.add(element);
                                        countQuestionsBySubjects();
                                      } else {
                                        subjects.remove(element);
                                        countQuestionsBySubjects();
                                      }
                                    });
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
                                    subjects = withQuestions.toList();
                                  });
                                },
                              ),
                              FlatButton(
                                child: Text('DESELECT ALL'),
                                onPressed: () {
                                  setState(() {
                                    subjects = List();
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
                  _questionsSlider()
                ],
              ),
            ),
          )),
        );
      });

  Widget _questionsSlider() {
    if (subjects.length == 0) {
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
                    child: Text('You need to select at least one subject'),
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
                min: 0,
                max: _selectedQuestions().toDouble(),
                divisions: _selectedQuestions(),
                label: questions.toString(),
                value: questions.toDouble(),
                activeColor: Colors.blueGrey,
                onChanged: (v) {
                  setState(() {
                    questions = v.toInt();
                  });
                },
              ),
              Text("$questions questions")
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

  int _questionCount(Subject item) {
    return widget.store.questions
        .where((question) => question.subjectId == item.id)
        .length;
  }

  int _selectedQuestions() {
    int c = 0;
    subjects.forEach((element) {
      c += _questionCount(element);
    });
    return c;
  }

  countQuestionsBySubjects() {
    questions = _selectedQuestions();
  }

  Widget _selectedCountText() {
    var subjectIds = subjects.map((e) => e.id);
    int questionsCount = widget.store.questions
        .where((question) => subjectIds.contains(question.subjectId))
        .length;

    return Text(questionsCount > 0
        ? "$questionsCount questions selected"
        : "No questions selected");
  }

  Widget _levelChip(int level) {
    return InputChip(
      avatar: CircleAvatar(
        backgroundColor: Colors.blueGrey.shade400,
        radius: 20,
        child: Icon(LineAwesomeIcons.minus),
      ),
      label: Text(level.toString()),
      backgroundColor: Colors.blueGrey.shade100,
      selectedColor: Colors.blue.shade100,
      selected: levels.contains(level),
      onSelected: (s) {
        setState(() {
          if (s) {
            levels.add(level);
          } else {
            levels.remove(level);
          }
        });
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
