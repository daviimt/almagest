class Products {
  bool? success;
  List<ProductData>? data;
  String? message;

  Products({this.success, this.data, this.message});

  Products.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    if (json['data'] != null) {
      data = <ProductData>[];
      json['data'].forEach((v) {
        data!.add(ProductData.fromJson(v));
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

class ProductData {
  int? id;
  int? articleId;
  int? companyId;
  String? compamyName;
  String? compamyDescription;
  String? price;
  int? stock;
  int? familyId;
  int? deleted;

  ProductData(
      {this.id,
      this.articleId,
      this.companyId,
      this.compamyName,
      this.compamyDescription,
      this.price,
      this.stock,
      this.familyId,
      this.deleted});

  ProductData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    articleId = json['article_id'];
    companyId = json['company_id'];
    compamyName = json['compamy_name'];
    compamyDescription = json['compamy_description'];
    price = json['price'];
    stock = json['stock'];
    familyId = json['family_id'];
    deleted = json['deleted'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['article_id'] = articleId;
    data['company_id'] = companyId;
    data['compamy_name'] = compamyName;
    data['compamy_description'] = compamyDescription;
    data['price'] = price;
    data['stock'] = stock;
    data['family_id'] = familyId;
    data['deleted'] = deleted;
    return data;
  }
}
