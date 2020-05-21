import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:line_awesome_icons/line_awesome_icons.dart';
import 'package:studio/models/book.dart';
import 'package:studio/models/course.dart';
import 'package:studio/models/subject.dart';
import 'package:studio/widgets/buttons.dart';

import '../constants.dart';
import '../courses_store.dart';

class EditSubjectScreen extends StatefulWidget {
  static final id = 'edit_subject_screen';
  final CoursesStore store;
  final Course course;
  final Subject data;

  EditSubjectScreen(this.store, this.course, this.data);

  @override
  _EditSubjectScreenState createState() => _EditSubjectScreenState();
}

class _EditSubjectScreenState extends State<EditSubjectScreen> {
  String name;
  String title = 'Add subject';
  String bookId;
  String bookTitle;
  String newBookTitle = '';
  List<Widget> booksRow = List();
  TextEditingController textCtrl = TextEditingController();

  @override
  void initState() {
    if (widget.data != null) {
      textCtrl.text = widget.data.name;
      name = widget.data.name;
      title = 'Edit subject';
      bookId = widget.data.bookId;
    }
    super.initState();
    widget.store.loadBooks(widget.course.id);
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
                              color: kPrimaryColor,
                              onPressed: () async {
                                if (newBookTitle.length > 0) {
                                  Navigator.maybePop(context);
                                  Book book = Book();
                                  book.title = newBookTitle;
                                  book.courseId = widget.course.id;
                                  await widget.store.saveBook(book);
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
    return widget.store.books
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
          appBar: AppBar(
            iconTheme: IconThemeData(color: kDarkBlue),
            title: Text(widget.course.name),
            centerTitle: true,
          ),
          body: SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(22.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Padding(
                      padding:
                          const EdgeInsets.symmetric(vertical: 0, horizontal: 16),
                      child: Text(
                        title + ':',
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                    TextField(
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
                          hintText: 'Subject name',
                          fillColor: Colors.white,
                          filled: true,
                          contentPadding: EdgeInsets.all(8),
                          prefixIcon: Icon(Icons.chevron_right)),
                      onChanged: (text) {
                        setState(() {
                          name = text;
                        });
                      },
                    ),
                    Wrap(spacing: 4, children: bookRow()),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 20, 0, 10),
                      child: PrimaryButton('Save', () {
                        var id = widget.data == null ? null : widget.data.id;
                        Subject subject = Subject();
                        subject.id = id;
                        subject.name = name;
                        subject.courseId = widget.course.id;
                        subject.bookTitle = bookTitle;
                        subject.bookId = bookId;
                        widget.store.saveSubject(subject);
                        Navigator.pop(context);
                      }),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      });
}
