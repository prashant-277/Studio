import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:progress_dialog/progress_dialog.dart';

import '../../constants.dart';
import '../../courses_store.dart';
import '../../models/course.dart';
import '../../widgets/buttons.dart';

// ignore: must_be_immutable
class EditCourseScreen extends StatefulWidget {
  static final id = 'add_course_screen';
  CoursesStore store;
  Course data;

  EditCourseScreen(this.store, this.data);

  @override
  _EditCourseScreenState createState() => _EditCourseScreenState();
}

class _EditCourseScreenState extends State<EditCourseScreen> {
  String name;
  String title = 'Add course';
  String selectedIcon = '';
  TextEditingController textCtrl = TextEditingController();

  double iconOpacity(String icon) {
    return icon == selectedIcon ? 1 : 0;
  }

  List<Widget> icons() {
    var list = List<Widget>();
    courseIcons.forEach((icon) {
      list.add(Container(
        child: FlatButton(
          padding: EdgeInsets.all(0),
          splashColor: kLightGrey,
          child: Stack(
            fit: StackFit.loose,
            children: [
              Image(
                image: AssetImage("assets/icons/${icon}"),
                fit: BoxFit.cover,
              ),
              Positioned(
                top: 0,
                right: 0,
                child: Opacity(
                  opacity: iconOpacity(icon),
                  child: Container(
                    padding: EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white.withAlpha(240),
                    ),
                    child: Icon(
                      Icons.check,
                      color: Colors.green,
                    ),
                  ),
                ),
              )
            ],
          ),
          onPressed: () {
            print(icon);
            setState(() {
              selectedIcon = icon;
            });
          },
        ),
      ));
    });
    return list;
  }

  @override
  void initState() {
    if (widget.data != null) {
      textCtrl.text = widget.data.name;
      name = widget.data.name;
      title = 'Edit course';
      selectedIcon = widget.data.icon;
    }
    super.initState();
  }

  _displaySnackBar(BuildContext context, String text) {
    final snackBar = SnackBar(content: Text(text));
    _scaffoldKey.currentState.showSnackBar(snackBar);
  }

  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundColor,
      appBar: AppBar(
        title: Text(title,
            style: TextStyle(
                color: kTitleColor,
                fontSize: 23,
                fontFamily: "Quicksand",
                fontWeight: FontWeight.w200)),
        centerTitle: true,
        leading: Container(
            child: FlatButton(
              child: Icon(
                Icons.arrow_back,
                color: kTitleColor,
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            )),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16,vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              TextField(
                autocorrect: true,
                controller: textCtrl,
                autofocus: true,

                decoration: InputDecoration(
                    contentPadding: EdgeInsets.all(0),
                    fillColor: kBackgroundColor,
                    labelText: 'Name of the course:'),
                onChanged: (text) {
                  setState(() {
                    name = text;
                  });
                },
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 12.0),
                child: Text(
                  "Choose an icon:",
                  style: TextStyle(fontSize: 14),
                  textAlign: TextAlign.left,
                ),
              ),
              GridView.count(
                physics: ScrollPhysics(),
                crossAxisCount: 4,
                shrinkWrap: true,
                children: courseIcons.map((e) => iconButton(e)).toList(),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
          elevation: 0,
          color: kBackgroundColor,
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 20, 0, 10),
                child: SizedBox(
                  child: PrimaryButton(
                    'ADD COURSE',
                        () async {

                      if(selectedIcon == null) {
                        _displaySnackBar(context, 'Choose an icon');
                        return;
                      }

                      final ProgressDialog pr = _getProgress(context);
                      pr.update(message: "Please wait...");
                      await pr.show();


                      Course course = Course();
                      course.name = name;
                      course.icon = selectedIcon;
                      if(widget.data != null)
                        course.id = widget.data.id;

                      String id = widget.data == null ? null : widget.data.id;
                      await widget.store.saveCourse(
                          id: id,
                          name: name,
                          icon: selectedIcon,
                          callback: () {
                            print("Saved!");
                            pr.hide();
                            Navigator.pop(context);
                          });
                      widget.store.loadCourses();
                    },
                  ),
                ),
              ),
            ],
          )),
    );
  }

  Widget iconButton(String icon) {
    List<Widget> widgets = List();
    if (selectedIcon == icon) {
      widgets.add(Positioned(
          top: 0,
          left: 0,
          right: 0,
          bottom: 0,
          child: Container(
            decoration: BoxDecoration(
              color: kAccentColor,
              shape: BoxShape.circle,
            ),
          )));
    }

    widgets.add(Image(
      image: AssetImage('assets/icons/$icon'),
    ));

    return FlatButton(
      child: Stack(fit: StackFit.loose, children: widgets),
      onPressed: () {
        setState(() {
          selectedIcon = icon;
        });
      },
    );
  }

  ProgressDialog _getProgress(BuildContext context) {
    return ProgressDialog(context);
  }
}