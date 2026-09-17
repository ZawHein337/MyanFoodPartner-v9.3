import 'package:stackfood_multivendor_restaurant/common/widgets/custom_card.dart';
import 'package:stackfood_multivendor_restaurant/features/expense/domain/models/expense_model.dart';
import 'package:stackfood_multivendor_restaurant/helper/date_converter_helper.dart';
import 'package:stackfood_multivendor_restaurant/helper/price_converter_helper.dart';
import 'package:stackfood_multivendor_restaurant/util/dimensions.dart';
import 'package:stackfood_multivendor_restaurant/util/styles.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ExpenseCardWidget extends StatelessWidget {
  final Expense expense;
  const ExpenseCardWidget({super.key, required this.expense});

  @override
  Widget build(BuildContext context) {
    return CustomCard(
      borderColor: Theme.of(context).disabledColor.withValues(alpha: 0.7),
      margin: const EdgeInsets.only(bottom: Dimensions.paddingSizeDefault, left: Dimensions.paddingSizeDefault, right: Dimensions.paddingSizeDefault),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

        Padding(
          padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
          child: Row(children: [
            Text('${'order'.tr} # ', style: robotoRegular),
            Text(expense.orderId.toString(), style: robotoBold),
            Spacer(),

            Text(
              DateConverter.dateTimeStringToDateTime(expense.createdAt!),
              style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).textTheme.bodyLarge!.color!.withValues(alpha: 0.5)),
            ),
          ]),
        ),
        Divider(height: 0),

        Padding(
          padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
          child: Column(
            children: [
              if(expense.order?.customer != null)
                Padding(
                  padding: const EdgeInsets.only(bottom: Dimensions.paddingSizeSmall),
                  child: Row(children: [

                    Icon(Icons.person, size: 20, color: Theme.of(context).hintColor),
                    const SizedBox(width: Dimensions.paddingSizeExtraSmall),

                    Text('${expense.order?.customer?.fName??''} ${expense.order?.customer?.lName??''}', style: robotoRegular),

                  ]),
                ),

              Container(
                padding: EdgeInsets.all(Dimensions.paddingSizeSmall),
                decoration: BoxDecoration(
                  color: Theme.of(context).disabledColor.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(Dimensions.radiusMedium),
                ),
                child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                  Text(expense.type!.tr, style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeSmall, color: expense.type == 'coupon_discount' ? Theme.of(context).primaryColor.withValues(alpha: 0.7) : Colors.blue)),


                  Text(PriceConverter.convertPrice(expense.amount), textDirection: TextDirection.ltr, style: robotoBold.copyWith(fontSize: 17)),
                ]),
              ),
            ],
          ),
        ),
      ]),
    );
  }
}