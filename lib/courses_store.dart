import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mobx/mobx.dart';
import 'package:studio/globals.dart';
import 'package:studio/models/course.dart';
import 'package:studio/models/note.dart';
import 'package:studio/models/question.dart';
import 'package:studio/models/subject.dart';
import 'package:studio/models/subject_stat.dart';
import 'package:studio/models/test_result.dart';
import 'package:studio/models/user_stats.dart';

import 'models/book.dart';
import 'models/course_stats.dart';

part 'courses_store.g.dart';

// This is the class used by rest of your codebase
class CoursesStore = _CoursesStore with _$CoursesStore;

const String kCourse = 'course';
const String kCourses = 'courses';
const String kSubject = 'subject';
const String kSubjects = 'subjects';
const String kNotes = 'notes';
const String kQuestions = 'questions';
const String kBooks = 'books';
const String kTests = 'tests';
const String kCounterIncrement = 'increment';
const String kCounterDecrease = 'decrease';

// The store-class
abstract class _CoursesStore with Store {
  final CollectionReference _courses =
      Firestore.instance.collection('courses');
  final CollectionReference _subjects =
      Firestore.instance.collection('subjects');
  final CollectionReference _notes =
      Firestore.instance.collection('notes');
  final CollectionReference _questions =
      Firestore.instance.collection('questions');
  final CollectionReference _books =
      Firestore.instance.collection('books');
  final CollectionReference _tests =
      Firestore.instance.collection('tests');
  final CollectionReference _users =
    Firestore.instance.collection('users');

  @observable
  ObservableMap<String, dynamic> loading = ObservableMap.of({});

  @observable
  Course course;

  @observable
  String courseName;

  @observable
  String courseId;

  @observable
  String subjectName;

  @observable
  String subjectId;

  @observable
  Subject subject;

  @observable
  ObservableList<Course> courses = ObservableList<Course>();

  @observable
  ObservableList<Subject> subjects = ObservableList<Subject>();

  @observable
  ObservableList<Note> notes = ObservableList<Note>();

  @observable
  ObservableList<Question> questions = ObservableList<Question>();

  @observable
  ObservableList<Book> books = ObservableList<Book>();

  @observable
  ObservableList<TestResult> tests = ObservableList<TestResult>();

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

  @computed
  bool get isBooksLoading => loading[kBooks] != null ? loading[kBooks] : false;

  @action
  Future<void> saveCourse(Course course) async {
    addLoading(kCourse);
    DocumentReference doc;
    var data = Map<String, Object>();
    data['name'] = course.name;
    data['nameDb'] = course.name.toLowerCase();
    data['icon'] = course.icon;
    data['updated'] = DateTime.now();

    bool isNew = false;
    if (course.id == null) {
      isNew = true;
      doc = _courses.document();
      data['userId'] = Globals.userId;
      data['created'] = DateTime.now();
      data['subjectsCount'] = 0;
    } else {
      doc = _courses.document(course.id);
    }
    await doc.setData(data, merge: true);
    this.course = Course.withData(data);
    this.course.id = doc.documentID;

    if(isNew) {
      await addCourseToStats(this.course);
    } else {
      await updateCourseStats(this.course);
    }

    stopLoading(kCourse);
  }

  Future<void> addCourseToStats(Course course) async {
    var doc = _users.document(Globals.userId);
    var user = await doc.get();
    var statsData = user.data["stats"];
    var stats = UserStat();

    if(statsData == null) {
      stats = UserStat();
    } else {
      stats = UserStat.deserialize(statsData);
    }
    CourseStats item = CourseStats();
    item.id = course.id;
    item.name = course.name;
    item.icon = course.icon;
    stats.courses.add(item);

    Globals.authStore.setStatsValue(stats);

    Map<String, dynamic> data = user.data;
    data["stats"] = stats.serialize();
    return doc.setData(data, merge: true);
  }

  Future<void> updateCourseStats(Course course) async {
    var doc = _users.document(Globals.userId);
    var user = await doc.get();
    var statsData = user.data["stats"];
    if(statsData == null)
      return addCourseToStats(course);

    var stats = UserStat.deserialize(user.data['stats']);
    CourseStats item = stats.courses.firstWhere((element) => element.id == course.id);
    if(item == null) {
      return addCourseToStats(course);
    } else {
      item.id = course.id;
      item.name = course.name;
      item.icon = course.icon;
      stats.courses.add(item);

      Globals.authStore.setStatsValue(stats);

      user.data["stats"] = stats.serialize();
      return doc.setData(user.data, merge: true);
    }
  }

