import 'dart:convert';

import 'package:almagest/Models/models.dart';
import 'package:almagest/services/user_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'package:http/http.dart' as http;

import '../Models/family.dart';
import '../Models/products.dart';
import 'auth_service.dart';

class FamilyService extends ChangeNotifier {
  final String _baseUrl = 'semillero.allsites.es';
  final storage = const FlutterSecureStorage();
  final List<FamilyData> family = [];
  bool isLoading = true;

  FamilyService() {
    getFamilies();
  }
  getFamilies() async {
    // String? token = await storage.read(key: 'token') ?? '';
    String? token = await AuthService().readToken();

    isLoading = true;
    notifyListeners();
    final url = Uri.http(_baseUrl, '/public/api/families', {});
    final resp = await http.get(
      url,
      headers: {
        'Content-type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    final Map<String, dynamic> decodedResp = json.decode(resp.body);
    var p = Family.fromJson(decodedResp);
    for (var i in p.data!) {
      family.add(i);
    }
    isLoading = false;
    notifyListeners();
    return family;
  }
}
