import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mobx/mobx.dart';
import 'package:studio/globals.dart';
import 'package:studio/models/course.dart';
import 'package:studio/models/subject.dart';

part 'courses_store.g.dart';

// This is the class used by rest of your codebase
class CoursesStore = _CoursesStore with _$CoursesStore;

const String kCourse = 'course';
const String kCourses = 'courses';
const String kSubject = 'subject';
const String kSubjects = 'subjects';

// The store-class
abstract class _CoursesStore with Store {
  final CollectionReference _courses = Firestore.instance.collection('courses');
  final CollectionReference _subjects = Firestore.instance.collection('subjects');

  @observable
  ObservableMap<String, dynamic> loading = ObservableMap.of({});

  @observable
  ObservableFuture<Course> courseFuture;

  @observable
  ObservableFuture<List<Course>> coursesFuture;

  @observable
  ObservableFuture<List<Subject>> subjectsFuture;

  @observable
  ObservableList<Course> courses = ObservableList<Course>();

  @observable
  ObservableList<Subject> subjects = ObservableList<Subject>();

  void addLoading(String id) {
    print("add loading $id");
    loading[id] = true;
  }

  void stopLoading(String id) {
    print("stopLoading $id");
    loading[id] = false;
  }

  @computed
  bool get isCourseLoading => loading[kCourse] != null ? loading[kCourse] : false;

  @computed
  bool get isCoursesLoading => loading[kCourses] != null ? loading[kCourses] : false;

  @computed
  bool get isSubjectsLoading => loading[kSubjects] != null ? loading[kSubjects] : false;

  @action
  void saveCourse({ String id, String name, String icon, Function callback }) {
    DocumentReference doc;
    var data = Map<String, Object>();
    data['name'] = name;
    data['nameDb'] = name.toLowerCase();
    data['icon'] = icon;
    data['updated'] = DateTime.now();
    if(id == null) {
      doc = _courses.document();
      data['userId'] = Globals.userId;
      data['created'] = DateTime.now();
      data['subjectsCount'] = 0;
    } else {
      doc = _courses.document(id);
    }
    doc.setData(data, merge: true).then((data) {
      loadCourses();
      if(id != null)
        loadCourse(id);
      callback();
    });
  }

  @action
  void saveSubject({ String id, String name, String courseId, Function callback}) {
    print("save subject");
    Firestore.instance.runTransaction( (Transaction tx) async {
      if(id == null) {
        var doc = _subjects.document();
        var courseRef = _courses.document(courseId);
        var course = await tx.get(courseRef);
        print("before saving subject");
        await tx.set(doc, {
          'name': name,
          'nameDb': name.toLowerCase(),
          'courseId': courseId,
          'userId': Globals.userId,
          'created': DateTime.now(),
        });

        await tx.update(courseRef, {
          'subjectsCount': course.data['subjectsCount'] + 1
        });
      } else {
        var doc = _subjects.document(id);
        tx.set(doc, {
          'name': name,
          'nameDb': name.toLowerCase(),
          'updated': DateTime.now(),
        }).then((onValue) {
          if(callback != null)
            callback();
        });
      }
    }).then((onValue) {
      loadCourses();
      loadSubjects(courseId);
      if(callback != null)
        callback();
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
            c.subjectsCount = doc.data['subjectsCount'];
            _courses.add(c);
            print('fullname docID: ${doc.documentID}');
          }
        }
        return _courses;
      }).catchError((onError) {
        print("Error fetching courses");
        print(onError);
        return List();
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

  @action fetchCourse(String courseId) => courseFuture =
      ObservableFuture(_courses.document(courseId).get().then( (snapshot) {
        if(snapshot.data['userId'] != Globals.userId) {
          throw Exception("Auth exception");
        }
        Course course = Course();
        course.userId = snapshot.data['userId'];
        course.name = snapshot.data['name'];
        course.subjectsCount = snapshot.data['subjectsCount'];
        return course;
      }));

  void loadCourses() {
    print("load courses");
    addLoading(kCourses);
    _courses.where('userId', isEqualTo: Globals.userId)
        .orderBy('nameDb')
        .getDocuments()
        .then( (snapshot) {
          print('snap length: ${snapshot.documents.length}');
          courses.clear();
          if (snapshot.documents.length > 0) {
            for (var doc in snapshot.documents) {
              var c = Course();
              c.id = doc.documentID;
              c.userId = doc.data['userId'];
              c.icon = doc.data['icon'];
              c.name = doc.data['name'];
              c.nameDb = doc.data['nameDb'];
              c.subjectsCount = doc.data['subjectsCount'];
              courses.add(c);
              print('${c.name} ${c.subjectsCount}');
            }
          }
          stopLoading(kCourses);
      });
    /*if (coursesFuture == null) {
      fetchCourses();
    }*/
  }

  void loadCourse(String courseId) {
    print("load course $courseId");
    //if (courseFuture == null) {
      fetchCourse(courseId);
    //}
  }

  void loadSubjects(String courseId) {
    print("load subjects");
    addLoading(kSubjects);
    subjects.clear();
    _subjects.where('courseId', isEqualTo: courseId)
        .orderBy('nameDb')
        .getDocuments()
        .then((snapshot) {
          for (var doc in snapshot.documents) {
            Subject subject = Subject();
            subject.id = doc.documentID;
            subject.courseId = doc.data['courseId'];
            subject.name = doc.data['name'];
            subject.nameDb = doc.data['nameDb'];
            subjects.add(subject);
          }
          print("subjects ${subjects.length}");
          stopLoading(kSubjects);
    });
  }
}