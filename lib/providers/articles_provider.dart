import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'package:http/http.dart' as http;

import '../Models/articles.dart';
import '../services/auth_service.dart';

class ArticleService extends ChangeNotifier {
  final String _baseUrl = 'semillero.allsites.es';
  final storage = const FlutterSecureStorage();
  final List<ArticleData> articles = [];
  bool isLoading = true;

  ArticleService();

  getArticles() async {
    String? token = await AuthService().readToken();
    isLoading = true;
    notifyListeners();
    final url = Uri.http(_baseUrl, '/public/api/articles');
    final resp = await http.post(url, headers: {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    });
    final Map<String, dynamic> decodedResp = json.decode(resp.body);
    var p = Articles.fromJson(decodedResp);
    for (var i in p.data!) {
      if (i.deleted == 0) {
        articles.add(i);
      }
    }
    isLoading = false;
    notifyListeners();
    return articles;
  }

  getArticle(String id) async {
    String? token = await storage.read(key: 'token') ?? '';
    isLoading = true;
    notifyListeners();
    final url =
        Uri.http(_baseUrl, '/public/api/mostrarArt', {'article_id': id});
    final resp = await http.post(url, headers: {
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    });
    final Map<String, dynamic> decodedResp = json.decode(resp.body);
    var p = Articles.fromJson(decodedResp);
    for (var i in p.data!) {
      if (i.deleted == 0) {
        articles.add(i);
      }
    }
    isLoading = false;
    notifyListeners();
  }

  getArticleFamily(String id) async {
    isLoading = true;
    notifyListeners();
    final url = Uri.http(_baseUrl, '/public/api/mostrarArt');
    final resp = await http.post(url);
    final Map<String, dynamic> decodedResp = json.decode(resp.body);
    var p = Articles.fromJson(decodedResp);
    for (var i in p.data!) {
      if (i.deleted == 0) {
        articles.add(i);
      }
    }
    isLoading = false;
    notifyListeners();
  }
}
