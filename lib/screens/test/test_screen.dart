import 'package:flutter/material.dart';
import 'package:line_awesome_icons/line_awesome_icons.dart';

import '../../constants.dart';
import '../../courses_store.dart';
import '../../models/question.dart';
import '../../services/test_service.dart';
import '../../widgets/course_title.dart';
import 'test_result.dart';

enum TestStatus { Question, Answer }

class TestScreen extends StatefulWidget {
  final CoursesStore store;
  final TestService service;

  TestScreen(this.store, this.service);

  @override
  _TestScreenState createState() => _TestScreenState();
}

class _TestScreenState extends State<TestScreen> {
  Question question = Question();
  var status = TestStatus.Question;

  @override
  void initState() {
    super.initState();
    question = widget.service.next();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        iconTheme: IconThemeData(color: kDarkBlue),
        title: Text(
          'Test',
          style: TextStyle(color: kDarkBlue),
        ),
        backgroundColor: kLightGrey,
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(2),
          child: CourseTitle(widget.store, widget.store.course, kDarkBlue),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        child: bottomBar(),
      ),
      body: SafeArea(
        child: Container(
          color: Colors.white,
          child: screen(),
        ),
      ),
    );
  }

  bottomBar() {
    if (status == TestStatus.Question) {
      return ButtonBar(
        alignment: MainAxisAlignment.center,
        children: <Widget>[
          RaisedButton(
            color: kPrimaryColor,
            textColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 42),
            child: Text(
              'SHOW ANSWER',
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
            ),
            onPressed: () {
              setState(() {
                status = TestStatus.Answer;
              });
            },
          )
        ],
      );
    } else {
      return ButtonBar(
        alignment: MainAxisAlignment.center,
        children: <Widget>[
          RaisedButton(
            color: Colors.red,
            textColor: Colors.white,
            child: Icon(LineAwesomeIcons.thumbs_down),
            padding: const EdgeInsets.symmetric(horizontal: 42),
            onPressed: () {
              setState(() {
                status = TestStatus.Question;
                widget.service.setResponse(false);
                widget.store.attentionQuestion(question.id, true);
                if (widget.service.hasMore())
                  question = widget.service.next();
                else
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              TestResultScreen(widget.store, widget.service)));
              });
            },
          ),
          RaisedButton(
            color: Colors.lightGreen,
            textColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 42),
            child: Icon(LineAwesomeIcons.thumbs_up),
            onPressed: () {
              setState(() {
                status = TestStatus.Question;
                widget.service.setResponse(true);
                if (widget.service.hasMore())
                  question = widget.service.next();
                else
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              TestResultScreen(widget.store, widget.service)));
              });
            },
          )
        ],
      );
    }
  }

  screen() {
    if (status == TestStatus.Question) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(18.0),
              child: Text(
                  'Question ${widget.service.index + 1}/${widget.service.length}'),
            ),
            Expanded(
              child: Container(),
            ),
            Text(
              question.text,
              style: TextStyle(
                fontSize: 24,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(
              height: 80,
            ),
            Expanded(
              child: Container(),
            ),
          ],
        ),
      );
    } else {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(18.0),
              child: Text(
                  'Question ${widget.service.index + 1}/${widget.service.length}'),
            ),
            Expanded(
              child: Container(),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 0, 0, 40),
              child: Text(
                question.text,
                style: TextStyle(
                  fontSize: 14,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            Text(
              question.answer,
              style: TextStyle(
                fontSize: 24,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(
              height: 80,
            ),
            Expanded(
              child: Container(),
            ),
          ],
        ),
      );
    }
  }
}
