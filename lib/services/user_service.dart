import 'dart:convert';

import 'package:almagest/services/services.dart';
import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'package:almagest/Models/models.dart';

class UserService extends ChangeNotifier {
  final String _baseUrl = 'semillero.allsites.es';
  bool isLoading = true;
  final List<Data> usuarios = [];

  UserService() {}

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
