import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mobx/mobx.dart';
import 'package:studio/globals.dart';
import 'package:studio/models/course.dart';
import 'package:studio/models/note.dart';
import 'package:studio/models/question.dart';
import 'package:studio/models/subject.dart';

import 'models/book.dart';

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
  final CollectionReference _books = Firestore.instance.collection('books');

  @observable
  ObservableMap<String, dynamic> loading = ObservableMap.of({});

  @observable
  Course course;

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
    //if (id != null) await loadCourse(id);
    this.course = Course.withData(data);

    stopLoading(kCourse);
    if (callback != null) callback();
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
    loadNotes(note.subjectId);
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
        loadSubjects(book.courseId);
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
      await alterCourseSubjects(subject.courseId, kCounterIncrement);
      await loadSubjects(subject.id);
    }

    await loadSubjects(subject.courseId);
    await loadCourses();

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
  Future<void> loadSubjects(String courseId) async {
    addLoading(kSubjects);
    _subjects
        .where('courseId', isEqualTo: courseId)
        .orderBy('bookTitle')
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
  Future<void> loadNotes(String subjectId) async {
    addLoading(kNotes);
    print("loadNotes $subjectId");
    notes.clear();
    _notes
        .where('subjectId', isEqualTo: subjectId)
        //.orderBy('order')
        .orderBy('created')
        .getDocuments()
        .then((snapshot) {
      print(snapshot.documents.length);
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
    print("loadQuestions $subjectId");
    questions.clear();

    _questions
        .where('subjectId', isEqualTo: subjectId)
        .where('courseId', isEqualTo: courseId)
    //.orderBy('order')
        .orderBy('created')
        .getDocuments()
        .then((snapshot) {
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
