import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_auth_buttons/flutter_auth_buttons.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:studio/screens/loginWithEmail.dart';
import 'package:studio/utils/Utils.dart';
import 'package:studio/widgets/buttons.dart';

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

  final _firestore = Firestore.instance;
  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  String email = '';

  TextEditingController email_controller = new TextEditingController();
  TextEditingController password_controller = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            height: MediaQuery.of(context).size.height,
            color: HexColor("F3F3F5"),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(
                  "My Professor",
                  style: TextStyle(
                      fontSize: 23,
                      fontFamily: "Quicksand",
                      color: HexColor("5D646B"),
                      fontWeight: FontWeight.w200),
                ),
                Image.asset(
                  "assets/images/professor-new.png",
                  height: MediaQuery.of(context).size.height / 3.5,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 15.0,
                  ),
                  child: Card(
                    elevation: 0.3,
                    child: Container(
                      color: Colors.white,
                      child: Column(
                        children: <Widget>[
                          SizedBox(height: 18),
                          Container(
                            width: MediaQuery.of(context).size.width / 1.26,
                            child: FacebookSignInButton(
                              onPressed: () => fb_email_login(),
                              text: "Join using Facebook",
                              textStyle: TextStyle(
                                  color: Colors.white,
                                  fontFamily: "nunito",
                                  fontWeight: FontWeight.w600),
                              centered: true,
                              borderRadius: 5,
                            ),
                          ),
                          SizedBox(
                            height: 8,
                          ),
                          //Join using Google
                          Container(
                            width: MediaQuery.of(context).size.width / 1.26,
                            child: GoogleSignInButton(
                              text: "Join using Google",
                              textStyle: TextStyle(
                                  color: Colors.black,
                                  fontFamily: "nunito",
                                  fontWeight: FontWeight.w600),
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
                            height: 8,
                          ),
                          //join using apple
                          /*Platform.isAndroid
                              ?*/
                          Platform.isIOS? Container(
                            color: Colors.white,
                            width: MediaQuery.of(context).size.width / 1.26,
                            child: AppleSignInButton(
                              style: AppleButtonStyle.black,
                              text: "Join using Apple",
                              textStyle: TextStyle(
                                  color: Colors.white,
                                  fontFamily: "nunito",
                                  fontWeight: FontWeight.w600),
                              onPressed: () {},
                              borderRadius: 5,
                              centered: true,
                            ),
                          ):Container(),
                          // : Container(),
                          SizedBox(
                            height: 5,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                color: Colors.black26,
                                width: MediaQuery.of(context).size.width / 2.95,
                                height: 1.5,
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8.0),
                                child: Text(
                                  "OR",
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontFamily: "nunito",
                                      fontWeight: FontWeight.w600),
                                ),
                              ),
                              Container(
                                color: Colors.black26,
                                width: MediaQuery.of(context).size.width / 2.95,
                                height: 1.5,
                              )
                            ],
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          //join using email
                          Container(
                            width: MediaQuery.of(context).size.width / 1.26,
                            child: FlatButton(
                              height: 40.5,
                              color: HexColor("E5E5E5"),
                              child: Text(
                                "Join using Email",
                                style: TextStyle(
                                    color: HexColor("1F1F1F"),
                                    fontFamily: "nunito",
                                    fontWeight: FontWeight.w800),
                              ),
                              onPressed: () {
                                showDialog(
                                    context: context,
                                    builder: (_) => AlertDialog(

                                        backgroundColor: kDarkBlue,
                                        title: Text(
                                          "Login with Email",
                                          style: TextStyle(color: Colors.white),
                                        ),
                                        content: SingleChildScrollView(
                                          child: Column(
                                            children: [
                                              Form(
                                                key: _formKey,
                                                autovalidate: false,
                                                child: Column(
                                                  children: [
                                                    TextFormField(
                                                      controller: email_controller,
                                                      autocorrect: true,
                                                      autofocus: true,
                                                      maxLines: 1,
                                                      style: TextStyle(color: Colors.white),
                                                      validator: (value) => value.isEmpty ? 'Enter email' : null,
                                                      onChanged: (value) {
                                                        setState(() => email = value);
                                                      },
                                                      keyboardType: TextInputType.emailAddress,
                                                      decoration: InputDecoration(
                                                          icon: Icon(
                                                            Icons.person,
                                                            color: Colors.white,
                                                          ),
                                                          hintText: "Email",
                                                          hintStyle: TextStyle(color: Colors.white)),
                                                    ),
                                                    TextFormField(
                                                      controller: password_controller,
                                                      autocorrect: true,
                                                      autofocus: true,
                                                      maxLines: 1,
                                                      style: TextStyle(color: Colors.white),
                                                      obscureText: true,
                                                      validator: (value) => value.isEmpty ? 'Enter password' : null,
                                                      onChanged: (value) {
                                                        setState(() => email = value);
                                                      },
                                                      keyboardType: TextInputType.emailAddress,
                                                      decoration: InputDecoration(
                                                          icon: Icon(
                                                            Icons.vpn_key_rounded,
                                                            color: Colors.white,
                                                          ),
                                                          hintText: "Password",
                                                          hintStyle: TextStyle(color: Colors.white)),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(top: 15.0),
                                                child: WhiteButton("Sign In", () {
                                                  if (_formKey.currentState.validate()) {
                                                    print("done");
                                                    loginWith_Email();
                                                  }
                                                }),
                                              )
                                            ],
                                          ),
                                        )

                                    ));
                              },
                            ),
                          ),
                          SizedBox(
                            height: 18,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Text.rich(
                      TextSpan(
                        text: 'Existing user? ',
                        style: TextStyle(
                            color: Colors.black,
                            fontFamily: "nunito",
                            fontSize: 15,
                            fontWeight: FontWeight.w700),
                        children: <TextSpan>[
                          TextSpan(
                            text: 'Log In',
                            style: TextStyle(
                                color: Colors.black,
                                fontFamily: "nunito",
                                fontSize: 15,
                                decoration: TextDecoration.underline,
                                fontWeight: FontWeight.w700),
                          ),
                          // can add more TextSpans here...
                        ],
                      ),
                    ))
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> fb_email_login() async {
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
        print("token " + facebookLoginResult.accessToken.token);

        var firebaseUser = await firebaseAuthWithFacebook(
            token: facebookLoginResult.accessToken);
    }
  }

  Future<FirebaseUser> firebaseAuthWithFacebook(
      {@required FacebookAccessToken token}) async {
    AuthCredential credential =
        FacebookAuthProvider.getCredential(accessToken: token.token);
    FirebaseUser firebaseUser =
        (await _auth.signInWithCredential(credential)).user;
    print("Facebook UserDetail------ /////  " +
        firebaseUser.displayName.toString());

    return firebaseUser;
  }

  void loginWith_Email() {
    FirebaseAuth.instance
        .createUserWithEmailAndPassword(
        email: email_controller.text, password: password_controller.text)
        .then((signedInUser) {
      _firestore.collection('users').add({
        'email': email_controller.text,
        'pass': password_controller.text,

      }).then((value) {
        Navigator.pop(context);
        widget.store.loggedIn(signedInUser.user.uid);


        if (signedInUser != null) {
          Navigator.pushNamed(context, '/homepage');
          print("null");
        } else {

        }
      }).catchError((e) {
        print(e);
      });
    }).catchError((e) {
      switch (e.code) {
        case 'ERROR_EMAIL_ALREADY_IN_USE':
          _scaffoldKey.currentState.showSnackBar(SnackBar(
            content: Text('Your email address is already in use.'),
          ));
          break;

        case 'ERROR_ACCOUNT_EXISTS_WITH_DIFFERENT_CREDENTIAL':
          _scaffoldKey.currentState.showSnackBar(SnackBar(
            content: Text("Your account already exists with different credential."),
          ));
          break;

        case 'ERROR_CREDENTIAL_ALREADY_IN_USE':
          _scaffoldKey.currentState.showSnackBar(SnackBar(
            content: Text("Entered credential already in use."),
          ));
          break;
      }
    });
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
