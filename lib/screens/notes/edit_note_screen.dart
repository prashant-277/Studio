import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:line_awesome_icons/line_awesome_icons.dart';

import '../../constants.dart';
import '../../courses_store.dart';
import '../../models/note.dart';
import '../../widgets/buttons.dart';

class NoteEdit extends StatefulWidget {
  final CoursesStore store;
  final Note data;

  NoteEdit(this.store, this.data);

  @override
  _NoteEditState createState() => _NoteEditState();
}

class _NoteEditState extends State<NoteEdit> {
  String text = '';
  int level = 1;
  TextEditingController textCtrl = TextEditingController();

  var radioItem;

  @override
  void initState() {
    if (widget.data != null) {
      textCtrl.text = widget.data.text;
      text = widget.data.text;
      level = widget.data.level;
    }
    super.initState();
  }

  /*Widget _addLevelChip(int l) {
    return LevelChip(
      level: l,
      selected: level == l,
      onSelected: (s) {
        if (s) {
          setState(() {
            level = l;
          });
        }
      },
    );
  }*/

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
                fontSize: 25,
                fontFamily: "Quicksand",
                fontWeight: FontWeight.w200)),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(top: 0),
                child: Text('Introduction',
                    style: TextStyle(
                        color: kDarkBlue,
                        fontSize: 18,
                        fontFamily: "Quicksand",
                        fontWeight: FontWeight.w600)),
              ),
              Padding(
                padding: EdgeInsets.all(10),
                child: Text('Add new keynote',
                    style: TextStyle(
                        color: kTitleColor,
                        fontSize: 15,
                        fontFamily: "Quicksand",
                        fontWeight: FontWeight.w600)),
              ),
              Padding(
                padding: EdgeInsets.only(left: 40, top: 25, bottom: 10),
                child: Row(
                  children: [
                    Text('Keynote:',
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
                padding: const EdgeInsets.fromLTRB(15, 20, 15, 0),
                child: Card(
                  elevation: 0,
                  child: Container(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(13, 5, 13, 10),
                      child: Center(
                        child: Text.rich(
                          TextSpan(
                            text: "☞",
                            style: TextStyle(
                                color: kTitleColor,
                                fontSize: 20,
                                fontFamily: "Quicksand",
                                fontWeight: FontWeight.w200),
                            children: <TextSpan>[
                              TextSpan(
                                text: " Write a very ",
                                style: TextStyle(
                                    color: kTitleColor,
                                    fontSize: 15,
                                    fontFamily: "Quicksand",
                                    fontWeight: FontWeight.w200),
                              ),
                              TextSpan(
                                text: "short ",
                                style: TextStyle(
                                    color: kTitleColor,
                                    fontSize: 15,
                                    fontFamily: "Quicksand",
                                    fontWeight: FontWeight.bold),
                              ),
                              TextSpan(
                                text:
                                    "keynote. A keynote  is like a memorandum about what you have to study",
                                style: TextStyle(
                                    color: kTitleColor,
                                    fontSize: 15,
                                    fontFamily: "Quicksand",
                                    fontWeight: FontWeight.w200),
                              ),
                              // can add more TextSpans here...
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(40, 20, 5, 0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: Text('Level:',
                          style: TextStyle(
                              color: kDarkBlue,
                              fontSize: 14,
                              fontFamily: "Nunito",
                              fontWeight: FontWeight.w400)),
                    ),
                    Container(
                      height: 30,
                      child: RadioListTile(
                        tileColor: Colors.transparent,
                        selectedTileColor: Colors.transparent,
                        activeColor: kdarkgreyfont,
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
                        contentPadding: EdgeInsets.zero,
                      ),
                    ),
                    Container(
                      height: 30,
                      child: RadioListTile(
                        activeColor: kdarkgreyfont,
                        contentPadding: EdgeInsets.zero,
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
                        activeColor: kdarkgreyfont,
                        dense: true,
                        contentPadding: EdgeInsets.zero,
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

              /*Wrap(
                crossAxisAlignment: WrapCrossAlignment.start,
                direction: Axis.vertical,
                spacing: 0,
                children: <Widget>[
                  Text('Level:',
                      style: TextStyle(
                          color: kDarkBlue,
                          fontSize: 14,
                          fontFamily: "Nunito",
                          fontWeight: FontWeight.w400)),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      _addLevelChip(1),
                      Text(
                        "Essential, I must know this keynote",
                        style: TextStyle(
                            color: kTitleColor,
                            fontFamily: "Nunito",
                            fontWeight: FontWeight.normal),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      _addLevelChip(2),
                      Text(
                        "Important but not essential",
                        style: TextStyle(
                            color: kTitleColor,
                            fontFamily: "Nunito",
                            fontWeight: FontWeight.normal),
                      ),
                    ],
                  ),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      _addLevelChip(3),
                      Text(
                        "Not essential",
                        style: TextStyle(
                            color: kTitleColor,
                            fontFamily: "Nunito",
                            fontWeight: FontWeight.normal),
                      ),
                    ],
                  ),
                ],
              ),*/
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
                'ADD KEYNOTE',
                () async {
                  if (text.trim().length == 0) {
                    Scaffold.of(context).showSnackBar(SnackBar(
                      content: Text('Enter a short text'),
                    ));
                  }

                  Note note = widget.data;
                  if (note == null)
                    note = Note();
                  else
                    note.id = widget.data.id;
                  note.courseId = widget.store.course.id;
                  note.subjectId = widget.store.subject.id;
                  note.text = text.trim();
                  note.level = level;
                  widget.store.saveNote(note);
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

class LevelChip extends StatelessWidget {
  final int level;
  final Function onSelected;
  final bool selected;

  LevelChip(
      {@required this.level,
      @required this.onSelected,
      @required this.selected});

  FontWeight _getFontWeight() {
    if (level == 1) return FontWeight.w900;
    if (level == 2) return FontWeight.w900;

    return FontWeight.w900;
  }

  @override
  Widget build(BuildContext context) {
    return ChoiceChip(
        backgroundColor: kBackgroundColor,
        label: Text(
          level.toString(),
          style: TextStyle(fontWeight: _getFontWeight()),
        ),
        selected: selected,
        onSelected: onSelected);
  }
}
