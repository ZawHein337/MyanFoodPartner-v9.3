import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:stackfood_multivendor_restaurant/common/widgets/gap_widget.dart';
import 'package:stackfood_multivendor_restaurant/util/dimensions.dart';
import 'package:stackfood_multivendor_restaurant/util/styles.dart';

class CustomSwitchTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final bool? isButtonActive;
  final Function onTap;
  const CustomSwitchTile({super.key, required this.title, required this.subtitle, required this.isButtonActive, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: Dimensions.paddingSizeSmall, top: Dimensions.paddingSizeSmall, bottom: Dimensions.paddingSizeSmall),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
        border: Border.all(color: Theme.of(context).disabledColor),
      ),
      child: Row(children: [

        Expanded(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(title, style: robotoSemiBold),

            Text(
              subtitle,
              style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).hintColor),
            ),
          ]),
        ),
        Gap.horizontal(Dimensions.paddingSizeDefault),

        Transform.scale(
          scale: 0.7,
          child: CupertinoSwitch(
            activeTrackColor: Theme.of(context).primaryColor,
            inactiveTrackColor: Theme.of(context).hintColor.withValues(alpha: 0.5),
            value: isButtonActive!,
            onChanged: (bool? value) => onTap(),
          ),
        ),

      ]),
    );
  }
}
