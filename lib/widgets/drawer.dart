import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:line_awesome_icons/line_awesome_icons.dart';
import 'package:studio/courses_store.dart';
import 'package:studio/models/course.dart';
import 'package:studio/screens/courses_screen.dart';

import '../auth_store.dart';
import '../constants.dart';
import '../globals.dart';
final auth = AuthStore();

class MainDrawer extends StatefulWidget {
  final CoursesStore store;
  MainDrawer(this.store);

  @override
  _MainDrawerState createState() => _MainDrawerState();
}

class _MainDrawerState extends State<MainDrawer> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) => Observer(builder: (_) {
        return Drawer(
          child: SafeArea(
            child: Column(
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                            border: Border(
                                bottom: BorderSide(
                                    color: Theme.of(context).dividerColor))),
                        child: Center(
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(0, 20, 0, 20),
                              child: Image(
                                image: AssetImage("assets/app/logo.png"),
                                width: 180,
                              ),
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                Expanded(
                  child: Column(
                    children: <Widget>[
                      ListTile(
                        dense: true,
                        leading: Icon(
                          LineAwesomeIcons.home
                        ),
                        contentPadding: EdgeInsets.fromLTRB(20, 0, 0, 0),
                        title: Text(
                          "Home",
                          style: TextStyle(
                              fontSize: kDrawerItemSize, fontWeight: FontWeight.w600),
                        ),
                        onTap: () {
                          Navigator.pushReplacementNamed(context, CoursesScreen.id);
                        },
                      ),
                      ListTile(
                        leading: Icon(
                            LineAwesomeIcons.graduation_cap
                        ),
                        dense: true,
                        contentPadding: EdgeInsets.fromLTRB(20, 0, 0, 0),
                        title: Text(
                          "About StudyHero",
                          style: TextStyle(
                              fontSize: kDrawerItemSize, fontWeight: FontWeight.w600),
                        ),
                        onTap: () {
                          Navigator.pushReplacementNamed(context, CoursesScreen.id);
                        },
                      ),
                      ListTile(
                        leading: Icon(
                            LineAwesomeIcons.search
                        ),
                        dense: true,
                        contentPadding: EdgeInsets.fromLTRB(20, 0, 0, 0),
                        title: Text(
                          "Search",
                          style: TextStyle(
                              fontSize: kDrawerItemSize, fontWeight: FontWeight.w600),
                        ),
                        onTap: () {
                          Navigator.pushReplacementNamed(context, CoursesScreen.id);
                        },
                      ),
                      ListTile(
                        dense: true,
                        leading: Icon(
                            LineAwesomeIcons.history
                        ),
                        contentPadding: EdgeInsets.fromLTRB(20, 0, 0, 0),
                        title: Text(
                          "Recent",
                          style: TextStyle(
                              fontSize: kDrawerItemSize, fontWeight: FontWeight.w600),
                        ),
                        onTap: () {
                          Navigator.pushReplacementNamed(context, CoursesScreen.id);
                        },
                      ),
                      ListTile(
                        dense: true,
                        leading: Icon(
                            LineAwesomeIcons.user
                        ),
                        contentPadding: EdgeInsets.fromLTRB(20, 0, 0, 0),
                        title: Text(
                          "Account",
                          style: TextStyle(
                              fontSize: kDrawerItemSize, fontWeight: FontWeight.w600),
                        ),
                        onTap: () {
                          Navigator.pushReplacementNamed(context, CoursesScreen.id);
                        },
                      ),
                      ListTile(
                        dense: true,
                        leading: Icon(
                            LineAwesomeIcons.pencil
                        ),
                        contentPadding: EdgeInsets.fromLTRB(20, 0, 0, 0),
                        title: Text(
                          "Contact",
                          style: TextStyle(
                              fontSize: kDrawerItemSize, fontWeight: FontWeight.w600),
                        ),
                        onTap: () {
                          Navigator.pushReplacementNamed(context, CoursesScreen.id);
                        },
                      ),
                      ListTile(
                        dense: true,
                        leading: Icon(
                            LineAwesomeIcons.power_off
                        ),
                        contentPadding: EdgeInsets.fromLTRB(20, 0, 0, 0),
                        title: Text(
                          "Logout",
                          style: TextStyle(
                              fontSize: kDrawerItemSize, fontWeight: FontWeight.w600),
                        ),
                        onTap: () {
                          Globals.auth.loggedOut();
                        },
                      ),
                    ],
                  )
                ),

                Container(
                  decoration: BoxDecoration(
                      border: Border(
                          top: BorderSide(
                              color: Theme.of(context).dividerColor))),
                  child: Wrap(
                    children: <Widget>[
                      FlatButton(
                        child: Text('Terms of use'),
                      ),
                      FlatButton(
                        child: Text('Payment terms'),
                      ),
                      FlatButton(
                        child: Text('Privacy policy'),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        );
      });
}
