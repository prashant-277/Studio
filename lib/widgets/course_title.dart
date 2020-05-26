import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:studio/models/course.dart';

import '../courses_store.dart';

class CourseTitle extends StatelessWidget {
  final CoursesStore store;
  final Course course;
  const CourseTitle(this.store, this.course);

  @override
  Widget build(BuildContext context) => Observer(builder: (_) {
    print("title ${course.name}");
    if (store.isCourseLoading) return Text(course.name);

    return Text(store.course != null ? store.course.name : "");
  });
}