import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';
import 'package:shopify_app/modules/http_Exeptions.dart';

class Auth with ChangeNotifier {
  late String _token;
   DateTime? _expiryDates;
  late String _userId;

  // Future<void> authenticate(
  //     String email, String password, String segmentUrl) async {
  //   final url = Uri.parse('https://identitytoolkit.googleapis.com/v1/accounts:$segmentUrl?key=AIzaSyDjbCGvavmZ3rO3t9ZcU8_xx1k49LDe5LE');
  //   try {
  //     final response = await http.post(url,
  //         body: json.encode({
  //           "email": email,
  //           "password": password,
  //           "returnSecureToken": true
  //         }));
  //     final responseData =
  //     json.decode(response.body) as Map<String,dynamic>;
  //     print(responseData);
  //     // if (responseData['error'] != null) {
  //     //   throw httpExeption(message: responseData["error"]["message"]);}
  //     // print("Response is" + response.body.toString() + "\nfgfdgfdgdf" + response.request.toString());
  //   }  catch (error) {
  //     print(error);
  //     throw error;
  //   }
  //   // if (response.statusCode == 200) {
  //   //   print(json.decode(response.body));
  //   // } else {
  //   //   print(responseData.statusCode);
  //   // }
  //   notifyListeners();
  // }

  bool get isAuth {
    return token != null;
  }

  String get token {
    if (_expiryDates != null &&
        _expiryDates!.isAfter(DateTime.now()) &&
        _token != null) {
      return _token;
    } else{
      return ' ';
    }
  }

  String get auth_userId {
    return _userId;
  }

  Future<void> signup(String email, String password) async {
    final url = Uri.parse(
        "https://identitytoolkit.googleapis.com/v1/accounts:signUp?key=AIzaSyDjbCGvavmZ3rO3t9ZcU8_xx1k49LDe5LE");
    try {
      final response = await http.post(url,
          body: json.encode({
            "email": email,
            "password": password,
            "returnSecureToken": true
          }));
      final responseBody = json.decode(response.body);
      print(responseBody);
      if (responseBody["error"] != null) {
        throw httpExeption(responseBody["error"]["message"]);
      }
      _token = responseBody["idToken"];
      _userId = responseBody["localId"];
      _expiryDates = DateTime.now()
          .add(Duration(seconds: int.parse(responseBody["expiresIn"])));
      notifyListeners();
    } on httpExeption catch (error) {
      print(error);
      throw error;
    }
  }

  Future<void> signin(String email, String password) async {
    final url = Uri.parse(
        "https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key=AIzaSyDjbCGvavmZ3rO3t9ZcU8_xx1k49LDe5LE");
    try {
      final response = await http.post(url,
          body: json.encode({
            "email": email,
            "password": password,
            "returnSecureToken": true
          }),
          // headers: {
          //   'Content-type': 'application/json',
          //   'Accept': 'application/json',
          // }
          );
      final responseBody = json.decode(response.body);
      print(responseBody);
      if (responseBody["error"] != null) {
        throw httpExeption(responseBody["error"]["message"]);
      }
      _token = responseBody["idToken"];
      _userId = responseBody["localId"];
      _expiryDates = DateTime.now()
          .add(Duration(seconds: int.parse(responseBody["expiresIn"]!)));
      notifyListeners();
    } on httpExeption catch (error) {
      print(error);
      throw error;
    }
  }
}
