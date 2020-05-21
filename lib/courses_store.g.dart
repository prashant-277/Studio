// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'courses_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$CoursesStore on _CoursesStore, Store {
  Computed<bool> _$isCourseLoadingComputed;

  @override
  bool get isCourseLoading =>
      (_$isCourseLoadingComputed ??= Computed<bool>(() => super.isCourseLoading,
              name: '_CoursesStore.isCourseLoading'))
          .value;
  Computed<bool> _$isCoursesLoadingComputed;

  @override
  bool get isCoursesLoading => (_$isCoursesLoadingComputed ??= Computed<bool>(
          () => super.isCoursesLoading,
          name: '_CoursesStore.isCoursesLoading'))
      .value;
  Computed<bool> _$isSubjectsLoadingComputed;

  @override
  bool get isSubjectsLoading => (_$isSubjectsLoadingComputed ??= Computed<bool>(
          () => super.isSubjectsLoading,
          name: '_CoursesStore.isSubjectsLoading'))
      .value;
  Computed<bool> _$isNotesLoadingComputed;

  @override
  bool get isNotesLoading =>
      (_$isNotesLoadingComputed ??= Computed<bool>(() => super.isNotesLoading,
              name: '_CoursesStore.isNotesLoading'))
          .value;
  Computed<bool> _$isQuestionsLoadingComputed;

  @override
  bool get isQuestionsLoading => (_$isQuestionsLoadingComputed ??=
          Computed<bool>(() => super.isQuestionsLoading,
              name: '_CoursesStore.isQuestionsLoading'))
      .value;
  Computed<bool> _$isBooksLoadingComputed;

  @override
  bool get isBooksLoading =>
      (_$isBooksLoadingComputed ??= Computed<bool>(() => super.isBooksLoading,
              name: '_CoursesStore.isBooksLoading'))
          .value;

  final _$loadingAtom = Atom(name: '_CoursesStore.loading');

  @override
  ObservableMap<String, dynamic> get loading {
    _$loadingAtom.reportRead();
    return super.loading;
  }

  @override
  set loading(ObservableMap<String, dynamic> value) {
    _$loadingAtom.reportWrite(value, super.loading, () {
      super.loading = value;
    });
  }

  final _$courseAtom = Atom(name: '_CoursesStore.course');

  @override
  Course get course {
    _$courseAtom.reportRead();
    return super.course;
  }

  @override
  set course(Course value) {
    _$courseAtom.reportWrite(value, super.course, () {
      super.course = value;
    });
  }

  final _$subjectAtom = Atom(name: '_CoursesStore.subject');

  @override
  Subject get subject {
    _$subjectAtom.reportRead();
    return super.subject;
  }

  @override
  set subject(Subject value) {
    _$subjectAtom.reportWrite(value, super.subject, () {
      super.subject = value;
    });
  }

  final _$coursesAtom = Atom(name: '_CoursesStore.courses');

  @override
  ObservableList<Course> get courses {
    _$coursesAtom.reportRead();
    return super.courses;
  }

  @override
  set courses(ObservableList<Course> value) {
    _$coursesAtom.reportWrite(value, super.courses, () {
      super.courses = value;
    });
  }

  final _$subjectsAtom = Atom(name: '_CoursesStore.subjects');

  @override
  ObservableList<Subject> get subjects {
    _$subjectsAtom.reportRead();
    return super.subjects;
  }

  @override
  set subjects(ObservableList<Subject> value) {
    _$subjectsAtom.reportWrite(value, super.subjects, () {
      super.subjects = value;
    });
  }

  final _$notesAtom = Atom(name: '_CoursesStore.notes');

  @override
  ObservableList<Note> get notes {
    _$notesAtom.reportRead();
    return super.notes;
  }

  @override
  set notes(ObservableList<Note> value) {
    _$notesAtom.reportWrite(value, super.notes, () {
      super.notes = value;
    });
  }

  final _$questionsAtom = Atom(name: '_CoursesStore.questions');

  @override
  ObservableList<Question> get questions {
    _$questionsAtom.reportRead();
    return super.questions;
  }

  @override
  set questions(ObservableList<Question> value) {
    _$questionsAtom.reportWrite(value, super.questions, () {
      super.questions = value;
    });
  }

  final _$booksAtom = Atom(name: '_CoursesStore.books');

  @override
  ObservableList<Book> get books {
    _$booksAtom.reportRead();
    return super.books;
  }

  @override
  set books(ObservableList<Book> value) {
    _$booksAtom.reportWrite(value, super.books, () {
      super.books = value;
    });
  }

  final _$saveCourseAsyncAction = AsyncAction('_CoursesStore.saveCourse');

  @override
  Future<void> saveCourse(
      {String id, String name, String icon, Function callback}) {
    return _$saveCourseAsyncAction.run(() =>
        super.saveCourse(id: id, name: name, icon: icon, callback: callback));
  }

  final _$saveNoteAsyncAction = AsyncAction('_CoursesStore.saveNote');

  @override
  Future<void> saveNote(Note note) {
    return _$saveNoteAsyncAction.run(() => super.saveNote(note));
  }

  final _$bookmarkNoteAsyncAction = AsyncAction('_CoursesStore.bookmarkNote');

  @override
  Future<void> bookmarkNote(String id, bool bookmark) {
    return _$bookmarkNoteAsyncAction
        .run(() => super.bookmarkNote(id, bookmark));
  }

  final _$bookmarkQuestionAsyncAction =
      AsyncAction('_CoursesStore.bookmarkQuestion');

  @override
  Future<void> bookmarkQuestion(String id, bool bookmark) {
    return _$bookmarkQuestionAsyncAction
        .run(() => super.bookmarkQuestion(id, bookmark));
  }

  final _$saveQuestionAsyncAction = AsyncAction('_CoursesStore.saveQuestion');

  @override
  Future<void> saveQuestion(Question question) {
    return _$saveQuestionAsyncAction.run(() => super.saveQuestion(question));
  }

  final _$saveBookAsyncAction = AsyncAction('_CoursesStore.saveBook');

  @override
  Future<void> saveBook(Book book) {
    return _$saveBookAsyncAction.run(() => super.saveBook(book));
  }

  final _$saveSubjectAsyncAction = AsyncAction('_CoursesStore.saveSubject');

  @override
  Future<void> saveSubject(Subject subject) {
    return _$saveSubjectAsyncAction.run(() => super.saveSubject(subject));
  }

  final _$deleteCourseAsyncAction = AsyncAction('_CoursesStore.deleteCourse');

  @override
  Future<void> deleteCourse(dynamic courseId) {
    return _$deleteCourseAsyncAction.run(() => super.deleteCourse(courseId));
  }

  final _$deleteSubjectAsyncAction = AsyncAction('_CoursesStore.deleteSubject');

  @override
  Future<void> deleteSubject(dynamic subjectId, dynamic courseId) {
    return _$deleteSubjectAsyncAction
        .run(() => super.deleteSubject(subjectId, courseId));
  }

  final _$deleteNoteAsyncAction = AsyncAction('_CoursesStore.deleteNote');

  @override
  Future<void> deleteNote(String id, Function callback) {
    return _$deleteNoteAsyncAction.run(() => super.deleteNote(id, callback));
  }

  final _$deleteQuestionAsyncAction =
      AsyncAction('_CoursesStore.deleteQuestion');

  @override
  Future<void> deleteQuestion(String id, Function callback) {
    return _$deleteQuestionAsyncAction
        .run(() => super.deleteQuestion(id, callback));
  }

  final _$deleteBookAsyncAction = AsyncAction('_CoursesStore.deleteBook');

  @override
  Future<void> deleteBook(String id) {
    return _$deleteBookAsyncAction.run(() => super.deleteBook(id));
  }

  final _$alterCourseSubjectsAsyncAction =
      AsyncAction('_CoursesStore.alterCourseSubjects');

  @override
  Future<void> alterCourseSubjects(dynamic courseId, dynamic op) {
    return _$alterCourseSubjectsAsyncAction
        .run(() => super.alterCourseSubjects(courseId, op));
  }

  final _$loadCoursesAsyncAction = AsyncAction('_CoursesStore.loadCourses');

  @override
  Future<void> loadCourses() {
    return _$loadCoursesAsyncAction.run(() => super.loadCourses());
  }

  final _$loadCourseAsyncAction = AsyncAction('_CoursesStore.loadCourse');

  @override
  Future<void> loadCourse(String courseId) {
    return _$loadCourseAsyncAction.run(() => super.loadCourse(courseId));
  }

  final _$loadSubjectsAsyncAction = AsyncAction('_CoursesStore.loadSubjects');

  @override
  Future<void> loadSubjects(String courseId) {
    return _$loadSubjectsAsyncAction.run(() => super.loadSubjects(courseId));
  }

  final _$loadBooksAsyncAction = AsyncAction('_CoursesStore.loadBooks');

  @override
  Future<void> loadBooks(String courseId) {
    return _$loadBooksAsyncAction.run(() => super.loadBooks(courseId));
  }

  final _$loadNotesAsyncAction = AsyncAction('_CoursesStore.loadNotes');

  @override
  Future<void> loadNotes(String subjectId) {
    return _$loadNotesAsyncAction.run(() => super.loadNotes(subjectId));
  }

  final _$loadQuestionsAsyncAction = AsyncAction('_CoursesStore.loadQuestions');

  @override
  Future<void> loadQuestions(String subjectId) {
    return _$loadQuestionsAsyncAction.run(() => super.loadQuestions(subjectId));
  }

  final _$_CoursesStoreActionController =
      ActionController(name: '_CoursesStore');

  @override
  void setSubject(Subject item) {
    final _$actionInfo = _$_CoursesStoreActionController.startAction(
        name: '_CoursesStore.setSubject');
    try {
      return super.setSubject(item);
    } finally {
      _$_CoursesStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void filterNotes(bool bookmarked) {
    final _$actionInfo = _$_CoursesStoreActionController.startAction(
        name: '_CoursesStore.filterNotes');
    try {
      return super.filterNotes(bookmarked);
    } finally {
      _$_CoursesStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void filterQuestions(bool bookmarked) {
    final _$actionInfo = _$_CoursesStoreActionController.startAction(
        name: '_CoursesStore.filterQuestions');
    try {
      return super.filterQuestions(bookmarked);
    } finally {
      _$_CoursesStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
loading: ${loading},
course: ${course},
subject: ${subject},
courses: ${courses},
subjects: ${subjects},
notes: ${notes},
questions: ${questions},
books: ${books},
isCourseLoading: ${isCourseLoading},
isCoursesLoading: ${isCoursesLoading},
isSubjectsLoading: ${isSubjectsLoading},
isNotesLoading: ${isNotesLoading},
isQuestionsLoading: ${isQuestionsLoading},
isBooksLoading: ${isBooksLoading}
    ''';
  }
}
