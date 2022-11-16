import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'package:http/http.dart' as http;
import 'package:almagest/Models/models.dart';

class AuthService extends ChangeNotifier {
  final String _baseUrl = 'salesin.allsites.es';

  final storage = new FlutterSecureStorage();

  // Si retornamos algo, es un error, si no, todo bien!
  Future<String?> createUser(
    String name,
    String surname,
    String email,
    String password,
    String c_password,
    int cicle_id,
    /*int courseId*/
  ) async {
    final Map<String, dynamic> authData = {
      'name': name,
      'surname': surname,
      'email': email,
      'password': password,
      'c_password': c_password,
      'cicle_id': cicle_id,
    };
    print(authData.toString());

    final url = Uri.http(_baseUrl, '/public/api/register', {});

    final resp = await http.post(url,
        headers: {
          'Content-type': 'application/json',
          'Accept': 'application/json',
          "Authorization": "Some token"
        },
        body: json.encode(authData));
    final Map<String, dynamic> decodedResp = json.decode(resp.body);

    if (decodedResp['success'] == true) {
      // Token hay que guardarlo en un lugar seguro
      // decodedResp['idToken'];
      await storage.write(key: 'token', value: decodedResp['data']['token']);
      await storage.write(
          key: 'name', value: decodedResp['data']['name'].toString());
    } else {
      return decodedResp['message'];
    }

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
      // 'returnSecureToken': true
    };

    final url = Uri.http(_baseUrl, '/public/api/login', {});

    final resp = await http.post(url,
        headers: {
          'Content-type': 'application/json',
          'Accept': 'application/json',
          "Authorization": "Some toke"
        },
        body: json.encode(authData));

    final Map<String, dynamic> decodedResp = json.decode(resp.body);

    if (decodedResp['success'] == true) {
      // Token hay que guardarlo en un lugar seguro
      // decodedResp['idToken'];
      await storage.write(key: 'token', value: decodedResp['data']['token']);
      await storage.write(
          key: 'id', value: decodedResp['data']['id'].toString());
      return decodedResp['data']['type'] +
          ',' +
          decodedResp['data']['actived'].toString();
    } else {
      return decodedResp['message'];
    }
  }

  Future logout() async {
    await storage.delete(key: 'token');
    return;
  }

  Future<String> readToken() async {
    return await storage.read(key: 'token') as String;
  }
}

class UserService extends ChangeNotifier {
  final String _baseUrl = 'salesin.allsites.es';
  bool isLoading = true;
  final List<Data> usuarios = [];

  UserService() {
    getUsers();
  }

  Future<List<Data>> getUsers() async {
    final url = Uri.http(_baseUrl, '/public/api/users');
    String? token = await AuthService().readToken();
    isLoading = true;
    notifyListeners();
    final resp = await http.get(
      url,
      headers: {
        'Content-type': 'application/json',
        'Accept': 'application/json',
        "Authorization": "Bearer $token"
      },
    );
    final Map<String, dynamic> decodedResp = json.decode(resp.body);
    var user = Users.fromJson(decodedResp);
    for (var i in user.data!) {
      if (i.deleted == 0) {
        usuarios.add(i);
      }
    }
    isLoading = false;
    notifyListeners();
    return usuarios;
  }

  Future postActivate(String id) async {
    final url = Uri.http(_baseUrl, '/public/api/activate', {'user_id': id});
    String? token = await AuthService().readToken();
    isLoading = true;
    notifyListeners();
    // ignore: unused_local_variable
    final resp = await http.post(
      url,
      headers: {
        'Content-type': 'application/json',
        'Accept': 'application/json',
        "Authorization": "Bearer $token"
      },
    );
  }

  Future postDeactivate(String id) async {
    final url = Uri.http(_baseUrl, '/public/api/deactivate', {'user_id': id});
    String? token = await AuthService().readToken();
    isLoading = true;
    notifyListeners();
    // ignore: unused_local_variable
    final resp = await http.post(
      url,
      headers: {
        'Content-type': 'application/json',
        'Accept': 'application/json',
        "Authorization": "Bearer $token"
      },
    );
  }

  Future postDelete(String id) async {
    final url = Uri.http(_baseUrl, '/public/api/delete', {'user_id': id});
    String? token = await AuthService().readToken();
    isLoading = true;
    notifyListeners();
    // ignore: unused_local_variable
    final resp = await http.post(
      url,
      headers: {
        'Content-type': 'application/json',
        'Accept': 'application/json',
        "Authorization": "Bearer $token"
      },
    );
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
