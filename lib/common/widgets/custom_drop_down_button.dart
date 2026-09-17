import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stackfood_multivendor_restaurant/util/dimensions.dart';
import 'package:stackfood_multivendor_restaurant/util/styles.dart';

class CustomDropdownButton extends StatefulWidget {
  final List<String>? items;
  final bool showTitle;
  final bool isBorder;
  final String? hintText;
  final bool? isRequired;
  final double? borderRadius;
  final Color? backgroundColor;
  final Function(String?)? onChanged;
  final FormFieldValidator<String>? validator;
  final FormFieldSetter<String>? onSaved;
  final FontWeight? titleFontWeight;
  final String? selectedValue;
  final List<DropdownItem<String>>? dropdownMenuItems;
  final MenuItemStyleData? menuItemStyleData;

  const CustomDropdownButton({
    super.key,
    this.items,
    this.showTitle = true,
    this.isBorder = true,
    this.hintText,
    this.isRequired = false,
    this.borderRadius,
    this.backgroundColor,
    this.onChanged,
    this.validator,
    this.onSaved,
    this.titleFontWeight,
    this.selectedValue,
    this.dropdownMenuItems,
    this.menuItemStyleData,
  });

  @override
  State<CustomDropdownButton> createState() => _CustomDropdownButtonState();
}

class _CustomDropdownButtonState extends State<CustomDropdownButton> {
  late final ValueNotifier<String?> _valueListenable = ValueNotifier<String?>(widget.selectedValue);

  @override
  void didUpdateWidget(covariant CustomDropdownButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.selectedValue != widget.selectedValue) {
      _valueListenable.value = widget.selectedValue;
    }
  }

  @override
  void dispose() {
    _valueListenable.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: widget.backgroundColor ?? Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(widget.borderRadius ?? Dimensions.radiusDefault),
      ),
      child: DropdownButtonFormField2<String>(
        isExpanded: true,
        valueListenable: _valueListenable,
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeSmall),
          focusedBorder: _border(),
          enabledBorder: _border(),
          disabledBorder: _border(),
          focusedErrorBorder: _border(),
          errorBorder: _border(),
        ),
        hint: RichText(text: TextSpan(children: [
          TextSpan(
            text: widget.hintText ?? 'select_an_option'.tr,
            style: robotoRegular.copyWith(color: Theme.of(context).hintColor, fontSize: Dimensions.fontSizeDefault)
          ),
          TextSpan(text: widget.isRequired == true ?' *' : '', style: TextStyle(color: Colors.red))
        ])),
        items: (widget.dropdownMenuItems ?? widget.items?.map((item) => DropdownItem<String>(
          value: item,
          child: Text(
            item.tr, style: robotoRegular.copyWith(color: Theme.of(context).textTheme.bodyLarge?.color, fontSize: Dimensions.fontSizeDefault),
          ),
        )).toList()) ?? [
          DropdownItem<String>(
            value: null,
            child: Text(
              'no_data_available'.tr,
              style: robotoRegular.copyWith(color: Theme.of(context).hintColor, fontSize: Dimensions.fontSizeDefault),
            ),
          )
        ],
        validator: widget.validator ?? (value) {
          if (value == null) {
            return 'please_select_an_option'.tr;
          }
          return null;
        },
        onChanged: widget.onChanged,
        onSaved: widget.onSaved,
        buttonStyleData: const FormFieldButtonStyleData(
          padding: EdgeInsets.only(right: 8),
        ),
        iconStyleData: IconStyleData(
          icon: Icon(Icons.arrow_drop_down_outlined, color: Theme.of(context).hintColor, size: 25),
        ),
        dropdownStyleData: DropdownStyleData(
          maxHeight: 300,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
          ),
        ),
        menuItemStyleData: widget.menuItemStyleData ?? const MenuItemStyleData(
          padding: EdgeInsets.symmetric(horizontal: 16),
        ),
      ),
    );
  }

  OutlineInputBorder _border() {
    return OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(widget.borderRadius ?? Dimensions.radiusDefault)),
      borderSide: BorderSide(width: 1, color: widget.isBorder ? Theme.of(context).disabledColor : Colors.transparent),
    );
  }
}