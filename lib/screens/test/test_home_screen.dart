import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:line_awesome_icons/line_awesome_icons.dart';

import '../../constants.dart';
import '../../courses_store.dart';
import '../../models/question.dart';
import '../../models/subject.dart';
import '../../services/test_service.dart';
import '../../widgets/course_title.dart';
import '../../widgets/shadow_container.dart';
import 'test_screen.dart';

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

  bool isToggled = false;

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
          backgroundColor: kBackgroundColor,
          key: _scaffoldKey,
          appBar: AppBar(
            centerTitle: true,
            elevation: 0,
            iconTheme: IconThemeData(color: kDarkBlue),
            title: CourseTitle(widget.store, widget.store.course, kDarkBlue),
            titleTextStyle: TextStyle(
                color: kTitleColor,
                fontSize: 23,
                fontFamily: "Quicksand",
                fontWeight: FontWeight.w200),
            backgroundColor: kLightGrey,
            /*bottom: PreferredSize(
              child: progressLoading(),
            ),*/
          ),
          body: SafeArea(
              child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 00, horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.all(10),
                    child: Text('Prepare a new test',
                        style: TextStyle(
                            color: kDarkBlue,
                            fontSize: 15,
                            fontFamily: "Quicksand",
                            fontWeight: FontWeight.w600)),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Text('Difficulty: ',
                            style: TextStyle(
                                color: kDarkBlue,
                                fontSize: 17,
                                fontFamily: "Quicksand",
                                fontWeight: FontWeight.w600)),
                        Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 10, horizontal: 0),
                            child: Row(
                              children: <Widget>[
                                levelChip(1),
                                levelChip(2),
                                levelChip(3),
                              ],
                            )),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Number of selected questions:',
                            style: TextStyle(
                                color: kDarkBlue,
                                fontSize: 15,
                                fontFamily: "Quicksand",
                                fontWeight: FontWeight.w600)),
                        Container(
                          width: 40,
                          height: 25,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(
                              Radius.circular(20),
                            ),
                            color: kDarkGrey,
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(3.0),
                            child: Center(
                              child: Text(" $selectedQuestionsCount",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 15,
                                      fontFamily: "Quicksand",
                                      fontWeight: FontWeight.w600)),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 25.0),
                    child: Wrap(
                      spacing: 12,
                      children: withQuestions.map((element) {
                        return Container(
                          height: MediaQuery.of(context).size.height/11.0,
                          decoration: new BoxDecoration(
                              border: new Border(
                                  bottom: new BorderSide(
                                      color: Color(0xfff4f4f4)))),
                          child: ListTile(
                            tileColor: Colors.white,
                            dense: true,
                            enabled: true,
                            title: Text(element.name,
                                style: TextStyle(
                                    color: selectedSubjects.contains(element)
                                        ? kDarkBlue
                                        : Color(0xffb3b3b4),
                                    fontSize: 18,
                                    fontFamily: "Quicksand",
                                    fontWeight: FontWeight.w600)),
                            subtitle: Text(
                                _questionsInSubject(element).toString() +
                                    " Questions",
                                style: TextStyle(
                                    color: selectedSubjects.contains(element)
                                        ? Colors.grey
                                        : Color(0xffb3b3b4),
                                    fontFamily: "Quicksand",
                                    fontSize: 10,
                                    fontWeight: FontWeight.w400)),
                            trailing: Switch(
                              value: isToggled == true
                                  ? selectedSubjects.contains(element)
                                  : selectedSubjects.contains(element),
                              onChanged: (value) {
                                setState(() {
                                  isToggled = value;
                                  print(isToggled);

                                  if (isToggled == true) {
                                    selectedSubjects.add(element);
                                    _hasQuestions(element);
                                  } else {
                                    selectedSubjects.remove(element);
                                  }
                                });
                                updateCount();
                              },
                              activeTrackColor: Color(0xffE1E1E1),
                              inactiveThumbColor: Color(0xffb3b3b4),
                              inactiveTrackColor: Color(0xffE1E1E1),
                              activeColor: Color(0xff2b9afb),
                              splashRadius: 20.0,
                            ),
                          ),
                        );
                      }).toList(),
                    ),

                    /*Padding(
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              child: Wrap(
                                spacing: 12,
                                children: withQuestions.map((element) {
                                  return InputChip(
                                    avatar: CircleAvatar(
                                        backgroundColor:
                                            Colors.blueGrey.shade400,
                                        radius: 20,
                                        child: Text(
                                          _questionsInSubject(element)
                                              .toString(),
                                          style: TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.w600,
                                              color: Colors.white),
                                        )),
                                    isEnabled: _hasQuestions(element),
                                    label: Text(element.name),
                                    backgroundColor: Colors.blueGrey.shade100,
                                    selectedColor: Colors.blue.shade100,
                                    selected:
                                        selectedSubjects.contains(element),
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
                                    showCheckmark: false,
                                  );
                                }).toList(),
                              ),
                            ),
                            selectedCountText(),
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
                            ),*/
                  ),

                  /*ShadowContainer(
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
                  ),*/
                  //_questionsSlider()
                ],
              ),
            ),
          )),
          bottomNavigationBar: BottomAppBar(
            elevation: 0,
            color: kBackgroundColor,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(0, 00, 0, 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  FlatButton(
                    padding: EdgeInsets.fromLTRB(30, 10, 30, 10),

                    color: selectedQuestionsCount < 3
                        ? Colors.blueGrey.shade100
                        : kPrimaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(50)),
                    ),
                    child: Text(
                      'START TEST',
                      style: TextStyle(
                          color: kTitleColor,
                          fontSize: 18,
                          fontFamily: "Quicksand",
                          fontWeight: FontWeight.w500),
                    ),
                    onPressed: () {
                      if (selectedQuestionsCount < 3) {
                        _scaffoldKey.currentState.showSnackBar(SnackBar(
                          content: Text(
                              'You need at least 3 questions to start a test'),
                        ));
                      } else {
                        var service = TestService(
                            getSelectedQuestions(), selectedQuestionsCount);
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    TestScreen(widget.store, service)));
                      }
                    },
                  ),
                ],
              ),
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
        .where((question) =>
            question.subjectId == item.id &&
            selectedLevels.contains(question.level))
        .length;
  }

  void updateCount() {
    setState(() {
      selectedQuestionsCount = getSelectedQuestions().length;
    });
  }

  List<QuestionResult> getSelectedQuestions() {
    List<Question> list = List();
    selectedSubjects.forEach((item) {
      list.addAll(widget.store.questions.where((question) =>
          question.subjectId == item.id &&
          selectedLevels.contains(question.level)));
    });
    return list.map((e) => QuestionResult(e)).toList();
  }

  Widget selectedCountText() {
    var subjectIds = selectedSubjects.map((e) => e.id);
    int questionsCount = widget.store.questions
        .where((question) => subjectIds.contains(question.subjectId))
        .length;

    return Text(questionsCount > 0
        ? "$questionsCount questions in ${selectedSubjects.length} subjects"
        : "No subjects selected");
  }

  Widget levelChip(int level) {
    return Transform(
      //transform: new Matrix4.identity()..scale(0.6),
      transform: new Matrix4.rotationX(7.0)..scale(0.8),
      alignment: Alignment.center,

      child: InputChip(
        padding: EdgeInsets.symmetric(vertical: 0, horizontal: 00),
        labelPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 3),
        label: Text(
          "$level",
          style: TextStyle(
              color: selectedLevels.contains(level) == true
                  ? Colors.white
                  : Colors.black,
              fontSize: 18),
        ),
        backgroundColor: Color(0xffE1E1E1),
        selectedColor: Color(0xff2b9afb),
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        selected: selectedLevels.contains(level),
        onSelected: (s) {
          setState(() {
            if (s) {
              selectedLevels.add(level);
              print(s);
            } else {
              selectedLevels.remove(level);
            }
          });
          updateCount();
        },
        showCheckmark: false,
      ),
    );
  }

  Widget progressLoading() {
    if (widget.store.isQuestionsLoading || widget.store.isSubjectsLoading) {
      Container(
        child: LinearProgressIndicator(),
      );
    }

    return Container();
  }
}
