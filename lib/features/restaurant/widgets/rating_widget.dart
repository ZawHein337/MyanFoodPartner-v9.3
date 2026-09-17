import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stackfood_multivendor_restaurant/common/widgets/rating_bar_widget.dart';
import 'package:stackfood_multivendor_restaurant/features/restaurant/widgets/rating_progress_widget.dart';
import 'package:stackfood_multivendor_restaurant/util/dimensions.dart';
import 'package:stackfood_multivendor_restaurant/util/styles.dart';

class RatingWidget extends StatelessWidget {
  final double? averageRating;
  final int? ratingCount;
  final int? reviewCommentCount;
  final List<int>? ratings;
  const RatingWidget({super.key, this.averageRating, this.ratingCount, this.reviewCommentCount, this.ratings});

  @override
  Widget build(BuildContext context) {

    List<double>? percentages = ratings?.map((rating) {
      int total = ratings!.reduce((value, element) => value + element);
      if (total == 0) return 0.0;
      return (rating / total) * 100;
    }).toList();

    List<double> progressForEach = calculateProgressForEach(percentages);

    return Container(
      padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
        boxShadow: [BoxShadow(color: Colors.grey.withValues(alpha: 0.1), spreadRadius: 1, blurRadius: 10, offset: const Offset(0, 1))],
      ),
      child: Row(children: [

        Expanded(
          flex: 3,
          child: Container(
            decoration: BoxDecoration(
              color: Theme.of(context).disabledColor,
              borderRadius: BorderRadius.circular(Dimensions.radiusMedium),
            ),
            padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
            child: Column(children: [

              Text((averageRating ?? 0).toStringAsFixed(1), style: robotoBold.copyWith(fontSize: Dimensions.fontSizeOverLarge)),
              const SizedBox(height: Dimensions.paddingSizeExtraSmall),

              RatingBarWidget(rating: averageRating, ratingCount: null, size: 16),
              const SizedBox(height: Dimensions.paddingSizeDefault),

              Text('${ratingCount ?? 0} ${'reviews'.tr}', style: robotoBold.copyWith(fontSize: Dimensions.fontSizeSmall)),

            ]),
          ),

        ),
        const SizedBox(width: Dimensions.paddingSizeDefault),

        Expanded(
          flex: 6,
          child: Column(children: [

            RatingProgressWidget(ratingNumber: 'excellent'.tr, ratingPercent: percentages?[0] ?? 0, progressValue: progressForEach.isNotEmpty ? progressForEach[0] : 0),
            const SizedBox(height: Dimensions.paddingSizeExtraSmall),

            RatingProgressWidget(ratingNumber: 'good'.tr, ratingPercent: percentages?[1] ?? 0, progressValue: progressForEach.length > 1 ? progressForEach[1] : 0),
            const SizedBox(height: Dimensions.paddingSizeExtraSmall),

            RatingProgressWidget(ratingNumber: 'average'.tr, ratingPercent: percentages?[2] ?? 0, progressValue: progressForEach.length > 2 ? progressForEach[2] : 0),
            const SizedBox(height: Dimensions.paddingSizeExtraSmall),

            RatingProgressWidget(ratingNumber: 'below_average'.tr, ratingPercent: percentages?[3] ?? 0, progressValue: progressForEach.length > 3 ? progressForEach[3] : 0),
            const SizedBox(height: Dimensions.paddingSizeExtraSmall),

            RatingProgressWidget(ratingNumber: 'poor'.tr, ratingPercent: percentages?[4] ?? 0, progressValue: progressForEach.length > 4 ? progressForEach[4] : 0),

          ]),

        ),

      ]),
    );
  }

  List<double> calculateProgressForEach(List<double>? percentages) {
    if (percentages == null) return [];

    List<double> progressList = [];
    for (double percent in percentages) {
      if (percent.isNaN || percent.isInfinite) {
        progressList.add(0.0);
      } else {
        double progress = percent / 100;
        progressList.add(progress);
      }
    }
    return progressList;
  }
}