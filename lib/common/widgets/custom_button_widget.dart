import 'package:flutter/material.dart';
import 'package:get/get_utils/get_utils.dart';
import 'package:stackfood_multivendor_restaurant/util/dimensions.dart';
import 'package:stackfood_multivendor_restaurant/util/styles.dart';

class CustomButtonWidget extends StatelessWidget {
  final Function? onPressed;
  final String buttonText;
  final bool transparent;
  final EdgeInsets? margin;
  final EdgeInsets? padding;
  final double? height;
  final double? width;
  final double? fontSize;
  final Color? color;
  final Color? iconColor;
  final IconData? icon;
  final double radius;
  final FontWeight? fontWeight;
  final Color? textColor;
  final bool isLoading;
  final IconData? onlyButtonIcon;
  final Color? buttonDisabledColor;
  final Color? borderColor;
  final bool isBorder;
  final bool loadingTextVisible;
  final bool takeMinimumWidth;
  const CustomButtonWidget({super.key, this.onPressed, required this.buttonText, this.transparent = false, this.margin,
    this.width, this.height, this.fontSize, this.color, this.icon, this.radius = Dimensions.radiusDefault, this.fontWeight,
    this.textColor, this.iconColor, this.isLoading = false, this.onlyButtonIcon, this.buttonDisabledColor, this.borderColor, this.isBorder = false, this.loadingTextVisible = true, this.takeMinimumWidth = false, this.padding});

  @override
  Widget build(BuildContext context) {

    final ButtonStyle flatButtonStyle = TextButton.styleFrom(
      backgroundColor: onPressed == null ? (buttonDisabledColor ?? Theme.of(context).hintColor) : transparent ? Colors.transparent : color ?? Theme.of(context).primaryColor,
      minimumSize: Size(width != null ? width! : takeMinimumWidth ? 10 :  1170, height != null ? height! : 50),
      padding: padding ?? EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall),
      tapTargetSize: takeMinimumWidth ? MaterialTapTargetSize.shrinkWrap : MaterialTapTargetSize.padded,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(radius),
        side: isBorder ? BorderSide(color: borderColor ?? Theme.of(context).primaryColor) : BorderSide.none,
      ),
    );

    return Padding(
      padding: margin == null ? const EdgeInsets.all(0) : margin!,
      child: TextButton(
        onPressed: isLoading ? null : onPressed as void Function()?,
        style: flatButtonStyle,
        child: isLoading ?
        Row(mainAxisSize: takeMinimumWidth ? MainAxisSize.min : MainAxisSize.max, mainAxisAlignment: MainAxisAlignment.center, children: [
          const SizedBox(
            height: 15, width: 15,
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              strokeWidth: 2,
            ),
          ),
          const SizedBox(width: Dimensions.paddingSizeSmall),

          loadingTextVisible ? Text('loading'.tr, style: robotoMedium.copyWith(color: Colors.white)) : const SizedBox.shrink(),
        ]) : Row(
          mainAxisSize: takeMinimumWidth ? MainAxisSize.min : MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center, children: [

          icon != null ? Icon(icon, color: iconColor ?? (transparent ? Theme.of(context).primaryColor : Theme.of(context).cardColor)) : const SizedBox(),
          SizedBox(width: icon != null ? Dimensions.paddingSizeSmall : 0),

          onlyButtonIcon != null ? Icon(onlyButtonIcon, color: Colors.white, size: 34,) : Text(buttonText, textAlign: TextAlign.center, style: robotoBold.copyWith(
            color: textColor ?? (transparent ? Theme.of(context).primaryColor : Theme.of(context).cardColor),
            fontSize: fontSize ?? Dimensions.fontSizeLarge, fontWeight: fontWeight,
          )),

        ]),
      ),
    );
  }
}