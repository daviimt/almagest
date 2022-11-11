import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'package:http/http.dart' as http;
import 'package:productos_app/Models/cicles_response.dart';
import 'package:productos_app/Models/ciclos.dart';

class AuthService extends ChangeNotifier {
  final String _baseUrl = 'http://salesin.allsites.es/public/api/register';
  final String _firebaseToken = 'AIzaSyBcytoCbDUARrX8eHpcR-Bdrdq0yUmSjf8';

  final storage = new FlutterSecureStorage();

  // Si retornamos algo, es un error, si no, todo bien!
  Future<String?> createUser(
      String name, String surname, String email, String password) async {
    final Map<String, dynamic> authData = {
      'name': name,
      'surname': surname,
      'email': email,
      'password': password,
      'returnSecureToken': true
    };
    print(authData.toString());

    final url = Uri.parse(_baseUrl);

    // final resp = await http.post(url, body: json.encode(authData));
    // final Map<String, dynamic> decodedResp = json.decode(resp.body);

    // if (decodedResp.containsKey('idToken')) {
    //   // Token hay que guardarlo en un lugar seguro
    //   await storage.write(key: 'token', value: decodedResp['idToken']);
    //   // decodedResp['idToken'];
    //   return null;
    // } else {
    //   return decodedResp['error']['message'];
    // }
  }

  Future<String?> login(String email, String password) async {
    final Map<String, dynamic> authData = {
      'email': email,
      'password': password,
      'returnSecureToken': true
    };

    final url = Uri.https(
        _baseUrl, '/v1/accounts:signInWithPassword', {'key': _firebaseToken});

    final resp = await http.post(url, body: json.encode(authData));
    final Map<String, dynamic> decodedResp = json.decode(resp.body);

    if (decodedResp.containsKey('idToken')) {
      // Token hay que guardarlo en un lugar seguro
      // decodedResp['idToken'];
      await storage.write(key: 'token', value: decodedResp['idToken']);
      return null;
    } else {
      return decodedResp['error']['message'];
    }
  }

  Future logout() async {
    await storage.delete(key: 'token');
    return;
  }

  Future<String> readToken() async {
    return await storage.read(key: 'token') ?? '';
  }
}

class GetCicles extends ChangeNotifier {
  String _baseUrl = 'salesin.allsites.es';

  List<Ciclos> getAllCiclos = [];

  GetCicles() {
    print('Inicializando');

    this.getCiclesName();
  }

  getCiclesName() async {
    print('INCICLES');
    var url = Uri.http(_baseUrl, '/public/api/cicles');

    final response = await http.get(url);
    final ciclesResponse = cicles_Response.fromJson(response.body);

    // print(ciclesResponse.data[1].name);
    getAllCiclos = ciclesResponse.data;
    notifyListeners();
  }
}
