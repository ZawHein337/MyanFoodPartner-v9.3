import 'package:flutter/material.dart';
import 'package:stackfood_multivendor_restaurant/common/widgets/details_custom_card.dart';
import 'package:stackfood_multivendor_restaurant/util/dimensions.dart';
import 'package:stackfood_multivendor_restaurant/util/styles.dart';

class SectionWidget extends StatelessWidget {
  final String title;
  final Widget? titleWidget;
  final Widget child;
  final bool? titleSpace;
  const SectionWidget({super.key, required this.title, required this.child, this.titleWidget, this.titleSpace = false});

  @override
  Widget build(BuildContext context) {
    return DetailsCustomCard(
      width: double.infinity,
      isBorder: false,
      padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(mainAxisAlignment: titleSpace! ? MainAxisAlignment.spaceBetween : MainAxisAlignment.start, children: [
          Text(title, style: robotoSemiBold),

          titleWidget != null ? titleWidget! : const SizedBox(),
        ]),
        // const SizedBox(height: Dimensions.paddingSizeSmall),
        Divider(),

        child,
      ]),
    );
  }
}
