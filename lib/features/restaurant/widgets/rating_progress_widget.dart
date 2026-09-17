import 'package:flutter/material.dart';
import 'package:stackfood_multivendor_restaurant/util/dimensions.dart';
import 'package:stackfood_multivendor_restaurant/util/styles.dart';

class RatingProgressWidget extends StatelessWidget {
  final String ratingNumber;
  final double ratingPercent;
  final double progressValue;
  const RatingProgressWidget({super.key, required this.ratingNumber, required this.ratingPercent, required this.progressValue});

  @override
  Widget build(BuildContext context) {

    return Row(children: [

      Text(ratingNumber, style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeSmall)),
      const SizedBox(width: Dimensions.paddingSizeSmall),

      Expanded(
        child: LinearProgressIndicator(
          minHeight: Dimensions.paddingSizeExtraSmall,
          value: progressValue,
          backgroundColor: Theme.of(context).hintColor.withValues(alpha: 0.2),
          borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
          valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor),
        ),
      ),

      Container(
        alignment: Alignment.centerRight,
        width: 50,
        child: Text('${ratingPercent.toStringAsFixed(1)}%', style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).textTheme.bodyMedium!.color?.withValues(alpha: 0.5))),
      ),

    ]);
  }
}