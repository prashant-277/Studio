import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:studio/courses_store.dart';
import 'package:studio/models/course.dart';
import 'package:studio/models/subject.dart';

import '../constants.dart';

class SubjectScreen extends StatefulWidget {
  SubjectScreen(this.store, this.course, this.subject);

  final Course course;
  final Subject subject;
  final CoursesStore store;
  static final id = 'subject_screen';

  @override
  _SubjectScreenState createState() => _SubjectScreenState();
}

class _SubjectScreenState extends State<SubjectScreen> with SingleTickerProviderStateMixin {
  TabController _tabController;

  @override
  void initState() {
    widget.store.loadSubjects(widget.course.id);
    super.initState();
    _tabController = TabController(vsync: this, length: 3);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        iconTheme: IconThemeData(
          color: kDarkBlue
        ),
        leading: const Icon(
          Icons.store
        ),
        bottom: TabBar(
          controller: _tabController,
          labelColor: kDarkBlue,
          tabs: <Widget>[
            Tab(text: 'Subjects',),
            Tab(text: 'Questions'),
            Tab(text: 'Mind map'),
          ],
        ),
        title: Text(
          widget.course.name,
          style: TextStyle(
            color: kDarkBlue,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: kLightGrey,
      ),
      body: TabBarView(
        controller: _tabController,
        children: <Widget>[
          SubjectsView(),
          QuestionsView(),
          Text('Mind map'),
        ],
      )
    );
  }
}

class SubjectsView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

class QuestionsView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