  Future<void> deleteCourseFromStats(String courseId) async {
    var doc = _users.document(Globals.userId);
    var user = await doc.get();
    var statsData = user.data["stats"];
    var stats = UserStat();

    if(statsData == null) {
      return;
    } else {
      stats = UserStat.deserialize(statsData);
    }

    stats.courses = stats.courses.where((element) => element.id != courseId).toList();
    Globals.authStore.setStatsValue(stats);

    Map<String, dynamic> data = user.data;
    data["stats"] = stats.serialize();
    return doc.setData(data, merge: true);
  }

  @action
  void setSubject(Subject item) {
    subject = item;
  }

  @action
  void setCourse(Course item) {
    course = item;
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
    data['userId'] = Globals.userId;
    data['bookmark'] = note.bookmark;
    data['attention'] = note.attention;
    data['level'] = note.level;
    if (note.id == null) {
      data['created'] = DateTime.now();
      doc = _notes.document();
    } else {
      doc = _notes.document(note.id);
    }
    await doc.setData(data, merge: true);

    stopLoading(kNotes);
    loadNotes(subjectId: note.subjectId);
  }

  @action
  Future<void> bookmarkNote(String id, bool bookmark) async {
    //addLoading(kNotes);
    DocumentReference doc = _notes.document(id);
    var data = Map<String, dynamic>();
    data['bookmark'] = bookmark;
    await doc.setData(data, merge: true);
    //stopLoading(kNotes);
  }

  @action
  Future<void> attentionNote(String id, bool attention) async {
    //addLoading(kNotes);
    DocumentReference doc = _notes.document(id);
    var data = Map<String, dynamic>();
    data['attention'] = attention;
    await doc.setData(data, merge: true);
    //stopLoading(kNotes);
  }

  @action
  Future<void> bookmarkQuestion(String id, bool bookmark) async {
    DocumentReference doc = _questions.document(id);
    var data = Map<String, dynamic>();
    data['bookmark'] = bookmark;
    await doc.setData(data, merge: true);
  }

  @action
  Future<void> attentionQuestion(String id, bool attention) async {
    DocumentReference doc = _questions.document(id);
    var data = Map<String, dynamic>();
    data['attention'] = attention;
    await doc.setData(data, merge: true);
  }

  @action
  Future<void> saveQuestion(Question question) async {
    addLoading(kQuestions);
    DocumentReference doc;
    var data = Map<String, Object>();
    data['text'] = question.text;
    data['answer'] = question.answer;
    data['updated'] = DateTime.now();
    data['subjectId'] = question.subjectId;
    data['courseId'] = question.courseId;
    data['userId'] = Globals.userId;
    data['attention'] = question.attention;
    data['bookmark'] = question.bookmark;
    data['level'] = question.level;
    if (question.id == null) {
      data['created'] = DateTime.now();
      doc = _questions.document();
    } else {
      doc = _questions.document(question.id);
    }
    await doc.setData(data, merge: true);
    stopLoading(kQuestions);
    loadQuestions(subjectId: question.subjectId);
  }

  @action
  Future<void> saveBook(Book book) async {
    addLoading(kBooks);
    DocumentReference doc;
    var data = Map<String, Object>();
    data['title'] = book.title;
    data['titleDb'] = book.title.toLowerCase();
    data['updated'] = DateTime.now();
    data['courseId'] = book.courseId;
    data['userId'] = Globals.userId;
    if (book.id == null) {
      data['created'] = DateTime.now();
      doc = _books.document();
    } else {
      doc = _books.document(book.id);
    }
    await doc.setData(data, merge: true);

    if (book.id != null) {
      _subjects
          .where('bookId', isEqualTo: book.id)
          .getDocuments()
          .then((value) {
        value.documents.forEach((element) async {
          var data = Map<String, Object>();
          data['bookTitle'] = book.title;
          await element.reference.setData(data, merge: true);
        });
        loadSubjects(courseId: book.courseId);
      });
    }

    stopLoading(kBooks);
    loadBooks(book.courseId);
  }

