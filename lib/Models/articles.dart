import 'package:almagest/Models/models.dart';

class Articles {
  bool? success;
  List<DataArticle>? data;
  String? message;

  Articles({this.success, this.data, this.message});

  Articles.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    if (json['data'] != null) {
      data = <DataArticle>[];
      json['data'].forEach((v) {
        data!.add(DataArticle.fromJson(v));
      });
    }
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['success'] = success;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    data['message'] = message;
    return data;
  }
}

class DataArticle {
  int? id;
  String? name;
  String? description;
  String? priceMin;
  String? priceMax;
  String? colorName;
  String? weight;
  String? size;
  int? familyId;
  int? deleted;

  DataArticle(
      {this.id,
      this.name,
      this.description,
      this.priceMin,
      this.priceMax,
      this.colorName,
      this.weight,
      this.size,
      this.familyId,
      this.deleted});

  DataArticle.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    description = json['description'];
    priceMin = json['price_min'];
    priceMax = json['price_max'];
    colorName = json['color_name'];
    weight = json['weight'];
    size = json['size'];
    familyId = json['family_id'];
    deleted = json['deleted'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['description'] = description;
    data['price_min'] = priceMin;
    data['price_max'] = priceMax;
    data['color_name'] = colorName;
    data['weight'] = weight;
    data['size'] = size;
    data['family_id'] = familyId;
    data['deleted'] = deleted;
    return data;
  }
}
