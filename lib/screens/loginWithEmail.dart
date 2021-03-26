/*
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:studio/auth_store.dart';
import 'package:studio/widgets/buttons.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../constants.dart';

class loginWithEmail extends StatefulWidget {
  loginWithEmail(this.store);

  AuthStore store;

  @override
  _loginWithEmailState createState() => _loginWithEmailState();
}

class _loginWithEmailState extends State<loginWithEmail> {
  final _firestore = Firestore.instance;

  final _formKey = GlobalKey<FormState>();
  String email = '';

  TextEditingController email_controller = new TextEditingController();
  TextEditingController password_controller = new TextEditingController();

  var _loading = false;

  String errorMessage;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
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
    );
  }

  void loginWith_Email() {
    try {
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
          } else {}
        }).catchError((e) {
          print(e);
        });
      }).catchError((e) {
        print(e);
      });
    } on PlatformException catch (exception) {
      switch (exception.code) {
        case 'ERROR_EMAIL_ALREADY_IN_USE':
          errorMessage = "Your email address is already in use.";
          print("Your email address is already in use.");
          break;

        case 'ERROR_ACCOUNT_EXISTS_WITH_DIFFERENT_CREDENTIAL':
          errorMessage = "Your account already exists with different credential.";
          break;

        case 'ERROR_CREDENTIAL_ALREADY_IN_USE':
          errorMessage = "Entered credential already in use.";
          break;
      }
    }
  }
}
*/
