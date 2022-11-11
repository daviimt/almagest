// To parse this JSON data, do
//
//     final cicles = ciclesFromMap(jsonString);

import 'dart:convert';

import 'ciclos.dart';

class cicles_Response {
  cicles_Response({
    required this.success,
    required this.data,
    required this.message,
  });

  bool success;
  List<Ciclos> data;
  String message;

  factory cicles_Response.fromJson(String str) =>
      cicles_Response.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory cicles_Response.fromMap(Map<String, dynamic> json) => cicles_Response(
        success: json["success"],
        data: List<Ciclos>.from(json["data"].map((x) => Ciclos.fromMap(x))),
        message: json["message"],
      );

  Map<String, dynamic> toMap() => {
        "success": success,
        "data": List<dynamic>.from(data.map((x) => x.toMap())),
        "message": message,
      };
}
