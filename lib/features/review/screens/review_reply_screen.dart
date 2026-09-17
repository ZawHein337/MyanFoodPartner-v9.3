import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stackfood_multivendor_restaurant/common/widgets/custom_app_bar_widget.dart';
import 'package:stackfood_multivendor_restaurant/common/widgets/custom_button_widget.dart';
import 'package:stackfood_multivendor_restaurant/common/widgets/custom_image_widget.dart';
import 'package:stackfood_multivendor_restaurant/common/widgets/custom_text_field_widget.dart';
import 'package:stackfood_multivendor_restaurant/common/widgets/rating_bar_widget.dart';
import 'package:stackfood_multivendor_restaurant/features/restaurant/controllers/restaurant_controller.dart';
import 'package:stackfood_multivendor_restaurant/features/restaurant/domain/models/review_model.dart';
import 'package:stackfood_multivendor_restaurant/features/splash/controllers/splash_controller.dart';
import 'package:stackfood_multivendor_restaurant/helper/route_helper.dart';
import 'package:stackfood_multivendor_restaurant/util/dimensions.dart';
import 'package:stackfood_multivendor_restaurant/util/styles.dart';

class ReviewReplyScreen extends StatefulWidget {
  final bool isGiveReply;
  final ReviewModel review;
  final bool? restaurantReviewReplyStatus;
  const ReviewReplyScreen({super.key, required this.isGiveReply, required this.review, this.restaurantReviewReplyStatus = false});

  @override
  State<ReviewReplyScreen> createState() => _ReviewReplyScreenState();
}

class _ReviewReplyScreenState extends State<ReviewReplyScreen> {

  final TextEditingController _replyController = TextEditingController();

  @override
  void initState() {
    super.initState();

    if(widget.isGiveReply) {
      _replyController.text = widget.review.reply ?? '';
    }

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBarWidget(title: !widget.restaurantReviewReplyStatus! ? 'review'.tr : widget.restaurantReviewReplyStatus! && widget.isGiveReply ? 'review_reply'.tr : 'update_reply'.tr),
      body: GetBuilder<RestaurantController>(builder: (restaurantController) {
        return Column(children: [

          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

                  Row(children: [

                    ClipRRect(
                      borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                      child: CustomImageWidget(
                        image: '${widget.review.foodImageFullUrl}',
                        height: 60, width: 60, fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(width: Dimensions.paddingSizeSmall),

                    Expanded(
                      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

                        Text(widget.review.foodName ?? '', style: robotoBold, overflow: TextOverflow.ellipsis, maxLines: 1),
                        const SizedBox(height: Dimensions.paddingSizeExtraSmall),

                        RatingBarWidget(rating: widget.review.rating?.toDouble(), ratingCount: null, size: 20),
                      ]),
                    ),

                  ]),
                  const SizedBox(height: Dimensions.paddingSizeDefault),

                  Text(widget.review.customerName ?? '', style: robotoBold),
                  const SizedBox(height: Dimensions.paddingSizeExtraSmall),

                  Text(widget.review.comment ?? '', style: robotoRegular),

                  const SizedBox(height: Dimensions.paddingSizeLarge),

                  widget.restaurantReviewReplyStatus! ? widget.isGiveReply ? CustomTextFieldWidget(
                    controller: _replyController,
                    hintText: 'write_your_reply_here'.tr,
                    borderColor: Theme.of(context).hintColor,
                    maxLines: 4,
                  ) : Container(
                    width: context.width,
                    height: 120,
                    padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                      border: Border.all(color: Theme.of(context).primaryColor.withValues(alpha: 0.2)),
                    ),
                    child: Text(widget.review.reply ?? '', style: robotoRegular, maxLines: 5, overflow: TextOverflow.ellipsis),
                  ) : const SizedBox(),

                ]),
              ),
            ),
          ),

          widget.restaurantReviewReplyStatus! ? Container(
            padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              boxShadow: [BoxShadow(color: Colors.grey.withValues(alpha: 0.2), spreadRadius: 1, blurRadius: 10, offset: const Offset(0, 1))],
            ),
            child: !restaurantController.isLoading ? CustomButtonWidget(
              onPressed: () {
                if(widget.isGiveReply) {
                  restaurantController.updateReply(widget.review.id!, _replyController.text);
                }else {
                  Get.offNamed(RouteHelper.getReviewReplyRoute(isGiveReply: true, review: widget.review, restaurantReviewReplyStatus: Get.find<SplashController>().configModel!.restaurantReviewReply!));
                }
              },
              buttonText: widget.isGiveReply ? 'send_reply'.tr : 'update_review_reply'.tr,
              radius: Dimensions.radiusDefault,
            ) : const Center(child: CircularProgressIndicator()),
          ) : const SizedBox(),

        ]);
      }),
    );
  }
}
