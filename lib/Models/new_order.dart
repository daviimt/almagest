class NewOrder {
  bool? success;
  DataNewOrder? data;
  String? message;

  NewOrder({this.success, this.data, this.message});

  NewOrder.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    data =
        json['data'] != null ? new DataNewOrder.fromJson(json['data']) : null;
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

class DataNewOrder {
  int? id;
  String? num;
  String? issueDate;

  DataNewOrder({this.id, this.num, this.issueDate});

  DataNewOrder.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    num = json['num'];
    issueDate = json['issue_date'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['num'] = this.num;
    data['issue_date'] = this.issueDate;
    return data;
  }
}
