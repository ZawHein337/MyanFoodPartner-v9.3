import 'package:stackfood_multivendor_restaurant/common/widgets/custom_button_widget.dart';
import 'package:stackfood_multivendor_restaurant/common/widgets/custom_image_widget.dart';
import 'package:stackfood_multivendor_restaurant/common/widgets/custom_tool_tip_widget.dart';
import 'package:stackfood_multivendor_restaurant/features/happy_hour/domain/models/happy_hour_model.dart';
import 'package:stackfood_multivendor_restaurant/helper/happy_hour_helper.dart';
import 'package:stackfood_multivendor_restaurant/helper/responsive_helper.dart';
import 'package:stackfood_multivendor_restaurant/util/dimensions.dart';
import 'package:stackfood_multivendor_restaurant/util/styles.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HappyHourCardWidget extends StatelessWidget {
  final HappyHourModel happyHourModel;
  final Function()? onTap;
  final Function()? onActionPressed;
  final bool isActionLoading;
  const HappyHourCardWidget({super.key, required this.happyHourModel, this.onTap, this.onActionPressed, this.isActionLoading = false});

  @override
  Widget build(BuildContext context) {
    /// The card opens the details screen; the action button keeps its own tap,
    /// so pressing it runs the action instead of navigating away from it.
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
      child: Container(
      padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
        boxShadow: const [BoxShadow(color: Colors.black12, spreadRadius: 0, blurRadius: 8, offset: Offset(0, 3))],
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

        Stack(children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
            child: CustomImageWidget(
              image: '${happyHourModel.imageFullUrl}',
              height: ResponsiveHelper.isDesktop(context) ? 200 : 140,
              width: Dimensions.webMaxWidth, fit: BoxFit.cover,
            ),
          ),

          (happyHourModel.isRunningNow ?? false) ? Positioned(
            top: Dimensions.paddingSizeSmall, left: Dimensions.paddingSizeSmall,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: const Color(0xff019463),
                borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
              ),
              child: Text(
                'running_now'.tr,
                style: robotoBold.copyWith(fontSize: Dimensions.fontSizeExtraSmall, color: Colors.white),
              ),
            ),
          ) : const SizedBox(),
        ]),
        SizedBox(height: Dimensions.paddingSizeSmall),

        Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(crossAxisAlignment: CrossAxisAlignment.start, children: [

            Expanded(child: Text(
              happyHourModel.title ?? '', maxLines: 1, overflow: TextOverflow.ellipsis,
              style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeDefault),
            )),
            SizedBox(width: Dimensions.paddingSizeSmall),

            happyHourModel.enrollmentState != null ? Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: _getStatusColor(context).$1,
                borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
              ),
              child: Text(
                happyHourModel.enrollmentState!.tr,
                style: robotoBold.copyWith(fontSize: Dimensions.fontSizeExtraSmall, color: _getStatusColor(context).$2),
              ),
            ) : const SizedBox(),

          ]),
          const SizedBox(height: Dimensions.paddingSizeExtraSmall),

          Text(
            '${'discount'.tr}: ${_getDiscount()}',
            style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).colorScheme.error),
          ),
          const SizedBox(height: Dimensions.paddingSizeSmall),

          Row(crossAxisAlignment: CrossAxisAlignment.end, children: [

            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

              Row(children: [

                Icon(Icons.calendar_today, size: 12, color: Theme.of(context).hintColor),
                const SizedBox(width: Dimensions.paddingSizeExtraSmall),
                Text(
                  _getRepeatText(),
                  style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).hintColor),
                ),

                /// A weekly rule does not say which days on its own, so they
                /// hang off an info icon instead of widening the card.
                HappyHourHelper.hasWeeklyDays(happyHourModel) ? Padding(
                  padding: const EdgeInsets.only(left: Dimensions.paddingSizeExtraSmall),
                  child: CustomToolTip(
                    message: HappyHourHelper.weeklyDays(happyHourModel),
                    child: Icon(Icons.info_outline, size: 14, color: Colors.blueAccent),
                  ),
                ) : const SizedBox(),
                const SizedBox(width: Dimensions.paddingSizeSmall),

                /// A custom schedule keeps its times per occurrence, so there is
                /// no single window to show here.
                if(_getTimeRange().isNotEmpty) ...[
                  Icon(Icons.access_time, size: 12, color: Theme.of(context).hintColor),
                  const SizedBox(width: Dimensions.paddingSizeExtraSmall),
                  Flexible(child: Text(
                    _getTimeRange(), maxLines: 1, overflow: TextOverflow.ellipsis,
                    style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).hintColor),
                  )),
                ],

              ]),
              const SizedBox(height: Dimensions.paddingSizeExtraSmall),

              Row(children: [

                Icon(Icons.date_range, size: 12, color: Theme.of(context).hintColor),
                const SizedBox(width: Dimensions.paddingSizeExtraSmall),
                Flexible(child: Text(
                  _getDateRange(), maxLines: 1, overflow: TextOverflow.ellipsis,
                  style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).hintColor),
                )),

              ]),

            ])),
            const SizedBox(width: Dimensions.paddingSizeSmall),

            /// The spinner sits where the button is, so this card is the only
            /// one that waits and it swaps straight to its new action.
            isActionLoading ? Container(
              height: 24, width: 60, alignment: Alignment.center,
              decoration: BoxDecoration(
                color: _buttonColor(context).withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
              ),
              child: SizedBox(
                height: 14, width: 14,
                child: CircularProgressIndicator(strokeWidth: 2, color: _buttonColor(context)),
              ),
            ) : CustomButtonWidget(
              margin: EdgeInsets.all(0),
              takeMinimumWidth: true,
              buttonText: _actionKey.tr,
              radius: Dimensions.radiusSmall,
              fontSize: Dimensions.fontSizeSmall, height: 24,
              color: _buttonColor(context),
              onPressed: onActionPressed,
            ),

          ]),

        ]),

      ]),
      ),
    );
  }

  String _getDiscount() => HappyHourHelper.discount(happyHourModel);

  String _getRepeatText() => HappyHourHelper.repeatText(happyHourModel);

  String _getTimeRange() => HappyHourHelper.timeRange(happyHourModel);

  String _getDateRange() => HappyHourHelper.dateRange(happyHourModel);

  (Color bg, Color textColor) _getStatusColor(BuildContext context) => HappyHourHelper.statusColor(context, happyHourModel.enrollmentState);

  String get _actionKey => HappyHourHelper.actionKey(happyHourModel);

  Color _buttonColor(BuildContext context) => HappyHourHelper.actionColor(context, _actionKey);
}
