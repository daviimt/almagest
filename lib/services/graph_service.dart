import 'dart:convert';

import 'package:almagest/Models/models.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'auth_service.dart';

class GraphService extends ChangeNotifier {
  final String _baseUrl = 'semillero.allsites.es';
  bool isLoading = true;
  final List<DataGraphs> listaSinSentido = [];

  Future<List<DataGraphs>> getGraphs() async {
    listaSinSentido.clear();
    isLoading = true;
    notifyListeners();
    final url = Uri.http(_baseUrl, '/public/api/orders/company');
    String? token = await AuthService().readToken();
    String? company_id = await userAlone().readCompany_id();
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
    var catalog = Graphs.fromJson(decodedResp);
    for (var i in catalog.data!) {
      listaSinSentido.add(i);
    }
    isLoading = false;
    notifyListeners();
    return listaSinSentido;
  }
}
