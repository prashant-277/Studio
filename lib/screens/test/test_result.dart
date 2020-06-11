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
        centerTitle: true,
        elevation: 0,
        iconTheme: IconThemeData(color: kDarkBlue),
        title: Text(
          'Test result',
          style: TextStyle(color: kDarkBlue),
        ),
        backgroundColor: Colors.blueGrey.shade50,
        bottom: PreferredSize(
          child: Text(
            widget.store.course.name
          ),
        ),
        leading: Container(),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            ClipPath(
              clipper: CurvedBottomClipper(),
              child: Container(
                color: Colors.blueGrey.shade50,
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: circle(),
              ),
            ),
            SizedBox(
              height: 40,
            ),
            titlePanel(),
            resultPanel(),
          ],
        ),
      ),
    );
  }

  Widget circle() {
    var value = widget.service.result().percentage();
    return CustomPaint(
      foregroundPainter: CircleProgress(value.toDouble()),
      child: Container(
        width: 200,
        height: 200,
        child: Center(
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: <Widget>[
              Text(
                "$value",
                style: TextStyle(
                    fontSize: 50,
                    fontWeight: FontWeight.w600,
                    color: kDarkBlue
                ),
              ),
              Text(
                "%",
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: kDarkBlue
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
                    child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 8),
                        child: Column(
                          children: subjectCard(e),
                        )),
                  ))
              .toList()),
    );
  }

  subjectCard(Subject subject) {
    List<Widget> content = [
      Text(
        subject.name,
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
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

class SliverTestResultHeader implements SliverPersistentHeaderDelegate {
  final double minExtent;
  final double maxExtent;
  final CoursesStore store;
  final TestService service;

  SliverTestResultHeader(
      {this.minExtent,
      @required this.maxExtent,
      @required this.store,
      @required this.service});

  @override
  Widget build(
          BuildContext context, double shrinkOffset, bool overlapsContent) =>
      Observer(builder: (_) {
        return AppBar(
          leading: Container(),
          centerTitle: true,
          elevation: 0,
          primary: true,
          iconTheme: IconThemeData(color: kContrastColor),
          flexibleSpace: Stack(
            fit: StackFit.loose,
            overflow: Overflow.visible,
            children: <Widget>[
              Container(
                decoration: BoxDecoration(
                    gradient: LinearGradient(
                        colors: [Colors.black87, Colors.transparent],
                        stops: [0, 1],
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter)),
              ),
              Positioned(
                top: this.maxExtent / 2 - 20,
                right: 0,
                left: 0,
                child: Center(child: circle()),
              ),
            ],
          ),
          backgroundColor: kContrastDarkColor,
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
                        builder: (context) => CourseScreen(store)));
              },
            ),
          ],
        );
      });

  Widget circle() {
    return CustomPaint(
      foregroundPainter: CircleProgress(12),
      child: Container(
        width: 200,
        height: 200,
        child: Center(
          child: Text(
            "12 %",
            style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );

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
              '${service.result().percentage()}%',
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

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) {
    return true;
  }

  @override
  FloatingHeaderSnapConfiguration get snapConfiguration => null;

  @override
  OverScrollHeaderStretchConfiguration get stretchConfiguration => null;

  sliverOpacity(double shrinkOffset) {
    return 1.0 - max(0.0, shrinkOffset) / maxExtent;
  }
}
