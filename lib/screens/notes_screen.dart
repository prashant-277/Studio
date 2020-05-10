import 'dart:math';

import 'package:drag_list/drag_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:line_awesome_icons/line_awesome_icons.dart';
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
    return Container(
      padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
      child: NoteItemsView(widget.store, widget.course, widget.subject),
    );
  }
}

class NoteItemsView extends StatelessWidget {
  final CoursesStore store;
  final Course course;
  final Subject subject;

  NoteItemsView(this.store, this.course, this.subject);

  @override
  Widget build(BuildContext context) => Observer(builder: (_) {
        return ModalProgressHUD(
          color: kLightGrey,
          child: resultWidget(context, store.notes),
          inAsyncCall: store.isNotesLoading,
        );
      });

  resultWidget(BuildContext context, List<Note> items) {
    if (!store.isNotesLoading && items.length == 0) {
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

    var dragList = DragList<Note>(
      items: items,
      itemExtent: 80,
      handleBuilder: (context) {
        return Container(
          height: 72.0,
          child: Icon(LineAwesomeIcons.bars),
        );
      },
      itemBuilder: (context, item, handle) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 24),
          child: Container(
            //padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 0),
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(10)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withAlpha(10),
                    blurRadius:
                    20.0, // has the effect of softening the shadow
                    spreadRadius:
                    10.0, // has the effect of extending the shadow
                    offset: Offset(
                      0.0, // horizontal, move right 10
                      0.0, // vertical, move down 10
                    ),
                  )
                ]),
            child: ListTile(
              onTap: () {},
              title: Container(
                child: Row(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 0, 10, 0),
                      child: handle,
                    ),
                    Text(
                      item.value.text.substring(0,
                          min(item.value.text.length, 30)
                      ) + (item.value.text.length > 30 ? '...' : ''),
                      style:
                      TextStyle(fontWeight: FontWeight.normal, fontSize: 18),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );

    var list = ListView.builder(
        physics: const AlwaysScrollableScrollPhysics(),
        itemCount: items.length,
        itemBuilder: (_, index) {
          final item = items[index];
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 24),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withAlpha(10),
                      blurRadius:
                          20.0, // has the effect of softening the shadow
                      spreadRadius:
                          10.0, // has the effect of extending the shadow
                      offset: Offset(
                        0.0, // horizontal, move right 10
                        0.0, // vertical, move down 10
                      ),
                    )
                  ]),
              child: ListTile(
                onTap: () {},
                title: Container(
                  child: Text(
                    item.text,
                    style:
                        TextStyle(fontWeight: FontWeight.normal, fontSize: 18),
                  ),
                ),
              ),
            ),
          );
        });

    return list;
  }
}
