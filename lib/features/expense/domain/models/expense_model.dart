class ExpenseBodyModel {
  int? totalSize;
  int? limit;
  String? offset;
  List<Expense>? expense;

  ExpenseBodyModel({this.totalSize, this.limit, this.offset, this.expense});

  ExpenseBodyModel.fromJson(Map<String, dynamic> json) {
    totalSize = json['total_size'];
    limit = json['limit'];
    offset = json['offset'];
    if (json['expense'] != null) {
      expense = <Expense>[];
      json['expense'].forEach((v) {
        expense!.add(Expense.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['total_size'] = totalSize;
    data['limit'] = limit;
    data['offset'] = offset;
    if (expense != null) {
      data['expense'] = expense!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Expense {
  int? id;
  String? type;
  double? amount;
  String? description;
  String? createdAt;
  String? updatedAt;
  String? createdBy;
  int? restaurantId;
  int? orderId;
  Order? order;

  Expense({
    this.id,
    this.type,
    this.amount,
    this.description,
    this.createdAt,
    this.updatedAt,
    this.createdBy,
    this.restaurantId,
    this.orderId,
    this.order,
  });

  Expense.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    type = json['type'];
    amount = json['amount']?.toDouble();
    description = json['description'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    createdBy = json['created_by'];
    restaurantId = json['restaurant_id'];
    orderId = json['order_id'];
    order = json['order'] != null ? Order.fromJson(json['order']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['type'] = type;
    data['amount'] = amount;
    data['description'] = description;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['created_by'] = createdBy;
    data['restaurant_id'] = restaurantId;
    data['order_id'] = orderId;
    if (order != null) {
      data['order'] = order!.toJson();
    }
    return data;
  }
}

class Order {
  int? id;
  int? userId;
  Customer? customer;

  Order({this.id, this.userId, this.customer});

  Order.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    customer = json['customer'] != null
        ? Customer.fromJson(json['customer'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['user_id'] = userId;
    if (customer != null) {
      data['customer'] = customer!.toJson();
    }
    return data;
  }
}

class Customer {
  int? id;
  String? fName;
  String? lName;
  String? imageFullUrl;

  Customer({this.id, this.fName, this.lName, this.imageFullUrl});

  Customer.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    fName = json['f_name'];
    lName = json['l_name'];
    imageFullUrl = json['image_full_url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['f_name'] = fName;
    data['l_name'] = lName;
    data['image_full_url'] = imageFullUrl;
    return data;
  }
}