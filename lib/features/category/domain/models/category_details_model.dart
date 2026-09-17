import 'package:stackfood_multivendor_restaurant/features/category/domain/models/category_model.dart';

class CategoryDetailsModel {
  int? id;
  int? restaurantId;
  String? name;
  String? slug;
  String? image;
  int? priority;
  int? status;
  String? imageFullUrl;
  List<Translations>? translations;

  CategoryDetailsModel({
    this.id,
    this.restaurantId,
    this.name,
    this.slug,
    this.image,
    this.priority,
    this.status,
    this.imageFullUrl,
    this.translations,
  });

  CategoryDetailsModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    restaurantId = json['restaurant_id'];
    name = json['name'];
    slug = json['slug'];
    image = json['image'];
    priority = json['priority'];
    status = json['status'];
    imageFullUrl = json['image_full_url'];
    if (json['translations'] != null) {
      translations = <Translations>[];
      json['translations'].forEach((v) => translations!.add(Translations.fromJson(v)));
    }
  }
}
