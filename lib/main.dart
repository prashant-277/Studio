import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mobx/mobx.dart';
import 'package:studio/screens/edit_subject_screen.dart';
import 'package:studio/screens/subject_screen.dart';
import 'package:studio/screens/courses_screen.dart';
import 'package:studio/screens/home_screen.dart';
import 'package:studio/screens/edit_course_screen.dart';
import 'auth_store.dart';
import 'constants.dart';
import 'courses_store.dart';
import 'screens/login_signup_screen.dart';

final auth = AuthStore();
final coursesStore = CoursesStore();

void main() => runApp(StudioApp());

class StudioApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Studio',
      theme: ThemeData(
        fontFamily: 'Baloo Paaji 2',
        appBarTheme: AppBarTheme(
          elevation: 0,
          color: kLightGrey,
          textTheme: TextTheme(
            title: TextStyle(
              color: kDarkBlue,
              fontFamily: 'Baloo Paaji 2',
              fontWeight: FontWeight.bold,
              fontSize: 20,
            )
          )
        ),
      ),
      initialRoute: SplashScreen.id,
      routes: {
        SplashScreen.id: (context) => SplashScreen(),
        EditCourseScreen.id: (context) => EditCourseScreen(coursesStore, null),
        CoursesScreen.id: (context) => CoursesScreen(coursesStore),
        EditSubjectScreen.id: (context) => EditSubjectScreen(coursesStore, null, null)
      },
    );
  }
}

class SplashScreen extends StatefulWidget {
  static String id = 'splash_screen';

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<FirebaseUser> _checkLogged() async {
    _auth.currentUser().then((user) {
      if (user != null)
        auth.loggedIn(user.uid);
      else
        auth.loggedOut();
    });
  }

  Widget getScreen() {
    if (auth.status == kStatusLoggedOut) return LoginSignupScreen(auth);

    if (auth.status == kStatusLoggedIn) return CoursesScreen(coursesStore);

    return Scaffold(
      body: Container(),
    );
  }

  @override
  Widget build(BuildContext context) {
    _checkLogged();

    return Container(
      child: Observer(
          builder: (_) => Observer(builder: (_) {
                return getScreen();
              })),
    );
  }
}
