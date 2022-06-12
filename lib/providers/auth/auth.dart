import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shop_app/config.dart';
import 'package:shop_app/keys.dart';
import 'package:shop_app/models/http_exception.dart';

enum AuthenticateMethod {
  Signup,
  Signin,
}

Uri baseAuthUrlSignUpWithWebApiToken =
    Uri.parse(baseAuthUrlSignUp.replaceAll('[API_KEY]', webApiToken));
Uri baseAuthUrlSignInWithWebApiToken =
    Uri.parse(baseAuthUrlSignIn.replaceAll('[API_KEY]', webApiToken));

class Auth with ChangeNotifier {
  String? _token;
  String? _userId;

  DateTime? _expiryDate;

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
    return _authenticate(email, password, AuthenticateMethod.Signup);
  }

  Future<void> _authenticate(
    String email,
    String password,
    AuthenticateMethod method,
  ) async {
    try {
      final url = method == AuthenticateMethod.Signin
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

      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> signIn(String email, String password) async {
    return _authenticate(email, password, AuthenticateMethod.Signin);
  }
}
