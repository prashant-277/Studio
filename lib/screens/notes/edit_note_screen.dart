import 'package:flutter/material.dart';
import 'package:line_awesome_icons/line_awesome_icons.dart';
import 'package:studio/courses_store.dart';
import 'package:studio/models/book.dart';
import 'package:studio/models/course.dart';
import 'package:studio/models/note.dart';
import 'package:studio/models/subject.dart';
import 'package:studio/widgets/buttons.dart';

import '../../constants.dart';

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

  @override
  void initState() {
    if (widget.data != null) {
      textCtrl.text = widget.data.text;
      text = widget.data.text;
      level = widget.data.level;
    }
    super.initState();
  }

  Widget _addLevelChip(int l) {
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: kDarkBlue),
        centerTitle: true,
        title: Text('Edit note' //widget.subject.name,
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
                  child: Text('Enter your note:'),
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
                SizedBox(
                  height: 20,
                ),
                Wrap(
                  crossAxisAlignment: WrapCrossAlignment.center,
                  spacing: 10,
                  children: <Widget>[
                    Text(
                      'Level:',
                      style: TextStyle(fontSize: 18),
                    ),
                    _addLevelChip(1),
                    _addLevelChip(2),
                    _addLevelChip(3),
                  ],
                ),
                SizedBox(
                  height: 20,
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
              ],
            ),
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

  LevelChip({@required this.level, @required this.onSelected, @required this.selected});

  FontWeight _getFontWeight() {
    if (level == 1) return FontWeight.w100;
    if (level == 2) return FontWeight.w600;

    return FontWeight.w900;
  }

  @override
  Widget build(BuildContext context) {
    return ChoiceChip(
        label: Text(
          level.toString(),
          style: TextStyle(fontWeight: _getFontWeight()),
        ),
        selected: selected,
        onSelected: onSelected);
  }
}
