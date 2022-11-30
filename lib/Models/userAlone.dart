class UserAlone {
  bool? success;
  Data? data;
  String? message;

  UserAlone({this.success, this.data, this.message});

  UserAlone.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    data['message'] = this.message;
    return data;
  }
}

class Data {
  int? id;
  String? firstname;
  String? secondname;
  int? companyId;
  int? actived;
  String? email;
  String? type;
  int? emailConfirmed;
  int? deleted;
  int? iscontact;
  String? company;
  String? createdAt;

  Data(
      {this.id,
      this.firstname,
      this.secondname,
      this.companyId,
      this.actived,
      this.email,
      this.type,
      this.emailConfirmed,
      this.deleted,
      this.iscontact,
      this.company,
      this.createdAt});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    firstname = json['firstname'];
    secondname = json['secondname'];
    companyId = json['company_id'];
    actived = json['actived'];
    email = json['email'];
    type = json['type'];
    emailConfirmed = json['email_confirmed'];
    deleted = json['deleted'];
    iscontact = json['iscontact'];
    company = json['company'];
    createdAt = json['created_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['firstname'] = this.firstname;
    data['secondname'] = this.secondname;
    data['company_id'] = this.companyId;
    data['actived'] = this.actived;
    data['email'] = this.email;
    data['type'] = this.type;
    data['email_confirmed'] = this.emailConfirmed;
    data['deleted'] = this.deleted;
    data['iscontact'] = this.iscontact;
    data['company'] = this.company;
    data['created_at'] = this.createdAt;
    return data;
  }
}
