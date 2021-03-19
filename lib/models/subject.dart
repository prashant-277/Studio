

import 'note.dart';
import 'question.dart';

class Subject {
  String id;
  String userId;
  String courseId;
  String name;
  String nameDb;
  DateTime created;
  List<Note> notes;
  String bookId;
  String bookTitle;
  List<Question> questions;
}