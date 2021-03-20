
import 'package:mobx/mobx.dart';

import 'globals.dart';


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
}
