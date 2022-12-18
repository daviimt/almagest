class Users {
  bool? success;
  List<UserData>? data;
  String? message;

  Users({this.success, this.data, this.message});

  Users.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    if (json['data'] != null) {
      data = <UserData>[];
      json['data'].forEach((v) {
        data!.add(UserData.fromJson(v));
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

class UserData {
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

  UserData(
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

  UserData.fromJson(Map<String, dynamic> json) {
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
