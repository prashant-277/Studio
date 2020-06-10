import 'package:flutter/material.dart';
import 'package:line_awesome_icons/line_awesome_icons.dart';
import 'package:studio/constants.dart';
import 'package:studio/courses_store.dart';
import 'package:studio/models/subject.dart';
import 'package:studio/models/test_result.dart';
import 'package:studio/screens/courses/course_screen.dart';
import 'package:studio/screens/courses/courses_screen.dart';
import 'package:studio/services/test_service.dart';

class TestResultScreen extends StatefulWidget {
  final CoursesStore store;
  final TestService service;

  TestResultScreen(this.store, this.service);

  @override
  _TestResultScreenState createState() => _TestResultScreenState();
}

class _TestResultScreenState extends State<TestResultScreen> {
  TestResult result;

  @override
  void initState() {
    result = widget.service.result();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Container(),
        centerTitle: true,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.white),
        title: Text(
          widget.store.course.name,
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.blueGrey.shade900,
        actions: <Widget>[
          FlatButton(
            child: Icon(
              LineAwesomeIcons.times_circle,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) => CourseScreen(widget.store)));
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Stack(
              overflow: Overflow.visible,
              alignment: AlignmentDirectional.center,
              children: <Widget>[
                Container(
                  height: 130,
                  color: Colors.blueGrey.shade900,
                ),
                Positioned(
                  top: 34,
                  child: circle(),
                )
              ],
            ),
            SizedBox(
              height: 100,
            ),
            titlePanel(),
            resultPanel(),
          ],
        ),
      ),
    );
  }

  Widget circle() {
    return Align(
      alignment: Alignment.center,
      child: Container(
        width: 180,
        height: 180,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: kPrimaryColor,
          boxShadow: [
            BoxShadow(
              color: Colors.black87.withAlpha(40),
              spreadRadius: 20,
              blurRadius: 40,
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
              child: Text(
                'Test result',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.white.withAlpha(200),
                ),
                textAlign: TextAlign.center,
              ),
            ),
            Text(
              '${result.percentage()}%',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 50,
                  fontWeight: FontWeight.normal,
                  height: 1),
            ),
            SizedBox(
              height: 10,
            ),
          ],
        ),
      ),
    );
  }

  Widget noErrorsPanel() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Column(
        children: <Widget>[
          Image(
            image: AssetImage('assets/images/celebrate.png'),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 16, 0, 0),
            child: Text(
              'All answers are correct, great job!',
              style: TextStyle(fontSize: 18, color: kDarkBlue.withAlpha(200)),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  Widget titlePanel() {
    var text = widget.service.hasErrors() ? "Wrong answers" : "";
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 8
      ),
      child: Text(text,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget resultPanel() {
    if (!widget.service.hasErrors()) {
      return noErrorsPanel();
    }

    var subjects = widget.service.wrongSubjects(widget.store.subjects);


    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
          children: subjects.map((e) => Card(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8
                      ),
                      child: Column(
                        children: subjectCard(e),
                      )
                    ),
                  ))
              .toList()),
    );
  }

  subjectCard(Subject subject) {
    List<Widget> content = [
      Text(subject.name,
        style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600
        ),
      ),
    ];

    widget.service.wrongQuestionsBySubject(subject).forEach((element) {
      content.add(ListTile(
        title: Text(element.text),
      ));
    });

    return content;
  }
}
