import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:line_awesome_icons/line_awesome_icons.dart';
import 'package:studio/screens/edit_book_screen.dart';

import '../../constants.dart';
import '../../courses_store.dart';
import '../../models/book.dart';
import '../../models/course.dart';
import '../../models/subject.dart';
import '../../widgets/buttons.dart';

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
  String title = 'Add new subject';
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
      backgroundColor: Colors.white,
      labelStyle: TextStyle(
          color: kTitleColor,
          fontSize: 14,
          fontFamily: "Quicksand",
          fontWeight: FontWeight.w200),
      label: Text('ADD BOOK'),
      avatar: Icon(
        LineAwesomeIcons.plus,
        size: 16,
      ),
      onPressed: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    EditBookScreen(widget.store, widget.store.course, null)));
        /*showDialog<int>(

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
            });*/
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

              selectedColor: Colors.blue,
              disabledColor: Colors.white,
              label: Text(e.title),
              labelStyle: TextStyle(
                  color: bookId == e.id ? Colors.white:Colors.black,
                  fontSize: 14,
                  fontFamily: "Quicksand",
                  fontWeight: FontWeight.w500),
              backgroundColor: Colors.white,
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
            backgroundColor: kBackgroundColor,
            appBar: AppBar(
              iconTheme: IconThemeData(color: kTitleColor),
              title: Text(widget.course.name,
                  style: TextStyle(
                      color: kTitleColor,
                      fontSize: 25,
                      fontFamily: "Quicksand",
                      fontWeight: FontWeight.w500)),
              centerTitle: true,
            ),
            body: SafeArea(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              title + ':',
                              style: TextStyle(
                                  color: kTitleColor,
                                  fontSize: 15,
                                  fontFamily: "Quicksand",
                                  fontWeight: FontWeight.w600),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height / 10.0,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 35),
                        child: TextField(
                          style: TextStyle(
                            color: kTitleColor,
                            fontSize: 14,
                            fontFamily: "Quicksand",
                            fontWeight: FontWeight.w500,
                          ),
                          autocorrect: true,
                          controller: textCtrl,
                          decoration: InputDecoration(
                            hintText: 'Name of the subject:',
                            filled: true,
                            fillColor: kBackgroundColor,
                            isDense: true,
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: 2, vertical: 3),
                            hintStyle: TextStyle(
                              color: kTitleColor,
                              fontSize: 14,
                              fontFamily: "Quicksand",
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          onChanged: (text) {
                            setState(() {
                              name = text;
                            });
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(8, 20, 8, 0),
                        child: Card(
                          elevation: 0,
                          child: Container(
                            decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(00))),
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(10, 5, 10, 10),
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
                                        text:
                                            " A subject is a unit of a course. Usually they match with the",
                                        style: TextStyle(
                                            color: kTitleColor,
                                            fontSize: 14,
                                            fontFamily: "Quicksand",
                                            fontWeight: FontWeight.w200),
                                      ),
                                      TextSpan(
                                        text: " chapter",
                                        style: TextStyle(
                                            color: kTitleColor,
                                            fontSize: 14,
                                            fontFamily: "Quicksand",
                                            fontWeight: FontWeight.bold),
                                      ),
                                      TextSpan(
                                        text: " of a book.",
                                        style: TextStyle(
                                            color: kTitleColor,
                                            fontSize: 14,
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
                        height: 20,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 5),
                        child: Row(
                          children: [
                            Text(
                              "Book:",
                              style: TextStyle(
                                  color: kTitleColor,
                                  fontSize: 14,
                                  fontFamily: "Quicksand",
                                  fontWeight: FontWeight.w600),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 10.0),
                        child: Wrap(spacing: 4, children: bookRow()),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Card(
                          elevation: 0,
                          child: Container(
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(10, 5, 10, 10),
                              child: Center(
                                child: Text.rich(TextSpan(
                                    text: "☞ ",
                                    style: TextStyle(
                                        color: kTitleColor,
                                        fontSize: 20,
                                        fontFamily: "Quicksand",
                                        fontWeight: FontWeight.w200),
                                    children: <TextSpan>[
                                      TextSpan(
                                        text:
                                            "If this subject is from a book, then add it to the library.",
                                        style: TextStyle(
                                            color: kTitleColor,
                                            fontSize: 14,
                                            fontFamily: "Quicksand",
                                            fontWeight: FontWeight.w200),
                                      ),
                                    ])),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
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
                    PrimaryButton('ADD SUBJECT', () {
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
                  ],
                ),
              ),
            ));
      });
}
