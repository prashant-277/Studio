import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:studio/widgets/buttons.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


import '../constants.dart';

class loginWithEmail extends StatefulWidget {
  @override
  _loginWithEmailState createState() => _loginWithEmailState();
}

class _loginWithEmailState extends State<loginWithEmail> {
  final _firestore = Firestore.instance;

  final _formKey = GlobalKey<FormState>();
  String email = '';

  TextEditingController email_controller = new TextEditingController();
  TextEditingController password_controller = new TextEditingController();

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
    FirebaseAuth.instance
        .createUserWithEmailAndPassword(
            email: email_controller.text, password: password_controller.text)
        .then((signedInUser) {
      _firestore.collection('users').add({
        'email': email_controller.text,
        'pass': password_controller.text,
      }).then((value) {
        if (signedInUser != null) {
          //Navigator.pushNamed(context, '/homepage');
          print("null");
        }
      }).catchError((e) {
        print(e);
      });
    }).catchError((e) {
      print(e);
    });
  }
}
