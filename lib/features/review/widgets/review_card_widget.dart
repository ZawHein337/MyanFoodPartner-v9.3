import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stackfood_multivendor_restaurant/common/widgets/custom_button_widget.dart';
import 'package:stackfood_multivendor_restaurant/common/widgets/custom_image_widget.dart';
import 'package:stackfood_multivendor_restaurant/features/restaurant/domain/models/review_model.dart';
import 'package:stackfood_multivendor_restaurant/features/splash/controllers/splash_controller.dart';
import 'package:stackfood_multivendor_restaurant/helper/date_converter_helper.dart';
import 'package:stackfood_multivendor_restaurant/helper/route_helper.dart';
import 'package:stackfood_multivendor_restaurant/util/dimensions.dart';
import 'package:stackfood_multivendor_restaurant/util/images.dart';
import 'package:stackfood_multivendor_restaurant/util/styles.dart';

class ReviewCardWidget extends StatelessWidget {
  final ReviewModel review;
  const ReviewCardWidget({super.key, required this.review});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
        boxShadow: [BoxShadow(color: Colors.grey.withValues(alpha: 0.2), spreadRadius: 1, blurRadius: 10, offset: const Offset(0, 1))],
      ),
      child: Column(children: [

        Container(
          padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor.withValues(alpha: 0.8),
            borderRadius: const BorderRadius.only(topLeft: Radius.circular(Dimensions.radiusSmall), topRight: Radius.circular(Dimensions.radiusSmall)),
            boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), spreadRadius: -3, blurRadius: 6, offset: const Offset(0, 3))],
          ),
          child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [

            Row(children: [
              Text('${'order'.tr} # ', style: robotoRegular),
              Text(review.orderId.toString(), style: robotoBold),
            ]),

            Text(DateConverter.isoStringToLocalDateTimeOnly(review.createdAt!), style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).hintColor)),

          ]),
        ),

        Padding(
          padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
          child: Row(children: [

            ClipRRect(
              borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
              child: CustomImageWidget(
                image: '${review.foodImageFullUrl}',
                height: 60, width: 60, fit: BoxFit.cover,
                placeholder: Images.placeholder,
              ),
            ),
            const SizedBox(width: Dimensions.paddingSizeDefault),

            Expanded(
              child: Text(review.foodName ?? '', style: robotoBold, overflow: TextOverflow.ellipsis, maxLines: 1),
            ),
            const SizedBox(width: Dimensions.paddingSizeDefault),

            Get.find<SplashController>().configModel!.restaurantReviewReply ?? false ? CustomButtonWidget(
              onPressed: () => Get.toNamed(RouteHelper.getReviewReplyRoute(isGiveReply: review.reply != null ? false : true, review: review,  restaurantReviewReplyStatus: Get.find<SplashController>().configModel!.restaurantReviewReply!)),
              width: 95, height: 40,
              radius: 8,
              fontWeight: FontWeight.w500,
              fontSize: Dimensions.fontSizeDefault,
              buttonText: review.reply != null ? 'view_reply'.tr : 'give_reply'.tr,
              color: review.reply != null ? Colors.blue.withValues(alpha: 0.05) : Theme.of(context).primaryColor,
              textColor: review.reply != null ? Colors.blue : Theme.of(context).cardColor,
            ) : CustomButtonWidget(
              onPressed: () => Get.toNamed(RouteHelper.getReviewReplyRoute(isGiveReply: review.reply != null ? false : true, review: review, restaurantReviewReplyStatus: Get.find<SplashController>().configModel!.restaurantReviewReply!)),
              width: 95, height: 40,
              radius: 8,
              fontWeight: FontWeight.w500,
              fontSize: Dimensions.fontSizeDefault,
              buttonText: 'view'.tr,
              color: Theme.of(context).primaryColor,
            ),

          ]),
        ),

        Divider(height: 0, thickness: 1, color: Theme.of(context).hintColor.withValues(alpha: 0.2)),

        Padding(
          padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
          child: review.customerName != null || review.customerPhone != null ? Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text('reviewer'.tr, style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).hintColor)),
            const SizedBox(height: Dimensions.paddingSizeSmall),

            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Text(review.customerName ?? '', style: robotoBold),

              Text(review.customerPhone ?? '', style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).hintColor)),
            ]),
          ]) : Text('reviewer_not_found'.tr, style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).hintColor)),
        ),

      ]),
    );
  }
}
