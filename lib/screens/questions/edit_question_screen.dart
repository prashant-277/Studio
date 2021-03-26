import 'package:flutter/material.dart';
import 'package:line_awesome_icons/line_awesome_icons.dart';
import 'package:studio/screens/notes/edit_note_screen.dart';

import '../../constants.dart';
import '../../courses_store.dart';
import '../../models/course.dart';
import '../../models/question.dart';
import '../../models/subject.dart';
import '../../widgets/buttons.dart';

class QuestionEdit extends StatefulWidget {
  final CoursesStore store;
  final Course course;
  final Subject subject;
  final Question data;

  QuestionEdit(this.store, this.course, this.subject, this.data);

  @override
  _QuestionEditState createState() => _QuestionEditState();
}

class _QuestionEditState extends State<QuestionEdit> {
  String text = '';
  String answer = '';
  TextEditingController textCtrl = TextEditingController();
  TextEditingController answerCtrl = TextEditingController();

  int level = 1;

  var radioItem;

  @override
  void initState() {
    if (widget.data != null) {
      textCtrl.text = widget.data.text;
      text = widget.data.text;
      answerCtrl.text = widget.data.answer;
      answer = widget.data.answer;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundColor,
      appBar: AppBar(
        iconTheme: IconThemeData(color: kTitleColor),
        centerTitle: true,
        elevation: 0,
        title: Text(widget.store.course.name,
            style: TextStyle(
                color: kTitleColor,
                fontSize: 23,
                fontFamily: "Quicksand",
                fontWeight: FontWeight.w200)),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.all(0),
                  child: Text('Cartography',
                      style: TextStyle(
                          color: kDarkBlue,
                          fontSize: 18,
                          fontFamily: "Quicksand",
                          fontWeight: FontWeight.w600)),
                ),
                Padding(
                  padding: EdgeInsets.all(10),
                  child: Text('Add new question',
                      style: TextStyle(
                          color: kTitleColor,
                          fontSize: 15,
                          fontFamily: "Quicksand",
                          fontWeight: FontWeight.w600)),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 40, top: 20, bottom: 5),
                  child: Row(
                    children: [
                      Text('Question:',
                          style: TextStyle(
                              color: kDarkBlue,
                              fontSize: 14,
                              fontFamily: "Nunito",
                              fontWeight: FontWeight.w400)),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 40, right: 40),
                  child: Container(
                    height: MediaQuery.of(context).size.height / 10,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(
                          Radius.circular(3),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withAlpha(10),
                            blurRadius: 20.0,
                            // has the effect of softening the shadow
                            spreadRadius: 10.0,
                            // has the effect of extending the shadow
                            offset: Offset(
                              0.0, // horizontal, move right 10
                              0.0, // vertical, move down 10
                            ),
                          ),
                        ],
                        border: Border.all(color: Color(0xff979797), width: 1)),
                    child: TextField(
                      style: TextStyle(
                        color: kTitleColor,
                        fontSize: 14,
                        fontFamily: "Quicksand",
                        fontWeight: FontWeight.w500,
                      ),
                      minLines: 2,
                      maxLines: 4,
                      autofocus: true,
                      autocorrect: true,
                      controller: textCtrl,
                      decoration: InputDecoration(
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white, width: 0),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        border: OutlineInputBorder(
                          borderSide: BorderSide(width: 0, color: Colors.white),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(width: 0, color: Colors.white),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        fillColor: Colors.white,
                        filled: true,
                        contentPadding: EdgeInsets.all(8),
                      ),
                      onChanged: (text) {
                        setState(() {
                          this.text = text;
                        });
                      },
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 40, top: 20, bottom: 5),
                  child: Row(
                    children: [
                      Text('Answer:',
                          style: TextStyle(
                              color: kDarkBlue,
                              fontSize: 14,
                              fontFamily: "Nunito",
                              fontWeight: FontWeight.w400))
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 40, right: 40),
                  child: Container(
                    height: MediaQuery.of(context).size.height / 10,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(
                          Radius.circular(3),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withAlpha(10),
                            blurRadius: 20.0,
                            // has the effect of softening the shadow
                            spreadRadius: 10.0,
                            // has the effect of extending the shadow
                            offset: Offset(
                              0.0, // horizontal, move right 10
                              0.0, // vertical, move down 10
                            ),
                          ),
                        ],
                        border: Border.all(color: Color(0xff979797), width: 1)),
                    child: TextField(
                      style: TextStyle(
                        color: kTitleColor,
                        fontSize: 14,
                        fontFamily: "Quicksand",
                        fontWeight: FontWeight.w500,
                      ),
                      minLines: 2,
                      maxLines: 4,
                      autofocus: true,
                      autocorrect: true,
                      controller: answerCtrl,
                      decoration: InputDecoration(
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white, width: 0),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        border: OutlineInputBorder(
                          borderSide: BorderSide(width: 0, color: Colors.white),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(width: 0, color: Colors.white),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        fillColor: Colors.white,
                        filled: true,
                        contentPadding: EdgeInsets.all(8),
                      ),
                      onChanged: (text) {
                        setState(() {
                          this.answer = text;
                        });
                      },
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(40, 10, 5, 0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Level:',
                          style: TextStyle(
                              color: kDarkBlue,
                              fontSize: 14,
                              fontFamily: "Nunito",
                              fontWeight: FontWeight.w400)),
                      Container(
                        height: 30,
                        child: RadioListTile(

                          tileColor: Colors.transparent,
                          selectedTileColor: Colors.transparent,
                          activeColor: Color(0xff5A5A5A),
                          groupValue: radioItem,

                          title: Text.rich(
                            TextSpan(
                              text: "1: ",
                              style: TextStyle(
                                  color: kdarkgreyfont,
                                  fontSize: 14,
                                  fontFamily: "Nunito",
                                  fontWeight: FontWeight.w900),
                              children: <TextSpan>[
                                TextSpan(
                                    text: "Essential, I must know this keynote",
                                    style: TextStyle(
                                        color: kdarkgreyfont,
                                        fontSize: 14,
                                        fontFamily: "Nunito",
                                        fontWeight: FontWeight.normal)),
                                // can add more TextSpans here...
                              ],
                            ),
                          ),
                          value: 1,
                          onChanged: (val) {
                            setState(() {
                              radioItem = val;
                              print(val);
                            });
                          },
                          dense: true,
                          contentPadding: EdgeInsets.all(0),
                        ),
                      ),
                      Container(
                        height: 30,
                        child: RadioListTile(
                          activeColor: Color(0xff5A5A5A),
                          contentPadding: EdgeInsets.all(0),
                          groupValue: radioItem,
                          title: Text.rich(
                            TextSpan(
                              text: "2: ",
                              style: TextStyle(
                                  color: kdarkgreyfont,
                                  fontSize: 14,
                                  fontFamily: "Nunito",
                                  fontWeight: FontWeight.w900),
                              children: <TextSpan>[
                                TextSpan(
                                    text: "Important but not essential",
                                    style: TextStyle(
                                        color: kdarkgreyfont,
                                        fontSize: 14,
                                        fontFamily: "Nunito",
                                        fontWeight: FontWeight.normal)),
                                // can add more TextSpans here...
                              ],
                            ),
                          ),
                          value: 2,
                          onChanged: (val) {
                            setState(() {
                              radioItem = val;
                              print(val);
                            });
                          },
                          dense: true,
                        ),
                      ),
                      Container(
                        height: 30,
                        child: RadioListTile(
                          activeColor: Color(0xff5A5A5A),
                          dense: true,
                          contentPadding: EdgeInsets.all(0),
                          groupValue: radioItem,
                          title: Text.rich(
                            TextSpan(
                              text: "3: ",
                              style: TextStyle(
                                  color: kdarkgreyfont,
                                  fontSize: 14,
                                  fontFamily: "Nunito",
                                  fontWeight: FontWeight.w900),
                              children: <TextSpan>[
                                TextSpan(
                                    text: "Not essential",
                                    style: TextStyle(
                                        color: kdarkgreyfont,
                                        fontSize: 14,
                                        fontFamily: "Nunito",
                                        fontWeight: FontWeight.normal)),
                                // can add more TextSpans here...
                              ],
                            ),
                          ),
                          value: 3,
                          onChanged: (val) {
                            setState(() {
                              radioItem = val;
                              print(val);
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
              ],
            ),

        ),
      ),
      bottomNavigationBar: BottomAppBar(
        elevation: 0,
        color: kBackgroundColor,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(0, 20, 0, 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              PrimaryButton(
                'ADD QUESTION',
                () async {
                  if (text.trim().length == 0) {
                    Scaffold.of(context).showSnackBar(SnackBar(
                      content: Text('Enter a short text'),
                    ));
                  }

                  Question question = widget.data;
                  if (question == null)
                    question = Question();
                  else
                    question.id = widget.data.id;
                  question.courseId = widget.course.id;
                  question.subjectId = widget.subject.id;
                  question.text = text.trim();
                  question.answer = answer.trim();
                  widget.store.saveQuestion(question);
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
