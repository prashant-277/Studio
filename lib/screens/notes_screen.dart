import 'dart:math';

import 'package:carousel_slider/carousel_slider.dart';
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
import 'edit_note_screen.dart';

class NotesView extends StatelessWidget {
  final CoursesStore store;
  final Course course;
  final Subject subject;
  final int mode;

  NotesView(this.store, this.course, this.subject, this.mode);

  @override
  Widget build(BuildContext context) {
    return NoteList(this.store, this.course, this.subject, this.mode);
  }
}

class NoteList extends StatefulWidget {
  final CoursesStore store;
  final Course course;
  final Subject subject;
  final int mode;

  NoteList(this.store, this.course, this.subject, this.mode);

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
      child: NoteItemsView(
          widget.store, widget.course, widget.subject, widget.mode),
    );
  }
}

class NoteItemsView extends StatefulWidget {
  final CoursesStore store;
  final Course course;
  final Subject subject;
  final int mode;

  NoteItemsView(this.store, this.course, this.subject, this.mode);

  @override
  _NoteItemsViewState createState() => _NoteItemsViewState();
}

class _NoteItemsViewState extends State<NoteItemsView> {
  int editState = -1;

  @override
  void initState() {
    super.initState();
  }

  Widget getTrailingIcon(int index) {
    int opacity = 0;
    if (editState == index) opacity = 255;

    if(editState != index)
      return null;

    return IconButton(
      icon: Icon(
        LineAwesomeIcons.trash,
      ),
      color: Colors.red.withAlpha(opacity),
      onPressed: () {
        //widget.store.deleteNote(widget.store.notes.elementAt(index).id);
      },
    );
  }

  @override
  Widget build(BuildContext context) => Observer(builder: (_) {
        return ModalProgressHUD(
          color: kLightGrey,
          child: resultWidget(context, widget.store.notes),
          inAsyncCall: widget.store.isNotesLoading,
        );
      });

  resultWidget(BuildContext context, List<Note> items) {
    if (!widget.store.isNotesLoading && items.length == 0) {
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
                    blurRadius: 20.0, // has the effect of softening the shadow
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
                      item.value.text
                              .substring(0, min(item.value.text.length, 30)) +
                          (item.value.text.length > 30 ? '...' : ''),
                      style: TextStyle(
                          fontWeight: FontWeight.normal, fontSize: 18),
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
            padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 20),
            child: Container(
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
                onTap: () {
                  setState(() {
                    editState = -1;
                  });
                },
                onLongPress: () {
                  /*setState(() {
                    editState = index;
                  });*/

                  var text = item.text;
                  if(item.text.length > 100)
                    text = item.text.substring(0, 100) + '...';

                  showDialog(
                      context: context,
                      builder: (_) => AlertDialog(
                        //title: Text('Confirm'),
                        content: Text(text),
                        actions: <Widget>[
                          FlatButton(
                            child: Text('Delete'),
                            textColor: Colors.red,
                            onPressed: () {
                              Navigator.pop(context);
                              widget.store.deleteNote(item.id, () {
                                widget.store.loadNotes(widget.subject.id);
                              });
                            },
                          ),
                          FlatButton(
                            onPressed: () {
                              Navigator.pop(context);
                              Navigator.push(context, MaterialPageRoute(
                                  builder: (context) =>
                                      NoteEdit(widget.store, widget.course, widget.subject, item)
                              ));
                            },
                            child: Text('Edit'),
                          ),
                        ],
                      ));
                },
                //contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 4),
                title: Container(
                  child: Text(
                    item.text,
                    style:
                        TextStyle(fontWeight: FontWeight.normal, fontSize: 18),
                  ),
                ),
                trailing: getTrailingIcon(index),
              ),
            ),
          );
        });

    var carousel = CarouselSlider(
      options:
          CarouselOptions(height: MediaQuery.of(context).size.height - 240),
      items: items.map((i) {
        return Builder(
          builder: (BuildContext context) {
            return Container(
                padding: EdgeInsets.all(40),
                width: MediaQuery.of(context).size.width,
                margin: EdgeInsets.symmetric(horizontal: 15.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      i.text,
                      style: TextStyle(fontSize: 16.0),
                    ),
                  ],
                ));
          },
        );
      }).toList(),
    );

    if (widget.mode == kModeCarousel) return carousel;

    return list;
  }
}