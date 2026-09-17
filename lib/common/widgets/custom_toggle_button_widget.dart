import 'package:flutter/material.dart';
import 'package:stackfood_multivendor_restaurant/util/dimensions.dart';

class CustomToggleButtonWidget extends StatelessWidget {
  final bool isActive;
  final VoidCallback? onTap;

  const CustomToggleButtonWidget({super.key, required this.isActive, this.onTap});

  @override
  Widget build(BuildContext context) {
    final Widget toggle = Container(
      width: 40,
      decoration: BoxDecoration(
        color: isActive ? Theme.of(context).primaryColor : Theme.of(context).hintColor,
        borderRadius: BorderRadius.circular(Dimensions.radiusLarge),
      ),
      padding: const EdgeInsets.all(1),
      child: Align(
        alignment: isActive ? Alignment.centerRight : Alignment.centerLeft,
        child: Container(
          height: 20, width: 20,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Theme.of(context).cardColor,
          ),
        ),
      ),
    );

    return onTap == null ? toggle : InkWell(onTap: onTap, child: toggle);
  }
}
