import 'dart:convert';

import 'package:http/http.dart' as http;

import 'package:products/user_preferences/user_preferences.dart';

class UserProvider {
  final String _firebaseKey = 'AIzaSyDts-hp1AczAcKb6LcyuGtusA0q6_l5Tu8';
  final _prefs = new UserPreferences();

  Future<Map<String, dynamic>> newUser(String email, String password) async {
    // What will be sent in the body
    final authData = {
      'email': email,
      'password': password,
      'returnSecureToken': true,
    };

    // POST method
    final resp = await http.post(
      Uri.parse(
          'https://securetoken.googleapis.com/v1/token?key=$_firebaseKey'),
      body: json.encode(authData),
    );

    // Decoded response
    Map<String, dynamic> decodedResp = json.decode(resp.body);

    // If successful
    if (decodedResp.containsKey('idToken')) {
      _prefs.token = decodedResp['idToken'];

      return {
        'ok': true,
        'token': decodedResp['idToken'],
      };
    }

    // If there's an error
    else {
      return {
        'ok': false,
        'message': decodedResp['error']['message'],
      };
    }
  }

  Future<Map<String, dynamic>> login(String email, String password) async {
    // What will be sent in the body
    final authData = {
      'email': email,
      'password': password,
      'returnSecureToken': true,
    };

    // POST method
    final resp = await http.post(
      Uri.parse(
          'https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key=$_firebaseKey'),
      body: json.encode(authData),
    );

    // Decoded response
    Map<String, dynamic> decodedResp = json.decode(resp.body);

    // If successful
    if (decodedResp.containsKey('idToken')) {
      _prefs.token = decodedResp['idToken'];

      return {
        'ok': true,
        'token': decodedResp['idToken'],
      };
    }

    // If there's an error
    else {
      return {
        'ok': false,
        'message': decodedResp['error']['message'],
      };
    }
  }
}
