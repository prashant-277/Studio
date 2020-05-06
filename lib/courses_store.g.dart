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

  final _$saveCourseAsyncAction = AsyncAction('saveCourse');

  @override
  Future<void> saveCourse(
      {String id, String name, String icon, Function callback}) {
    return _$saveCourseAsyncAction.run(() =>
        super.saveCourse(id: id, name: name, icon: icon, callback: callback));
  }

  final _$saveSubjectAsyncAction = AsyncAction('saveSubject');

  @override
  Future<void> saveSubject(
      {String id, String name, String courseId, Function callback}) {
    return _$saveSubjectAsyncAction.run(() => super.saveSubject(
        id: id, name: name, courseId: courseId, callback: callback));
  }

  @override
  String toString() {
    final string =
        'loading: ${loading.toString()},course: ${course.toString()},courses: ${courses.toString()},subjects: ${subjects.toString()},isCourseLoading: ${isCourseLoading.toString()},isCoursesLoading: ${isCoursesLoading.toString()},isSubjectsLoading: ${isSubjectsLoading.toString()}';
    return '{$string}';
  }
}
