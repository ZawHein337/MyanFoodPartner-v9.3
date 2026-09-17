import 'package:stackfood_multivendor_restaurant/util/dimensions.dart';
import 'package:stackfood_multivendor_restaurant/util/styles.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SubMenuCardWidget extends StatelessWidget {
  final String title;
  final String image;
  final void Function() route;
  const SubMenuCardWidget({super.key, required this.title, required this.image, required this.route});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: route,
      child: Container(
        height: 80, width: context.width,
        padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
          color: Theme.of(context).primaryColor.withValues(alpha: 0.03),
          border: Border.all(width: 1, color: Theme.of(context).primaryColor.withValues(alpha: 0.3)),
        ),
        child: Row(children: [

          Image.asset(image, width: 40, height: 40, color: Theme.of(context).primaryColor),
          const SizedBox(width: Dimensions.paddingSizeSmall),

          Text(title, style: robotoMedium),

        ]),
      ),
    );
  }
}