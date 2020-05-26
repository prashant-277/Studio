import 'dart:async';
import 'dart:math';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:drag_list/drag_list.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:line_awesome_icons/line_awesome_icons.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:studio/courses_store.dart';
import 'package:studio/models/course.dart';
import 'package:studio/models/note.dart';
import 'package:studio/models/question.dart';
import 'package:studio/models/subject.dart';
import 'package:studio/screens/edit_question_screen.dart';
import 'dart:math';
import '../../constants.dart';
import 'edit_note_screen.dart';

class NoteList extends StatefulWidget {
  final CoursesStore store;
  final Course course;
  final Subject subject;
  final int mode;
  final Function changeMode;
  final int index;

  NoteList(this.store, this.course, this.subject, this.mode, this.changeMode,
      this.index);

  @override
  _NoteListState createState() => _NoteListState();
}

class _NoteListState extends State<NoteList> with TickerProviderStateMixin {
  int editState = -1;
  bool bookmarked = false;
  CarouselController carouselController = CarouselController();

  @override
  void initState() {
    print("init state notes");
    widget.store.loadNotes(widget.subject.id);
    super.initState();
  }

  Widget getTrailingIcon(int index) {
    int opacity = 0;
    if (editState == index) opacity = 255;

    if (editState != index) return null;

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
        print("build notes view");
        return ModalProgressHUD(
          color: kLightGrey,
          child: resultWidget(context, widget.store.notes),
          inAsyncCall: widget.store.isNotesLoading,
        );
      });

  resultWidget(BuildContext context, List<Note> items) {
    if (!widget.store.isNotesLoading && items.length == 0) {
      return EmptyNotesScreen(bookmarked, (state) {
        widget.store.filterNotes(state);
        setState(() {
          bookmarked = state;
        });
      });
    }

    var list = ListView.builder(
        physics: const AlwaysScrollableScrollPhysics(),
        itemCount: items.length + 1,
        itemBuilder: (_, index) {
          if (index == 0) {
            return Container(
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 4, 16, 4),
                child: Wrap(
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: <Widget>[
                    Switch(
                      activeColor: kPrimaryColor,
                      value: bookmarked,
                      onChanged: (state) {
                        widget.store.filterNotes(state);
                        setState(() {
                          bookmarked = state;
                        });
                      },
                    ),
                    Text('Bookmarked')
                  ],
                ),
              ),
            );
          }

          final item = items[index - 1];

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
                    //currentIndex = index;
                    widget.changeMode(kModeCarousel, index);
                  });
                },
                onLongPress: () {
                  /*setState(() {
                    editState = index;
                  });*/

                  var text = item.text;
                  if (item.text.length > 100)
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
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => NoteEdit(
                                              widget.store,
                                              widget.course,
                                              widget.subject,
                                              item)));
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

    var carousel = getCarousel(items);

    if (widget.mode == kModeCarousel) return carousel;
    return list;
  }

  Timer timer1;
  Timer timer2;

  Widget getCarousel(List<Note> items) {
    var subjIndex = widget.store.subjects.indexOf(widget.subject);
    var count = items.length + 2;
    bool isLast = subjIndex == widget.store.notes.length;
    if (isLast) count--;

    return CarouselSlider.builder(
      options: CarouselOptions(
          height: MediaQuery.of(context).size.height - 240,
          enableInfiniteScroll: false,
          initialPage: widget.index,
          ),
      itemCount: count,
      carouselController: carouselController,
      itemBuilder: (ctx, i) {
        if (i == 0) {
          return coverSlider([
            Text(
              widget.store.subjects[subjIndex].name,
              style: TextStyle(fontSize: 28, color: Colors.white),
              textAlign: TextAlign.center,
            ),
            SizedBox(
              height: 30,
            ),
            Text(
              widget.subject.bookTitle,
              style: TextStyle(fontSize: 18, color: Colors.white),
              textAlign: TextAlign.center,
            )
          ]);
        }

        if (!isLast && i == count - 1) {
          return coverSlider([
            Text(
              widget.store.subjects[subjIndex + 1].name,
              style: TextStyle(fontSize: 28, color: Colors.white),
              textAlign: TextAlign.center,
            ),
            SizedBox(
              height: 30,
            ),
            Text(
              widget.subject.bookTitle,
              style: TextStyle(fontSize: 18, color: Colors.white),
              textAlign: TextAlign.center,
            ),
            SizedBox(
              height: 30,
            ),
            IconButton(
              icon: Icon(
                LineAwesomeIcons.chevron_right,
                color: Colors.white,
              ),
              onPressed: () {
                print("load ${widget.store.subjects[subjIndex + 1].name}");
                widget.store.setSubject(widget.store.subjects[subjIndex + 1]);
                widget.store.loadNotes(widget.store.subjects[subjIndex + 1].id);
                carouselController.jumpToPage(0);
                //widget.store.loadNotes(widget.store.subjects[subjIndex + 1].id);
              },
            )
          ]);
        }

        return Padding(
          padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
          child: Stack(
            children: <Widget>[
              Container(
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
                      items[i - 1].text,
                      style: TextStyle(
                        fontSize: 20.0,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
              Positioned(
                bottom: 6,
                right: 26,
                child: Wrap(
                  children: <Widget>[
                    IconButton(
                      icon: Stack(
                        overflow: Overflow.visible,
                        children: <Widget>[
                          Positioned(
                            bottom: 2,
                            left: 2,
                            child: Icon(
                              LineAwesomeIcons.question,
                              size: 26,
                              color: Colors.grey,
                            ),
                          ),
                          Positioned(
                            top: -4,
                            right: -4,
                            child: Icon(
                              LineAwesomeIcons.plus,
                              size: 20,
                              color: Colors.grey,
                            ),
                          )
                        ],
                      ),
                      onPressed: () {
                        if (items[i - 1].questionId == null) {
                          Question q = Question();
                          q.text = items[i - 1].text;
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => QuestionEdit(
                                      widget.store,
                                      widget.course,
                                      widget.subject,
                                      q)));
                        }
                      },
                    ),
                    bookmarkButton(items[i - 1])
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget coverSlider(List<Widget> children) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
      child: Container(
        padding: EdgeInsets.all(40),
        width: MediaQuery.of(context).size.width,
        margin: EdgeInsets.symmetric(horizontal: 15.0),
        decoration: BoxDecoration(
          color: kPrimaryColor,
        ),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: children),
      ),
    );
  }

  Widget bookmarkButton(Note item) {
    Color color = item.bookmark ? kPrimaryColor : Colors.grey;
    return IconButton(
      icon: Icon(
        LineAwesomeIcons.bookmark,
        size: 30,
        color: color,
      ),
      onPressed: () {
        setState(() {
          item.bookmark = !item.bookmark;
          widget.store.bookmarkNote(item.id, item.bookmark);
        });
      },
    );
  }
}

class EmptyNotesScreen extends StatelessWidget {
  final bool bookmarked;
  final Function onFilter;
  EmptyNotesScreen(this.bookmarked, this.onFilter);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Row(
          children: <Widget>[
            Expanded(
              child: Container(
                color: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 4, 16, 4),
                  child: Wrap(
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: <Widget>[
                      Switch(
                        activeColor: kPrimaryColor,
                        value: bookmarked,
                        onChanged: (state) {
                          onFilter(state);
                        },
                      ),
                      Text('Bookmarked')
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              bookmarked ? 'No bookmarked notes yet' : 'No notes yet',
              style: TextStyle(
                fontSize: 18,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
