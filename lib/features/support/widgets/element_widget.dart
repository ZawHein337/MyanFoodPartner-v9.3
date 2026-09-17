import 'package:flutter/material.dart';
import 'package:stackfood_multivendor_restaurant/util/dimensions.dart';
import 'package:stackfood_multivendor_restaurant/util/styles.dart';

class ElementWidget extends StatelessWidget {
  final String image;
  final String title;
  final String subTitle;
  final Function() onTap;
  const ElementWidget({super.key, required this.image, required this.title, required this.subTitle, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Image.asset(image, height: 45, width: 45, fit: BoxFit.cover),

        Text(title, style: robotoBold.copyWith(fontSize: Dimensions.fontSizeDefault)),

        Text(
          subTitle,
          style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeDefault, color: Theme.of(context).hintColor),
          overflow: TextOverflow.ellipsis, maxLines: 2,
        ),

      ]),
    );
  }
}
