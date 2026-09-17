import 'package:stackfood_multivendor_restaurant/features/splash/controllers/splash_controller.dart';
import 'package:stackfood_multivendor_restaurant/util/dimensions.dart';
import 'package:stackfood_multivendor_restaurant/util/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class CustomTextFormFieldWidget extends StatefulWidget {
  final String? hintText;
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final FocusNode? nextFocus;
  final TextInputType inputType;
  final TextInputAction? inputAction;
  final int maxLines;
  final bool isPassword;
  final Function? onTap;
  final Function? onChanged;
  final Function? onSubmit;
  final bool? isEnabled;
  final TextCapitalization capitalization;
  final Color? fillColor;
  final bool isAmount;
  final bool amountIcon;
  final bool showTitle;
  final Function? onComplete;
  final bool readOnly;
  final bool isRequired;
  final String? titleName;
  final Color? containerColor;
  final bool isBorderEnabled;
  final bool isNumber;

  const CustomTextFormFieldWidget({
    super.key,
    this.hintText = '',
    this.controller,
    this.focusNode,
    this.nextFocus,
    this.isEnabled = true,
    this.inputType = TextInputType.text,
    this.inputAction = TextInputAction.next,
    this.maxLines = 1,
    this.onSubmit,
    this.onChanged,
    this.capitalization = TextCapitalization.none,
    this.onTap,
    this.fillColor,
    this.isPassword = false,
    this.isAmount = false,
    this.amountIcon = false,
    this.showTitle = true,
    this.onComplete,
    this.readOnly = false,
    this.isRequired = false,
    this.titleName,
    this.containerColor,
    this.isBorderEnabled = true,
    this.isNumber = false,
  });

  @override
  CustomTextFormFieldWidgetState createState() => CustomTextFormFieldWidgetState();
}

class CustomTextFormFieldWidgetState extends State<CustomTextFormFieldWidget> {

  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

      widget.showTitle ? Row(children: [

        Flexible(
          child: Text(
            widget.titleName ?? widget.hintText!,
            style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeLarge),
            maxLines: 1, overflow: TextOverflow.ellipsis,
          ),
        ),
        const SizedBox(width: Dimensions.paddingSizeExtraSmall),

        /*widget.isEnabled! ? const SizedBox() : Text('(${'non_changeable'.tr})', style: robotoRegular.copyWith(
          fontSize: Dimensions.fontSizeExtraSmall, color: Theme.of(context).colorScheme.error,
        )),*/

        widget.isRequired ? Text('*', style: robotoBold.copyWith(color: Theme.of(context).primaryColor)) : const SizedBox(),

      ]) : const SizedBox(),
      SizedBox(height: widget.showTitle ? Dimensions.paddingSizeSmall : 0),

      Container(
        height: widget.maxLines != 5 ? 50 : 100,
        decoration: BoxDecoration(
          color: widget.containerColor,
          borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
          //border: Border.all(color: Theme.of(context).primaryColor, width: 0.5),
        ),
        child: TextField(
          maxLines: widget.maxLines,
          controller: widget.controller,
          focusNode: widget.focusNode,
          readOnly: widget.readOnly,
          style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeDefault),
          textInputAction: widget.nextFocus != null ? widget.inputAction : TextInputAction.done,
          keyboardType: widget.isAmount ? TextInputType.number : widget.inputType,
          autofillHints: widget.inputType == TextInputType.name ? [AutofillHints.name]
              : widget.inputType == TextInputType.emailAddress ? [AutofillHints.email]
              : widget.inputType == TextInputType.phone ? [AutofillHints.telephoneNumber]
              : widget.inputType == TextInputType.streetAddress ? [AutofillHints.fullStreetAddress]
              : widget.inputType == TextInputType.url ? [AutofillHints.url]
              : widget.inputType == TextInputType.visiblePassword ? [AutofillHints.password] : null,
          cursorColor: Theme.of(context).primaryColor,
          textCapitalization: widget.capitalization,
          enabled: widget.isEnabled,
          textAlignVertical: TextAlignVertical.center,
          autofocus: false,
          obscureText: widget.isPassword ? _obscureText : false,
          inputFormatters: widget.inputType == TextInputType.phone ? <TextInputFormatter>[FilteringTextInputFormatter.allow(RegExp('[0-9+]'))]
              : widget.isAmount ? [FilteringTextInputFormatter.allow(RegExp(r'[0-9.]'))] : null,
          decoration: InputDecoration(
            hintText: widget.hintText,
            contentPadding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeSmall, horizontal: Dimensions.paddingSizeDefault),
            fillColor: widget.fillColor ?? Theme.of(context).cardColor,
            border: widget.isBorderEnabled ? OutlineInputBorder(
              borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
              borderSide: BorderSide(color: Theme.of(context).hintColor.withValues(alpha: 0.5)),
            ) : InputBorder.none,
            enabledBorder:  widget.isBorderEnabled ? OutlineInputBorder(
              borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
              borderSide: BorderSide(color: Theme.of(context).hintColor.withValues(alpha: 0.5)),
            ) : InputBorder.none,
            focusedBorder:  widget.isBorderEnabled ? OutlineInputBorder(
              borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
              borderSide: BorderSide(color: Theme.of(context).hintColor.withValues(alpha: 0.5)),
            ) : InputBorder.none,
            hintStyle: robotoRegular.copyWith(color: Theme.of(context).hintColor.withValues(alpha: 0.8)),
            suffixIcon: widget.isPassword ? IconButton(
              icon: Icon(_obscureText ? Icons.visibility_off : Icons.visibility, color: Theme.of(context).hintColor.withValues(alpha: 0.3)),
              onPressed: _toggle,
            ) : null,
            prefixIcon: widget.amountIcon ? SizedBox(
              width: 20,
              child: Center(child: Text('${Get.find<SplashController>().configModel!.currencySymbol}',style: const TextStyle(fontSize: 20),textAlign: TextAlign.center)),
            ) : null,
          ),
          onTap: widget.onTap as void Function()?,
          onSubmitted: (text) => widget.nextFocus != null ? FocusScope.of(context).requestFocus(widget.nextFocus)
              : widget.onSubmit != null ? widget.onSubmit!(text) : null,
          onChanged: widget.onChanged as void Function(String)?,
          onEditingComplete: widget.onComplete as void Function()?,
        ),
      ),

    ]);
  }

  void _toggle() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }
}