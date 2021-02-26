import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:studio/globals.dart';
import 'package:studio/screens/course/course.dart';
import 'package:studio/screens/course/subject.dart';
import 'package:studio/screens/edit_course.dart';
import 'package:studio/screens/edit_subject.dart';
import 'package:studio/screens/home/home.dart';
import 'auth_store.dart';
import 'colors.dart';
import 'courses_store.dart';
import 'screens/login_signup.dart';

final authStore = AuthStore();
final coursesStore = CoursesStore();

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Globals.authStore = authStore;
  Globals.coursesStore = coursesStore;
  runApp(StudioApp());
}

class StudioApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Studio Hero',
      theme: ThemeData(
        fontFamily: 'Nunito',
        appBarTheme: AppBarTheme(
          elevation: 0,
          brightness: Brightness.light,
          color: kBackgroundColor,
          iconTheme: IconThemeData(color: kTextColor),
          textTheme: TextTheme(
            headline6: TextStyle(
              color: kTextColor,
              fontFamily: 'Quicksand',
              fontWeight: FontWeight.normal,
              fontSize: 24,
            ),
          ),
        ),
        backgroundColor: kBackgroundColor,
        accentColor: kAccentColor,
        textTheme: TextTheme(
          headline6: TextStyle(
            color: kTextColor,
            fontFamily: 'Nunito',
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
      ),
      initialRoute: SplashScreen.id,
      routes: {
        SplashScreen.id: (context) => SplashScreen(),
        CourseScreen.id: (context) => CourseScreen(),
        SubjectScreen.id: (context) => SubjectScreen(),
        EditCourseScreen.id: (context) => EditCourseScreen(),
        EditSubjectScreen.id: (context) => EditSubjectScreen(),
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
    print("checkLogged");
    _auth.currentUser().then((user) {
      if (user != null) {
        Globals.authStore.loggedIn(user.uid);
        Globals.authStore.loggedUser(user);
      } else
        Globals.authStore.loggedOut();
    });
  }

  Widget getScreen() {
    print("getScreen");
    if (Globals.authStore.status == kStatusLoggedOut)
      return LoginSignupScreen();

    if (Globals.authStore.status == kStatusLoggedIn) return HomeScreen();

    return Scaffold(
      body: Container(),
    );
  }

  @override
  Widget build(BuildContext context) {
    _checkLogged();
    return Observer(builder: (_) => getScreen());
  }
}
