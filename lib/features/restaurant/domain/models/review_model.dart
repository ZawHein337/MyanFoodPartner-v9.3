import 'package:stackfood_multivendor_restaurant/features/order/domain/models/order_model.dart';

class ReviewModel {
  int? id;
  String? comment;
  int? rating;
  String? foodName;
  String? foodImageFullUrl;
  String? customerName;
  String? createdAt;
  String? updatedAt;
  Customer? customer;
  int? orderId;
  String? reply;
  String? customerPhone;

  ReviewModel({
    this.id,
    this.comment,
    this.rating,
    this.foodName,
    this.foodImageFullUrl,
    this.customerName,
    this.createdAt,
    this.updatedAt,
    this.customer,
    this.orderId,
    this.reply,
    this.customerPhone,
  });

  ReviewModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    comment = json['comment'];
    rating = json['rating'];
    foodName = json['food_name'];
    foodImageFullUrl = json['food_image_full_url'];
    customerName = json['customer_name'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    customer = json['customer'] != null ? Customer.fromJson(json['customer']) : null;
    orderId = json['order_id'];
    reply = json['reply'];
    customerPhone = json['customer_phone'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['comment'] = comment;
    data['rating'] = rating;
    data['food_name'] = foodName;
    data['food_image_full_url'] = foodImageFullUrl;
    data['customer_name'] = customerName;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    if (customer != null) {
      data['customer'] = customer!.toJson();
    }
    data['order_id'] = orderId;
    data['reply'] = reply;
    data['customer_phone'] = customerPhone;
    return data;
  }
}