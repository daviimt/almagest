// ignore_for_file: body_might_complete_normally_nullable
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'auth_service.dart';

class VerifyService extends ChangeNotifier {
  final String _baseUrl = 'semillero.allsites.es';

  final storage = const FlutterSecureStorage();

  Future<String?> isVerify(id) async {
    final url = Uri.http(_baseUrl, '/public/api/confirm', {'user_id': id});
    String? token = await AuthService().readToken();
    // ignore: unused_local_variable
    final resp = await http.post(
      url,
      headers: {'Accept': 'application/json', "Authorization": "Bearer $token"},
    );
  }

  static void verifyService(id) {}
}
