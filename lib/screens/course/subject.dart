import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:line_awesome_icons/line_awesome_icons.dart';
import 'package:studio/widgets/subtitle.dart';

import '../../colors.dart';
import '../../constants.dart';
import '../../globals.dart';

class SubjectScreen extends StatefulWidget {
  static const id = "subject";
  SubjectScreen({Key key}) : super(key: key);

  @override
  _SubjectScreenState createState() => _SubjectScreenState();
}

class _SubjectScreenState extends State<SubjectScreen> {
  @override
  Widget build(BuildContext context) => Observer(builder: (_) {
        return Scaffold(
          appBar: AppBar(
            title: Text(Globals.coursesStore.subject.name),
            centerTitle: true,
            backgroundColor: kAccentColor,
            actions: <Widget>[
              PopupMenuButton<int>(
                onSelected: (int) {
                  switch (int) {
                    case kActionEdit:
                      break;
                    case kActionDelete:
                      showDialog(
                          context: context,
                          builder: (_) => AlertDialog(
                                title: Text('Confirm'),
                                content: Text('Do you really want to delete '
                                    'course ${Globals.coursesStore.course.name} and all '
                                    'its subjects, notes and questions?'),
                                actions: <Widget>[
                                  FlatButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: Text('No'),
                                  ),
                                  FlatButton(
                                    child: Text('Yes'),
                                    textColor: Colors.red,
                                    onPressed: () async {
                                      Navigator.pop(context);
                                      await Globals.coursesStore.deleteCourse(
                                          Globals.coursesStore.course.id);
                                      Navigator.pop(context);
                                    },
                                  )
                                ],
                              ));
                      break;
                    case kActionBooks:
                      break;
                  }
                },
                //offset: Offset(0, 40),
                elevation: 20,
                itemBuilder: (context) => [
                  PopupMenuItem(
                    value: kActionBooks,
                    child: Text(
                      "Books",
                      style: TextStyle(
                          //color: kDarkGrey,
                          ),
                    ),
                  ),
                  PopupMenuItem(
                    value: kActionEdit,
                    child: Text(
                      "Edit subject",
                      style: TextStyle(
                          //color: kDarkGrey,
                          ),
                    ),
                  ),
                  PopupMenuItem(
                    value: kActionDelete,
                    child: Text(
                      "Delete subject",
                      style: TextStyle(
                        color: Colors.red,
                      ),
                    ),
                  ),
                ],
                child: Icon(Icons.more_vert),
              ),
            ],
          ),
          backgroundColor: kBackgroundColor,
          body: SafeArea(
            child: SingleChildScrollView(
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisSize: MainAxisSize.max,
                  children: _widgets()),
            ),
          ),
          floatingActionButton: SpeedDial(
            child: Icon(LineAwesomeIcons.plus),
            overlayOpacity: 0.5,
            children: [
              SpeedDialChild(
                child: Icon(LineAwesomeIcons.book_open),
                label: 'Add subject',
                labelStyle: TextStyle(fontSize: 14.0),
                onTap: () {},
              ),
              SpeedDialChild(
                  child: Icon(LineAwesomeIcons.marker),
                  label: 'Add key concept',
                  labelStyle: TextStyle(fontSize: 14.0),
                  onTap: () => print('FIRST CHILD')),
            ],
          ),
        );
      });

  List<Widget> _widgets() {
    var list = List<Widget>();
    if (Globals.coursesStore.isSubjectsLoading) {
      list.add(LinearProgressIndicator());
    }
    list.add(Container(
        color: kAccentColor,
        child: Subtitle(
          text: 'Subjects',
        )));

    list.addAll(Globals.coursesStore.subjects.map((s) => Card(
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: ListTile(
              title: Text(s.name),
              trailing: Icon(Icons.chevron_right),
              onTap: () {
                Navigator.pushNamed(context, SubjectScreen.id);
              },
            ),
          ),
        )));

    return list;
  }
}
