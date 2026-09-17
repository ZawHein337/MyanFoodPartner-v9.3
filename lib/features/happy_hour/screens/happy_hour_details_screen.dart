import 'package:stackfood_multivendor_restaurant/common/widgets/custom_app_bar_widget.dart';
import 'package:stackfood_multivendor_restaurant/common/widgets/custom_button_widget.dart';
import 'package:stackfood_multivendor_restaurant/common/widgets/custom_image_widget.dart';
import 'package:stackfood_multivendor_restaurant/common/widgets/readmore_widget.dart';
import 'package:stackfood_multivendor_restaurant/features/happy_hour/controllers/happy_hour_controller.dart';
import 'package:stackfood_multivendor_restaurant/features/happy_hour/domain/models/happy_hour_model.dart';
import 'package:stackfood_multivendor_restaurant/helper/happy_hour_action_helper.dart';
import 'package:stackfood_multivendor_restaurant/helper/happy_hour_helper.dart';
import 'package:stackfood_multivendor_restaurant/helper/price_converter_helper.dart';
import 'package:stackfood_multivendor_restaurant/helper/route_helper.dart';
import 'package:stackfood_multivendor_restaurant/helper/responsive_helper.dart';
import 'package:stackfood_multivendor_restaurant/util/dimensions.dart';
import 'package:stackfood_multivendor_restaurant/util/images.dart';
import 'package:stackfood_multivendor_restaurant/util/styles.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HappyHourDetailsScreen extends StatefulWidget {
  final int happyHourId;
 
  final bool fromNotification;
  const HappyHourDetailsScreen({super.key, required this.happyHourId, this.fromNotification = false});

  @override
  State<HappyHourDetailsScreen> createState() => _HappyHourDetailsScreenState();
}

class _HappyHourDetailsScreenState extends State<HappyHourDetailsScreen> {

  bool _descriptionExpanded = false;

