import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:line_awesome_icons/line_awesome_icons.dart';

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
  String title = 'Add book';
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
      appBar: AppBar(
        iconTheme: IconThemeData(color: kDarkBlue),
        title: Text(widget.course.name),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(22.0),
          child: Column(
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
                    hintText: 'Book name',
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
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 20, 0, 10),
                child: PrimaryButton('Save', () {
                  var id = widget.data == null ? null : widget.data.id;
                  Book book = Book();
                  book.id = id;
                  book.title = name;
                  book.courseId = widget.course.id;
                  widget.store.saveBook(book);
                  Navigator.pop(context);
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