  @action
  Future<void> saveSubject(Subject subject) async {
    DocumentReference doc;
    var data = Map<String, Object>();
    data['courseId'] = subject.courseId;
    data['name'] = subject.name;
    data['nameDb'] = subject.name.toLowerCase();
    data['bookTitle'] = subject.bookTitle;
    data['bookId'] = subject.bookId;
    data['updated'] = DateTime.now();
    if (subject.id == null) {
      doc = _subjects.document();
      data['userId'] = Globals.userId;
      data['created'] = DateTime.now();
    } else {
      doc = _subjects.document(subject.id);
    }
    doc.setData(data, merge: true);

    if (subject.id == null) {
      subject.id = doc.documentID;
      await alterCourseSubjects(subject.courseId, kCounterIncrement);
      await addSubjectToStats(subject);
    } else {
      await updateSubjectStats(subject);
    }

    await loadSubjects(courseId: subject.courseId);
    await loadCourses();
  }

  Future<void> addSubjectToStats(Subject subject) async {
    var doc = _users.document(Globals.userId);
    var user = await doc.get();
    var statsData = user.data["stats"];
    var stats = UserStat();

    if(statsData == null) {
      stats = UserStat();
    } else {
      stats = UserStat.deserialize(statsData);
    }

    var course = stats.courses.firstWhere((c) => c.id == subject.courseId);
    if(course == null) {
      return;
    }

    SubjectStat subjectStat = SubjectStat();
    subjectStat.id = subject.id;
    subjectStat.name = subject.name;

    course.subjects.add(subjectStat);
    Globals.authStore.setStatsValue(stats);

    Map<String, dynamic> data = user.data;
    data["stats"] = stats.serialize();
    return doc.setData(data, merge: true);
  }

  Future<void> updateSubjectStats(Subject subject) async {
    
  }

  @action
  Future<void> deleteCourse(courseId) async {
    addLoading(kCourse);
    await _notes
        .where('courseId', isEqualTo: courseId)
        .getDocuments()
        .then((snapshot) {
      snapshot.documents.forEach((doc) async {
        await doc.reference.delete();
      });
    });
    await _questions
        .where('courseId', isEqualTo: courseId)
        .getDocuments()
        .then((snapshot) {
      snapshot.documents.forEach((doc) async {
        await doc.reference.delete();
      });
    });
    await _subjects
        .where('courseId', isEqualTo: courseId)
        .getDocuments()
        .then((snapshot) {
      snapshot.documents.forEach((doc) async {
        await doc.reference.delete();
      });
    });
    await _books
        .where('courseId', isEqualTo: courseId)
        .getDocuments()
        .then((snapshot) {
      snapshot.documents.forEach((doc) async {
        await doc.reference.delete();
      });
    });
    await _courses.document(courseId).get().then((doc) async {
      await doc.reference.delete();
    });
    await deleteCourseFromStats(courseId);
    stopLoading(kCourse);
    loadCourses();
  }

  @action
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

  @action
  Future<void> deleteNote(String id, Function callback) async {
    addLoading(kNotes);
    print("delete note $id");
    await _notes.document(id).delete();
    stopLoading(kNotes);
    if (callback != null) callback();
  }

  @action
  Future<void> deleteQuestion(String id, Function callback) async {
    addLoading(kQuestions);
    print("delete question $id");
    await _questions.document(id).delete();
    stopLoading(kQuestions);
    if (callback != null) callback();
  }

  @action
  Future<void> deleteBook(String id) async {
    addLoading(kBooks);
    await _notes.where('bookId', isEqualTo: id).getDocuments().then((value) {
      value.documents.forEach((element) async {
        var data = Map();
        data['bookId'] = null;
        await element.reference.setData(data, merge: true);
      });
    });
    await _books.document(id).delete();
    stopLoading(kBooks);
  }

  @action
  Future<void> alterCourseSubjects(courseId, op) async {
    var course = await _courses.document(courseId).get();
    print("subjectsCount ${course.data['subjectsCount']}");
    _courses.document(courseId).setData({
      'subjectsCount': op == kCounterIncrement
          ? course.data['subjectsCount'] + 1
          : course.data['subjectsCount'] - 1
    }, merge: true);
  }

