import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stackfood_multivendor_restaurant/common/widgets/custom_app_bar_widget.dart';
import 'package:stackfood_multivendor_restaurant/common/widgets/custom_asset_image_widget.dart';
import 'package:stackfood_multivendor_restaurant/common/widgets/custom_bottom_sheet_widget.dart';
import 'package:stackfood_multivendor_restaurant/features/expense/enum/filter_type.dart';
import 'package:stackfood_multivendor_restaurant/features/reports/controllers/report_controller.dart';
import 'package:stackfood_multivendor_restaurant/features/reports/screens/tax/widgets/tax_report_bottom_sheet.dart';
import 'package:stackfood_multivendor_restaurant/helper/date_converter_helper.dart';
import 'package:stackfood_multivendor_restaurant/helper/extensions_helper.dart';
import 'package:stackfood_multivendor_restaurant/helper/price_converter_helper.dart';
import 'package:stackfood_multivendor_restaurant/util/dimensions.dart';
import 'package:stackfood_multivendor_restaurant/util/images.dart';
import 'package:stackfood_multivendor_restaurant/util/styles.dart';

class TaxReportScreen extends StatefulWidget {
  const TaxReportScreen({super.key});

  @override
  State<TaxReportScreen> createState() => _TaxReportScreenState();
}

class _TaxReportScreenState extends State<TaxReportScreen> {
  final ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    Get.find<ReportController>().initTaxReportDate();
    Get.find<ReportController>().setOffset(1);

    Get.find<ReportController>().getTaxReport(
      offset: Get.find<ReportController>().offset.toString(),
      from: Get.find<ReportController>().from, to: Get.find<ReportController>().to,
    );

    scrollController.addListener(() {
      if (scrollController.position.pixels == scrollController.position.maxScrollExtent
          && Get.find<ReportController>().orderList != null && !Get.find<ReportController>().isLoading) {
        int pageSize = (Get.find<ReportController>().pageSize! / 10).ceil();
        if (Get.find<ReportController>().offset < pageSize) {
          Get.find<ReportController>().setOffset(Get.find<ReportController>().offset+1);
          debugPrint('end of the page');
          Get.find<ReportController>().showBottomLoader();
          Get.find<ReportController>().getTaxReport(
            offset: Get.find<ReportController>().offset.toString(),
            from: Get.find<ReportController>().from, to: Get.find<ReportController>().to,
          );
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ReportController>(builder: (reportController) {
      return Scaffold(
        appBar: CustomAppBarWidget(
          title: 'vat_report'.tr,
          menuWidget: PopupMenuButton(
            position: PopupMenuPosition.under,
            itemBuilder: (context) {
              return <PopupMenuEntry>[
                PopupMenuItem(
                  value: FilterType.all,
                  child: SizedBox(width: 100, child: Text('all_the_time'.tr, style: robotoRegular)),
                ),

                PopupMenuItem(
                  value: FilterType.thisYear,
                  child: Text('this_year'.tr, style: robotoRegular),
                ),

                PopupMenuItem(
                  value: FilterType.previousYear,
                  child: Text('previous_year'.tr, style: robotoRegular),
                ),

                PopupMenuItem(
                  value: FilterType.thisMonth,
                  child: Text('this_month'.tr, style: robotoRegular),
                ),

                PopupMenuItem(
                  value: FilterType.thisWeek,
                  child: Text('this_week'.tr, style: robotoRegular),
                ),

                PopupMenuItem(
                  value: FilterType.custom,
                  child: Text('custom'.tr, style: robotoRegular),
                ),

              ];
            },
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(Dimensions.radiusDefault)),
            child: Container(
              padding: const EdgeInsets.all(Dimensions.paddingSizeExtraSmall + 3),
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor.withValues(alpha: 0.05),
                borderRadius: BorderRadius.circular(Dimensions.radiusMedium),
                border: Border.all(color: Theme.of(context).primaryColor, width: 1),
              ),
              child: Icon(Icons.tune_rounded, color: Theme.of(context).primaryColor, size: 20),
            ),
            onSelected: (dynamic value) {
              if (value == FilterType.all) {
                reportController.setFilter(FilterType.all.name);
              }else if (value == FilterType.thisYear) {
                reportController.setFilter(FilterType.thisYear.name);
              }else if (value == FilterType.previousYear) {
                reportController.setFilter(FilterType.previousYear.name);
              }else if (value == FilterType.thisMonth) {
                reportController.setFilter(FilterType.thisMonth.name);
              }else if (value == FilterType.thisWeek) {
                reportController.setFilter(FilterType.thisWeek.name);
              } else{
                reportController.showDatePicker(context, isTaxReport: true);
              }
            },
          ),
        ),

        body: reportController.taxReportModel != null && reportController.orderList != null ? SingleChildScrollView(
          controller: scrollController,
          padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
          child: Column(children: [

            Column(children: [

              Row(children: [

                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                    decoration: BoxDecoration(
                      color: const Color(0xffD89D4B).withValues(alpha: 0.05),
                      borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                    ),
                    child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [

                      Expanded(
                        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                          Text('total_orders'.tr, style: robotoRegular.copyWith(color: Theme.of(context).hintColor)),
                          const SizedBox(height: Dimensions.paddingSizeSmall),

                          Text(reportController.taxReportModel!.totalOrders.toString(), style: robotoBlack.copyWith(color: const Color(0xffD89D4B), fontSize: Dimensions.fontSizeExtraLarge)),
                        ]),
                      ),

                      CustomAssetImageWidget(image: Images.taxOrderIcon, height: 30, width: 30, color: Theme.of(context).hintColor),

                    ]),
                  ),
                ),
                const SizedBox(width: Dimensions.paddingSizeSmall),

                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                    decoration: BoxDecoration(
                      color: const Color(0xff0661CB).withValues(alpha: 0.05),
                      borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                    ),
                    child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [

                      Expanded(
                        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                          Text('total_order_amount'.tr, style: robotoRegular.copyWith(color: Theme.of(context).hintColor)),
                          const SizedBox(height: Dimensions.paddingSizeSmall),

                          Text(PriceConverter.convertPrice(reportController.taxReportModel?.totalOrderAmount ?? 0), style: robotoBlack.copyWith(color: const Color(0xff0661CB), fontSize: Dimensions.fontSizeExtraLarge)),
                        ]),
                      ),

                      const CustomAssetImageWidget(image: Images.taxAmountIcon, height: 30, width: 30),

                    ]),
                  ),
                ),

              ]),
              const SizedBox(height: Dimensions.paddingSizeSmall),

              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                decoration: BoxDecoration(
                  color: const Color(0xffFAF8F5),
                  borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                ),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

