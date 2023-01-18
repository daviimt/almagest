class Family {
  bool? success;
  List<FamilyData>? data;
  String? message;

  Family({this.success, this.data, this.message});

  Family.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    if (json['data'] != null) {
      data = <FamilyData>[];
      json['data'].forEach((v) {
        data!.add(new FamilyData.fromJson(v));
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

class FamilyData {
  int? id;
  String? name;
  String? profitMargin;
  int? deleted;

  FamilyData({this.id, this.name, this.profitMargin, this.deleted});

  FamilyData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    profitMargin = json['profit_margin'];
    deleted = json['deleted'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['profit_margin'] = this.profitMargin;
    data['deleted'] = this.deleted;
    return data;
  }
}
