import 'package:flutter/material.dart';
import 'package:line_awesome_icons/line_awesome_icons.dart';
import 'package:studio/courses_store.dart';
import 'package:studio/models/book.dart';
import 'package:studio/models/course.dart';
import 'package:studio/models/question.dart';
import 'package:studio/models/subject.dart';
import 'package:studio/widgets/buttons.dart';

import '../constants.dart';

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

  @override
  void initState() {
    if(widget.data != null) {
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
      appBar: AppBar(
        iconTheme: IconThemeData(color: kDarkBlue),
        centerTitle: true,
        title: Text('Edit question' //widget.subject.name,
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(18.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.all(10),
                  child: Text('Enter question:'),
                ),
                Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(10)),
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
                        )
                      ]),
                  child: TextField(
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
                Padding(
                  padding: EdgeInsets.all(10),
                  child: Text('Enter the answer:'),
                ),
                Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(10)),
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
                        )
                      ]),
                  child: TextField(
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
                Container(
                  margin: EdgeInsets.fromLTRB(0, 20, 0, 10),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,

                  children: <Widget>[
/*                    IconButton(
                      child: Icon(LineAwesomeIcons.camera),
                      color: Colors.red,
                      focusColor: Colors.white,
                      highlightColor: Colors.white,
                      splashColor: Colors.white,
                      hoverColor: Colors.green,
                      disabledColor: Colors.blue,
                      onPressed: () {
                        print("camera");
                      },
                    ),

                    Container(
                      margin: EdgeInsets.fromLTRB(0, 0, 20, 0),
                      child: FloatingActionButton(
                        heroTag: 'addMic',
                        child: Icon(Icons.mic_none),
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.blueGrey,
                        elevation: 10,
                        onPressed: () {

                        },
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.fromLTRB(0, 0, 20, 0),
                      child: FloatingActionButton(
                        heroTag: 'attachFile',
                        child: Icon(Icons.attach_file),
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.blueGrey,
                        elevation: 10,
                        onPressed: () {

                        },
                      ),
                    ),*/
                    PrimaryButton(
                      'Save',
                          () async {
                        if(text.trim().length == 0) {
                          Scaffold.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Enter a short text'),
                              )
                          );
                        }

                        Question question = widget.data;
                        if(question == null)
                          question = Question();
                        else
                          question.id = widget.data.id;
                        question.courseId = widget.course.id;
                        question.subjectId = widget.subject.id;
                        question.text = text.trim();
                        widget.store.saveQuestion(question);
                        Navigator.pop(context);
                      },
                    ),
                  ],
                ),

              ],
            ),
          ),
        ),
      ),
    );
  }
}
