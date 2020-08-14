import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mobx/mobx.dart';
import 'package:studio/globals.dart';
import 'package:studio/models/course_stats.dart';
import 'package:studio/models/user_stats.dart';

import 'models/user.dart';

part 'auth_store.g.dart';

const kStatusUnknown = 0;
const kStatusLoggedIn = 1;
const kStatusLoggedOut = 2;

// This is the class used by rest of your codebase
class AuthStore = _AuthStore with _$AuthStore;

// The store-class
abstract class _AuthStore with Store {
  @observable
  int status = 0;
  String userId;

  User user;

  @observable
  UserStat stats;

  final CollectionReference _users = Firestore.instance.collection('users');

  @action
  void loggedIn(userId) {
    Globals.userId = userId;
    status = kStatusLoggedIn;
    this.userId = userId;
  }

  @action
  void loggedOut() {
    status = kStatusLoggedOut;
  }

  void loggedUser(FirebaseUser fUser) async {
    print("logged user");
    user = User();
    user.id = fUser.uid;
    user.name = fUser.displayName;
    user.email = fUser.email;
    user.avatar = fUser.photoUrl;
  }

  @action
  Future<void> setStatsValue(UserStat stats) {
    this.stats = stats;
  }

  @action
  Future<void> loadStats() async {
    var doc = await _users.document(user.id).get();
    if(doc["stats"] != null)
      stats = UserStat.deserialize(doc['stats']);
  }
}