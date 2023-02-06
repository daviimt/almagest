import 'dart:convert';
import 'package:almagest/services/auth_service.dart';
import 'package:almagest/services/catalog_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:almagest/models/models.dart';
import 'services.dart';

class CatalogService2 extends ChangeNotifier {
  final String _baseUrl = 'semillero.allsites.es';
  bool isLoading = true;
  final List<CatalogData> catalogdata = [];
  List<CatalogData> catalogfilter = [];
  final List<CatalogData> aux = [];

  Future<List<CatalogData>> getCatalog(company_id) async {
    catalogdata.clear();
    aux.clear();
    isLoading = true;
    notifyListeners();
    final catalogService = CatalogService();
    await catalogService.getCatalog();
    catalogfilter = catalogService.catalogdata;

    final url = Uri.http(_baseUrl, '/public/api/products/company');
    String? token = await AuthService().readToken();
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
    for (int i = 0; i < catalogdata.length; i++) {
      for (int j = 0; j < catalogfilter.length; j++) {
        if (catalogdata[i].articleId == catalogfilter[j].articleId) {
          aux.add(catalogdata[i]);
        }
      }
    }
    isLoading = false;
    notifyListeners();
    return catalogdata;
  }
}
