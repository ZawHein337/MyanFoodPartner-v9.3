import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stackfood_multivendor_restaurant/common/widgets/custom_app_bar_widget.dart';
import 'package:stackfood_multivendor_restaurant/common/widgets/custom_asset_image_widget.dart';
import 'package:stackfood_multivendor_restaurant/common/widgets/custom_bottom_sheet_widget.dart';
import 'package:stackfood_multivendor_restaurant/common/widgets/custom_button_widget.dart';
import 'package:stackfood_multivendor_restaurant/common/widgets/custom_image_widget.dart';
import 'package:stackfood_multivendor_restaurant/common/widgets/custom_ink_well_widget.dart';
import 'package:stackfood_multivendor_restaurant/features/bogo_offer/controllers/bogo_offer_controller.dart';
import 'package:stackfood_multivendor_restaurant/features/bogo_offer/domain/models/bogo_offer_model.dart';
import 'package:stackfood_multivendor_restaurant/features/bogo_offer/screen/bogo_offer_setup_screen.dart';
import 'package:stackfood_multivendor_restaurant/features/bogo_offer/widgets/leave_bogo_offer_confirmation_bottom_sheet.dart';
import 'package:stackfood_multivendor_restaurant/helper/date_converter_helper.dart';
import 'package:stackfood_multivendor_restaurant/helper/route_helper.dart';
import 'package:stackfood_multivendor_restaurant/util/dimensions.dart';
import 'package:stackfood_multivendor_restaurant/util/images.dart';
import 'package:stackfood_multivendor_restaurant/util/styles.dart';

part "../widgets/offer_card.dart";

class BogoCampaignListScreen extends StatefulWidget {
  final bool fromNotification;
  const BogoCampaignListScreen({super.key, this.fromNotification = false});

  @override
  State<BogoCampaignListScreen> createState() => _BogoCampaignListScreenState();
}

class _BogoCampaignListScreenState extends State<BogoCampaignListScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    Get.find<BogoOfferController>().getBogoOfferList(offset: '1');
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    final BogoOfferController bogoOfferController = Get.find<BogoOfferController>();

    if(_scrollController.position.pixels == _scrollController.position.maxScrollExtent
        && bogoOfferController.bogoOfferList != null && !bogoOfferController.isLoading) {
      final int pageSize = ((bogoOfferController.pageSize ?? 0) / 25).ceil();
      if(bogoOfferController.offset < pageSize) {
        bogoOfferController.setOffset(bogoOfferController.offset + 1);
        bogoOfferController.showBottomLoader();
        bogoOfferController.getBogoOfferList(offset: bogoOfferController.offset.toString());
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: Navigator.canPop(context),
      onPopInvokedWithResult: (didPop, result) async {
        if(widget.fromNotification) {
          Get.offAllNamed(RouteHelper.getInitialRoute());
        }else {
          return;
        }
      },
      child: Scaffold(
        appBar: CustomAppBarWidget(title: 'bogo_offer_list'.tr, onBackPressed: () {
          if(widget.fromNotification) {
            Get.offAllNamed(RouteHelper.getInitialRoute());
          }else {
            Get.back();
          }
        }),

        body: GetBuilder<BogoOfferController>(builder: (bogoOfferController) {
          final List<BogoOffer>? offerList = bogoOfferController.bogoOfferList;

          if(offerList == null) {
            return const Center(child: CircularProgressIndicator());
          }

          return offerList.isNotEmpty ? ListView.separated(
            controller: _scrollController,
            padding: const EdgeInsets.all(16),
            itemCount: offerList.length + 1,
            separatorBuilder: (context, index) => const SizedBox(height: Dimensions.paddingSizeSmall),
            itemBuilder: (context, index) {
              if(index == offerList.length) {
                return bogoOfferController.isLoading ? const Center(child: Padding(
                  padding: EdgeInsets.all(Dimensions.paddingSizeSmall),
                  child: CircularProgressIndicator(),
                )) : const SizedBox();
              }
              return _OfferCard(offer: offerList[index]);
            },
          ) : Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            const CustomAssetImageWidget(image: Images.bogoOfferIcon, height: 50, width: 50),
            const SizedBox(height: Dimensions.paddingSizeDefault),

            Text('no_bogo_offer_found'.tr, style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeLarge, color: Theme.of(context).hintColor)),
          ]));
        }),
      ),
    );
  }
}
