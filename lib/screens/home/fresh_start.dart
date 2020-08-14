import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:studio/screens/edit_course.dart';
import 'package:studio/widgets/prof_card.dart';

import '../../colors.dart';

class FreshStartScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.max,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.fromLTRB(18, 18, 18, 18),
          child: Text('Follow the instructions of the professor, you’ll be guided straight to success!',
            style: TextStyle(
              fontSize: 16,
            ),
            textAlign: TextAlign.center,
          ),
        ),
        ProfCard(
          text: "Create your first course!",
          fontWeight: FontWeight.bold,
          buttons: <Widget>[
            FlatButton(
              child: Text('ADD COURSE'),
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(
                  builder: (context) => EditCourseScreen(data: null,)
                ));
              },
              color: kAccentColor,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18.0),
              ),
            )
          ],
        ),
        SizedBox(
          height: 40,
        )
      ],
    );
  }
}
