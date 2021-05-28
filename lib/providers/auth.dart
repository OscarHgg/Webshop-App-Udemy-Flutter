import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttershopudemy/models/http_exception.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class Auth with ChangeNotifier {
  //no finals, many auths
  String _token;
  DateTime _expDate;
  String _userId;
  Timer _authTimer;

  bool get isAuth {
    //check token with get below
    return token != null;
  }

  String get token {
    if (_expDate != null &&
        _expDate.isAfter(DateTime.now()) &&
        _token != null) {
      return _token;
    }
    return null;
  }

  String get userId {
    return _userId;
  }

  Future<void> _authenticate(
      String email, String password, String urlSegment) async {
    final url =
        'https://identitytoolkit.googleapis.com/v1/accounts:$urlSegment?key=AIzaSyAmP0AwdOi10dEerYALdS9i2SXeHfoqXNs';
    try {
      final response = await http.post(
        Uri.parse(url),
        body: json.encode({
          'email': email,
          'password': password,
          'returnSecureToken': true,
        }),
      );
      final responseData = json.decode(response.body);
      if (responseData['error'] != null) {
        //there is problem
        throw HttpException(responseData['error']['message']);
      }
      //success
      _token = responseData['idToken'];
      _userId = responseData['localId'];
      _expDate = DateTime.now().add(Duration(
        seconds: int.parse(responseData['expiresIn']),
      ));
      _autoLogout();
      //send token
      notifyListeners();

      //store login data on device via shared preferences
      //preference access
      final prefs = await SharedPreferences.getInstance();

      //set value, use json.encode for larger things
      final userData = json.encode({
        'token': _token,
        'userId': _userId,
        'expDate': _expDate.toIso8601String()
      });
      prefs.setString('userData', userData);
    } catch (error) {
      throw error;
    }
  }

  Future<void> signup(String email, String password) async {
    return _authenticate(email, password, 'signUp');
  }

  Future<void> login(String email, String password) async {
    return _authenticate(email, password, 'signInWithPassword');
  }

  //try autologin
  Future<bool> tryAutoLogin() async {
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('userData')) {
      return false;
    }
    final extractedUserData =
        json.decode(prefs.getString('userData')) as Map<String, Object>;
    final expiryDate = DateTime.parse(extractedUserData['expDate']);

    //is expired?
    if (expiryDate.isAfter(DateTime.now())) {
      return false;
    }

    _token = extractedUserData['token'];
    _userId = extractedUserData['userId'];
    _expDate = expiryDate;
    notifyListeners();
    _autoLogout();
    return true;
  }

  Future<void> logout() async {
    _token = null;
    _userId = null;
    _expDate = null;
    if (_authTimer != null) {
      _authTimer.cancel();
      _authTimer = null;
    }
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    //prefs.remove('userData');

    //purge all
    prefs.clear();
  }

  void _autoLogout() {
    if (_authTimer != null) {
      _authTimer.cancel();
    }
    final timeLeft = _expDate.difference(DateTime.now()).inSeconds;
    _authTimer = Timer(Duration(seconds: timeLeft), logout);
  }
}
