import 'package:stackfood_multivendor_restaurant/features/order/domain/models/cart_model.dart';

class CartHelper {

  static String setupVariationText({required CartModel cart}) {
    String variationText = '';

    if(cart.variations!.isNotEmpty) {
      for(int index=0; index<cart.variations!.length; index++) {
        if(cart.variations![index].isNotEmpty && cart.variations![index].contains(true)) {
          variationText = '$variationText${variationText.isNotEmpty ? ', ' : ''}${cart.product!.variations![index].name} (';

          for(int i=0; i<cart.variations![index].length; i++) {
            if(cart.variations![index][i]!) {
              variationText = '$variationText${variationText.endsWith('(') ? '' : ', '}${cart.product!.variations![index].variationValues![i].level}';
            }
          }
          variationText = '$variationText)';
        }
      }
    }

    return variationText;
  }

  static String? setupAddonsText({required CartModel cart}) {
    String addOnText = '';
    int index0 = 0;
    List<int?> ids = [];
    List<int?> qtys = [];
    for (var addOn in cart.addOnIds!) {
      ids.add(addOn.id);
      qtys.add(addOn.quantity);
    }
    for (var addOn in cart.product!.addOns!) {
      if (ids.contains(addOn.id)) {
        addOnText = '$addOnText${(index0 == 0) ? '' : ',  '}${addOn.name} (${qtys[index0]})';
        index0 = index0 + 1;
      }
    }
    return addOnText;
  }
}