import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../../constants.dart';

class how_to_study extends StatefulWidget {
  @override
  _how_to_studyState createState() => _how_to_studyState();
}

class _how_to_studyState extends State<how_to_study> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: kContrastDarkColor),
        centerTitle: true,
        elevation: 0,
        backgroundColor: kBackground,
        title: Padding(
          padding: const EdgeInsets.all(18.0),
          child: Text(
            'How to study',
            style: TextStyle(color: kContrastDarkColor),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          width: MediaQuery.of(context).size.width,
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Text(
                      "There is no one-size-fits-all approach when learning how to effectively study. Studying methods should be tailored to each student. Everyone has different abilities, so it is important to determine what works for you and what doesn’t. (Find out what type of learner you are and which study techniques will work best for you!) For some students, studying and staying motivated comes easily — others may have to work a little bit harder.",
                    style: TextStyle(color: Colors.black54,letterSpacing: 1, ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Image.asset("assets/images/bg-login-1.jpg"),
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Text(
                    "There is no one-size-fits-all approach when learning how to effectively study. Studying methods should be tailored to each student. Everyone has different abilities, so it is important to determine what works for you and what doesn’t. (Find out what type of learner you are and which study techniques will work best for you!) For some students, studying and staying motivated comes easily — others may have to work a little bit harder.",
                    style: TextStyle(color: Colors.black54,letterSpacing: 1, ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
