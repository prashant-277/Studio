import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mobx/mobx.dart';
import 'package:studio/globals.dart';
import 'package:studio/models/course.dart';
import 'package:studio/models/subject.dart';

part 'courses_store.g.dart';

// This is the class used by rest of your codebase
class CoursesStore = _CoursesStore with _$CoursesStore;

// The store-class
abstract class _CoursesStore with Store {
  final CollectionReference _courses = Firestore.instance.collection('courses');
  final CollectionReference _subjects = Firestore.instance.collection('subjects');

  @observable
  ObservableFuture<List<Course>> coursesFuture;

  @observable
  ObservableFuture<List<Subject>> subjectsFuture;

  @action
  void addCourse(String name, String icon, Function callback) {
    _courses.document().setData({
      'name': name,
      'nameDb': name.toLowerCase(),
      'icon': icon,
      'userId': Globals.userId,
      'created': DateTime.now(),
      'subjectsCount': 0
    }).then((data) {
      fetchCourses();
      callback();
    });
  }

  @action
  void addSubject(String name, String courseId) {
    Firestore.instance.runTransaction( (Transaction tx) async {
      var doc = _subjects.document();
      await tx.set(doc, {
        'name': name,
        'nameDb': name.toLowerCase(),
        'courseId': courseId,
        'userId': Globals.userId,
        'created': DateTime.now(),
      });
      var courseRef = _courses.document(courseId);
      var course = await tx.get(courseRef);
      await tx.update(courseRef, {
        'subjectsCount': course.data['subjectsCount'] + 1
      });
      fetchCourses();
    });
  }

  @action
  Future fetchCourses() => coursesFuture =
      ObservableFuture(_courses.where('userId', isEqualTo: Globals.userId)
          .orderBy('nameDb', descending: false).getDocuments().then( (snapshot) {
        print('snap length: ${snapshot.documents.length}');
        List<Course> _courses = List();
        if (snapshot.documents.length > 0) {
          for (var doc in snapshot.documents) {
            var c = Course();
            c.id = doc.documentID;
            c.userId = doc.data['userId'];
            c.icon = doc.data['icon'];
            c.name = doc.data['name'];
            c.nameDb = doc.data['nameDb'];
            c.subjectsCount = doc.data['subjects'];
            _courses.add(c);
            print('fullname docID: ${doc.documentID}');
          }
        }
        return _courses;
      }));

  @action
  Future fetchSubjects(String courseId) => subjectsFuture =
      ObservableFuture(_subjects
          .where('userId', isEqualTo: Globals.userId)
          .where('courseId', isEqualTo: courseId)
          .getDocuments().then( (snapshot) {
        print('snap length: ${snapshot.documents.length}');
        List<Subject> _subjects = List();
        if (snapshot.documents.length > 0) {
          for (var doc in snapshot.documents) {
            var c = Subject();
            c.id = doc.documentID;
            c.userId = doc.data['userId'];
            c.courseId = doc.data['courseId'];
            c.name = doc.data['name'];
            c.nameDb = doc.data['nameDb'];
            _subjects.add(c);
            print('fullname docID: ${doc.documentID}');
          }
        }
        return _subjects;
      }));

  void loadCourses() {
    if (coursesFuture == null) {
      fetchCourses();
    }
  }

  void loadSubjects(String courseId) {
    if (subjectsFuture == null) {
      fetchSubjects(courseId);
    }
  }
}