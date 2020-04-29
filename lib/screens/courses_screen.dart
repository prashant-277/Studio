import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mobx/mobx.dart';
import 'package:studio/courses_store.dart';
import 'package:studio/models/course.dart';
import 'package:studio/screens/new_course_screen.dart';

import '../constants.dart';
import 'course_screen.dart';
import 'subject_screen.dart';

class CoursesScreen extends StatefulWidget {
  static String id = 'courses_screen';
  final CoursesStore store;
  const CoursesScreen(this.store);

  @override
  _CoursesScreenState createState() => _CoursesScreenState();
}

class _CoursesScreenState extends State<CoursesScreen>
    with SingleTickerProviderStateMixin {

  @override
  void initState() {
    widget.store.loadCourses();
    super.initState();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: kLightGrey,
        appBar: AppBar(
          centerTitle: true,
          elevation: 0,
          title: Padding(
            padding: const EdgeInsets.all(18.0),
            child: Text(
              'My courses',
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          child: const Icon(
            Icons.add,
            color: Colors.white,
          ),
          backgroundColor: kPrimaryColor,
          onPressed: () {
            Navigator.pushNamed(context, AddCourseScreen.id);
          },
        ),
        body: SafeArea(
            child: Column(
          children: <Widget>[
            SizedBox(height: 20,),
            Expanded(
              child: CourseItemsView(widget.store),
            )
          ],
        )),
      );
}

class CourseItemsView extends StatelessWidget {
  const CourseItemsView(this.store);

  final CoursesStore store;

  @override
  // ignore: missing_return
  Widget build(BuildContext context) => Observer(builder: (_) {
        final future = store.coursesFuture;

        switch (future.status) {
          case FutureStatus.pending:
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  CircularProgressIndicator(),
                  Text('Loading items...'),
                ],
              ),
            );

          case FutureStatus.rejected:
            return Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const Text(
                  'Failed to load items.',
                  style: TextStyle(color: Colors.red),
                ),
              ],
            );

          case FutureStatus.fulfilled:
            final List<Course> items = future.result;
            return RefreshIndicator(
              onRefresh: store.fetchCourses,
              child: ListView.builder(
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
                            Navigator.push(context, MaterialPageRoute(
                                builder: (context) => CourseScreen(store, item)
                            ));
                          },
                          leading: Container(
                            child: Image(
                              image: AssetImage("assets/icons/${item.icon}"),
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
                          subtitle: Text('${item.subjectsCount ?? 0} subjects'),
                        ),
                      ),
                    );
                  }),
            );
        }
      });
}
