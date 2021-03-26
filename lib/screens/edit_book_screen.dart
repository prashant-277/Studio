import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/widgets.dart';

import '../constants.dart';
import '../courses_store.dart';
import '../models/book.dart';
import '../models/course.dart';
import '../widgets/buttons.dart';

class EditBookScreen extends StatefulWidget {
  static final id = 'edit_book_screen';
  final CoursesStore store;
  final Course course;
  final Book data;

  EditBookScreen(this.store, this.course, this.data);

  @override
  _EditBookScreenState createState() => _EditBookScreenState();
}

class _EditBookScreenState extends State<EditBookScreen> {
  String name;
  String title = 'Add new book';
  TextEditingController textCtrl = TextEditingController();

  @override
  void initState() {
    if (widget.data != null) {
      textCtrl.text = widget.data.title;
      name = widget.data.title;
      title = 'Edit book';
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
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
                  height: MediaQuery.of(context).size.height / 9.0,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 20, right: 20),
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
                        hintText: 'Title of the book:',
                        filled: true,
                        isDense: true,
                        fillColor: kBackgroundColor,
                        contentPadding: EdgeInsets.symmetric(horizontal: 2,vertical: 3),
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
                PrimaryButton('ADD BOOK', () {
                  var id = widget.data == null ? null : widget.data.id;
                  Book book = Book();
                  book.id = id;
                  book.title = name;
                  book.courseId = widget.course.id;
                  widget.store.saveBook(book);
                  Navigator.pop(context);
                }),
              ],
            ),
          ),
        ));
  }
}
