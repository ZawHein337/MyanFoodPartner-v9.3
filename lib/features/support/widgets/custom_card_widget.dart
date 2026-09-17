import 'package:flutter/material.dart';
import 'package:stackfood_multivendor_restaurant/util/dimensions.dart';

class CustomCardWidget extends StatelessWidget {
  final Widget child;
  const CustomCardWidget({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
        gradient: LinearGradient(
          colors: [
            Theme.of(context).cardColor,
            Theme.of(context).cardColor,
            Theme.of(context).primaryColor.withValues(alpha: 0.2),
            Theme.of(context).primaryColor.withValues(alpha: 0.5),
            Theme.of(context).primaryColor,
          ],
          begin: Alignment.topCenter, end: Alignment.bottomCenter,
        ),
      ),
      padding: const EdgeInsets.all(1),
      child: Container(
        height: 130,
        width: double.infinity,
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
        ),
        padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
        child: child,
      ),
    );
  }
}
