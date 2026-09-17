import 'package:flutter/material.dart';
import 'package:stackfood_multivendor_restaurant/util/dimensions.dart';
import 'package:stackfood_multivendor_restaurant/util/styles.dart';

class CustomRadioListTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final int value;
  final int? groupValue;
  final Function(int?) onChanged;
  const CustomRadioListTile({super.key, required this.title, required this.subtitle, required this.value, required this.groupValue, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return RadioGroup(
      groupValue: groupValue,
      onChanged: onChanged,
      child: RadioListTile(
        titleAlignment: ListTileTitleAlignment.top,
        value: value,
        activeColor: Theme.of(context).primaryColor,
        contentPadding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
        title: Text(title, style: robotoSemiBold),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: Dimensions.paddingSizeExtraSmall),
          child: Text(
            subtitle,
            style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).hintColor),
          ),
        ),
      ),
    );
  }
}
