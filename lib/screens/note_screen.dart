import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:studio/courses_store.dart';
import 'package:studio/models/course.dart';
import 'package:studio/models/note.dart';
import 'package:studio/models/subject.dart';

import '../constants.dart';

class NotesView extends StatelessWidget {
  final CoursesStore store;
  final Course course;
  final Subject subject;

  NotesView(this.store, this.course, this.subject);

  @override
  Widget build(BuildContext context) {
    return NoteList(this.store, this.course, this.subject);
  }
}

class NoteList extends StatefulWidget {

  final CoursesStore store;
  final Course course;
  final Subject subject;

  NoteList(this.store, this.course, this.subject);

  @override
  _NoteListState createState() => _NoteListState();
}

class _NoteListState extends State<NoteList> {

  @override
  void initState() {
    widget.store.loadNotes(widget.subject.id);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return NoteItemsView(widget.store, widget.course, widget.subject);
  }
}

class NoteItemsView extends StatelessWidget {

  final CoursesStore store;
  final Course course;
  final Subject subject;

  NoteItemsView(this.store, this.course, this.subject);

  @override
  Widget build(BuildContext context) => Observer(builder: (_) {
    return  ModalProgressHUD(
      color: kLightGrey,
      child: resultWidget(context, store.notes),
      inAsyncCall: store.isNotesLoading,
    );
  });

  resultWidget(BuildContext context, List<Note> items) {
    if(!store.isNotesLoading && items.length == 0) {
      return Column(
        children: <Widget>[
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'No notes yet',
                style: TextStyle(
                  fontSize: 18,
                ),
              ),
            ),
          ),
        ],
      );
    }

    return ListView.builder(
        physics: const AlwaysScrollableScrollPhysics(),
        itemCount: items.length,
        itemBuilder: (_, index) {
          final item = items[index];
          return Padding(
            padding: const EdgeInsets.symmetric(
                vertical: 4,
                horizontal: 10
            ),
            child: Container(
              child: ListTile(
                onTap: () {

                },

                trailing: const Icon(
                  Icons.chevron_right,
                  color: kDarkBlue,
                ),
                title: Container(
                  child: Text(
                    item.text,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
          );
        });
  }
}
