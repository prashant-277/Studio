import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:line_awesome_icons/line_awesome_icons.dart';
import 'package:studio/screens/drawer/WebViewContainer.dart';
import 'package:studio/screens/drawer/how_to_study.dart';
import 'package:studio/screens/drawer/premium_screen.dart';
import 'package:studio/screens/drawer/tutorial_tips.dart';

import '../auth_store.dart';
import '../constants.dart';
import '../courses_store.dart';
import '../globals.dart';
import '../screens/courses/courses_screen.dart';

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
  Widget build(BuildContext context) =>
      Observer(builder: (_) {
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
                                    color: Theme
                                        .of(context)
                                        .dividerColor))),
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
                      leading: Icon(LineAwesomeIcons.home),
                      contentPadding: EdgeInsets.fromLTRB(20, 0, 0, 0),
                      title: Text(
                        "Home",
                        style: TextStyle(
                            fontSize: kDrawerItemSize,
                            fontWeight: FontWeight.w600),
                      ),
                      onTap: () {
                        Navigator.pushReplacementNamed(
                            context, CoursesScreen.id);
                      },
                    ),
                    ListTile(
                        leading: Icon(LineAwesomeIcons.user_graduate),
                        dense: true,
                        contentPadding: EdgeInsets.fromLTRB(20, 0, 0, 0),
                        title: Text(
                          "How to study",
                          style: TextStyle(
                              fontSize: kDrawerItemSize,
                              fontWeight: FontWeight.w600),
                        ),
                        onTap: () =>
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => how_to_study()))),
                    ListTile(
                      leading: Icon(LineAwesomeIcons.mobile),
                      dense: true,
                      contentPadding: EdgeInsets.fromLTRB(20, 0, 0, 0),
                      title: Text(
                        "Tutorial & Tips",
                        style: TextStyle(
                            fontSize: kDrawerItemSize,
                            fontWeight: FontWeight.w600),
                      ),
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => tutorial_tips()));
                      },
                    ),
                    ListTile(
                      leading: Icon(LineAwesomeIcons.search),
                      dense: true,
                      contentPadding: EdgeInsets.fromLTRB(20, 0, 0, 0),
                      title: Text(
                        "Search",
                        style: TextStyle(
                            fontSize: kDrawerItemSize,
                            fontWeight: FontWeight.w600),
                      ),
                      onTap: () {
                        Navigator.pushReplacementNamed(
                            context, CoursesScreen.id);
                      },
                    ),
                    ListTile(
                      dense: true,
                      leading: Icon(LineAwesomeIcons.history),
                      contentPadding: EdgeInsets.fromLTRB(20, 0, 0, 0),
                      title: Text(
                        "Recent",
                        style: TextStyle(
                            fontSize: kDrawerItemSize,
                            fontWeight: FontWeight.w600),
                      ),
                      onTap: () {
                        Navigator.pushReplacementNamed(
                            context, CoursesScreen.id);
                      },
                    ),
                    ListTile(
                        dense: true,
                        leading: Icon(LineAwesomeIcons.user),
                        contentPadding: EdgeInsets.fromLTRB(20, 0, 0, 0),
                        title: Text(
                          "Account",
                          style: TextStyle(
                              fontSize: kDrawerItemSize,
                              fontWeight: FontWeight.w600),
                        ),
                        onTap: () =>
                            _handleURLButtonPress(context,
                                'https://www.multipz.com/about-us', 'Account')),
                    ListTile(
                        dense: true,
                        leading: Icon(LineAwesomeIcons.pencil_alt),
                        contentPadding: EdgeInsets.fromLTRB(20, 0, 0, 0),
                        title: Text(
                          "Contact",
                          style: TextStyle(
                              fontSize: kDrawerItemSize,
                              fontWeight: FontWeight.w600),
                        ),
                        onTap: () =>
                            _handleURLButtonPress(context,
                                'https://www.multipz.com/contact-us',
                                'Contact')),
                    ListTile(
                      dense: true,
                      leading: Icon(LineAwesomeIcons.power_off),
                      contentPadding: EdgeInsets.fromLTRB(20, 0, 0, 0),
                      title: Text(
                        "Logout",
                        style: TextStyle(
                            fontSize: kDrawerItemSize,
                            fontWeight: FontWeight.w600),
                      ),
                      onTap: () {
                        Globals.auth.loggedOut();


                      },
                    ),
                    ListTile(
                      dense: true,
                      leading: Icon(
                        LineAwesomeIcons.money_check, color: Colors.green,),
                      contentPadding: EdgeInsets.fromLTRB(20, 0, 0, 0),
                      title: Text(
                        "Premium",
                        style: TextStyle(color: Colors.green,
                            fontSize: kDrawerItemSize,
                            fontWeight: FontWeight.w600),
                      ),
                      onTap: () =>
                          Navigator.push(context, MaterialPageRoute(
                              builder: (context) => premium_screen(widget.store))))
                      ],
                    )),
                Container(
                  decoration: BoxDecoration(
                      border: Border(
                          top: BorderSide(
                              color: Theme
                                  .of(context)
                                  .dividerColor))),
                  child: Wrap(
                    children: <Widget>[
                      FlatButton(
                        child: Text('Terms of use'),
                        onPressed: () =>
                            _handleURLButtonPress(
                                context,
                                'https://www.multipz.com/mobile-app-development',
                                'Terms of use'),
                      ),
                      FlatButton(
                        child: Text('Payment terms'),
                        onPressed: () =>
                            _handleURLButtonPress(
                                context,
                                'https://www.multipz.com/mobile-app-development',
                                'Payment terms'),
                      ),
                      FlatButton(
                        child: Text('Privacy policy'),
                        onPressed: () =>
                            _handleURLButtonPress(
                                context,
                                'https://www.multipz.com/mobile-app-development',
                                'Privacy policy'),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        );
      });

  void _handleURLButtonPress(BuildContext context, String url, String tabName) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => WebViewContainer(url, tabName)));
  }
}
