import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:studio/models/note.dart';
import 'package:studio/widgets/label.dart';
import 'package:studio/widgets/mini_subtitle.dart';
import 'package:studio/widgets/subtitle.dart';
import 'package:studio/widgets/tip_card.dart';

import '../colors.dart';
import '../globals.dart';

class EditNoteScreen extends StatefulWidget {

  final Note data;

  EditNoteScreen({ this.data });

  @override
  _EditNoteScreenState createState() => _EditNoteScreenState();
}

class _EditNoteScreenState extends State<EditNoteScreen> {

  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  String bookId;
  String bookTitle;
  String newBookTitle = '';
  List<Widget> booksRow = List();
  TextEditingController textCtrl = TextEditingController();

  String _text;
  int _level = 1;

  @override
  void initState() {
    if (widget.data != null) {
      textCtrl.text = widget.data.text;
    }

    super.initState();
  }

  _displaySnackBar(BuildContext context, String text) {
    final snackBar = SnackBar(content: Text(text));
    _scaffoldKey.currentState.showSnackBar(snackBar);
  }

  ProgressDialog _getProgress(BuildContext context) {
    return ProgressDialog(context);
  }

  @override
  Widget build(BuildContext context) => Observer(builder: (_) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(Globals.coursesStore.courseName),
      ),
      backgroundColor: kBackgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(
              horizontal: 16
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              MiniSubtitle(text: Globals.coursesStore.subjectName),
              Subtitle(text: widget.data == null ? 'Add keynote' : 'Edit keynote'),
              Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    TextFormField(
                      autofocus: true,
                      maxLines: 2,
                      minLines: 2,
                      controller: textCtrl,
                      decoration: InputDecoration(
                          labelText: 'Enter the keynote',
                      ),
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please enter some text';
                        }
                        return null;
                      },
                      onChanged: (text) {
                        setState(() {
                          _text = text;
                        });
                      },
                    ),

                    TipCard(text: '👉 Write a very short keynote. A keynote is like a memorandum about what you have to study.',),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 12,
                      ),
                      child: Label(text: 'Level:'),
                    ),
                    ListTile(
                      title: const
                        Text('1: Essential, I must know this keynote',
                        style: TextStyle(
                            fontSize: 16
                        ),
                      ),
                      leading: Radio(
                        value: 1,
                        groupValue: _level,
                        onChanged: (int value) {
                          setState(() {
                            _level = value;
                          });
                        },
                      ),
                    ),
                    ListTile(
                      title: const
                        Text('2: Important but not essential',
                        style: TextStyle(
                          fontSize: 16
                        ),
                      ),
                      leading: Radio(
                        value: 2,
                        groupValue: _level,
                        onChanged: (int value) {
                          setState(() {
                            _level = value;
                          });
                        },
                      ),
                    ),
                    ListTile(
                      title: const
                      Text('3: Not essential',
                        style: TextStyle(
                            fontSize: 16
                        ),
                      ),
                      leading: Radio(
                        value: 3,
                        groupValue: _level,
                        onChanged: (int value) {
                          setState(() {
                            _level = value;
                          });
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              FlatButton(
                child: Text('SAVE'),
                onPressed: () async {
                  if (_formKey.currentState.validate()) {

                    Note note = Note();
                    note.courseId = Globals.coursesStore.courseId;
                    note.subjectId = Globals.coursesStore.subjectId;
                    note.text = _text;
                    note.bookmark = false;
                    note.attention = false;
                    note.level = _level;

                    if(widget.data != null)
                      note.id = widget.data.id;

                    final ProgressDialog pr = _getProgress(context);
                    pr.update(message: "Please wait...");
                    await pr.show();
                    Globals.coursesStore.saveNote(note).then((value) async {
                      await Globals.authStore.loadStats();
                      pr.hide();
                      Navigator.pop(context);
                    });
                  }
                },
                color: kAccentColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18.0),
                ),
              ),
            ],
          )
      ),
    );
  });
}
