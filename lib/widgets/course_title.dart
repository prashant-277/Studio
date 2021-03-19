import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import '../courses_store.dart';
import '../models/course.dart';

class CourseTitle extends StatelessWidget {
  final CoursesStore store;
  final Course course;
  final Color color;
  const CourseTitle(this.store, this.course, this.color);

  @override
  Widget build(BuildContext context) => Observer(builder: (_) {
    print("title ${course.name}");
    var style = TextStyle(
        color: color
    );

    if (store.isCourseLoading) return Text(course.name,
    style: style,);

    return Text(store.course != null ? store.course.name : "",
    style: style,);
  });
}