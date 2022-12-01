// To parse this JSON data, do
//
//     final cicles = ciclesFromMap(jsonString);

import 'dart:convert';

import 'package:almagest/Models/companies.dart';

class CompaniesResponse {
  CompaniesResponse({
    required this.success,
    required this.data,
    required this.message,
  });

  bool success;
  List<Companies> data;
  String message;

  List<Companies> get dataCompanies {
    return data;
  }

  factory CompaniesResponse.fromJson(String str) =>
      CompaniesResponse.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory CompaniesResponse.fromMap(Map<String, dynamic> json) =>
      CompaniesResponse(
        success: json["success"],
        data:
            List<Companies>.from(json["data"].map((x) => Companies.fromMap(x))),
        message: json["message"],
      );

  Map<String, dynamic> toMap() => {
        "success": success,
        "data": List<dynamic>.from(data.map((x) => x.toMap())),
        "message": message,
      };
}
