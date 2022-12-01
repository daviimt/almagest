import 'dart:convert';

import 'package:almagest/services/services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'package:http/http.dart' as http;
import 'package:almagest/Models/models.dart';

class AuthService extends ChangeNotifier {
  final String _baseUrl = 'semillero.allsites.es';
  final storage = const FlutterSecureStorage();

  // Si retornamos algo, es un error, si no, todo bien!
  Future<String?> createUser(
    String name,
    String surname,
    String email,
    String password,
    String cpassword,
    int cicleid,
    /*int courseId*/
  ) async {
    final Map<String, dynamic> authData = {
      'firstname': name,
      'secondname': surname,
      'email': email,
      'password': password,
      'c_password': cpassword,
      'company_id': cicleid,
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

    if (resp.statusCode == 200) {
      //Or put here your next screen using Navigator.push() method
      print('success');
      String id = decodedResp['data']['id'].toString();

      VerifyService().isVerify(id);
    } else {
      print('error');
    }
    if (decodedResp['success'] == true) {
      // Token hay que guardarlo en un lugar seguro
      // decodedResp['idToken'];
      await storage.write(key: 'token', value: decodedResp['data']['token']);
      await storage.write(
          key: 'name', value: decodedResp['data']['name'].toString());
    } else {
      return decodedResp['message'];
    }
    return null;
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
  final String _baseUrl = 'semillero.allsites.es';
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

class GetCompanies extends ChangeNotifier {
  final String _baseUrl = 'semillero.allsites.es';

  List<Companies> getAllCompanies = [];

  GetCompanies() {
    print('Inicializando');

    getCompaniesName();
  }

  getCompaniesName() async {
    print('INCOMPANIES');
    var url = Uri.http(_baseUrl, '/public/api/companies');

    final response = await http.get(url);
    final companies_Response = CompaniesResponse.fromJson(response.body);

    getAllCompanies = companies_Response.data;
    notifyListeners();
  }
}
