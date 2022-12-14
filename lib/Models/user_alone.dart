class UserAlone {
  bool? success;
  Data? data;
  String? message;

  UserAlone({this.success, this.data, this.message});

  UserAlone.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['success'] = success;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    data['message'] = message;
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
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['firstname'] = firstname;
    data['secondname'] = secondname;
    data['company_id'] = companyId;
    data['actived'] = actived;
    data['email'] = email;
    data['type'] = type;
    data['email_confirmed'] = emailConfirmed;
    data['deleted'] = deleted;
    data['iscontact'] = iscontact;
    data['company'] = company;
    data['created_at'] = createdAt;
    return data;
  }
}