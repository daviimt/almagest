import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'package:http/http.dart' as http;

import '../Models/products.dart';

class ProductService extends ChangeNotifier {
  final String _baseUrl = 'semillero.allsites.es';
  final storage = const FlutterSecureStorage();
  final List<Data> products = [];
  bool isLoading = true;

  getProducts(String id) async {
    String? token = await storage.read(key: 'token') ?? '';
    isLoading = true;
    notifyListeners();
    final url =
        Uri.http(_baseUrl, '/public/api/products/company', {'company_id': id});
    final resp = await http.post(url, headers: {
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    });
    final Map<String, dynamic> decodedResp = json.decode(resp.body);
    var p = Products.fromJson(decodedResp);
    for (var i in p.data!) {
      if (i.deleted == 0) {
        products.add(i);
      }
    }
    isLoading = false;
    notifyListeners();
  }

  createProduct(
      String articleId, String companyId, String price, String familyId) async {
    String? token = await storage.read(key: 'token') ?? '';
    final Map<String, dynamic> authData = {
      'article_id': articleId,
      'company_id': companyId,
      'empriceail': price,
      'family_id': familyId,
    };

    final url = Uri.http(_baseUrl, '/public/api/products', {});

    final resp = await http.post(url,
        headers: {
          'Content-type': 'application/json',
          'Accept': 'application/json',
          "Authorization": "Some $token"
        },
        body: json.encode(authData));
    final Map<String, dynamic> decodedResp = json.decode(resp.body);

    if (decodedResp['success'] == true) {
      return decodedResp['message'];
    }
  }

  deleteProduct(String id) async {
    String? token = await storage.read(key: 'token') ?? '';

    final url = Uri.http(_baseUrl, '/public/api/products/$id');
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
