import 'dart:convert';

class Ciclos {
  Ciclos({
    required this.id,
    required this.name,
    required this.img,
  });

  int id;
  String name;
  String img;

  String get nameCicle {
    return name;
  }

  int get idCicle {
    return id;
  }

  factory Ciclos.fromJson(String str) => Ciclos.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Ciclos.fromMap(Map<String, dynamic> json) => Ciclos(
        id: json["id"],
        name: json["name"],
        img: json["img"],
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "name": name,
        "img": img,
      };
}
