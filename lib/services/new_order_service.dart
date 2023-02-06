import 'dart:convert';
import 'package:almagest/Models/new_order.dart';
import 'package:almagest/services/auth_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:almagest/models/models.dart';
import 'dart:math';
import '../models/catalog.dart';
import 'services.dart';
import 'package:intl/intl.dart';

class NewOrderService extends ChangeNotifier {
  final String _baseUrl = 'semillero.allsites.es';
  bool isLoading = true;

  Future<String?> getNewOrder(String num, Map<String, String> pedido,
      DateTime fecha, String myCompany_id, String targetCompany_id) async {
    isLoading = true;
    notifyListeners();
    String datosPedido = "";
    final DateFormat formatter = DateFormat('yyyy-MM-dd');
    final String fechaFormat = formatter.format(fecha);
    int longitud = pedido.length;
    int cont = 0;
    pedido.forEach((key, value) {
      datosPedido += key + ',' + value;
      cont++;
      if (cont != longitud) {
        datosPedido += ',';
      }
    });
    final url = Uri.http(_baseUrl, '/public/api/orders');
    String? token = await AuthService().readToken();
    final Map<String, dynamic> catalogData = {
      'num': num,
      'issue_date': fechaFormat,
      'origin_company_id': myCompany_id,
      'target_company_id': targetCompany_id,
      'products': datosPedido
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
    var newOrder = NewOrder.fromJson(decodedResp);
    print(decodedResp);
    isLoading = false;
    notifyListeners();
    return null;
  }
}
