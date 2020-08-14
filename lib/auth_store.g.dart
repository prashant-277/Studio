// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$AuthStore on _AuthStore, Store {
  final _$statusAtom = Atom(name: '_AuthStore.status');

  @override
  int get status {
    _$statusAtom.reportRead();
    return super.status;
  }

  @override
  set status(int value) {
    _$statusAtom.reportWrite(value, super.status, () {
      super.status = value;
    });
  }

  final _$statsAtom = Atom(name: '_AuthStore.stats');

  @override
  UserStat get stats {
    _$statsAtom.reportRead();
    return super.stats;
  }

  @override
  set stats(UserStat value) {
    _$statsAtom.reportWrite(value, super.stats, () {
      super.stats = value;
    });
  }

  final _$loadStatsAsyncAction = AsyncAction('_AuthStore.loadStats');

  @override
  Future<void> loadStats() {
    return _$loadStatsAsyncAction.run(() => super.loadStats());
  }

  final _$_AuthStoreActionController = ActionController(name: '_AuthStore');

  @override
  void loggedIn(dynamic userId) {
    final _$actionInfo =
        _$_AuthStoreActionController.startAction(name: '_AuthStore.loggedIn');
    try {
      return super.loggedIn(userId);
    } finally {
      _$_AuthStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void loggedOut() {
    final _$actionInfo =
        _$_AuthStoreActionController.startAction(name: '_AuthStore.loggedOut');
    try {
      return super.loggedOut();
    } finally {
      _$_AuthStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  Future<void> setStatsValue(UserStat stats) {
    final _$actionInfo = _$_AuthStoreActionController.startAction(
        name: '_AuthStore.setStatsValue');
    try {
      return super.setStatsValue(stats);
    } finally {
      _$_AuthStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
status: ${status},
stats: ${stats}
    ''';
  }
}
