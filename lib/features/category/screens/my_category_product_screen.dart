import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stackfood_multivendor_restaurant/common/widgets/custom_app_bar_widget.dart';
import 'package:stackfood_multivendor_restaurant/common/widgets/product_shimmer_widget.dart';
import 'package:stackfood_multivendor_restaurant/common/widgets/product_widget.dart';
import 'package:stackfood_multivendor_restaurant/features/category/controllers/category_controller.dart';
import 'package:stackfood_multivendor_restaurant/util/dimensions.dart';

class MyCategoryProductScreen extends StatefulWidget {
  final int categoryId;
  final String categoryName;
  const MyCategoryProductScreen({super.key, required this.categoryId, required this.categoryName});

  @override
  State<MyCategoryProductScreen> createState() => _MyCategoryProductScreenState();
}

class _MyCategoryProductScreenState extends State<MyCategoryProductScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_){
      Get.find<CategoryController>().getStoreCategoryItemList(offset: '1', id: widget.categoryId);

      _scrollController.addListener(() {
        final ctrl = Get.find<CategoryController>();
        if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent
            && ctrl.storeCategoryItemList != null
            && !ctrl.isStoreCategoryItemLoading) {
          final int pageSize = (ctrl.storeCategoryItemPageSize! / 10).ceil();
          if (ctrl.storeCategoryItemOffset < pageSize) {
            ctrl.setStoreCategoryItemOffset(ctrl.storeCategoryItemOffset + 1);
            ctrl.showStoreCategoryItemBottomLoader();
            ctrl.getStoreCategoryItemList(
              offset: ctrl.storeCategoryItemOffset.toString(),
              id: widget.categoryId,
            );
          }
        }
      });
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBarWidget(title: widget.categoryName),
      body: GetBuilder<CategoryController>(builder: (ctrl) {
        return SingleChildScrollView(
          controller: _scrollController,
          padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
          child: Column(children: [

            ctrl.storeCategoryItemList != null
                ? ctrl.storeCategoryItemList!.isNotEmpty
                    ? GridView.builder(
                        key: UniqueKey(),
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisSpacing: Dimensions.paddingSizeLarge,
                          mainAxisSpacing: 0.01,
                          crossAxisCount: 1,
                          mainAxisExtent: 120,
                        ),
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: ctrl.storeCategoryItemList!.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.only(bottom: Dimensions.paddingSizeDefault),
                            child: ProductWidget(
                              product: ctrl.storeCategoryItemList![index],
                              index: index,
                              length: ctrl.storeCategoryItemList!.length,
                              isCampaign: false,
                              inRestaurant: true,
                            ),
                          );
                        },
                      )
                    : Padding(
                        padding: const EdgeInsets.only(top: 300),
                        child: Center(child: Text('no_food_available'.tr)),
                      )
                : GridView.builder(
                    key: UniqueKey(),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisSpacing: Dimensions.paddingSizeLarge,
                      mainAxisSpacing: 0.01,
                      crossAxisCount: 1,
                      mainAxisExtent: 120,
                    ),
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: 20,
                    itemBuilder: (context, index) => ProductShimmerWidget(),
                  ),

            if (ctrl.isStoreCategoryItemLoading)
              Padding(
                padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                child: Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor),
                  ),
                ),
              ),

          ]),
        );
      }),
    );
  }
}
