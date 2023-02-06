class Cicles {
  bool? success;
  List<Data>? data;
  String? message;

  Cicles({this.success, this.data, this.message});

  Cicles.fromJson(Map<String, dynamic> json) {
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
  String? address;
  String? city;
  String? cif;
  String? email;
  String? phone;
  String? delTermId;
  int? transportId;
  String? paymentTermId;
  String? discountId;

  Data(
      {this.id,
      this.name,
      this.address,
      this.city,
      this.cif,
      this.email,
      this.phone,
      this.delTermId,
      this.transportId,
      this.paymentTermId,
      this.discountId});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    address = json['address'];
    city = json['city'];
    cif = json['cif'];
    email = json['email'];
    phone = json['phone'];
    delTermId = json['del_term_id'];
    transportId = json['transport_id'];
    paymentTermId = json['payment_term_id'];
    discountId = json['discount_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['address'] = this.address;
    data['city'] = this.city;
    data['cif'] = this.cif;
    data['email'] = this.email;
    data['phone'] = this.phone;
    data['del_term_id'] = this.delTermId;
    data['transport_id'] = this.transportId;
    data['payment_term_id'] = this.paymentTermId;
    data['discount_id'] = this.discountId;
    return data;
  }
}
