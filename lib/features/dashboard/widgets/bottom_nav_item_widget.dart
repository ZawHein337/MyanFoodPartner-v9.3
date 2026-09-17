import 'package:flutter/material.dart';
import 'package:stackfood_multivendor_restaurant/common/widgets/custom_ink_well_widget.dart';
import 'package:stackfood_multivendor_restaurant/util/dimensions.dart';

class BottomNavItemWidget extends StatelessWidget {
  final String imageData;
  final VoidCallback onTap;
  final bool isSelected;
  const BottomNavItemWidget({super.key, required this.imageData, required this.onTap, this.isSelected = false});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: CustomInkWellWidget(
        onTap: onTap,
        radius: Dimensions.radiusDefault,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Image.asset(imageData , color: isSelected ? Theme.of(context).primaryColor : Colors.grey, height: 25, width: 25),
        ),
      ),
    );
  }
}