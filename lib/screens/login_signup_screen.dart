import 'dart:ffi';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_auth_buttons/flutter_auth_buttons.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:studio/screens/loginWithEmail.dart';
import 'package:studio/widgets/buttons.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

import '../auth_store.dart';
import '../constants.dart';

class LoginSignupScreen extends StatefulWidget {

  const LoginSignupScreen(this.store);

  static String id = 'login_screen';
  final AuthStore store;

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
  void dispose() {
    _controller.dispose();
    super.dispose();
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
                        child: SingleChildScrollView(
                          child: Column(
                            children: <Widget>[
                              Logo(),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 0, horizontal: 30),
                                child: FadeTransition(
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
                      ),
                      SingleChildScrollView(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            Column(
                              children: <Widget>[
                                Container(
                                  width:
                                  MediaQuery.of(context).size.width / 1.60,
                                  child: FacebookSignInButton(
                                    onPressed: () => fb_email_login(),
                                    text: "Join using Facebook",
                                    textStyle: TextStyle(
                                        color: Colors.white, fontSize: 18),
                                    centered: true,
                                    borderRadius: 5,
                                  ),
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Container(
                                  width:
                                  MediaQuery.of(context).size.width / 1.60,
                                  child: GoogleSignInButton(
                                    text: "Join using Google",
                                    textStyle: TextStyle(
                                        color: Colors.black, fontSize: 18),
                                    centered: true,
                                    borderRadius: 5,
                                    onPressed: () {
                                      print('Sign in');
                                      setState(() {
                                        _loading = true;
                                      });
                                      _handleSignIn().then((FirebaseUser user) {
                                        print(user.displayName);
                                        setState(() {
                                          _loading = false;
                                        });
                                        widget.store.loggedIn(user.uid);
                                        //Navigator.of(context).pushReplacementNamed(HomeScreen.id);
                                        //Navigator.pushNamed(context, HomeScreen.id);
                                      }).catchError((e) => print(e));
                                    },
                                  ),
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Platform.isIOS
                                    ? Container(
                                  width:
                                  MediaQuery.of(context).size.width /
                                      1.60,
                                  child: AppleSignInButton(
                                    text: "Join using Apple",
                                    textStyle: TextStyle(
                                        color: Colors.black,
                                        fontSize: 18),
                                    onPressed: () {},
                                    borderRadius: 5,
                                    centered: true,
                                  ),
                                )
                                    : Container(),
                                SizedBox(
                                  height: 5,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(
                                      color: Colors.white38,
                                      width: MediaQuery.of(context).size.width /
                                          3.5,
                                      height: 2,
                                    ),
                                    Text(
                                      "OR",
                                      style: TextStyle(color: Colors.white38),
                                    ),
                                    Container(
                                      color: Colors.white38,
                                      width: MediaQuery.of(context).size.width /
                                          3.5,
                                      height: 2,
                                    )
                                  ],
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Container(
                                  width:
                                  MediaQuery.of(context).size.width / 1.60,
                                  child: FlatButton(
                                    color: Colors.white,
                                    child: Text(
                                      "Join using Email",
                                      style: TextStyle(
                                          color: Colors.black, fontSize: 18),
                                    ),
                                    onPressed: () {
                                      showDialog(
                                          context: context,
                                          builder: (_) => AlertDialog(
                                              backgroundColor: kDarkBlue,
                                              title: Text(
                                                "Login with Email",
                                                style: TextStyle(
                                                    color: Colors.white),
                                              ),
                                              content: loginWithEmail()));
                                    },
                                  ),
                                ),
                                SizedBox(
                                  height: 5,
                                ),
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

  fb_email_login() async {
    final facebookLogin = new FacebookLogin();

    final facebookLoginResult =
        await facebookLogin.logIn(['email', 'public_profile']);

    switch (facebookLoginResult.status) {
      case FacebookLoginStatus.error:
        print("Error");
        break;

      case FacebookLoginStatus.cancelledByUser:
        print("CancelledByUser");
        break;

      case FacebookLoginStatus.loggedIn:
        print("LoggedIn");

        var firebaseUser = await firebaseAuthWithFacebook(
            token: facebookLoginResult.accessToken);
        print("Facebook UserDetail /////  " + firebaseUser.toString());
    }
  }
  Future<FirebaseUser> firebaseAuthWithFacebook(
      {@required FacebookAccessToken token}) async {
    AuthCredential credential =
    FacebookAuthProvider.getCredential(accessToken: token.toString());

    FirebaseUser firebaseUser =
        (await _auth.signInWithCredential(credential)).user;
    print("signed in " + firebaseUser.displayName);
    return firebaseUser;
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