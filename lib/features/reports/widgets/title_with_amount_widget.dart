import 'package:stackfood_multivendor_restaurant/helper/price_converter_helper.dart';
import 'package:stackfood_multivendor_restaurant/util/styles.dart';
import 'package:flutter/material.dart';

class TitleWithAmountWidget extends StatelessWidget {
  final String title;
  final double amount;
  const TitleWithAmountWidget({super.key, required this.title, required this.amount});

  @override
  Widget build(BuildContext context) {
    return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [

      Text(title, style: robotoRegular),

      Text(PriceConverter.convertPrice(amount), style: robotoRegular),

    ]);
  }
}