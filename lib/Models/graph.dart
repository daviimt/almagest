class Graphs {
  bool? success;
  List<DataGraphs>? data;
  String? message;

  Graphs({this.success, this.data, this.message});

  Graphs.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    if (json['data'] != null) {
      data = <DataGraphs>[];
      json['data'].forEach((v) {
        data!.add(new DataGraphs.fromJson(v));
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

class DataGraphs {
  int? id;
  int? originCompanyId;
  List<OrderLines>? orderLines;
  String? issueDate;

  DataGraphs({this.id, this.originCompanyId, this.orderLines, this.issueDate});

  DataGraphs.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    originCompanyId = json['origin_company_id'];
    if (json['order_lines'] != null) {
      orderLines = <OrderLines>[];
      json['order_lines'].forEach((v) {
        orderLines!.add(OrderLines.fromJson(v));
      });
    }
    issueDate = json['issue_date'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['origin_company_id'] = this.originCompanyId;
    if (this.orderLines != null) {
      data['order_lines'] = this.orderLines!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class OrderLines {
  int? id;
  int? orderId;
  String? orderLineNum;
  String? issueDate;
  int? deleted;
  String? createdAt;
  String? updatedAt;
  List<ArticlesLine>? articlesLine;

  OrderLines(
      {this.id,
      this.orderId,
      this.orderLineNum,
      this.issueDate,
      this.deleted,
      this.createdAt,
      this.updatedAt,
      this.articlesLine});

  OrderLines.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    orderId = json['order_id'];
    orderLineNum = json['order_line_num'];
    issueDate = json['issue_date'];
    deleted = json['deleted'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    if (json['articles_line'] != null) {
      articlesLine = <ArticlesLine>[];
      json['articles_line'].forEach((v) {
        articlesLine!.add(new ArticlesLine.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['order_id'] = this.orderId;
    data['order_line_num'] = this.orderLineNum;
    data['issue_date'] = this.issueDate;
    data['deleted'] = this.deleted;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    if (this.articlesLine != null) {
      data['articles_line'] =
          this.articlesLine!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ArticlesLine {
  int? id;
  int? articleId;
  int? numArticles;
  int? orderLinesId;
  int? deleted;
  String? updatedAt;
  String? createdAt;
  Article? article;

  ArticlesLine(
      {this.id,
      this.articleId,
      this.numArticles,
      this.orderLinesId,
      this.deleted,
      this.updatedAt,
      this.createdAt,
      this.article});

  ArticlesLine.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    articleId = json['article_id'];
    numArticles = json['num_articles'];
    orderLinesId = json['order_lines_id'];
    deleted = json['deleted'];
    updatedAt = json['updated_at'];
    createdAt = json['created_at'];
    article =
        json['article'] != null ? new Article.fromJson(json['article']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['article_id'] = this.articleId;
    data['num_articles'] = this.numArticles;
    data['order_lines_id'] = this.orderLinesId;
    data['deleted'] = this.deleted;
    data['updated_at'] = this.updatedAt;
    data['created_at'] = this.createdAt;
    if (this.article != null) {
      data['article'] = this.article!.toJson();
    }
    return data;
  }
}

class Article {
  int? id;
  String? name;
  String? description;
  String? priceMin;
  String? priceMax;
  String? colorName;
  String? weight;
  String? size;
  int? familyId;
  int? deleted;
  String? createdAt;
  String? updatedAt;

  Article(
      {this.id,
      this.name,
      this.description,
      this.priceMin,
      this.priceMax,
      this.colorName,
      this.weight,
      this.size,
      this.familyId,
      this.deleted,
      this.createdAt,
      this.updatedAt});

  Article.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    description = json['description'];
    priceMin = json['price_min'];
    priceMax = json['price_max'];
    colorName = json['color_name'];
    weight = json['weight'];
    size = json['size'];
    familyId = json['family_id'];
    deleted = json['deleted'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['description'] = this.description;
    data['price_min'] = this.priceMin;
    data['price_max'] = this.priceMax;
    data['color_name'] = this.colorName;
    data['weight'] = this.weight;
    data['size'] = this.size;
    data['family_id'] = this.familyId;
    data['deleted'] = this.deleted;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}
