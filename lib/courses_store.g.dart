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

  final _$courseFutureAtom = Atom(name: '_CoursesStore.courseFuture');

  @override
  ObservableFuture<Course> get courseFuture {
    _$courseFutureAtom.context.enforceReadPolicy(_$courseFutureAtom);
    _$courseFutureAtom.reportObserved();
    return super.courseFuture;
  }

  @override
  set courseFuture(ObservableFuture<Course> value) {
    _$courseFutureAtom.context.conditionallyRunInAction(() {
      super.courseFuture = value;
      _$courseFutureAtom.reportChanged();
    }, _$courseFutureAtom, name: '${_$courseFutureAtom.name}_set');
  }

  final _$coursesFutureAtom = Atom(name: '_CoursesStore.coursesFuture');

  @override
  ObservableFuture<List<Course>> get coursesFuture {
    _$coursesFutureAtom.context.enforceReadPolicy(_$coursesFutureAtom);
    _$coursesFutureAtom.reportObserved();
    return super.coursesFuture;
  }

  @override
  set coursesFuture(ObservableFuture<List<Course>> value) {
    _$coursesFutureAtom.context.conditionallyRunInAction(() {
      super.coursesFuture = value;
      _$coursesFutureAtom.reportChanged();
    }, _$coursesFutureAtom, name: '${_$coursesFutureAtom.name}_set');
  }

  final _$subjectsFutureAtom = Atom(name: '_CoursesStore.subjectsFuture');

  @override
  ObservableFuture<List<Subject>> get subjectsFuture {
    _$subjectsFutureAtom.context.enforceReadPolicy(_$subjectsFutureAtom);
    _$subjectsFutureAtom.reportObserved();
    return super.subjectsFuture;
  }

  @override
  set subjectsFuture(ObservableFuture<List<Subject>> value) {
    _$subjectsFutureAtom.context.conditionallyRunInAction(() {
      super.subjectsFuture = value;
      _$subjectsFutureAtom.reportChanged();
    }, _$subjectsFutureAtom, name: '${_$subjectsFutureAtom.name}_set');
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

  final _$_CoursesStoreActionController =
      ActionController(name: '_CoursesStore');

  @override
  void saveCourse({String id, String name, String icon, Function callback}) {
    final _$actionInfo = _$_CoursesStoreActionController.startAction();
    try {
      return super
          .saveCourse(id: id, name: name, icon: icon, callback: callback);
    } finally {
      _$_CoursesStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void saveSubject(
      {String id, String name, String courseId, Function callback}) {
    final _$actionInfo = _$_CoursesStoreActionController.startAction();
    try {
      return super.saveSubject(
          id: id, name: name, courseId: courseId, callback: callback);
    } finally {
      _$_CoursesStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  Future<dynamic> fetchCourses() {
    final _$actionInfo = _$_CoursesStoreActionController.startAction();
    try {
      return super.fetchCourses();
    } finally {
      _$_CoursesStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  Future<dynamic> fetchSubjects(String courseId) {
    final _$actionInfo = _$_CoursesStoreActionController.startAction();
    try {
      return super.fetchSubjects(courseId);
    } finally {
      _$_CoursesStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic fetchCourse(String courseId) {
    final _$actionInfo = _$_CoursesStoreActionController.startAction();
    try {
      return super.fetchCourse(courseId);
    } finally {
      _$_CoursesStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    final string =
        'loading: ${loading.toString()},courseFuture: ${courseFuture.toString()},coursesFuture: ${coursesFuture.toString()},subjectsFuture: ${subjectsFuture.toString()},courses: ${courses.toString()},subjects: ${subjects.toString()},isCourseLoading: ${isCourseLoading.toString()},isCoursesLoading: ${isCoursesLoading.toString()},isSubjectsLoading: ${isSubjectsLoading.toString()}';
    return '{$string}';
  }
}
