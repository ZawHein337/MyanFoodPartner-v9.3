import 'package:shimmer_animation/shimmer_animation.dart';
import 'package:stackfood_multivendor_restaurant/util/dimensions.dart';
import 'package:flutter/material.dart';

class ProductShimmerWidget extends StatelessWidget {
  const ProductShimmerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: Dimensions.webMaxWidth,
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
        border: Border.all(color: Colors.grey.withValues(alpha: 0.1)),
      ),
      padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [

        Row(children: [

          ClipRRect(
            borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
            child: Shimmer(
              child: Container(
                height: 80, width: 80,
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(Dimensions.radiusSmall), color: Theme.of(context).shadowColor),
              ),
            ),
          ),

          const SizedBox(width: Dimensions.paddingSizeSmall),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
              child: Shimmer(
                child: Container(
                  height: 15, width: 100,
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(Dimensions.radiusSmall), color: Theme.of(context).shadowColor),
                ),
              ),
            ),
            const SizedBox(height: Dimensions.paddingSizeSmall),

            ClipRRect(
              borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
              child: Shimmer(
                child: Container(
                  height: 15, width: 150,
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(Dimensions.radiusSmall), color: Theme.of(context).shadowColor),
                ),
              ),
            ),

          ])),
          Column(children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
              child: Shimmer(
                child: Container(
                  height: 20, width: 50,
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(Dimensions.radiusSmall), color: Theme.of(context).shadowColor),
                ),
              ),
            ),
            const SizedBox(height: Dimensions.paddingSizeSmall),

            ClipRRect(
              borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
              child: Shimmer(
                child: Container(
                  height: 20, width: 70,
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(Dimensions.radiusSmall), color: Theme.of(context).shadowColor),
                ),
              ),
            ),
          ]),
        ]),

      ]),
    );
  }
}