import 'package:animated_flip_counter/animated_flip_counter.dart';
import 'package:flutter/cupertino.dart';
import 'package:just_the_tooltip/just_the_tooltip.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stackfood_multivendor_restaurant/common/widgets/custom_button_widget.dart';
import 'package:stackfood_multivendor_restaurant/common/widgets/custom_image_widget.dart';
import 'package:stackfood_multivendor_restaurant/common/widgets/custom_snackbar_widget.dart';
import 'package:stackfood_multivendor_restaurant/common/widgets/custom_tool_tip_widget.dart';
import 'package:stackfood_multivendor_restaurant/common/widgets/discount_tag_widget.dart';
import 'package:stackfood_multivendor_restaurant/common/widgets/rating_bar_widget.dart';
import 'package:stackfood_multivendor_restaurant/features/order/controllers/order_edit_controller.dart';
import 'package:stackfood_multivendor_restaurant/features/order/domain/models/cart_model.dart';
import 'package:stackfood_multivendor_restaurant/features/order/widgets/discount_tag_without_image_widget.dart';
import 'package:stackfood_multivendor_restaurant/features/order/widgets/edit_order/quantity_button_widget.dart';
import 'package:stackfood_multivendor_restaurant/features/restaurant/domain/models/product_model.dart';
import 'package:stackfood_multivendor_restaurant/features/splash/controllers/splash_controller.dart';
import 'package:stackfood_multivendor_restaurant/helper/date_converter_helper.dart';
import 'package:stackfood_multivendor_restaurant/helper/price_converter_helper.dart';
import 'package:stackfood_multivendor_restaurant/helper/responsive_helper.dart';
import 'package:stackfood_multivendor_restaurant/util/dimensions.dart';
import 'package:stackfood_multivendor_restaurant/util/images.dart';
import 'package:stackfood_multivendor_restaurant/util/styles.dart';

class ProductBottomSheetWidget extends StatefulWidget {
  final Product? product;
  final CartModel? cart;
  final int? cartIndex;
  const ProductBottomSheetWidget({super.key, required this.product, this.cart, this.cartIndex});

  @override
  State<ProductBottomSheetWidget> createState() => _ProductBottomSheetWidgetState();
}

class _ProductBottomSheetWidgetState extends State<ProductBottomSheetWidget> {

  JustTheController tooTipController = JustTheController();
  final ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    OrderEditController orderEditController = Get.find<OrderEditController>();

    orderEditController.initData(widget.product, widget.cart);
    String? warning = orderEditController.checkOutOfStockVariationSelected(widget.product?.variations);
    if(warning != null) {
      showCustomSnackBar(warning);
    }

