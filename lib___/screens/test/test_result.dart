import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:line_awesome_icons/line_awesome_icons.dart';
import 'package:studio/constants.dart';
import 'package:studio/courses_store.dart';
import 'package:studio/models/subject.dart';
import 'package:studio/models/test_result.dart';
import 'package:studio/screens/courses/course_screen.dart';
import 'package:studio/screens/courses/courses_screen.dart';
import 'package:studio/services/test_service.dart';
import 'package:studio/widgets/circle_progress.dart';
import 'package:studio/widgets/curved_bottom_clipper.dart';

class TestResultScreen extends StatefulWidget {
  final CoursesStore store;
  final TestService service;

  TestResultScreen(this.store, this.service);

  @override
  _TestResultScreenState createState() => _TestResultScreenState();
}

class _TestResultScreenState extends State<TestResultScreen> with SingleTickerProviderStateMixin {
  TestResult result;
  AnimationController progressController;
  Animation<double> animation;

  @override
  void initState() {
    super.initState();
    result = widget.service.result();
    progressController = AnimationController(vsync: this,duration: Duration(milliseconds: 1000));
    animation = Tween<double>(begin: 0,end: result.percentage().toDouble()).animate(progressController)..addListener((){
      setState(() {

      });
    });
    progressController.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey.shade50,
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        iconTheme: IconThemeData(color: kContrastColor),
        title: Text(
          'Test result',
          style: TextStyle(color: kContrastColor),
        ),
        backgroundColor: Colors.blueGrey.shade900,
        bottom: PreferredSize(
          child: Text(
            widget.store.course.name,
            style: TextStyle(
              color: kContrastColor
            ),
          ),
        ),
        leading: Container(),
        actions: <Widget>[
          FlatButton(
            child: Icon(LineAwesomeIcons.times,
            color: kContrastColor,
            ),
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(
                builder: (context) => CourseScreen(widget.store)
              ));
            },
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            ClipPath(
              clipper: CurvedBottomClipper(),
              child: Container(
                color: Colors.blueGrey.shade900,
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: circle(),
              ),
            ),
            SizedBox(
              height: widget.service.hasErrors() ? 40 : 0,
            ),
            titlePanel(),
            resultPanel(),
          ],
        ),
      ),
    );
  }

  Widget circle() {
    var value = animation.value;

    var color = Colors.redAccent;
    if(value > 50)
      color = Colors.orangeAccent;
    if(value > 70)
      color = Colors.greenAccent;

    return CustomPaint(
      foregroundPainter: CircleProgress(animation.value, color),
      child: Container(
        width: 160,
        height: 160,
        child: Center(
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: <Widget>[
              Text(
                "%",
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: kDarkBlue.withAlpha(0)
                ),
              ),
              Text(
                "${animation.value.toInt()}",
                style: TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.w600,
                    color: color
                ),
              ),
              Text(
                "%",
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: color
                ),
              ),
            ],
          )
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
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Text(
        text,
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
          children: subjects
              .map((e) => Card(
            elevation: 0,
                    child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 8),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: subjectCard(e),
                        )),
                  ))
              .toList()),
    );
  }

  subjectCard(Subject subject) {
    List<Widget> content = [
      Row(
        children: <Widget>[
          Text(
            subject.name,
            style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              color: kDarkBlue,
              ),
            textAlign: TextAlign.left,
          ),
        ],
      ),
    ];

    widget.service.wrongQuestionsBySubject(subject).forEach((element) {
      content.add(ListTile(
        contentPadding: const EdgeInsets.all(0),
        title: Text(element.text),
      ));
    });

    return content;
  }
}
