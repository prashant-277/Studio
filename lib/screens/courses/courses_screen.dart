import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:studio/utils/Utils.dart';

import '../../constants.dart';
import '../../courses_store.dart';
import '../../models/course.dart';
import '../../widgets/drawer.dart';
import '../../widgets/shadow_container.dart';
import 'course_screen.dart';
import 'edit_course_screen.dart';

class CoursesScreen extends StatefulWidget {
  static String id = 'courses_screen';
  final CoursesStore store;

  const CoursesScreen(this.store);

  @override
  _CoursesScreenState createState() => _CoursesScreenState();
}

class _CoursesScreenState extends State<CoursesScreen>
    with SingleTickerProviderStateMixin {
  int _currentIndex = 0;

  @override
  void initState() {
    widget.store.loadCourses();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var _views = [
      CoursesView(widget.store),
      Container(
        child: Text("Purchase"),
      ),
      Container(
        child: Text("Tests"),
      ),
      Container(
        child: Text("Stats"),
      ),
    ];

    return Scaffold(
        backgroundColor: kBackground,
        appBar: AppBar(
          iconTheme: IconThemeData(color: kContrastDarkColor),
          centerTitle: true,
          elevation: 0,
          backgroundColor: kBackground,
          title: Padding(
            padding: const EdgeInsets.all(18.0),
            child: Text(
              'My Professor',
              style: TextStyle(
                  color: kTitleColor,
                  fontSize: 23,
                  fontFamily: "Quicksand",
                  fontWeight: FontWeight.w200),
            ),
          ),
        ),
        drawer: MainDrawer(widget.store),
        floatingActionButton:
            widget.store.courses.length == 0
                ? SizedBox()
                : FloatingActionButton(
                    child: const Icon(
                      Icons.add,
                      color: Colors.white,
                    ),
                    backgroundColor: kPrimaryColor,
                    onPressed: () {
                      Navigator.pushNamed(context, EditCourseScreen.id);
                    },
                  ),
        body: CoursesView(widget.store));
  }
}

class CoursesView extends StatefulWidget {
  final CoursesStore store;

  CoursesView(this.store);

  @override
  _CoursesViewState createState() => _CoursesViewState();
}

class _CoursesViewState extends State<CoursesView> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: <Widget>[
          SizedBox(
            height: 20,
          ),
          Expanded(
            child: CourseItemsView(widget.store),
          )
        ],
      ),
    );
  }
}

class CourseItemsView extends StatelessWidget {
  const CourseItemsView(this.store);

  final CoursesStore store;

  @override
  Widget build(BuildContext context) => Observer(builder: (_) {
        return ModalProgressHUD(
          color: kLightGrey,
          child: resultWidget(context, store.courses),
          inAsyncCall: store.isCoursesLoading,
        );
      });

  resultWidget(BuildContext context, List<Course> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        if (!store.isCoursesLoading && items.length == 0)
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'Follow the instructions of the \nprofessor, you\'ll be guided to \nstraight to success!',
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 20,
                  height: 1.4,
                  fontFamily: "Quicksand",
                  color: HexColor("5D646B"),
                  fontWeight: FontWeight.w500),
            ),
          ),
        if (!store.isCoursesLoading && items.length == 0)
          Container(
            padding: EdgeInsets.symmetric(vertical: 20),
            margin: EdgeInsets.symmetric(horizontal: 15, vertical: 24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10),
                  topRight: Radius.circular(10),
                  bottomLeft: Radius.circular(10),
                  bottomRight: Radius.circular(10)),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  spreadRadius: 2,
                  blurRadius: 3,
                  offset: Offset(0, 1.2), // changes position of shadow
                ),
              ],
            ),
            child: Row(
              children: [
                Image(
                  image: AssetImage('assets/images/professor-new.png'),
                  height: 150,
                  width: 150,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Create your first \ncourse!',
                      textAlign: TextAlign.justify,
                      style: TextStyle(
                          fontSize: 20,
                          fontFamily: "Quicksand",
                          color: HexColor("5D646B"),
                          fontWeight: FontWeight.w200),
                      maxLines: 2,
                    ),
                    SizedBox(
                      height: 28,
                    ),
                    FlatButton(
                      color: kPrimaryColor,
                      textColor: kDarkBlue,
                      shape: RoundedRectangleBorder(
                          side: BorderSide(
                              color: HexColor("F5A638"),
                              width: 2,
                              style: BorderStyle.solid),
                          borderRadius: BorderRadius.circular(50)),
                      child: Text(
                        "ADD COURSE",
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.black,
                          fontFamily: "Quicksand",
                          fontWeight: FontWeight.w200,
                        ),
                      ),
                      onPressed: () {
                        Navigator.pushNamed(context, EditCourseScreen.id);
                      },
                      padding: EdgeInsets.fromLTRB(30, 12, 30, 12),
                    )
                  ],
                )
              ],
            ),
          ),
        if (items.length != 0)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 5),
            child: Text(
              "Your courses:",
              style: TextStyle(
                fontSize: 16,
                color: Colors.black,
                fontFamily: "Quicksand",
                fontWeight: FontWeight.w200,
              ),
            ),
          ),
        Expanded(
          child: ListView.builder(
              physics: const AlwaysScrollableScrollPhysics(),
              itemCount: items.length,
              itemBuilder: (_, index) {
                final item = items[index];
                return Container(
                    padding:
                        const EdgeInsets.symmetric(vertical: 4, horizontal: 16),
                    child: ShadowContainer(
                      child: ListTile(
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 0, horizontal: 10),
                        onTap: () {
                          store.setCourse(item);
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => CourseScreen(store)));
                        },
                        leading: Container(
                          child: Hero(
                            tag: 'course-icon-${item.icon}',
                            child: Image(
                              image: AssetImage("assets/icons/${item.icon}"),
                            ),
                          ),
                        ),
                        trailing: Image(
                          image: AssetImage("assets/images/right_arrow.png"),
                          height: 20,
                        ),
                        title: Container(
                          child: Text(
                            item.name,
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        // subtitle: Text('${item.subjectsCount} subjects'),
                      ),
                    ));
              }),
        )
      ],
    );
  }
}
