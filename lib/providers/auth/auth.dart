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
    } catch (error) {
      throw error;
    }
  }

  Future<void> signIn(String email, String password) async {
    return _authenticate(email, password, AuthenticateMethod.Signin);
  }
}
