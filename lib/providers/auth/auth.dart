import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shop_app/config.dart';
import 'package:shop_app/keys.dart';
import 'package:shop_app/models/http_exception.dart';

enum AuthenticateMethod {
  signup,
  login,
}

Uri baseAuthUrlSignUpWithWebApiToken =
    Uri.parse(baseAuthUrlSignUp.replaceAll('[API_KEY]', webApiToken));
Uri baseAuthUrlSignInWithWebApiToken =
    Uri.parse(baseAuthUrlSignIn.replaceAll('[API_KEY]', webApiToken));

class Auth with ChangeNotifier {
  String? _token;
  String? _userId;

  DateTime? _expiryDate;

  Timer? _authTimer;

  bool get isAuth {
    return _token != null;
  }

  String? get userId {
    return _userId;
  }

  String? get token {
    if (_expiryDate == null) {
      return null;
    }

    if (_expiryDate != null &&
        _expiryDate!.isAfter(DateTime.now()) &&
        _token != null) {
      return _token;
    }

    return null;
  }

  Future<void> signUp(String email, String password) async {
    return _authenticate(email, password, AuthenticateMethod.signup);
  }

  Future<void> _authenticate(
    String email,
    String password,
    AuthenticateMethod method,
  ) async {
    try {
      final url = method == AuthenticateMethod.login
          ? baseAuthUrlSignInWithWebApiToken
          : baseAuthUrlSignUpWithWebApiToken;

      final response = await http.post(
        url,
        body: json.encode({
          'email': email,
          'password': password,
          'returnSecureToken': true,
        }),
      );

      final responseData = json.decode(response.body);
      if (responseData['error'] != null) {
        throw HttpException(responseData['error']['message']);
      }

      _token = responseData['idToken'];
      _userId = responseData['localId'];
      _expiryDate = DateTime.now().add(
        Duration(
          seconds: int.parse(responseData['expiresIn']),
        ),
      );

      _autoLogout();

      notifyListeners();

      final prefs = await SharedPreferences.getInstance();
      final userData = json.encode({
        'token': _token,
        'userId': _userId,
        'expiryDate': _expiryDate!.toIso8601String(),
      });

      prefs.setString('userData', userData);
    } catch (error) {
      rethrow;
    }
  }

  Future<void> signIn(String email, String password) async {
    return _authenticate(email, password, AuthenticateMethod.login);
  }

  Future<void> signOut() async {
    _token = null;
    _userId = null;
    _expiryDate = null;

    if (_authTimer != null) {
      _authTimer!.cancel();
      _authTimer = null;
    }

    notifyListeners();

    final prefs = await SharedPreferences.getInstance();
    prefs.clear();
  }

  void _autoLogout() {
    if (_authTimer != null) {
      _authTimer!.cancel();
    }

    final timeToExpiry = _expiryDate!.difference(DateTime.now()).inSeconds;

    _authTimer = Timer(Duration(seconds: timeToExpiry), signOut);
  }

  Future<bool> tryAutoSignIn() async {
    final prefs = await SharedPreferences.getInstance();

    if (!prefs.containsKey('userData')) {
      return false;
    }

    final extractedUserData = json
        .decode(prefs.getString('userData').toString()) as Map<String, dynamic>;
    final expiryDate =
        DateTime.parse(extractedUserData['expiryDate'].toString());

    if (expiryDate.isBefore(DateTime.now())) {
      return false;
    }

    _token = extractedUserData['token'].toString();
    _userId = extractedUserData['userId'].toString();

    _expiryDate = expiryDate;

    notifyListeners();
    _autoLogout();

    return true;
  }
}
