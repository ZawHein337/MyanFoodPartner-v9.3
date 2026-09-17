import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:stackfood_multivendor_restaurant/util/dimensions.dart';

class QuantityButton extends StatelessWidget {
  final bool isIncrement;
  final Function? onTap;
  final bool showRemoveIcon;
  final Color? color;
  final bool isLastItem;
  const QuantityButton({super.key, required this.isIncrement, required this.onTap, this.showRemoveIcon = false, this.color, this.isLastItem = false});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap as void Function()?,
      child: Container(
        height: 30, width: 30,
        margin: EdgeInsets.only(left: isIncrement ? Dimensions.paddingSizeSmall : 0, right: isIncrement ? 0 : Dimensions.paddingSizeSmall),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: showRemoveIcon ? Theme.of(context).disabledColor.withValues(alpha: 0.2) : isIncrement ? color ?? Theme.of(context).primaryColor : Theme.of(context).disabledColor.withValues(alpha: 0.2),
        ),
        alignment: Alignment.center,
        child: Icon(
          showRemoveIcon ? CupertinoIcons.trash : isIncrement ? Icons.add : Icons.remove,
          size: 28,
          color: (showRemoveIcon && isLastItem) ? Theme.of(context).hintColor : showRemoveIcon ? Theme.of(context).colorScheme.error : isIncrement ? Theme.of(context).cardColor : Theme.of(context).textTheme.bodyLarge?.color,
        ),
      ),
    );
  }
}