                  Row(children: [

                    Expanded(
                      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

                        Text('total_vat_amount'.tr, style: robotoRegular.copyWith(color: Theme.of(context).hintColor)),
                        const SizedBox(height: Dimensions.paddingSizeExtraSmall),

                        Text(PriceConverter.convertPrice(reportController.taxReportModel?.totalTax ?? 0), style: robotoBlack.copyWith(color: const Color(0xff00AA6D), fontSize: Dimensions.fontSizeExtraLarge)),

                      ]),
                    ),
                    const SizedBox(width: Dimensions.paddingSizeSmall),

                    const CustomAssetImageWidget(image: Images.taxReportIcon, height: 50, width: 50),

                  ]),
                  const SizedBox(height: Dimensions.paddingSizeLarge),

                  SizedBox(
                    height: 45,
                    child: ListView.builder(
                      itemCount: reportController.taxReportModel?.taxSummary?.length,
                      shrinkWrap: true,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) {
                        return Container(
                          padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                          margin: EdgeInsets.only(right: index == (reportController.taxReportModel?.taxSummary?.length ?? 0) - 1 ? 0 : Dimensions.paddingSizeSmall),
                          width: 240,
                          decoration: BoxDecoration(
                            color: Get.isDarkMode ? Theme.of(context).hintColor.withValues(alpha: 0.3) : Theme.of(context).cardColor,
                            borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                          ),
                          child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [

                            Text(
                              '${reportController.taxReportModel!.taxSummary?[index].taxName?.toTitleCase()} '
                                  '(${(double.parse(reportController.taxReportModel?.taxSummary?[index].taxLabel ?? '0')).toStringAsFixed(1)}%)',
                              style: robotoRegular.copyWith(
                                color: Theme.of(context).hintColor,
                                fontSize: Dimensions.fontSizeSmall,
                              ),
                            ),
                            Text(PriceConverter.convertPrice(reportController.taxReportModel!.taxSummary?[index].totalTax), style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeSmall)),

                          ]),
                        );
                      },
                    ),
                  ),

                ]),
              ),

            ]),

            reportController.orderList!.isNotEmpty ? ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeLarge),
              itemCount: reportController.orderList!.length,
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () {
                    showCustomBottomSheet(child: TaxReportBottomSheet(orderList: reportController.orderList![index]));
                  },
                  child: Container(
                    margin: const EdgeInsets.only(bottom: Dimensions.paddingSizeDefault),
                    decoration: BoxDecoration(
                      color: Theme.of(context).cardColor,
                      borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                      boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 5, spreadRadius: 0)],
                    ),
                    child: Column(children: [

                      Container(
                        padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
                        decoration: BoxDecoration(
                          color: Theme.of(context).hintColor.withValues(alpha: 0.15),
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(Dimensions.radiusDefault),
                            topRight: Radius.circular(Dimensions.radiusDefault),
                          ),
                        ),
                        child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [

                          Expanded(
                            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

                              Text('${'order'.tr} #${reportController.orderList?[index].id}', style: robotoMedium.copyWith(color: Theme.of(context).textTheme.bodyLarge!.color?.withValues(alpha: 0.6), fontSize: Dimensions.fontSizeSmall)),
                              const SizedBox(height: Dimensions.paddingSizeExtraSmall - 2),

                              Text(PriceConverter.convertPrice(reportController.orderList?[index].orderAmount), style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeLarge)),

                            ]),
                          ),

                          Text(DateConverter.dateTimeToMonthAndTime(reportController.orderList![index].createdAt!), style: robotoRegular.copyWith(color: Theme.of(context).hintColor, fontSize: Dimensions.fontSizeSmall), textAlign: TextAlign.end),

                        ]),
                      ),

                      Container(
                        padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
                        child: Row(children: [

                          Expanded(
                            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

                              Text('${'tax'.tr}: ${PriceConverter.convertPrice(reportController.orderList?[index].totalTaxAmount ?? 0)}', style: robotoBold.copyWith(color: Theme.of(context).primaryColor, fontSize: Dimensions.fontSizeLarge)),
                              const SizedBox(height: Dimensions.paddingSizeExtraSmall - 2),

                              reportController.orderList![index].orderTaxes!.isNotEmpty ? Wrap(
                                alignment: WrapAlignment.start,
                                children: List.generate(
                                  reportController.orderList![index].orderTaxes?.length ?? 0,
                                      (i) => Padding(
                                    padding: EdgeInsets.only(right: i == (reportController.orderList![index].orderTaxes?.length ?? 0) - 1 ? 0 : Dimensions.paddingSizeSmall),
                                    child: Text(
                                      '${reportController.orderList![index].orderTaxes?[i].taxName?.toTitleCase()} ${i == (reportController.orderList![index].orderTaxes?.length ?? 0) - 1 ? '' : ','}',
                                      style: robotoRegular.copyWith(color: Theme.of(context).textTheme.bodyLarge!.color?.withValues(alpha: 0.6), fontSize: Dimensions.fontSizeSmall),
                                      maxLines: 1, overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ),
                              ) : Text('no_tax'.tr, style: robotoRegular.copyWith(color: Theme.of(context).textTheme.bodyLarge!.color?.withValues(alpha: 0.6), fontSize: Dimensions.fontSizeSmall), textAlign: TextAlign.end),

                            ]),
                          ),

                          Container(
                            padding: const EdgeInsets.all(Dimensions.paddingSizeExtraSmall),
                            decoration: BoxDecoration(
                              color: Theme.of(context).cardColor,
                              borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                              boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 1, spreadRadius: 0)],
                            ),
                            child: Icon(Icons.arrow_forward, size: 20, color: Theme.of(context).primaryColor),
                          ),

                        ]),
                      ),

                    ]),
                  ),
                );
              },
            ) : Padding(
              padding: EdgeInsets.only(top: context.height * 0.2),
              child: Center(
                child: Text(
                  'no_tax_report_found'.tr,
                  style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeLarge, color: Theme.of(context).textTheme.bodyLarge!.color?.withValues(alpha: 0.6)),
                ),
              ),
            ),

          ]),
        ) : const Center(child: CircularProgressIndicator()),
      );
    });
  }
}
