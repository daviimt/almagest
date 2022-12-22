class UserAlone {
  int? id;
  String? firstname;
  String? secondname;
  String? email;
  int? companyId;
  String? type;
  int? emailConfirmed;
  int? actived;
  String? code;
  int? iscontact;
  int? deleted;
  String? createdAt;
  String? updatedAt;

  UserAlone(
      {this.id,
      this.firstname,
      this.secondname,
      this.email,
      this.companyId,
      this.type,
      this.emailConfirmed,
      this.actived,
      this.code,
      this.iscontact,
      this.deleted,
      this.createdAt,
      this.updatedAt});

  UserAlone.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    firstname = json['firstname'];
    secondname = json['secondname'];
    email = json['email'];
    companyId = json['company_id'];
    type = json['type'];
    emailConfirmed = json['email_confirmed'];
    actived = json['actived'];
    code = json['code'];
    iscontact = json['iscontact'];
    deleted = json['deleted'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['firstname'] = firstname;
    data['secondname'] = secondname;
    data['email'] = email;
    data['company_id'] = companyId;
    data['type'] = type;
    data['email_confirmed'] = emailConfirmed;
    data['actived'] = actived;
    data['code'] = code;
    data['iscontact'] = iscontact;
    data['deleted'] = deleted;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}
