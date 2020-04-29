// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'courses_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$CoursesStore on _CoursesStore, Store {
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

  final _$_CoursesStoreActionController =
      ActionController(name: '_CoursesStore');

  @override
  void addCourse(String name, String icon, Function callback) {
    final _$actionInfo = _$_CoursesStoreActionController.startAction();
    try {
      return super.addCourse(name, icon, callback);
    } finally {
      _$_CoursesStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void addSubject(String name, String courseId) {
    final _$actionInfo = _$_CoursesStoreActionController.startAction();
    try {
      return super.addSubject(name, courseId);
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
  String toString() {
    final string =
        'coursesFuture: ${coursesFuture.toString()},subjectsFuture: ${subjectsFuture.toString()}';
    return '{$string}';
  }
}
