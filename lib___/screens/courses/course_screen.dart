import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/src/rendering/sliver_persistent_header.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:studio/screens/subjects/subjects_screen.dart';
import 'package:studio/screens/test/test_home_screen.dart';
import 'package:studio/widgets/drawer.dart';
import 'package:studio/widgets/shadow_container.dart';

import '../../constants.dart';
import '../../courses_store.dart';
import '../books_screen.dart';
import 'edit_course_screen.dart';

class CourseScreen extends StatefulWidget {
  final String id = "course_screen";
  final CoursesStore store;

  const CourseScreen(this.store);

  @override
  _CourseScreenState createState() => _CourseScreenState();
}

class _CourseScreenState extends State<CourseScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: MainDrawer(widget.store),
      body: CustomScrollView(
        slivers: <Widget>[
          SliverPersistentHeader(
            pinned: true,
            delegate: SliverCourseHeader(
              maxExtent: 250,
              minExtent: 80,
              store: widget.store,
            ),
          ),
          SliverList(
              delegate: SliverChildListDelegate([
            CourseScreenItem(
              title: 'Subjects',
              subtitle:
                  'You have ${widget.store.course.subjectsCount} subjects in this course',
              image: 'assets/images/subjects2.png',
              //icon: LineAwesomeIcons.graduation_cap,
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => SubjectsScreen(widget.store)));
              },
            ),
            CourseScreenItem(
              title: 'Books',
              subtitle: 'Manage the books of this course',
              //icon: LineAwesomeIcons.book,
              image: 'assets/images/study.png',
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => BooksScreen(widget.store)));
              },
            ),
            CourseScreenItem(
              title: 'Test',
              subtitle: 'Evaluate your learning in this course',
              //icon: LineAwesomeIcons.list_ol,
              image: 'assets/images/exam.png',
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => TestHomeScreen(widget.store)));
              },
            ),
            CourseScreenItem(
              title: 'Results',
              subtitle: 'Subjects to review. Improve your knowledge.',
              //icon: LineAwesomeIcons.list_ol,
              image: 'assets/images/chart.png',
              onTap: () {
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => TestHomeScreen(widget.store)));
              },
            ),
          ]))
        ],
      ),
    );
  }
}

class CourseScreenItem extends StatelessWidget {
  final String title;
  final IconData icon;
  final Function onTap;
  final String subtitle;
  final String image;

  CourseScreenItem(
      {this.title, this.icon, this.onTap, this.subtitle, this.image});

  Widget graphic() {
    if (this.icon != null) {
      return Icon(
        icon,
        size: 30,
      );
    }

    if (this.image != null) {
      return Image(
        image: AssetImage(this.image),
        width: 100,
      );
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
      child: ShadowContainer(
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 24),
        child: GestureDetector(
          onTap: onTap,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 0, vertical: 0),
            child: Row(
              children: <Widget>[
                graphic(),
                SizedBox.fromSize(
                  size: Size.square(20),
                ),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        title,
                        style: TextStyle(
                            fontSize: 20,
                            color: kDarkBlue,
                            fontWeight: FontWeight.w600),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 3,
                      ),
                      tileSubTitle()
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget tileSubTitle() {
    if (subtitle != null) {
      return Text(subtitle,
          style: TextStyle(fontSize: 16, color: kContrastDarkColor));
    }

    return null;
  }
}

class SliverCourseHeader implements SliverPersistentHeaderDelegate {
  final double minExtent;
  final double maxExtent;
  final CoursesStore store;

  SliverCourseHeader({
    this.minExtent,
    @required this.maxExtent,
    @required this.store,
  });

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) =>
      Observer(builder: (_) {
        return AppBar(
          centerTitle: true,
          elevation: 0,
          primary: true,
          iconTheme: IconThemeData(color: kContrastColor),
          flexibleSpace: Stack(
            fit: StackFit.loose,
            children: <Widget>[
              Hero(
                tag: 'course-icon-${store.course.icon}',
                child: Center(
                  child: Opacity(
                    opacity: sliverOpacity(shrinkOffset),
                    child: Image(
                      image: AssetImage("assets/icons/${store.course.icon}"),
                      height: 160,
                    ),
                  ),
                ),
              ),
              Container(
                decoration: BoxDecoration(
                    gradient: LinearGradient(colors: [
                  Colors.black87,
                  Colors.black87,
                  Colors.transparent
                ], stops: [
                  0,
                  0.2,
                  1
                ], begin: Alignment.bottomCenter, end: Alignment.topCenter)),
              ),
              Positioned(
                bottom: 8,
                left: 10,
                right: 10,
                child: Text(
                  store.course.name,
                  style: TextStyle(
                    color: kContrastColor,
                    fontSize: 24,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
          backgroundColor: kContrastDarkColor,
          actions: <Widget>[
            PopupMenuButton<int>(
              onSelected: (int) {
                switch (int) {
                  case kActionEdit:
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                EditCourseScreen(store, store.course)));
                    break;
                  case kActionDelete:
                    showDialog(
                        context: context,
                        builder: (_) => AlertDialog(
                              title: Text('Confirm'),
                              content: Text('Do you really want to delete '
                                  'course ${store.course.name} and all '
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
                                    await store.deleteCourse(store.course.id);
                                    Navigator.pop(context);
                                  },
                                )
                              ],
                            ));
                    break;
                  case kActionBooks:
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => BooksScreen(store)));
                    break;
                }
              },
              offset: Offset(0, 40),
              elevation: 20,
              itemBuilder: (context) => [
                PopupMenuItem(
                  value: kActionBooks,
                  child: Text(
                    "Books",
                    style: TextStyle(
                      color: kDarkGrey,
                    ),
                  ),
                ),
                PopupMenuItem(
                  value: kActionEdit,
                  child: Text(
                    "Edit course",
                    style: TextStyle(
                      color: kDarkGrey,
                    ),
                  ),
                ),
                PopupMenuItem(
                  value: kActionDelete,
                  child: Text(
                    "Delete course",
                    style: TextStyle(
                      color: Colors.red,
                    ),
                  ),
                ),
              ],
              child: Icon(Icons.more_vert),
            ),
          ],
        );
      });

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) {
    return true;
  }

  @override
  FloatingHeaderSnapConfiguration get snapConfiguration => null;

  @override
  OverScrollHeaderStretchConfiguration get stretchConfiguration => null;

  sliverOpacity(double shrinkOffset) {
    return 1.0 - max(0.0, shrinkOffset) / maxExtent;
  }

  @override
  // TODO: implement showOnScreenConfiguration
  PersistentHeaderShowOnScreenConfiguration get showOnScreenConfiguration => null;

  @override
  // TODO: implement vsync
  TickerProvider get vsync => null;
}
