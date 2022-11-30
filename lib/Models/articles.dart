class Articles {
  bool? success;
  List<Data>? data;
  String? message;

  Articles({this.success, this.data, this.message});

  Articles.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(new Data.fromJson(v));
      });
    }
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    data['message'] = this.message;
    return data;
  }
}

class Data {
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

  Data(
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

  Data.fromJson(Map<String, dynamic> json) {
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
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['description'] = this.description;
    data['price_min'] = this.priceMin;
    data['price_max'] = this.priceMax;
    data['color_name'] = this.colorName;
    data['weight'] = this.weight;
    data['size'] = this.size;
    data['family_id'] = this.familyId;
    data['deleted'] = this.deleted;
    return data;
  }
}
