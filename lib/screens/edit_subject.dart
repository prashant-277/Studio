import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:line_awesome_icons/line_awesome_icons.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:studio/globals.dart';
import 'package:studio/models/book.dart';
import 'package:studio/models/subject.dart';
import 'package:studio/widgets/label.dart';
import 'package:studio/widgets/subtitle.dart';
import 'package:studio/widgets/tip_card.dart';

import '../colors.dart';

class EditSubjectScreen extends StatefulWidget {
  static const id = 'edit_subject';
  final Subject data;

  EditSubjectScreen({this.data});

  @override
  _EditSubjectScreenState createState() => _EditSubjectScreenState();
}

class _EditSubjectScreenState extends State<EditSubjectScreen> {
  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  String bookId;
  String bookTitle;
  String newBookTitle = '';
  List<Widget> booksRow = List();
  TextEditingController textCtrl = TextEditingController();

  String name;

  @override
  void initState() {
    if (widget.data != null) {
      textCtrl.text = widget.data.name;
      name = widget.data.name;
      bookId = widget.data.bookId;
    }
    Globals.coursesStore.loadBooks(Globals.coursesStore.courseId);
    super.initState();
  }

  _displaySnackBar(BuildContext context, String text) {
    final snackBar = SnackBar(content: Text(text));
    _scaffoldKey.currentState.showSnackBar(snackBar);
  }

  ProgressDialog _getProgress(BuildContext context) {
    return ProgressDialog(context);
  }

  List<Widget> bookRow() {
    var add = ActionChip(
      label: Text('New book'),
      avatar: Icon(
        LineAwesomeIcons.plus,
        size: 16,
      ),
      onPressed: () {
        showDialog<int>(
            context: context,
            builder: (BuildContext context) {
              return SimpleDialog(
                title: const Text('New book'),
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          'Enter title:',
                        ),
                        TextField(
                          autocorrect: true,
                          autofocus: true,
                          onChanged: (t) {
                            setState(() {
                              newBookTitle = t;
                            });
                          },
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Wrap(
                          alignment: WrapAlignment.spaceEvenly,
                          spacing: 10,
                          children: <Widget>[
                            RaisedButton(
                              child: Text('Cancel'),
                              color: Colors.white,
                              onPressed: () {
                                Navigator.maybePop(context);
                              },
                            ),
                            RaisedButton(
                              elevation: 10,
                              child: Text('Save'),
                              color: kAccentColor,
                              onPressed: () async {
                                if (newBookTitle.length > 0) {
                                  Navigator.maybePop(context);
                                  Book book = Book();
                                  book.title = newBookTitle;
                                  book.courseId = Globals.coursesStore.courseId;
                                  await Globals.coursesStore.saveBook(book);
                                }
                              },
                            ),
                          ],
                        )
                      ],
                    ),
                  )
                ],
              );
            });
      },
      padding: const EdgeInsets.all(4),
    );
    var row = List<Widget>();
    row.add(add);
    row.addAll(_booksChips());
    return row;
  }

  List<Widget> _booksChips() {
    return Globals.coursesStore.books
        .map((e) => ChoiceChip(
              label: Text(e.title),
              selected: bookId == e.id,
              onSelected: (v) {
                setState(() {
                  if (v) {
                    bookId = e.id;
                    bookTitle = e.title;
                  } else {
                    bookId = bookTitle = null;
                  }
                });
              },
            ))
        .toList();
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
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Subtitle(
                      text:
                          widget.data == null ? 'Add subject' : 'Edit subject'),
                  Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        TextFormField(
                          autofocus: true,
                          controller: textCtrl,
                          decoration: InputDecoration(
                              labelText: 'Enter the name of the subject'),
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Please enter some text';
                            }
                            return null;
                          },
                          onChanged: (text) {
                            setState(() {
                              name = text;
                            });
                          },
                        ),
                        TipCard(
                          text:
                              '👉 A subject is a unit of a course. Usually they match with the chapter of a book.',
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(12, 20, 12, 0),
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Label(text: 'Book'),
                              Wrap(spacing: 4, children: bookRow()),
                            ],
                          ),
                        ),
                        TipCard(
                          text:
                              '👉 If this subject is from a book, then add it to the library.',
                        )
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
                    Subject subject = Subject();
                    subject.courseId = Globals.coursesStore.courseId;
                    subject.name = name;
                    if (widget.data != null) subject.id = widget.data.id;

                    final ProgressDialog pr = _getProgress(context);
                    pr.update(message: "Please wait...");
                    await pr.show();
                    Globals.coursesStore
                        .saveSubject(subject)
                        .then((value) async {
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
          )),
        );
      });
}
