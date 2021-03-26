import 'package:flutter/material.dart';
import 'package:line_awesome_icons/line_awesome_icons.dart';
import 'package:studio/widgets/buttons.dart';

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
      backgroundColor: kBackgroundColor,
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
        backgroundColor: kBackgroundColor,
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(2),
          child: Text(
            'Test',
            style: TextStyle(
                color: kTitleColor,
                fontSize: 15,
                fontFamily: "Quicksand",
                fontWeight: FontWeight.w400),
          ),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        color: kBackgroundColor,
        elevation: 0,
        child: bottomBar(),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 20, right: 20 , top: 25),
              child: LinearProgressIndicator(
                minHeight: 6.0,
                backgroundColor: Colors.grey[400],
                valueColor:
                    AlwaysStoppedAnimation<Color>(Color(0xff95e572)),
                value: (widget.service.index+1)/widget.service.length,
              ),
            ),
            Container(
              child: screen(),
            ),
          ],
        ),
      ),
    );
  }

  bottomBar() {
    if (status == TestStatus.Question) {
      return ButtonBar(
        alignment: MainAxisAlignment.center,
        children: <Widget>[
          PrimaryButton(
            'SHOW ANSWER',
            () {
              setState(() {
                status = TestStatus.Answer;
              });
            },
          )
        ],
      );
    } else {
      return ButtonBar(
        alignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          FlatButton(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(40)),
            ),
            color: Colors.red,
            textColor: Colors.white,
            child: Icon(LineAwesomeIcons.thumbs_down),
            padding: const EdgeInsets.symmetric(horizontal: 45),
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
          FlatButton(
            color: Colors.lightGreen,
            textColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(40)),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 45),
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
        padding: const EdgeInsets.only(left: 16, right: 16, top: 10),
        child: Card(
          elevation: 3,
          child: Container(
            height: MediaQuery.of(context).size.height / 2.5,
            color: Colors.white,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
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
          ),
        ),
      );
    } else {
      return Padding(
        padding: const EdgeInsets.only(left: 16, right: 16, top: 20),
        child: Card(
          elevation: 3,
          child: Container(
            height: MediaQuery.of(context).size.height / 2.5,
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
          ),
        ),
      );
    }
  }
}
