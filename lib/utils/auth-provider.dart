import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:socials/models/User.dart';

class AuthState extends ChangeNotifier {
  /// state  of user information
  UserApp _user =
      UserApp(id: '1', email: 'email', username: 'username', api_token: '');
  UserApp get userInfo => _user;
  void setUser(UserApp user) {
    _user = user;
    notifyListeners();
  }

  void logout() {
    _user = UserApp(
        id: '1',
        email: 'email',
        username: 'username',
        api_token: ''); // api token is empty
    notifyListeners();
  }

  bool get isAuthorized {
    return _user.api_token.isNotEmpty;
  }
}
