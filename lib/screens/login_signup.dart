import 'dart:ffi';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

import '../globals.dart';

class LoginSignupScreen extends StatefulWidget {

  static String id = 'login_screen';

  @override
  State<StatefulWidget> createState() => _LoginSignupScreenState();
}

class _LoginSignupScreenState extends State<LoginSignupScreen>
    with SingleTickerProviderStateMixin {
  var loggedIn = false;
  var _loading = false;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  AnimationController _controller;

  Future<FirebaseUser> _handleSignIn() async {
    final GoogleSignInAccount googleUser = await _googleSignIn.signIn();
    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;

    final AuthCredential credential = GoogleAuthProvider.getCredential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    final FirebaseUser user =
        (await _auth.signInWithCredential(credential)).user;
    print("signed in " + user.displayName);
    Globals.authStore.loggedUser(user);
    return user;
  }

  Animation<double> opacity;
  @override
  void initState() {
    super.initState();

    //  precacheImage(new AssetImage('assets/images/bg-login-2.jpg'), context);

    _controller = AnimationController(
        duration: const Duration(milliseconds: 1000), vsync: this);
    opacity = CurvedAnimation(parent: _controller, curve: Curves.easeIn);
    _controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.blueGrey[800],
        child: Stack(
          fit: StackFit.loose,
          children: <Widget>[
            Container(
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage("assets/images/bg-login-2.jpg"),
                      fit: BoxFit.cover,
                      alignment: Alignment.center)),
            ),
            Positioned.fill(
              child: ModalProgressHUD(
                inAsyncCall: _loading,
                opacity: .8,
                color: Colors.blueGrey[800],
                progressIndicator: CircularProgressIndicator(),
                child: Container(
                  alignment: Alignment.center,
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: <Color>[
                        Colors.blueGrey[800].withAlpha(0),
                        Colors.blueGrey[800].withAlpha(200)
                      ],
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Flexible(child: Container()),
                      Flexible(
                        flex: 3,
                        child: Column(
                          children: <Widget>[
                            Logo(),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 0, horizontal: 30),
                              child: FadeTransition (
                                opacity: opacity,
                                child: Text(
                                  'Memorize concepts efficiently and rapidly. Stop wasting your time.',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Colors.white.withAlpha(240),
                                    fontSize: 20,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Flexible(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            Column(
                              mainAxisSize: MainAxisSize.max,
                              children: <Widget>[
                                RaisedButton (
                                  child: Text("JOIN US"),
                                )
                              ],
                            ),
                            Column(
                              children: <Widget>[
                                RaisedButton(
                                  child: Text('SIGN IN'),
                                  onPressed: () {
                                    setState(() {
                                      _loading = true;
                                    });
                                    _handleSignIn()
                                        .then((FirebaseUser user) {
                                      print(user.displayName);
                                      setState(() {
                                        _loading = false;
                                      });
                                      Globals.authStore.loggedIn(user.uid);
                                      //Navigator.of(context).pushReplacementNamed(HomeScreen.id);
                                      //Navigator.pushNamed(context, HomeScreen.id);
                                    }).catchError((e) => print(e));
                                  },
                                  /*'SIGN IN', () {
                                    print('Sign in');
                                    setState(() {
                                      _loading = true;
                                    });
                                    _handleSignIn()
                                        .then((FirebaseUser user) {
                                          print(user.displayName);
                                          setState(() {
                                            _loading = false;
                                          });
                                          widget.store.loggedIn(user.uid);
                                          //Navigator.of(context).pushReplacementNamed(HomeScreen.id);
                                          //Navigator.pushNamed(context, HomeScreen.id);
                                        })
                                        .catchError((e) => print(e));
                                  },*/
                                )
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}


class Logo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.fromLTRB(0, 0, 0, 80),
      child: Text(
        'Studio',
          style: TextStyle(
              color: Colors.white, fontSize: 60, fontWeight: FontWeight.w600),
        ),
    );
  }
}
