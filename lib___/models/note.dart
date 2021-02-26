import 'package:studio/models/subject_item.dart';

class Note extends SubjectItem {
  String text;
  bool bookmark = false;
  bool attention = false;
  String questionId;
}