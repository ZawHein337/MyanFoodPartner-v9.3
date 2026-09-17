import 'package:stackfood_multivendor_restaurant/features/restaurant/domain/models/review_model.dart';

class FoodReviewModel {
  int? ratingCount;
  double? avgRating;
  List<int>? rating;
  List<ReviewModel>? reviews;

  FoodReviewModel({this.ratingCount, this.avgRating, this.rating, this.reviews});

  FoodReviewModel.fromJson(Map<String, dynamic> json) {
    ratingCount = json['rating_count'];
    avgRating = json['avg_rating']?.toDouble();
    rating = json['rating'].cast<int>();
    if (json['reviews'] != null) {
      reviews = <ReviewModel>[];
      json['reviews'].forEach((v) {
        reviews!.add(ReviewModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['rating_count'] = ratingCount;
    data['avg_rating'] = avgRating;
    data['rating'] = rating;
    if (reviews != null) {
      data['reviews'] = reviews!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}