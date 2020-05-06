import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:studio/courses_store.dart';
import 'package:studio/models/course.dart';
import 'package:studio/screens/courses_screen.dart';
import 'package:studio/widgets/buttons.dart';

import '../constants.dart';

// ignore: must_be_immutable
class EditCourseScreen extends StatefulWidget {
  static final id = 'add_course_screen';
  CoursesStore store;
  Course data;

  EditCourseScreen(CoursesStore store, Course data)
  {
    this.store = store;
    this.data = data;
  }

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
    if(widget.data != null) {
      textCtrl.text = widget.data.name;
      name = widget.data.name;
      title = 'Edit course';
      selectedIcon = widget.data.icon;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        centerTitle: true,
        leading: Container(
            child: FlatButton(
          child: Icon(
            Icons.chevron_left,
            color: kDarkBlue,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        )),
      ),
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            Container(
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withAlpha(10),
                      blurRadius: 20.0, // has the effect of softening the shadow
                      spreadRadius: 10.0, // has the effect of extending the shadow
                      offset: Offset(
                        0.0, // horizontal, move right 10
                        0.0, // vertical, move down 10
                      ),
                    )
                  ]
              ),
              child: TextField(
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
                    hintText: 'Course name',
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
            ),
            SizedBox(
              height: 20,
            ),
            Expanded(
              child: CustomScrollView(
                primary: false,
                slivers: <Widget>[
                  SliverPadding(
                    padding: const EdgeInsets.all(20),
                    sliver: SliverGrid.count(
                      crossAxisCount: 4,
                      crossAxisSpacing: 20,
                      mainAxisSpacing: 20,
                      children: icons(),
                    ),
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 20, 0, 10),
              child: SizedBox(
                width: double.infinity,
                child: PrimaryButton(
                  'Save',
                  () async {
                    String id = widget.data == null ? null : widget.data.id;
                    await widget.store.saveCourse(id: id, name: name, icon: selectedIcon, callback: () {
                      print("Saved!");
                      Navigator.pop(context);
                    });
                    widget.store.loadCourses();
                  },
                ),
              ),
            )
          ],
        ),
      )),
    );
  }
}
