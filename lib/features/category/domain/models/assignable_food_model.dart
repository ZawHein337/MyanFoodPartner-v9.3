import 'package:stackfood_multivendor_restaurant/helper/type_converter.dart';

class AssignableFoodModel {
  CategoryInfo? category;
  int? unassignedCount;
  int? totalSize;
  int? limit;
  int? offset;
  List<AssignableFood>? foods;

  AssignableFoodModel({this.category, this.unassignedCount, this.totalSize, this.limit, this.offset, this.foods});

  AssignableFoodModel.fromJson(Map<String, dynamic> json) {
    category = json['category'] != null ? CategoryInfo.fromJson(json['category']) : null;
    unassignedCount = json['unassigned_count'];
    totalSize = json['total_size'];
    limit = json['limit'];
    offset = json['offset'];
    if (json['foods'] != null) {
      foods = [];
      json['foods'].forEach((v) => foods!.add(AssignableFood.fromJson(v)));
    }
  }
}

class CategoryInfo {
  int? id;
  String? name;

  CategoryInfo({this.id, this.name});

  CategoryInfo.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
  }
}

class AssignableFood {
  int? id;
  String? name;
  String? imageFullUrl;
  double? price;
  int? restaurantCategoryId;
  bool? isAssigned;
  int? variationsCount;

  AssignableFood({this.id, this.name, this.imageFullUrl, this.price, this.restaurantCategoryId, this.isAssigned, this.variationsCount});

  AssignableFood.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    imageFullUrl = json['image_full_url'];
    price = (json['price'] as num?)?.toDouble();
    restaurantCategoryId = json['restaurant_category_id'];
    isAssigned = TypeConverter.convertToBool(json['is_assigned']);
    variationsCount = json['variations_count'];
  }
}
