import 'package:flutter/cupertino.dart';
import 'package:stackfood_multivendor_restaurant/common/widgets/details_custom_card.dart';
import 'package:stackfood_multivendor_restaurant/util/dimensions.dart';
import 'package:stackfood_multivendor_restaurant/util/styles.dart';
import 'package:flutter/material.dart';

class SwitchButtonWidget extends StatelessWidget {
  final IconData? icon;
  final String title;
  final bool? isButtonActive;
  final Function onTap;
  const SwitchButtonWidget({super.key, this.icon, required this.title, required this.onTap, this.isButtonActive});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap as void Function()?,
      child: DetailsCustomCard(
        padding: EdgeInsets.only(
          left: Dimensions.paddingSizeSmall,
          top: isButtonActive != null ? Dimensions.paddingSizeExtraSmall : Dimensions.paddingSizeDefault,
          bottom: isButtonActive != null ? Dimensions.paddingSizeExtraSmall : Dimensions.paddingSizeDefault,
        ),
        child: Row(children: [

          icon != null ? Icon(icon, size: 25) : const SizedBox(),
          SizedBox(width: icon != null ? Dimensions.paddingSizeSmall : 0),

          Expanded(child: Text(title, style: robotoRegular)),

          isButtonActive != null ? Transform.scale(
           scale: 0.7,
           child: CupertinoSwitch(
             activeTrackColor: Theme.of(context).primaryColor,
             inactiveTrackColor: Theme.of(context).hintColor.withValues(alpha: 0.5),
              value: isButtonActive!,
             onChanged: (bool? value) => onTap(),
            ),
         ) : const SizedBox(),

        ]),
      ),
    );
  }
}