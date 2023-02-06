import 'dart:convert';
import 'package:almagest/services/auth_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:almagest/models/models.dart';

import 'services.dart';

class CatalogService extends ChangeNotifier {
  final String _baseUrl = 'semillero.allsites.es';
  bool isLoading = true;
  final List<CatalogData> catalogdata = [];

  Future<List<CatalogData>> getCatalog() async {
    catalogdata.clear();
    isLoading = true;
    notifyListeners();
    final url = Uri.http(_baseUrl, '/public/api/products/company');
    String? token = await AuthService().readToken();
    String? company_id = await UserService().readCompany_id();
    final Map<String, dynamic> catalogData = {
      'id': company_id,
    };

    final resp = await http.post(
      url,
      headers: {
        'Content-type': 'application/json',
        'Accept': 'application/json',
        "Authorization": "Bearer $token"
      },
      body: json.encode(catalogData),
    );
    final Map<String, dynamic> decodedResp = json.decode(resp.body);
    var catalog = Catalog.fromJson(decodedResp);
    for (var i in catalog.data!) {
      catalogdata.add(i);
    }
    isLoading = false;
    notifyListeners();
    return catalogdata;
  }
}
