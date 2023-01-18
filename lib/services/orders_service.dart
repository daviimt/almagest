import 'dart:convert';

import 'package:almagest/Models/models.dart';
import 'package:almagest/services/user_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'package:http/http.dart' as http;

import '../Models/products.dart';
import 'auth_service.dart';

class OrdersService extends ChangeNotifier {
  final String _baseUrl = 'semillero.allsites.es';
  final storage = const FlutterSecureStorage();
  final List<OrdersData> orders = [];
  bool isLoading = true;

  getOrders() async {
    // String? token = await storage.read(key: 'token') ?? '';
    String? token = await AuthService().readToken();

    isLoading = true;
    notifyListeners();
    final url = Uri.http(_baseUrl, '/public/api/orders', {});
    final resp = await http.post(
      url,
      headers: {
        'Content-type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    final Map<String, dynamic> decodedResp = json.decode(resp.body);
    var p = Orders.fromJson(decodedResp);
    for (var i in p.data!) {
      orders.add(i);
    }
    isLoading = false;
    notifyListeners();
    return orders;
  }
}
