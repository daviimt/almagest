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
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['firstname'] = this.firstname;
    data['secondname'] = this.secondname;
    data['email'] = this.email;
    data['company_id'] = this.companyId;
    data['type'] = this.type;
    data['email_confirmed'] = this.emailConfirmed;
    data['actived'] = this.actived;
    data['code'] = this.code;
    data['iscontact'] = this.iscontact;
    data['deleted'] = this.deleted;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}
