import 'package:stackfood_multivendor_restaurant/features/restaurant/domain/models/product_model.dart';
import 'package:stackfood_multivendor_restaurant/helper/type_converter.dart';

class ReelDetailsModel {
  int? id;
  int? restaurantId;
  String? description;
  String? thumbnail;
  String? video;
  bool? isAlwaysVisible;
  bool? orderNowButton;
  int? foodId;
  int? orderCount;
  double? totalSaleAmount;
  String? startDate;
  String? endDate;
  bool? status;
  int? totalViews;
  int? totalLikes;
  int? totalStoreVisits;
  String? createdAt;
  String? updatedAt;
  String? thumbnailFullUrl;
  String? videoFullUrl;
  String? reelStatusLabel;
  List<Translation>? translations;

  ReelDetailsModel({
    this.id,
    this.restaurantId,
    this.description,
    this.thumbnail,
    this.video,
    this.isAlwaysVisible,
    this.orderNowButton,
    this.foodId,
    this.orderCount,
    this.totalSaleAmount,
    this.startDate,
    this.endDate,
    this.status,
    this.totalViews,
    this.totalLikes,
    this.totalStoreVisits,
    this.createdAt,
    this.updatedAt,
    this.thumbnailFullUrl,
    this.videoFullUrl,
    this.reelStatusLabel,
    this.translations,
  });

  ReelDetailsModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    restaurantId = json['restaurant_id'] ?? json['store_id'];
    description = json['description'];
    thumbnail = json['thumbnail'];
    video = json['video'];
    isAlwaysVisible = json['is_always_visible'];
    orderNowButton = TypeConverter.convertToBool(json['order_now_button']);
    foodId = json['food_id'];
    orderCount = json['order_count'] != null ? int.parse(json['order_count'].toString()) : 0;
    totalSaleAmount = json['total_sale_amount'] != null ? double.parse(json['total_sale_amount'].toString()) : 0;
    startDate = json['start_date'];
    endDate = json['end_date'];
    status = json['status'];
    totalViews = json['total_views'] != null ? int.parse(json['total_views'].toString()) : 0;
    totalLikes = json['total_likes'] != null ? int.parse(json['total_likes'].toString()) : 0;
    totalStoreVisits = (json['total_store_visits'] ?? json['total_restaurant_visits']) != null
        ? int.parse((json['total_store_visits'] ?? json['total_restaurant_visits']).toString())
        : 0;
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    thumbnailFullUrl = json['thumbnail_full_url'];
    videoFullUrl = json['video_full_url'];
    reelStatusLabel = json['reel_status_label'];
    if (json['translations'] != null) {
      translations = <Translation>[];
      json['translations'].forEach((v) => translations!.add(Translation.fromJson(v)));
    }
  }
}