  @action
  Future<void> loadCourses() async {
    print("load courses");
    addLoading(kCourses);
    return _courses
        .where('userId', isEqualTo: Globals.userId)
        .orderBy('nameDb')
        .getDocuments()
        .then((snapshot) {

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
        }
      }
      stopLoading(kCourses);
    });
  }

  @action
  Future<void> loadTests() async {
    print("load tests");
    addLoading(kTests);
    return _tests
        .where('userId', isEqualTo: Globals.userId)
        .getDocuments()
        .then((snapshot) {

      tests.clear();
      if (snapshot.documents.length > 0) {
        for (var doc in snapshot.documents) {
          var c = TestResult();
          c.id = doc.documentID;
          c.userId = doc.data['userId'];
          c.questions = doc.data['questions'];
          tests.add(c);
        }
      }
      stopLoading(kTests);
    });
  }

  @action
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
      setCourse(course);
      stopLoading(kCourse);
    });
  }

  @action
  Future<void> loadSubjects({ String courseId }) async {
    addLoading(kSubjects);

    print("subjects userId ${Globals.userId}");
    var query = _subjects.where('userId', isEqualTo: Globals.userId);
    if(courseId != null)
      query = query.where('courseId', isEqualTo: courseId);

    return query.orderBy('bookTitle')
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
        subject.bookTitle = doc.data['bookTitle'];
        subject.bookId = doc.data['bookId'];
        subjects.add(subject);
      }
      stopLoading(kSubjects);
    });
  }

  @action
  Future<void> loadBooks(String courseId) async {
    addLoading(kBooks);
    books.clear();
    return _books
        .where('courseId', isEqualTo: courseId)
        .orderBy('titleDb')
        .getDocuments()
        .then((snapshot) {
      for (var doc in snapshot.documents) {
        Book book = Book();
        book.id = doc.documentID;
        book.titleDb = doc.data['titleDb'];
        book.title = doc.data['title'];
        book.courseId = doc.data['courseId'];
        books.add(book);
      }
      stopLoading(kBooks);
    });
  }

  List<Note> notesBackup = List();
  @action
  void filterNotes (bool bookmarked) {
    if(bookmarked) {
      notesBackup.clear();
      notes.clear();
      notes.forEach((element) {
        notesBackup.add(element);
      });

      var filtered = notes.where((element) => element.bookmark == true)
          .toList();
      print("filtered ${filtered.length}");
      notes.clear();
      notes.addAll(filtered);
    } else {
      notes.clear();
      notes.addAll(notesBackup);
    }
    print("notes ${notes.length}");
  }

  @action
  Future<void> loadNotes({ String subjectId }) async {
    addLoading(kNotes);
    print("loadNotes userId ${Globals.userId}");

    var query = _notes.where('userId', isEqualTo: Globals.userId);

    if(subjectId != null)
      query = query.where('subjectId', isEqualTo: subjectId);

    return query.orderBy('order')
        //.orderBy('created')
        .getDocuments()
        .then((snapshot) {
      print(snapshot.documents.length);
      notes.clear();
      for (var doc in snapshot.documents) {
        Note note = Note();
        note.id = doc.documentID;
        note.subjectId = doc.data['subjectId'];
        note.courseId = doc.data['courseId'];
        note.userId = doc.data['userId'];
        note.text = doc.data['text'];
        note.bookmark = doc.data['bookmark'] ?? false;
        note.attention = doc.data['attention'] ?? false;
        note.level = doc.data['level'] ?? 1;
        notes.add(note);
      }
      stopLoading(kNotes);
    });
  }


  List<Question> questionsBackup = List();
  @action
  void filterQuestions (bool bookmarked) {
    if(bookmarked) {
      questionsBackup.clear();
      questions.clear();
      questions.forEach((element) {
        questionsBackup.add(element);
      });

      var filtered = questions.where((element) => element.bookmark == true)
          .toList();
      print("filtered ${filtered.length}");
      questions.clear();
      questions.addAll(filtered);
    } else {
      questions.clear();
      questions.addAll(questionsBackup);
    }
  }

  @action
  Future<void> loadQuestions({ String subjectId, String courseId }) async {
    addLoading(kQuestions);


    var query = _questions.where('userId', isEqualTo: Globals.userId);
    if(subjectId != null)
      query = query.where('subjectId', isEqualTo: subjectId);

    if(courseId != null)
      query = query.where('courseId', isEqualTo: courseId);

    return query.orderBy('order')
        .getDocuments()
        .then((snapshot) {
          print("questions count ${snapshot.documents.length}");
          questions.clear();
      for (var doc in snapshot.documents) {
        Question question = Question();
        question.id = doc.documentID;
        question.subjectId = doc.data['subjectId'];
        question.courseId = doc.data['courseId'];
        question.userId = doc.data['userId'];
        question.text = doc.data['text'];
        question.answer = doc.data['answer'];
        question.bookmark = doc.data['bookmark'] ?? false;
        question.attention = doc.data['attention'] ?? false;
        question.level = doc.data['level'] ?? 1;
        questions.add(question);
      }
      stopLoading(kQuestions);
    });
  }
}
