import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:line_awesome_icons/line_awesome_icons.dart';
import 'package:mobx/mobx.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

import '../../constants.dart';
import '../../courses_store.dart';
import '../../models/course.dart';
import '../../widgets/drawer.dart';
import '../../widgets/shadow_container.dart';
import 'course_screen.dart';
import '../subjects/subjects_screen.dart';
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
              'My courses',
              style: TextStyle(color: kContrastDarkColor),
            ),
          ),
        ),
        drawer: MainDrawer(widget.store),
        floatingActionButton: FloatingActionButton(
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
    if (!store.isCoursesLoading && items.length == 0) {
      return Column(
        children: <Widget>[
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'No courses yet, let\'s start with the first one!',
                style: TextStyle(
                  fontSize: 18,
                ),
              ),
            ),
          ),
          Image(
            image: AssetImage('assets/images/study.png'),
          ),
          Expanded(
            child: Container(),
          )
        ],
      );
    }

    return ListView.builder(
        physics: const AlwaysScrollableScrollPhysics(),
        itemCount: items.length,
        itemBuilder: (_, index) {
          final item = items[index];
          return Container(
              padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 16),
              child: ShadowContainer(
                child: ListTile(
                  contentPadding:
                      const EdgeInsets.symmetric(vertical: 4, horizontal: 10),
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
                  trailing: const Icon(
                    Icons.chevron_right,
                    color: kDarkBlue,
                  ),
                  title: Container(
                    child: Text(
                      item.name,
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  subtitle: Text('${item.subjectsCount} subjects'),
                ),
              ));
        });
  }
}