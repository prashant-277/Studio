import 'package:studio/models/question.dart';
import 'package:studio/models/subject_item.dart';

import 'note.dart';

class Subject {
  String id;
  String userId;
  String courseId;
  String name;
  String nameDb;
  DateTime created;
  List<Note> notes;
  List<Question> questions;
}