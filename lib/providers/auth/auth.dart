import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shop_app/config.dart';
import 'package:shop_app/keys.dart';

Uri baseAuthUrlWithWebApiToken =
    Uri.parse(baseAuthUrl.replaceAll('[API_KEY]', webApiToken));

class Auth with ChangeNotifier {
  String? _token;
  String? _userId;

  DateTime? _expiryDate;

  Future<void> signUp(String email, String password) async {
    try {
      final response = await http.post(
        baseAuthUrlWithWebApiToken,
        body: json.encode({
          'email': email,
          'password': password,
          'returnSecureToken': true,
        }),
      );
      print(json.decode(response.body));
    } catch (error) {
      throw error;
    }
  }
}
