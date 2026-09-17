import 'package:stackfood_multivendor_restaurant/util/dimensions.dart';
import 'package:stackfood_multivendor_restaurant/util/styles.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OrderStatusCardWidget extends StatelessWidget {
  final String image;
  final String title;
  final int totalCount;
  const OrderStatusCardWidget({super.key, required this.image, required this.title, required this.totalCount});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: context.width * 0.8, height: 80,
      padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault),
      decoration:  BoxDecoration(
        borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
        color: Theme.of(context).hintColor.withValues(alpha: 0.1),
      ),
      child: Row(children: [

        Container(
          height: 50, width: 50,
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(Dimensions.radiusDefault)),
          ),
          child: Image.asset(image, height: 50, width: 50, fit: BoxFit.cover),
        ),
        const SizedBox(width: Dimensions.paddingSizeDefault),

        Text(title, style: robotoBold.copyWith(color: Theme.of(context).textTheme.bodyLarge!.color?.withValues(alpha: 0.6))),

        const Spacer(),

        Text(
          totalCount.toString(),
          style: robotoBold.copyWith(fontSize: Dimensions.fontSizeLarge, color: Colors.green),
          textDirection: TextDirection.ltr,
        ),

      ]),
    );
  }
}