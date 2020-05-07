import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mobx/mobx.dart';
import 'package:studio/globals.dart';
import 'package:studio/models/course.dart';
import 'package:studio/models/note.dart';
import 'package:studio/models/question.dart';
import 'package:studio/models/subject.dart';

part 'courses_store.g.dart';

// This is the class used by rest of your codebase
class CoursesStore = _CoursesStore with _$CoursesStore;

const String kCourse = 'course';
const String kCourses = 'courses';
const String kSubject = 'subject';
const String kSubjects = 'subjects';
const String kNotes = 'notes';
const String kQuestions = 'questions';
const String kCounterIncrement = 'increment';
const String kCounterDecrease = 'decrease';

// The store-class
abstract class _CoursesStore with Store {
  final CollectionReference _courses = Firestore.instance.collection('courses');
  final CollectionReference _subjects =
      Firestore.instance.collection('subjects');
  final CollectionReference _notes = Firestore.instance.collection('notes');
  final CollectionReference _questions =
      Firestore.instance.collection('questions');

  @observable
  ObservableMap<String, dynamic> loading = ObservableMap.of({});

  @observable
  Course course;

  @observable
  ObservableList<Course> courses = ObservableList<Course>();

  @observable
  ObservableList<Subject> subjects = ObservableList<Subject>();

  @observable
  ObservableList<Note> notes = ObservableList<Note>();

  @observable
  ObservableList<Question> questions = ObservableList<Question>();

  void addLoading(String id) {
    loading[id] = true;
  }

  void stopLoading(String id) {
    loading[id] = false;
  }

  @computed
  bool get isCourseLoading =>
      loading[kCourse] != null ? loading[kCourse] : false;

  @computed
  bool get isCoursesLoading =>
      loading[kCourses] != null ? loading[kCourses] : false;

  @computed
  bool get isSubjectsLoading =>
      loading[kSubjects] != null ? loading[kSubjects] : false;

  @computed
  bool get isNotesLoading => loading[kNotes] != null ? loading[kNotes] : false;

  @computed
  bool get isQuestionsLoading =>
      loading[kQuestions] != null ? loading[kQuestions] : false;

  @action
  Future<void> saveCourse(
      {String id, String name, String icon, Function callback}) async {
    addLoading(kCourse);
    DocumentReference doc;
    var data = Map<String, Object>();
    data['name'] = name;
    data['nameDb'] = name.toLowerCase();
    data['icon'] = icon;
    data['updated'] = DateTime.now();
    if (id == null) {
      doc = _courses.document();
      data['userId'] = Globals.userId;
      data['created'] = DateTime.now();
      data['subjectsCount'] = 0;
    } else {
      doc = _courses.document(id);
    }
    await doc.setData(data, merge: true);
    if (id != null) await loadCourse(id);

    stopLoading(kCourse);
    if (callback != null) callback();
  }

  @action
  Future<void> saveNote(Note note) async {
    addLoading(kNotes);
    DocumentReference doc;
    var data = Map<String, Object>();
    data['text'] = note.text;
    data['updated'] = DateTime.now();
    data['subjectId'] = note.subjectId;
    data['courseId'] = note.courseId;
    data['usersId'] = Globals.userId;
    if(note.id == null) {
      data['created'] = DateTime.now();
      doc = _notes.document();
    } else {
      doc = _notes.document(note.id);
    }
    await doc.setData(data, merge: true);
    stopLoading(kNotes);
    loadNotes(note.subjectId);
  }

  @action
  Future<void> saveSubject(
      {String id, String name, String courseId, Function callback}) async {
    DocumentReference doc;
    var data = Map<String, Object>();
    data['courseId'] = courseId;
    data['name'] = name;
    data['nameDb'] = name.toLowerCase();
    data['updated'] = DateTime.now();
    if (id == null) {
      doc = _subjects.document();
      data['userId'] = Globals.userId;
      data['created'] = DateTime.now();
    } else {
      doc = _subjects.document(id);
    }
    doc.setData(data, merge: true);

    if (id == null) {
      await alterCourseSubjects(courseId, kCounterIncrement);
      await loadSubjects(id);
    }

    await loadCourses();
    if (callback != null) callback();

    /*
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
    });*/
  }

  Future<void> deleteCourse(courseId) async {
    throw Exception("Not yet implemented");
  }

  Future<void> deleteSubject(subjectId, courseId) async {
    addLoading(kSubjects);
    _notes
        .where('subjectId', isEqualTo: subjectId)
        .getDocuments()
        .then((snapshot) {
      snapshot.documents.forEach((doc) async {
        await doc.reference.delete();
      });
    });
    _questions
        .where('subjectId', isEqualTo: subjectId)
        .getDocuments()
        .then((snapshot) {
      snapshot.documents.forEach((doc) async {
        await doc.reference.delete();
      });
    });
    _subjects.document(subjectId).get().then((doc) async {
      await doc.reference.delete();
    });
    await alterCourseSubjects(courseId, kCounterDecrease);
    stopLoading(kSubjects);
  }

  Future<void> alterCourseSubjects(courseId, op) async {
    var course = await _courses.document(courseId).get();
    print("subjectsCount ${course.data['subjectsCount']}");
    _courses.document(courseId).setData({
      'subjectsCount': op == kCounterIncrement
          ? course.data['subjectsCount'] + 1
          : course.data['subjectsCount'] - 1
    }, merge: true);
  }

  Future<void> loadCourses() async {
    print("load courses");
    addLoading(kCourses);
    _courses
        .where('userId', isEqualTo: Globals.userId)
        .orderBy('nameDb')
        .getDocuments()
        .then((snapshot) {
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
  }

  Future<void> loadCourse(String courseId) async {
    addLoading(kCourse);
    _courses.document(courseId).get().then((snapshot) {
      course = Course();
      course.name = snapshot.data['name'];
      course.nameDb = snapshot.data['nameDb'];
      course.icon = snapshot.data['icon'];
      course.id = snapshot.data['id'];
      course.userId = snapshot.data['userId'];
      course.subjectsCount = snapshot.data['subjectsCount'];
      print("course loaded");
      stopLoading(kCourse);
    });
  }

  Future<void> loadSubjects(String courseId) async {
    addLoading(kSubjects);
    _subjects
        .where('courseId', isEqualTo: courseId)
        .orderBy('nameDb')
        .getDocuments()
        .then((snapshot) {
      subjects.clear();
      for (var doc in snapshot.documents) {
        Subject subject = Subject();
        subject.id = doc.documentID;
        subject.courseId = doc.data['courseId'];
        subject.name = doc.data['name'];
        subject.nameDb = doc.data['nameDb'];
        subjects.add(subject);
      }
      stopLoading(kSubjects);
    });
  }

  Future<void> loadNotes(String subjectId) async {
    addLoading(kNotes);
    print("loadNotes $subjectId");
    _notes
        .where('subjectId', isEqualTo: subjectId)
        //.orderBy('order')
        //.orderBy('created')
        .getDocuments()
        .then((snapshot) {
          print(snapshot.documents.length);
      notes.clear();
      for (var doc in snapshot.documents) {
        Note note = Note();
        note.subjectId = doc.data['subjectId'];
        note.courseId = doc.data['courseId'];
        note.userId = doc.data['userId'];
        note.text = doc.data['text'];
        note.created = doc.data['created'];
        print("note: ${note.text}");
        notes.add(note);
      }
      stopLoading(kNotes);
    });
  }
}