    if(widget.product != null && (widget.product!.variations?.isEmpty ?? true)) {
      orderEditController.setExistInCart(widget.product!);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 550,
      margin: EdgeInsets.only(top: GetPlatform.isWeb ? 0 : 30),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: const BorderRadius.all(Radius.circular(Dimensions.radiusExtraLarge)),
      ),
      child: GetBuilder<OrderEditController>(builder: (orderEditController) {
        Product? product = widget.product;
        double price = product!.price!;
        double? discount = product.discount;
        String? discountType = product.discountType;
        double variationPrice = _getVariationPrice(product, orderEditController);
        double variationPriceWithDiscount = _getVariationPriceWithDiscount(product, orderEditController, discount, discountType);
        double priceWithDiscountForView = PriceConverter.convertWithDiscount(price, discount, discountType)!;
        double priceWithDiscount = PriceConverter.convertWithDiscount(price, discount, discountType)!;

        double addonsCost = _getAddonCost(product, orderEditController);
        List<AddOn> addOnIdList = _getAddonIdList(product, orderEditController);
        List<AddOns> addOnsList = _getAddonList(product, orderEditController);

        debugPrint('===total : $addonsCost + (($variationPriceWithDiscount + $price) , $discount , $discountType ) * ${orderEditController.quantity}');
        double priceWithAddonsVariationWithDiscount = addonsCost + (PriceConverter.convertWithDiscount(variationPrice + price , discount, discountType)! * orderEditController.quantity);
        double priceWithAddonsVariation = ((price + variationPrice) * orderEditController.quantity) + addonsCost;
        double priceWithVariation = price + variationPrice;
        bool isAvailable = DateConverter.isAvailable(product.availableTimeStarts, product.availableTimeEnds);

        return ConstrainedBox(
          constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.8),
          child: Stack(
            children: [

              Column( mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(height: GetPlatform.isIOS ? Dimensions.paddingSizeLarge : 0),

                  Flexible(
                    child: SingleChildScrollView(
                      controller: scrollController,
                      padding: const EdgeInsets.only(left: Dimensions.paddingSizeDefault, bottom: Dimensions.paddingSizeDefault),
                      child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.end, children: [
                        Padding(
                          padding: EdgeInsets.only(
                            right: Dimensions.paddingSizeDefault, top: Dimensions.paddingSizeDefault,
                          ),
                          child: Column(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.start, children: [

                            ///Product
                            Row(mainAxisAlignment: MainAxisAlignment.center, children: [

                              (product.imageFullUrl != null && product.imageFullUrl!.isNotEmpty) ? Stack(children: [

                                ClipRRect(
                                  borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                                  child: CustomImageWidget(
                                    image: '${product.imageFullUrl}',
                                    width: 100, height: 100, fit: BoxFit.cover,
                                  ),
                                ),

                                DiscountTagWidget(discount: discount, discountType: discountType),

                              ]) : const SizedBox.shrink(),
                              const SizedBox(width: Dimensions.paddingSizeSmall),

                              Expanded(
                                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                  Text(
                                    product.name ?? '', style: robotoBold.copyWith(fontSize: Dimensions.fontSizeLarge),
                                    maxLines: 2, overflow: TextOverflow.ellipsis,
                                  ),

                                  Padding(
                                    padding: const EdgeInsets.fromLTRB(0, 5, 5, 5),
                                    child: Text(
                                      product.restaurantName ?? '',
                                      style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).primaryColor),
                                    ),
                                   ),

                                  RatingBarWidget(rating: product.avgRating, size: 15, ratingCount: product.ratingCount),
                                  const SizedBox(height: Dimensions.paddingSizeExtraSmall),

                                  Wrap(children: [
                                    price > priceWithDiscountForView ? Text(
                                      PriceConverter.convertPrice(price), textDirection: TextDirection.ltr,
                                      style: robotoMedium.copyWith(color: Theme.of(context).hintColor, decoration: TextDecoration.lineThrough),
                                    ) : const SizedBox(),
                                    const SizedBox(width: Dimensions.paddingSizeExtraSmall),

                                    (product.imageFullUrl != null && product.imageFullUrl!.isNotEmpty)? const SizedBox.shrink()
                                        : DiscountTagWithoutImageWidget(discount: discount, discountType: discountType),

                                    Text(
                                      PriceConverter.convertPrice(priceWithDiscountForView),
                                      textDirection: TextDirection.ltr,
                                      style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeLarge),
                                    ),

                                    (product.stockType != 'unlimited' && product.itemStock! <= 0)
                                      ? Text(' (${'out_of_stock'.tr})', style: robotoRegular.copyWith(color: Theme.of(context).colorScheme.error))
                                      : const SizedBox(),

                                    (product.stockType != 'unlimited' && orderEditController.quantity != 1 && orderEditController.quantity >= product.itemStock!)
                                      ? Text(' (${'only'.tr} ${product.itemStock!} ${'item_available'.tr})', style: robotoRegular.copyWith(color: Colors.blue, fontSize: Dimensions.fontSizeSmall))
                                      : const SizedBox(),

                                  ]),

                                ]),
                              ),

                              Column(mainAxisSize: MainAxisSize.min, mainAxisAlignment: MainAxisAlignment.spaceBetween, crossAxisAlignment: CrossAxisAlignment.end, children: [

                                (product.isHalal! == 1) && (product.halalTagStatus == 1) ? Padding(
                                  padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                                  child: CustomToolTip(
                                    message: 'this_is_a_halal_food'.tr,
                                    preferredDirection: AxisDirection.up,
                                    child: Image.asset(Images.halalIcon, height: 35, width: 35),
                                  ),
                                ) : const SizedBox(),

                              ]),
                            ]),

                            const SizedBox(height: Dimensions.paddingSizeDefault),

                            (product.description != null && product.description!.isNotEmpty) ? Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [

                                Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [

                                  Text('description'.tr, style: robotoBold.copyWith(fontSize: Dimensions.fontSizeLarge)),

                                  (Get.find<SplashController>().configModel!.toggleVegNonVeg!) ? Container(
                                    padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeExtraSmall, horizontal: Dimensions.paddingSizeSmall),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(Dimensions.radiusExtraLarge),
                                      color: Theme.of(context).cardColor,
                                      boxShadow: [BoxShadow(color: Colors.grey.withValues(alpha: 0.2), blurRadius: 10, spreadRadius: 1)],
                                    ),
                                    child: Row(children: [
                                      Image.asset(product.veg == 1 ? Images.vegImage : Images.nonVegImage, height: 20, width: 20),
                                      const SizedBox(width: Dimensions.paddingSizeSmall),

                                      Text(product.veg == 1 ? 'veg'.tr : 'non_veg'.tr, style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeDefault)),
                                    ]),
                                  ) : const SizedBox(),

                                ]),
                                const SizedBox(height: Dimensions.paddingSizeExtraSmall),

                                Text(product.description ?? '', style: robotoRegular.copyWith(color: Theme.of(context).textTheme.bodyLarge!.color?.withValues(alpha: 0.8)), textAlign: TextAlign.justify),
                                const SizedBox(height: Dimensions.paddingSizeLarge),

                              ],
                            ) : const SizedBox(),

                            (product.nutrition != null && product.nutrition!.isNotEmpty) ? Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('nutrition_details'.tr, style: robotoBold.copyWith(fontSize: Dimensions.fontSizeLarge)),
                                const SizedBox(height: Dimensions.paddingSizeExtraSmall),

                                Wrap(children: List.generate(product.nutrition!.length, (index) {
                                  return Text(
                                    '${product.nutrition![index]}${product.nutrition!.length-1 == index ? '.' : ', '}',
                                    style: robotoRegular.copyWith(color: Theme.of(context).textTheme.bodyLarge!.color?.withValues(alpha: 0.8)),
                                  );
                                })),
                                const SizedBox(height: Dimensions.paddingSizeLarge),
                              ],
                            ) : const SizedBox(),

                            (product.allergies != null && product.allergies!.isNotEmpty) ? Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('allergic_ingredients'.tr, style: robotoBold.copyWith(fontSize: Dimensions.fontSizeLarge)),
                                const SizedBox(height: Dimensions.paddingSizeExtraSmall),

                                Wrap(children: List.generate(product.allergies!.length, (index) {
                                  return Text(
                                    '${product.allergies![index]}${product.allergies!.length-1 == index ? '.' : ', '}',
                                    style: robotoRegular.copyWith(color: Theme.of(context).textTheme.bodyLarge!.color?.withValues(alpha: 0.8)),
                                  );
                                })),
                                const SizedBox(height: Dimensions.paddingSizeLarge),
                              ],
                            ) : const SizedBox(),

                            /// Variation
                            product.variations != null ? ListView.builder(
                              shrinkWrap: true,
                              itemCount: product.variations!.length,
                              physics: const NeverScrollableScrollPhysics(),
                              padding: EdgeInsets.only(bottom: ( product.variations != null && product.variations!.isNotEmpty) ? Dimensions.paddingSizeLarge : 0),
                              itemBuilder: (context, index) {
                                
                                int selectedCount = 0;
                                bool isVariationRequired = product.variations![index].required == 'on';
                                bool isMultiSelect = product.variations![index].type == 'multi';
                                int min = int.parse(product.variations![index].min!);
                                
                                if(isVariationRequired){
                                  for (var value in orderEditController.selectedVariations[index]) {
                                    if(value == true){
                                      selectedCount++;
                                    }
                                  }
                                }
                                return Container(
                                  padding: EdgeInsets.all(isVariationRequired ? (isMultiSelect ? min : 1) <= selectedCount
                                      ? Dimensions.paddingSizeSmall : Dimensions.paddingSizeSmall : 0),
                                  margin: EdgeInsets.only(bottom: index != product.variations!.length - 1 ? Dimensions.paddingSizeDefault : 0),
                                  decoration: BoxDecoration(
                                      color: isVariationRequired ? (isMultiSelect ? min : 1) <= selectedCount
                                          ? Theme.of(context).primaryColor.withValues(alpha: 0.05) :Theme.of(context).hintColor.withValues(alpha: 0.05) : Colors.transparent,
                                      border: Border.all(color: isVariationRequired ? (isMultiSelect ? min : 1) <= selectedCount
                                          ? Theme.of(context).primaryColor.withValues(alpha: 0.3) : Theme.of(context).hintColor.withValues(alpha: 0.1) : Colors.transparent, width: 1),
                                      borderRadius: BorderRadius.circular(Dimensions.radiusDefault)
                                  ),
                                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                    Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, crossAxisAlignment: CrossAxisAlignment.center, children: [
                                      Text(product.variations![index].name!, style: robotoBold.copyWith(fontSize: Dimensions.fontSizeLarge)),

                                      AnimatedContainer(
                                        duration: Duration(milliseconds: 800),
                                        curve: Curves.easeIn,
                                        decoration: BoxDecoration(
                                          color: isVariationRequired ? (isMultiSelect ? min : 1) > selectedCount
                                              ? Theme.of(context).colorScheme.error.withValues(alpha: 0.1) : Theme.of(context).primaryColor.withValues(alpha: 0.1) : Theme.of(context).hintColor.withValues(alpha: 0.2),
                                          borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                                        ),
                                        padding: const EdgeInsets.all(Dimensions.paddingSizeExtraSmall),

                                        child: Text(
                                          isVariationRequired
                                              ? (isMultiSelect ? min : 1) <= selectedCount ? 'completed'.tr : 'required'.tr
                                              : 'optional'.tr,
                                          style: robotoRegular.copyWith(
                                            color: isVariationRequired
                                                ? (isMultiSelect ? min : 1) <= selectedCount ? Theme.of(context).primaryColor : Theme.of(context).colorScheme.error
                                                : Theme.of(context).hintColor,
                                            fontSize: Dimensions.fontSizeSmall,
                                          ),
                                        ),
                                      ),
                                    ]),
                                    const SizedBox(height: Dimensions.paddingSizeExtraSmall),

                                    Row(children: [
                                      isMultiSelect ? Text(
                                        '${'select_minimum'.tr} ${'${product.variations![index].min}'
                                            ' ${'and_up_to'.tr} ${product.variations![index].max} ${'options'.tr}'}',
                                        style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeExtraSmall, color: Theme.of(context).hintColor),
                                      ) : Text(
                                        'select_one'.tr,
                                        style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeExtraSmall, color: Theme.of(context).hintColor),
                                      ),
                                    ]),
                                    SizedBox(height: isMultiSelect ? Dimensions.paddingSizeExtraSmall : 0),

                                    ListView.builder(
                                      shrinkWrap: true,
                                      physics: const NeverScrollableScrollPhysics(),
                                      padding: EdgeInsets.zero,
                                      itemCount: orderEditController.collapseVariation[index] ? (product.variations != null && product.variations!.length > index && product.variations![index].variationValues != null
                                        && product.variations![index].variationValues!.length > 4 ? 5 : (product.variations![index].variationValues?.length ?? 0))
                                        : (product.variations?[index].variationValues?.length ?? 0),
                                      itemBuilder: (context, i) {
                                        List<VariationOption>? variationValues = (product.variations != null && product.variations!.length > index) ? product.variations![index].variationValues : null;
                                        int? currentStock = (variationValues != null && variationValues.length > i) ? int.tryParse(variationValues[i].currentStock ?? '') : null;
                                        double optionPrice = (variationValues != null && variationValues.length > i && variationValues[i].optionPrice != null) ? double.tryParse(variationValues[i].optionPrice!) ?? 0.0 : 0.0;

                                        if (i == 4 && orderEditController.collapseVariation[index]) {
                                          return Padding(
                                            padding: const EdgeInsets.all(Dimensions.paddingSizeExtraSmall),
                                            child: InkWell(
                                              onTap: () => orderEditController.showMoreSpecificSection(index),
                                              child: Row(children: [
                                                Icon(Icons.expand_more, size: 18, color: Theme.of(context).primaryColor),
                                                const SizedBox(width: Dimensions.paddingSizeExtraSmall),
                                                Text('${'view'.tr} ${(variationValues?.length ?? 0) - 4} ${'more_option'.tr}', style: robotoMedium.copyWith(color: Theme.of(context).primaryColor)),
                                              ]),
                                            ),
                                          );
                                        } else {
                                          return InkWell(
                                            onTap: () {
                                              orderEditController.setCartVariationIndex(index, i, product, isMultiSelect);
                                              orderEditController.setExistInCartForBottomSheet(product, orderEditController.selectedVariations);
                                            },
                                            child: Row(children: [
                                              Flexible(
                                                child: Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
                                                  isMultiSelect ? Checkbox(
                                                    value: (orderEditController.selectedVariations.length > index && orderEditController.selectedVariations[index].length > i) ? orderEditController.selectedVariations[index][i] : false,
                                                    activeColor: Theme.of(context).primaryColor,
                                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(Dimensions.radiusSmall)),
                                                    onChanged: (bool? newValue) {
                                                      orderEditController.setCartVariationIndex(index, i, product, isMultiSelect);
                                                      orderEditController.setExistInCartForBottomSheet(product, orderEditController.selectedVariations);
                                                    },
                                                    visualDensity: const VisualDensity(horizontal: -3, vertical: -3),
                                                    side: BorderSide(width: 2, color: Theme.of(context).hintColor),
                                                  ) : RadioGroup(
                                                    groupValue: (orderEditController.selectedVariations.length > index) ? orderEditController.selectedVariations[index].indexOf(true) : -1,
                                                    onChanged: (dynamic value) {
                                                      orderEditController.setCartVariationIndex(index, i, product, isMultiSelect);
                                                      orderEditController.setExistInCartForBottomSheet(product, orderEditController.selectedVariations);
                                                    },
                                                    child: Radio(
                                                      value: i,
                                                      activeColor: Theme.of(context).primaryColor,
                                                      toggleable: false,
                                                      visualDensity: const VisualDensity(horizontal: -3, vertical: -3),
                                                      fillColor: WidgetStateColor.resolveWith((states) => (orderEditController.selectedVariations.length > index && orderEditController.selectedVariations[index].length > i && orderEditController.selectedVariations[index][i] == true) ? Theme.of(context).primaryColor : Theme.of(context).hintColor),
                                                    ),
                                                  ),

                                                  Flexible(
                                                    child: Text(
                                                      (variationValues != null && variationValues.length > i && variationValues[i].level != null) ? variationValues[i].level!.trim() : '',
                                                      maxLines: 1, overflow: TextOverflow.ellipsis,
                                                      style: (orderEditController.selectedVariations.length > index && orderEditController.selectedVariations[index].length > i && orderEditController.selectedVariations[index][i] == true) ? robotoMedium : robotoRegular.copyWith(color: Theme.of(context).hintColor),
                                                    ),
                                                  ),

                                                  Flexible(
                                                    child: (orderEditController.selectedVariations.length > index && orderEditController.selectedVariations[index].length > i && orderEditController.selectedVariations[index][i] == true && orderEditController.quantity == currentStock)
                                                      ? Text(' (${'only'.tr} $currentStock ${'item_available'.tr})', style: robotoRegular.copyWith(color: Colors.blue, fontSize: Dimensions.fontSizeExtraSmall))
                                                      : Text(' (${'out_of_stock'.tr})', maxLines: 1, overflow: TextOverflow.ellipsis,
                                                      style: (variationValues != null && variationValues.length > i && variationValues[i].stockType != 'unlimited' && currentStock != null && currentStock <= 0)
                                                        ? robotoMedium.copyWith(color: Theme.of(context).colorScheme.error, fontSize: Dimensions.fontSizeExtraSmall)
                                                        : robotoRegular.copyWith(color: Colors.transparent),
                                                    ),
                                                  ),
                                                ]),
                                              ),
                                              (price > priceWithDiscount && discountType == 'percent') ? Text(
                                                PriceConverter.convertPrice(optionPrice),
                                                maxLines: 1, overflow: TextOverflow.ellipsis, textDirection: TextDirection.ltr,
                                                style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeExtraSmall, color: Theme.of(context).hintColor, decoration: TextDecoration.lineThrough),
                                              ) : const SizedBox(),
                                              SizedBox(width: price > priceWithDiscount ? Dimensions.paddingSizeExtraSmall : 0),
                                              Text(
                                                '+${PriceConverter.convertPrice(optionPrice, discount: discount, discountType: discountType, isVariation: true)}',
                                                maxLines: 1, overflow: TextOverflow.ellipsis, textDirection: TextDirection.ltr,
                                                style: (orderEditController.selectedVariations.length > index && orderEditController.selectedVariations[index].length > i && orderEditController.selectedVariations[index][i] == true)
                                                    ? robotoMedium.copyWith(fontSize: Dimensions.fontSizeExtraSmall)
                                                    : robotoRegular.copyWith(fontSize: Dimensions.fontSizeExtraSmall, color: Theme.of(context).hintColor),
                                              )
                                            ]),
                                          );
                                        }
                                      },
                                    ),
                                  ]),
                                );
                              },
                            ) : const SizedBox(),
                            SizedBox(height: (product.variations != null && product.variations!.isNotEmpty) ? 0 : 0),

                            product.addOns!.isNotEmpty ? Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(left: Dimensions.paddingSizeExtraSmall),
                                  child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                                    Text('addons'.tr, style: robotoBold.copyWith(fontSize: Dimensions.fontSizeLarge)),

                                    Container(
                                      decoration: BoxDecoration(
                                        color: Theme.of(context).hintColor.withValues(alpha: 0.1),
                                        borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                                      ),
                                      padding: const EdgeInsets.all(Dimensions.paddingSizeExtraSmall),
                                      child: Text(
                                        'optional'.tr,
                                        style: robotoRegular.copyWith(color: Theme.of(context).hintColor, fontSize: Dimensions.fontSizeSmall),
                                      ),
                                    ),
                                  ]),
                                ),
                                const SizedBox(height: Dimensions.paddingSizeExtraSmall),

                                ListView.builder(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  padding: EdgeInsets.zero,
                                  itemCount: product.addOns!.length,
                                  itemBuilder: (context, index) {
                                    return InkWell(
                                      onTap: () {
                                        if (!orderEditController.addOnActiveList[index]) {
                                          orderEditController.addAddOn(true, index, product.addOns![index].stockType, product.addOns![index].addonStock);
                                        } else if (orderEditController.addOnQtyList[index] == 1) {
                                          orderEditController.addAddOn(false, index, product.addOns![index].stockType, product.addOns![index].addonStock);
                                        }
                                      },
                                      child: Row(children: [

                                        Flexible(
                                          child: Row(crossAxisAlignment: CrossAxisAlignment.center, children: [

                                            Checkbox(
                                              value: orderEditController.addOnActiveList[index],
                                              activeColor: Theme.of(context).primaryColor,
                                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(Dimensions.radiusSmall)),
                                              onChanged:(bool? newValue) {
                                                if (!orderEditController.addOnActiveList[index]) {
                                                  orderEditController.addAddOn(true, index, product.addOns![index].stockType, product.addOns![index].addonStock);
                                                } else if (orderEditController.addOnQtyList[index] == 1) {
                                                  orderEditController.addAddOn(false, index, product.addOns![index].stockType, product.addOns![index].addonStock);
                                                }
                                              },
                                              visualDensity: const VisualDensity(horizontal: -3, vertical: -3),
                                              side: BorderSide(width: 2, color: Theme.of(context).hintColor),
                                            ),

                                            Text(
                                              product.addOns![index].name!,
                                              maxLines: 1, overflow: TextOverflow.ellipsis,
                                              style: orderEditController.addOnActiveList[index] ? robotoMedium : robotoRegular.copyWith(color: Theme.of(context).hintColor),
                                            ),

                                            Flexible(
                                              child: Text(
                                                ' (${'out_of_stock'.tr})',
                                                maxLines: 1, overflow: TextOverflow.ellipsis,
                                                style: product.addOns![index].stockType != 'unlimited' && product.addOns![index].addonStock != null && product.addOns![index].addonStock! <= 0
                                                    ? robotoMedium.copyWith(color: Theme.of(context).colorScheme.error, fontSize: Dimensions.fontSizeExtraSmall)
                                                    : robotoRegular.copyWith(color: Colors.transparent),
                                              ),
                                            ),
                                          ]),
                                        ),

                                        Text(
                                          product.addOns![index].price! > 0 ? PriceConverter.convertPrice(product.addOns![index].price) : 'free'.tr,
                                          maxLines: 1, overflow: TextOverflow.ellipsis, textDirection: TextDirection.ltr,
                                          style: orderEditController.addOnActiveList[index] ? robotoMedium.copyWith(fontSize: Dimensions.fontSizeSmall)
                                              : robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).hintColor),
                                        ),

                                        orderEditController.addOnActiveList[index] ? Container(
                                          height: 25, width: 90,
                                          decoration: BoxDecoration(borderRadius: BorderRadius.circular(Dimensions.radiusSmall), color: Theme.of(context).cardColor),
                                          child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                                            Expanded(
                                              child: InkWell(
                                                onTap: () {
                                                  if (orderEditController.addOnQtyList[index]! > 1) {
                                                    orderEditController.setAddOnQuantity(false, index, product.addOns![index].stockType, product.addOns![index].addonStock);
                                                  } else {
                                                    orderEditController.addAddOn(false, index, product.addOns![index].stockType, product.addOns![index].addonStock);
                                                  }
                                                },
                                                child: Center(child: Icon(
                                                  (orderEditController.addOnQtyList[index]! > 1) ? Icons.remove : CupertinoIcons.delete, size: 18,
                                                  color: (orderEditController.addOnQtyList[index]! > 1) ? Theme.of(context).primaryColor : Theme.of(context).colorScheme.error,
                                                )),
                                              ),
                                            ),
                                            Text(
                                              orderEditController.addOnQtyList[index].toString(),
                                              style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeDefault),
                                            ),
                                            Expanded(
                                              child: InkWell(
                                                onTap: () => orderEditController.setAddOnQuantity(true, index, product.addOns![index].stockType, product.addOns![index].addonStock),
                                                child: Center(child: Icon(Icons.add, size: 18, color: Theme.of(context).primaryColor)),
                                              ),
                                            ),
                                          ]),
                                        ) : const SizedBox(),

                                      ]),
                                    );

                                  },
                                ),
                                const SizedBox(height: Dimensions.paddingSizeExtraSmall),
                              ],
                            ) : const SizedBox(),

                          ]),
                        ),
                      ]),
                    ),
                  ),

                  ///Bottom side..
                  Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context).cardColor,
                      borderRadius: BorderRadius.vertical(bottom: Radius.circular(ResponsiveHelper.isDesktop(context) ? Dimensions.radiusExtraLarge : 0)),
                      boxShadow: [BoxShadow(color: Colors.grey[300]!, blurRadius: 10)]
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault, vertical: Dimensions.paddingSizeDefault),

                    child: SafeArea(
                      child: Column(
                        children: [
                          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                            Text('${'total_amount'.tr}:', style: robotoBold.copyWith(color: Theme.of(context).primaryColor)),
                            const SizedBox(width: Dimensions.paddingSizeExtraSmall),

                            Row(children: [
                              (priceWithAddonsVariation > priceWithAddonsVariationWithDiscount) ? PriceConverter.convertAnimationPrice(
                                priceWithAddonsVariation,
                                textStyle: robotoMedium.copyWith(color: Theme.of(context).hintColor, fontSize: Dimensions.fontSizeSmall, decoration: TextDecoration.lineThrough),
                              ) : const SizedBox(),
                              const SizedBox(width: Dimensions.paddingSizeExtraSmall),

                              PriceConverter.convertAnimationPrice(
                                priceWithAddonsVariationWithDiscount,
                                textStyle: robotoBold.copyWith(color: Theme.of(context).primaryColor),
                              ),

                            ]),
                          ]),
                          const SizedBox(height: Dimensions.paddingSizeSmall),


                          Row(
                            children: [
                              Row(children: [
                                QuantityButton(
                                  onTap: () {
                                    if (orderEditController.quantity > 1) {
                                      orderEditController.setQuantity(false, product.cartQuantityLimit, product.stockType, product.itemStock);
                                    }
                                  },
                                  isIncrement: false,
                                ),

                                AnimatedFlipCounter(
                                  duration: const Duration(milliseconds: 500),
                                  value: orderEditController.quantity.toDouble(),
                                  textStyle: robotoMedium.copyWith(fontSize: Dimensions.fontSizeLarge),
                                ),

                                QuantityButton(
                                  onTap: () {
                                    orderEditController.setQuantity(true, product.cartQuantityLimit, product.stockType, product.itemStock);
                                  },
                                  isIncrement: true,
                                ),
                              ]),
                              const SizedBox(width: Dimensions.paddingSizeSmall),

                              Expanded(
                                child: CustomButtonWidget(
                                  radius : Dimensions.paddingSizeDefault,
                                  buttonText: (!product.scheduleOrder! && !isAvailable) ? 'not_available_now'.tr
                                      : (widget.cart != null || orderEditController.cartIndex != -1) ? 'update_in_cart'.tr : 'add_to_cart'.tr,
                                  onPressed: ((!product.scheduleOrder! && !isAvailable) || (!isAvailable)) || (widget.cart != null && orderEditController.checkOutOfStockVariationSelected(product.variations) != null) ? null : () async {

                                    _onButtonPressed(orderEditController, priceWithVariation, priceWithDiscount, price, discount, discountType, addOnIdList, addOnsList, priceWithAddonsVariation);

                                  },
                                ),
                              ),

                            ],
                          ),

                        ],
                      ),
                    ),
                  ),

                ],
              ),

              GetPlatform.isAndroid ? const SizedBox() : Positioned(
                top: 5, right: 10,
                child: InkWell(
                  onTap: () => Get.back(),
                  child: Container(
                    padding:  const EdgeInsets.all(Dimensions.paddingSizeExtraSmall),
                    decoration: BoxDecoration(
                      color: Theme.of(context).cardColor,
                      shape: BoxShape.circle,
                      boxShadow: [BoxShadow(color: Theme.of(context).primaryColor.withValues(alpha: 0.3), blurRadius: 5)],
                    ),
                    child: const Icon(Icons.close, size: 14),
                  ),
                ),
              ),

            ],
          ),
        );

      }),
    );
  }

  void _onButtonPressed(
      OrderEditController orderEditController, double priceWithVariation, double priceWithDiscount,
      double price, double? discount, String? discountType, List<AddOn> addOnIdList, List<AddOns> addOnsList,
      double priceWithAddonsVariation,
      ) async {

    _processVariationWarning(orderEditController);

    if(orderEditController.canAddToCartProduct) {

      CartModel cartModel = CartModel(
        id: null, price: priceWithVariation, discountedPrice: priceWithDiscount, discountAmount: (price - PriceConverter.convertWithDiscount(price, discount, discountType)!),
        quantity: orderEditController.quantity, addOnIds: addOnIdList, addOns: addOnsList, isCampaign: false, product: widget.product, variations: orderEditController.selectedVariations,
        quantityLimit: widget.product!.cartQuantityLimit, variationsStock: orderEditController.variationsStock,
      );

      debugPrint('-------Edit cart : ${cartModel.toJson()}');

      await _executeActions(orderEditController, cartModel);
    }
  }

  void _processVariationWarning(OrderEditController orderEditController) {
    final product = widget.product;

    if (product == null) {
      orderEditController.changeCanAddToCartProduct(false);
      showCustomSnackBar('product_not_found'.tr);
      return;
    }

    final variations = product.variations ?? [];

    if (variations.isNotEmpty) {
      for (int index = 0; index < variations.length; index++) {
        final variation = variations[index];
        final isVariationRequired = variation.required == 'on';
        final isMultiSelect = variation.type == 'multi';

        final min = int.tryParse(variation.min ?? '0') ?? 0;
        final max = int.tryParse(variation.max ?? '0') ?? 0;

        if (!isMultiSelect && isVariationRequired && !(orderEditController.selectedVariations[index].contains(true))) {
          showCustomSnackBar('${'choose_a_variation_from'.tr} ${variation.name}');
          orderEditController.changeCanAddToCartProduct(false);
          return;
        } else if (isMultiSelect && (isVariationRequired || (orderEditController.selectedVariations[index].contains(true))) &&
            min > orderEditController.selectedVariationLength(orderEditController.selectedVariations, index)) {
          showCustomSnackBar('${'you_need_to_select_minimum'.tr} $min '
              '${'to_maximum'.tr} $max ${'options_from'.tr} ${variation.name} ${'variation'.tr}');
          orderEditController.changeCanAddToCartProduct(false);
          return;
        } else if (product.stockType != 'unlimited' && (product.itemStock ?? 0) <= 0) {
          showCustomSnackBar('product_is_out_of_stock'.tr);
          orderEditController.changeCanAddToCartProduct(false);
          return;
        } else {
          orderEditController.changeCanAddToCartProduct(true);
        }
      }
    } else if (product.stockType != 'unlimited' && (product.itemStock ?? 0) <= 0) {
      showCustomSnackBar('product_is_out_of_stock'.tr);
      orderEditController.changeCanAddToCartProduct(false);
      return;
    }
  }

  Future<void> _executeActions(OrderEditController orderEditController, CartModel cartModel) async {
    if(widget.cart != null || (widget.cartIndex != null && widget.cartIndex != -1)) {
      await orderEditController.updateCart(cartModel, widget.cartIndex!);
    } else {
      await orderEditController.addToCart(cartModel, fromProductBottomSheet: true);
    }
  }

  double _getVariationPriceWithDiscount(Product product, OrderEditController orderEditController, double? discount, String? discountType) {
    double variationPrice = 0;
    if(product.variations != null){
      for(int index = 0; index< product.variations!.length; index++) {
        for(int i=0; i<product.variations![index].variationValues!.length; i++) {
          if(orderEditController.selectedVariations[index].isNotEmpty && orderEditController.selectedVariations[index][i]!) {
            variationPrice += PriceConverter.convertWithDiscount(double.parse(product.variations![index].variationValues![i].optionPrice!), discount, discountType)!;
          }
        }
      }
    }
    return variationPrice;
  }

  double _getVariationPrice(Product product, OrderEditController orderEditController) {
    double variationPrice = 0;
    if(product.variations != null){
      for(int index = 0; index< product.variations!.length; index++) {
        for(int i=0; i<product.variations![index].variationValues!.length; i++) {
          if(orderEditController.selectedVariations[index].isNotEmpty && orderEditController.selectedVariations[index][i]!) {
            variationPrice += PriceConverter.convertWithDiscount(double.parse(product.variations![index].variationValues![i].optionPrice!), 0, 'none')!;
          }
        }
      }
    }
    return variationPrice;
  }

  double _getAddonCost(Product product, OrderEditController orderEditController) {
    double addonsCost = 0;

    for (int index = 0; index < product.addOns!.length; index++) {
      if (orderEditController.addOnActiveList[index]) {
        addonsCost = addonsCost + (product.addOns![index].price! * orderEditController.addOnQtyList[index]!);
      }
    }

    return addonsCost;
  }

  List<AddOn> _getAddonIdList(Product product, OrderEditController orderEditController) {
    List<AddOn> addOnIdList = [];
    for (int index = 0; index < product.addOns!.length; index++) {
      if (orderEditController.addOnActiveList[index]) {
        addOnIdList.add(AddOn(id: product.addOns![index].id, quantity: orderEditController.addOnQtyList[index]));
      }
    }

    return addOnIdList;
  }

  List<AddOns> _getAddonList(Product product, OrderEditController orderEditController) {
    List<AddOns> addOnsList = [];
    for (int index = 0; index < product.addOns!.length; index++) {
      if (orderEditController.addOnActiveList[index]) {
        addOnsList.add(product.addOns![index]);
      }
    }

    return addOnsList;
  }

}

