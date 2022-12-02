// ignore_for_file: non_constant_identifier_names

import 'dart:convert';

// ignore: implementation_imports
import 'package:flutter/src/material/dropdown.dart';

class Companies {
  Companies({
    required this.id,
    required this.name,
    required this.address,
    required this.city,
    required this.cif,
    required this.email,
    required this.phone,
    required this.del_term_id,
    required this.transport_id,
    required this.payment_term_id,
    required this.discount_id,
  });

  int id;
  String name;
  String address;
  String city;
  String cif;
  String email;
  String phone;
  String del_term_id;
  int transport_id;
  String payment_term_id;
  String discount_id;

  String get nameCompanie {
    return name;
  }

  int get idCompanie {
    return id;
  }

  factory Companies.fromJson(String str) => Companies.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Companies.fromMap(Map<String, dynamic> json) => Companies(
        id: json["id"],
        name: json["name"],
        address: json["address"],
        city: json["city"],
        cif: json["cif"],
        email: json["email"],
        phone: json["phone"],
        del_term_id: json["del_term_id"],
        transport_id: json["transport_id"],
        payment_term_id: json["payment_term_id"],
        discount_id: json["discount_id"],
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "name": name,
        "address": address,
        "city": city,
        "cif": cif,
        "email": email,
        "phone": phone,
        "del_term_id": del_term_id,
        "transport_id": transport_id,
        "payment_term_id": payment_term_id,
        "discount_id": discount_id,
      };

  map(DropdownMenuItem<Object> Function(dynamic courseName) param0) {}
}
