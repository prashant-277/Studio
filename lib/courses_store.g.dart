// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'courses_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$CoursesStore on _CoursesStore, Store {
  Computed<bool> _$isCourseLoadingComputed;

  @override
  bool get isCourseLoading => (_$isCourseLoadingComputed ??=
          Computed<bool>(() => super.isCourseLoading))
      .value;
  Computed<bool> _$isCoursesLoadingComputed;

  @override
  bool get isCoursesLoading => (_$isCoursesLoadingComputed ??=
          Computed<bool>(() => super.isCoursesLoading))
      .value;
  Computed<bool> _$isSubjectsLoadingComputed;

  @override
  bool get isSubjectsLoading => (_$isSubjectsLoadingComputed ??=
          Computed<bool>(() => super.isSubjectsLoading))
      .value;
  Computed<bool> _$isNotesLoadingComputed;

  @override
  bool get isNotesLoading =>
      (_$isNotesLoadingComputed ??= Computed<bool>(() => super.isNotesLoading))
          .value;
  Computed<bool> _$isQuestionsLoadingComputed;

  @override
  bool get isQuestionsLoading => (_$isQuestionsLoadingComputed ??=
          Computed<bool>(() => super.isQuestionsLoading))
      .value;
  Computed<bool> _$isBooksLoadingComputed;

  @override
  bool get isBooksLoading =>
      (_$isBooksLoadingComputed ??= Computed<bool>(() => super.isBooksLoading))
          .value;

  final _$loadingAtom = Atom(name: '_CoursesStore.loading');

  @override
  ObservableMap<String, dynamic> get loading {
    _$loadingAtom.context.enforceReadPolicy(_$loadingAtom);
    _$loadingAtom.reportObserved();
    return super.loading;
  }

  @override
  set loading(ObservableMap<String, dynamic> value) {
    _$loadingAtom.context.conditionallyRunInAction(() {
      super.loading = value;
      _$loadingAtom.reportChanged();
    }, _$loadingAtom, name: '${_$loadingAtom.name}_set');
  }

  final _$courseAtom = Atom(name: '_CoursesStore.course');

  @override
  Course get course {
    _$courseAtom.context.enforceReadPolicy(_$courseAtom);
    _$courseAtom.reportObserved();
    return super.course;
  }

  @override
  set course(Course value) {
    _$courseAtom.context.conditionallyRunInAction(() {
      super.course = value;
      _$courseAtom.reportChanged();
    }, _$courseAtom, name: '${_$courseAtom.name}_set');
  }

  final _$coursesAtom = Atom(name: '_CoursesStore.courses');

  @override
  ObservableList<Course> get courses {
    _$coursesAtom.context.enforceReadPolicy(_$coursesAtom);
    _$coursesAtom.reportObserved();
    return super.courses;
  }

  @override
  set courses(ObservableList<Course> value) {
    _$coursesAtom.context.conditionallyRunInAction(() {
      super.courses = value;
      _$coursesAtom.reportChanged();
    }, _$coursesAtom, name: '${_$coursesAtom.name}_set');
  }

  final _$subjectsAtom = Atom(name: '_CoursesStore.subjects');

  @override
  ObservableList<Subject> get subjects {
    _$subjectsAtom.context.enforceReadPolicy(_$subjectsAtom);
    _$subjectsAtom.reportObserved();
    return super.subjects;
  }

  @override
  set subjects(ObservableList<Subject> value) {
    _$subjectsAtom.context.conditionallyRunInAction(() {
      super.subjects = value;
      _$subjectsAtom.reportChanged();
    }, _$subjectsAtom, name: '${_$subjectsAtom.name}_set');
  }

  final _$notesAtom = Atom(name: '_CoursesStore.notes');

  @override
  ObservableList<Note> get notes {
    _$notesAtom.context.enforceReadPolicy(_$notesAtom);
    _$notesAtom.reportObserved();
    return super.notes;
  }

  @override
  set notes(ObservableList<Note> value) {
    _$notesAtom.context.conditionallyRunInAction(() {
      super.notes = value;
      _$notesAtom.reportChanged();
    }, _$notesAtom, name: '${_$notesAtom.name}_set');
  }

  final _$questionsAtom = Atom(name: '_CoursesStore.questions');

  @override
  ObservableList<Question> get questions {
    _$questionsAtom.context.enforceReadPolicy(_$questionsAtom);
    _$questionsAtom.reportObserved();
    return super.questions;
  }

  @override
  set questions(ObservableList<Question> value) {
    _$questionsAtom.context.conditionallyRunInAction(() {
      super.questions = value;
      _$questionsAtom.reportChanged();
    }, _$questionsAtom, name: '${_$questionsAtom.name}_set');
  }

  final _$booksAtom = Atom(name: '_CoursesStore.books');

  @override
  ObservableList<Book> get books {
    _$booksAtom.context.enforceReadPolicy(_$booksAtom);
    _$booksAtom.reportObserved();
    return super.books;
  }

  @override
  set books(ObservableList<Book> value) {
    _$booksAtom.context.conditionallyRunInAction(() {
      super.books = value;
      _$booksAtom.reportChanged();
    }, _$booksAtom, name: '${_$booksAtom.name}_set');
  }

  final _$saveCourseAsyncAction = AsyncAction('saveCourse');

  @override
  Future<void> saveCourse(
      {String id, String name, String icon, Function callback}) {
    return _$saveCourseAsyncAction.run(() =>
        super.saveCourse(id: id, name: name, icon: icon, callback: callback));
  }

  final _$saveNoteAsyncAction = AsyncAction('saveNote');

  @override
  Future<void> saveNote(Note note) {
    return _$saveNoteAsyncAction.run(() => super.saveNote(note));
  }

  final _$saveBookAsyncAction = AsyncAction('saveBook');

  @override
  Future<void> saveBook(Book book) {
    return _$saveBookAsyncAction.run(() => super.saveBook(book));
  }

  final _$saveSubjectAsyncAction = AsyncAction('saveSubject');

  @override
  Future<void> saveSubject(
      {String id, String name, String courseId, Function callback}) {
    return _$saveSubjectAsyncAction.run(() => super.saveSubject(
        id: id, name: name, courseId: courseId, callback: callback));
  }

  final _$deleteCourseAsyncAction = AsyncAction('deleteCourse');

  @override
  Future<void> deleteCourse(dynamic courseId) {
    return _$deleteCourseAsyncAction.run(() => super.deleteCourse(courseId));
  }

  final _$deleteSubjectAsyncAction = AsyncAction('deleteSubject');

  @override
  Future<void> deleteSubject(dynamic subjectId, dynamic courseId) {
    return _$deleteSubjectAsyncAction
        .run(() => super.deleteSubject(subjectId, courseId));
  }

  final _$deleteNoteAsyncAction = AsyncAction('deleteNote');

  @override
  Future<void> deleteNote(String id, Function callback) {
    return _$deleteNoteAsyncAction.run(() => super.deleteNote(id, callback));
  }

  final _$alterCourseSubjectsAsyncAction = AsyncAction('alterCourseSubjects');

  @override
  Future<void> alterCourseSubjects(dynamic courseId, dynamic op) {
    return _$alterCourseSubjectsAsyncAction
        .run(() => super.alterCourseSubjects(courseId, op));
  }

  final _$loadCoursesAsyncAction = AsyncAction('loadCourses');

  @override
  Future<void> loadCourses() {
    return _$loadCoursesAsyncAction.run(() => super.loadCourses());
  }

  final _$loadCourseAsyncAction = AsyncAction('loadCourse');

  @override
  Future<void> loadCourse(String courseId) {
    return _$loadCourseAsyncAction.run(() => super.loadCourse(courseId));
  }

  final _$loadSubjectsAsyncAction = AsyncAction('loadSubjects');

  @override
  Future<void> loadSubjects(String courseId) {
    return _$loadSubjectsAsyncAction.run(() => super.loadSubjects(courseId));
  }

  final _$loadBooksAsyncAction = AsyncAction('loadBooks');

  @override
  Future<void> loadBooks(String courseId) {
    return _$loadBooksAsyncAction.run(() => super.loadBooks(courseId));
  }

  @override
  String toString() {
    final string =
        'loading: ${loading.toString()},course: ${course.toString()},courses: ${courses.toString()},subjects: ${subjects.toString()},notes: ${notes.toString()},questions: ${questions.toString()},books: ${books.toString()},isCourseLoading: ${isCourseLoading.toString()},isCoursesLoading: ${isCoursesLoading.toString()},isSubjectsLoading: ${isSubjectsLoading.toString()},isNotesLoading: ${isNotesLoading.toString()},isQuestionsLoading: ${isQuestionsLoading.toString()},isBooksLoading: ${isBooksLoading.toString()}';
    return '{$string}';
  }
}
