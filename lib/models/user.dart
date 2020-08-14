import 'package:studio/models/user_stats.dart';

import 'course_stats.dart';

class User {
  String id;
  String email;
  String avatar;
  String name;
  UserStat stats;
}


/**
 * courses:
 *  - Geography
 *    subjects:
 *      - Introduction
 *        notes: yes
 *        questions: no
 *        id
 *    tests:
 *      - 0:
 *        date: 2020-03-02
 *        result: 0.824
 *        subjects:
 *          - id:
 *            wrong:
 *              - id_0387312
 *              - id_9432899
 *          - Cartography
 */