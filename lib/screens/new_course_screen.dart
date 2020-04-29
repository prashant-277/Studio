import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:studio/courses_store.dart';
import 'package:studio/screens/courses_screen.dart';
import 'package:studio/widgets/buttons.dart';

import '../constants.dart';

class AddCourseScreen extends StatefulWidget {
  static final id = 'add_course_screen';
  final CoursesStore store;

  AddCourseScreen(this.store);

  @override
  _AddCourseScreenState createState() => _AddCourseScreenState();
}

class _AddCourseScreenState extends State<AddCourseScreen> {
  String name;
  String selectedIcon = '';

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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add course'),
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
            TextField(
              autocorrect: true,
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
              child: PrimaryButton(
                'Save',
                () {
                  widget.store.addCourse(name, selectedIcon, () {
                    print("Saved!");
                    Navigator.pop(context);
                  });
                },
              ),
            )
          ],
        ),
      )),
    );
  }
}