  late final TapGestureRecognizer _descriptionTapRecognizer = TapGestureRecognizer()
    ..onTap = () => setState(() => _descriptionExpanded = !_descriptionExpanded);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Get.find<HappyHourController>().getHappyHourDetails(widget.happyHourId);
    });
  }

  @override
  void dispose() {
    _descriptionTapRecognizer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<HappyHourController>(builder: (happyHourController) {
      final HappyHourModel? happyHour = happyHourController.happyHourDetails;

      return PopScope(
        canPop: !widget.fromNotification,
        onPopInvokedWithResult: (didPop, result) {
          if(!didPop && widget.fromNotification) {
            Get.offAllNamed(RouteHelper.getInitialRoute());
          }
        },
        child: Scaffold(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,

          appBar: CustomAppBarWidget(
            title: happyHour == null ? 'happy_hour'.tr : happyHour.title ?? '',
            titleSuffix: happyHour == null ? null : _buildStatusBadge(context, happyHour),
            onBackPressed: widget.fromNotification ? () => Get.offAllNamed(RouteHelper.getInitialRoute()) : null,
          ),

          body: happyHour == null ? happyHourController.happyHourNotFound
              ? _buildNotFound(context) : const Center(child: CircularProgressIndicator()) : Column(children: [

            Expanded(child: SingleChildScrollView(
              padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
              physics: const AlwaysScrollableScrollPhysics(),
              child: Center(child: Container(
                width: Dimensions.webMaxWidth,
                padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                  boxShadow: const [BoxShadow(color: Colors.black12, spreadRadius: 0, blurRadius: 8, offset: Offset(0, 3))],
                ),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

                  Stack(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                        child: CustomImageWidget(
                          image: '${happyHour.imageFullUrl}', placeholder: Images.restaurantCover,
                          height: ResponsiveHelper.isDesktop(context) ? 200 : 140,
                          width: Dimensions.webMaxWidth, fit: BoxFit.cover,
                        ),
                      ),
                      (happyHour.isRunningNow ?? false) ? Positioned(
                        top: Dimensions.paddingSizeExtraSmall,
                        left: Dimensions.paddingSizeExtraSmall,
                        child: Row(
                          mainAxisSize: MainAxisSize.min, spacing: 5,
                          children: [
                            Container(height:10, width: 10, decoration: BoxDecoration( color: Color(0xff019463), shape: BoxShape.circle,),),

                            Text(
                              'running'.tr,
                              style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeExtraSmall, color: Color(0xff019463)),
                            ),
                          ],
                        ),
                      ) : const SizedBox(),
                    ],
                  ),
                  const SizedBox(height: Dimensions.paddingSizeDefault),

                  Text(
                    happyHour.title ?? '',
                    style: robotoBold.copyWith(fontSize: Dimensions.fontSizeDefault),
                  ),

                  const SizedBox(height: Dimensions.paddingSizeExtraSmall),

                  _buildDescription(context, happyHour),
                  const SizedBox(height: Dimensions.paddingSizeDefault),

                  Divider(height: 1, color: Theme.of(context).disabledColor.withValues(alpha: 0.3)),

                  Container(
                    padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
                    decoration: BoxDecoration(
                      color: Theme.of(context).disabledColor.withAlpha(50),
                      borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                    ),
                    child: Column(
                      children: [
                        _buildInfoRow(context, 'discount'.tr, HappyHourHelper.discount(happyHour)),
                        _buildInfoRow(context, 'minimum_order_amount'.tr, PriceConverter.convertPrice(happyHour.minOrderAmount ?? 0)),
                        /// A custom schedule keeps its window per occurrence, so
                        /// there is no single one to state here.
                        if(HappyHourHelper.timeRange(happyHour).isNotEmpty)
                          _buildInfoRow(context, 'offer_active'.tr, HappyHourHelper.timeRange(happyHour)),
                        _buildInfoRow(context, 'repeat'.tr, HappyHourHelper.repeatText(happyHour)),
                        if(HappyHourHelper.hasWeeklyDays(happyHour))
                          _buildInfoRow(context, 'weekly'.tr, HappyHourHelper.weeklyDays(happyHour)),
                        _buildInfoRow(context, 'validity'.tr, HappyHourHelper.dateRange(happyHour), isLast: true),
                      ],
                    ),
                  ),

                  _buildRejectionReason(context, happyHour),

                  _buildIneligibleNote(context, happyHour),

                  _buildSchedule(context, happyHour),

                ]),
              )),
            )),

            _buildActionBar(context, happyHourController, happyHour),

          ]),
        ),
      );
    });
  }

  /// The happy hour has been deleted, so there is nothing to show and no action
  /// to offer — only a way out, back to wherever the screen was opened from.
  Widget _buildNotFound(BuildContext context) {
    return Center(child: Padding(
      padding: const EdgeInsets.all(Dimensions.paddingSizeLarge),
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [

        Icon(Icons.event_busy, size: 50, color: Theme.of(context).disabledColor),
        const SizedBox(height: Dimensions.paddingSizeDefault),

        Text(
          'happy_hour_no_longer_available'.tr, textAlign: TextAlign.center,
          style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeLarge),
        ),
        const SizedBox(height: Dimensions.paddingSizeSmall),

        Text(
          'this_happy_hour_has_been_removed'.tr, textAlign: TextAlign.center,
          style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).hintColor),
        ),
        const SizedBox(height: Dimensions.paddingSizeExtraLarge),

        SizedBox(width: 200, child: CustomButtonWidget(
          buttonText: 'back'.tr, height: 50,
          onPressed: () => widget.fromNotification ? Get.offAllNamed(RouteHelper.getInitialRoute()) : Get.back(),
        )),

      ]),
    ));
  }

  /// Status chip beside the app bar title, tinted the same way the happy hour
  /// card badge is.
  Widget? _buildStatusBadge(BuildContext context, HappyHourModel happyHour) {
    if(happyHour.enrollmentState == null || happyHour.enrollmentState!.isEmpty) {
      return null;
    }

    final (Color bg, Color textColor) statusColor = HappyHourHelper.statusColor(context, happyHour.enrollmentState);

    return Row(
      spacing: Dimensions.paddingSizeSmall, children: [
        Text( ' #${happyHour.id ?? ''}', style: robotoSemiBold.copyWith(fontSize: Dimensions.fontSizeLarge),),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall, vertical: Dimensions.paddingSizeExtraSmall),
          decoration: BoxDecoration(
            color: statusColor.$1,
            borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
          ),
          child: Text(
            happyHour.enrollmentState!.tr,
            style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeSmall, color: statusColor.$2),
          ),
        ),
      ],
    );
  }

  /// Who refused and why, so a rejected restaurant is not left guessing. Either
  /// side can have said no, and a refusal carries no reason of its own when the
  /// restaurant is the one that declined — so the two are shown independently.
  Widget _buildRejectionReason(BuildContext context, HappyHourModel happyHour) {
    final String? rejectedBy = HappyHourHelper.rejectedByText(happyHour);
    final String? reason = happyHour.enrollment?.rejectionReason;
    final bool hasReason = reason != null && reason.isNotEmpty;

    if(rejectedBy == null && !hasReason) {
      return const SizedBox();
    }

    return Padding(
      padding: const EdgeInsets.only(top: Dimensions.paddingSizeDefault),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.error.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
        ),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

          if(rejectedBy != null) Text(
            rejectedBy,
            style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).colorScheme.error),
          ),

          if(rejectedBy != null && hasReason) const SizedBox(height: Dimensions.paddingSizeExtraSmall),

          if(hasReason) Text(
            '${'rejection_reason'.tr}: $reason',
            style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).colorScheme.error),
          ),

        ]),
      ),
    );
  }

  /// The server's own words for why this restaurant cannot join, shown instead
  /// of letting the join button fail with a 403.
  Widget _buildIneligibleNote(BuildContext context, HappyHourModel happyHour) {
    if((happyHour.isEligible ?? true) || happyHour.ineligibleReason == null || happyHour.ineligibleReason!.isEmpty) {
      return const SizedBox();
    }

    return Padding(
      padding: const EdgeInsets.only(top: Dimensions.paddingSizeDefault),
      child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [

        Icon(Icons.info_outline, size: 16, color: Theme.of(context).hintColor),
        const SizedBox(width: Dimensions.paddingSizeExtraSmall),

        Expanded(child: Text(
          happyHour.ineligibleReason!,
          style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).hintColor),
        )),

      ]),
    );
  }

  /// Every occurrence from today onward. A permanent weekly rule returns none
  /// and is already described by the weekly row above.
  Widget _buildSchedule(BuildContext context, HappyHourModel happyHour) {
    if(happyHour.dates == null || happyHour.dates!.isEmpty) {
      return const SizedBox();
    }

    return Padding(
      padding: const EdgeInsets.only(top: Dimensions.paddingSizeDefault),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

        Text('upcoming_schedule'.tr, style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeDefault)),
        const SizedBox(height: Dimensions.paddingSizeSmall),

        ...happyHour.dates!.map((date) => Padding(
          padding: const EdgeInsets.only(bottom: Dimensions.paddingSizeExtraSmall),
          child: Row(children: [

            Icon(Icons.event, size: 14, color: Theme.of(context).hintColor),
            const SizedBox(width: Dimensions.paddingSizeExtraSmall),

            Expanded(child: Text(
              HappyHourHelper.formatDate(date.applicableDate),
              style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall),
            )),

            Text(
              '${HappyHourHelper.formatTime(date.startTime)} - ${HappyHourHelper.formatTime(date.endTime)}',
              style: robotoRegular.copyWith(
                fontSize: Dimensions.fontSizeSmall,
                color: (date.status ?? true) ? Theme.of(context).hintColor : Theme.of(context).disabledColor,
              ),
            ),

          ]),
        )),

      ]),
    );
  }

  Widget _buildDescription(BuildContext context, HappyHourModel happyHour) {
    final String description = happyHour.shortDescription ?? '';

    final TextStyle descriptionStyle = robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).hintColor);
    final TextStyle linkStyle = robotoMedium.copyWith(fontSize: Dimensions.fontSizeSmall, color: const Color(0xFF245BD1));

    return ReadMoreText(
      description,
      style: descriptionStyle,
      trimMode: TrimMode.Line,
      trimLines: 2,
      colorClickableText: Colors.blueAccent,
      lessStyle: linkStyle,
      moreStyle: linkStyle,
      trimCollapsedText: 'see_more'.tr,
      trimExpandedText: ' ${'see_less'.tr}',
    );
  }

  Widget _buildInfoRow(BuildContext context, String title, String value, {bool isLast = false}) {
    return Padding(
      padding: EdgeInsets.only(bottom: isLast ? 0 : Dimensions.paddingSizeDefault),
      child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [

        Text(title, style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).hintColor)),
        const SizedBox(width: Dimensions.paddingSizeDefault),

        /// The value stays on one line — a long one (the validity span) is
        /// scaled down to fit rather than wrapping under its own label.
        /// `scaleDown` only ever shrinks, so a short value like "21%" keeps its
        /// normal size instead of being blown up to fill the row.
        Expanded(child: FittedBox(
          fit: BoxFit.scaleDown,
          alignment: AlignmentDirectional.centerEnd,
          child: Text(
            value, maxLines: 1,
            style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall),
          ),
        )),

      ]),
    );
  }

  Widget _buildActionBar(BuildContext context, HappyHourController happyHourController, HappyHourModel happyHour) {
    final String actionKey = HappyHourHelper.actionKey(happyHour);
    final bool canRespond = happyHour.actions?.canRespond ?? false;

    final bool isActionLoading = happyHourController.isActionLoadingFor(happyHour.id);
    final bool primaryEnabled = !isActionLoading && actionKey != 'view';

    return Container(
      padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        boxShadow: [BoxShadow(color: Theme.of(context).disabledColor.withValues(alpha: 0.2), spreadRadius: 0, blurRadius: 8, offset: const Offset(0, -3))],
      ),
      child: SafeArea(
        top: false,
        /// The bar keeps its buttons while the action runs — the primary one
        /// carries the spinner itself, so it swaps straight to the action it
        /// has become instead of the bar disappearing and coming back.
        child: Row(children: [

            Expanded(child: canRespond ? CustomButtonWidget(
              buttonText: 'deny'.tr,
              color: Theme.of(context).colorScheme.error.withValues(alpha: 0.1),
              textColor: Theme.of(context).colorScheme.error,
              height: 50,
              onPressed: isActionLoading ? null : () => HappyHourActionHelper.deny(happyHour),
            ) : CustomButtonWidget(
              buttonText: actionKey == 'cancel' ? 'close'.tr : 'cancel'.tr,
              color: Theme.of(context).disabledColor.withValues(alpha: 0.2),
              textColor: Theme.of(context).textTheme.bodyLarge!.color,
              height: 50,
              onPressed: () => widget.fromNotification ? Get.offAllNamed(RouteHelper.getInitialRoute()) : Get.back(),
            )),
            const SizedBox(width: Dimensions.paddingSizeDefault),

            Expanded(child: CustomButtonWidget(
              buttonText: actionKey.tr,
              isLoading: isActionLoading,
              color: primaryEnabled ? HappyHourHelper.actionColor(context, actionKey) : Theme.of(context).disabledColor,
              buttonDisabledColor: isActionLoading ? HappyHourHelper.actionColor(context, actionKey) : null,
              height: 50,
              onPressed: primaryEnabled ? () => HappyHourActionHelper.run(happyHour, actionKey: actionKey) : null,
            )),

        ]),
      ),
    );
  }

}
