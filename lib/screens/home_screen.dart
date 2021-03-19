import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../auth_store.dart';
import '../widgets/buttons.dart';
import 'courses/courses_screen.dart';

class HomeScreen extends StatelessWidget {
  final AuthStore store;

  HomeScreen(this.store);

  static String id = 'home_screen';

  final FirebaseAuth _auth = FirebaseAuth.instance;
  
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Container(
        child: Padding(
          padding: EdgeInsets.all(8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text('Home',
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 60, fontWeight: FontWeight.w600
                ),
              ),
              WhiteButton(
                'Courses', () {
                  Navigator.of(context).pushReplacementNamed(CoursesScreen.id);
                },
              ),
              WhiteButton(
                'Logout', () {
                  _auth.signOut().then( (_) {
                    _auth.signOut().then((_) {
                      store.loggedOut();
                    });
                  });
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
