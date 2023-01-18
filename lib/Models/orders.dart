class Orders {
  bool? success;
  List<OrdersData>? data;
  String? message;

  Orders({this.success, this.data, this.message});

  Orders.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    if (json['data'] != null) {
      data = <OrdersData>[];
      json['data'].forEach((v) {
        data!.add(new OrdersData.fromJson(v));
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

class OrdersData {
  int? id;
  String? num;
  String? issueDate;
  String? targetCompanyName;
  String? createdAt;
  int? deliveryNotes;
  int? invoices;

  OrdersData(
      {this.id,
      this.num,
      this.issueDate,
      this.targetCompanyName,
      this.createdAt,
      this.deliveryNotes,
      this.invoices});

  OrdersData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    num = json['num'];
    issueDate = json['issue_date'];
    targetCompanyName = json['target_company_name'];
    createdAt = json['created_at'];
    deliveryNotes = json['delivery_notes'];
    invoices = json['invoices'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['num'] = this.num;
    data['issue_date'] = this.issueDate;
    data['target_company_name'] = this.targetCompanyName;
    data['created_at'] = this.createdAt;
    data['delivery_notes'] = this.deliveryNotes;
    data['invoices'] = this.invoices;
    return data;
  }
}
