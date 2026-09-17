import 'package:stackfood_multivendor_restaurant/features/restaurant/domain/models/product_model.dart';

class CartModel {
  int? id;
  double? price;
  double? discountedPrice;
  double? discountAmount;
  int? quantity;
  List<AddOn>? addOnIds;
  List<AddOns>? addOns;
  bool? isCampaign;
  Product? product;
  List<List<bool?>>? variations;
  int? quantityLimit;
  List<List<int?>>? variationsStock;

  CartModel({
    this.id,
    this.price,
    this.discountedPrice,
    this.discountAmount,
    this.quantity,
    this.addOnIds,
    this.addOns,
    this.isCampaign,
    this.product,
    this.variations,
    this.quantityLimit,
    this.variationsStock,
  });

  CartModel.fromJson(Map<String, dynamic> json) {
    id = json['cart_id'];
    price = json['price'].toDouble();
    discountedPrice = json['discounted_price']?.toDouble();
    discountAmount = json['discount_amount']?.toDouble();
    quantity = json['quantity'];
    if (json['add_on_ids'] != null) {
      addOnIds = [];
      json['add_on_ids'].forEach((v) {
        addOnIds!.add(AddOn.fromJson(v));
      });
    }
    if (json['add_ons'] != null) {
      addOns = [];
      json['add_ons'].forEach((v) {
        addOns!.add(AddOns.fromJson(v));
      });
    }
    isCampaign = json['is_campaign'];
    if (json['product'] != null) {
      product = Product.fromJson(json['product']);
    }
    if (json['variations'] != null) {
      variations = [];
      for(int index=0; index<json['variations'].length; index++) {
        variations!.add([]);
        for(int i=0; i<json['variations'][index].length; i++) {
          variations![index].add(json['variations'][index][i]);
        }
      }
    }
    if(json['quantity_limit'] != null) {
      quantityLimit = int.parse(json['quantity_limit']);
    }
    if (json['variations_stock'] != null) {
      variationsStock = [];
      for(int index=0; index<json['variations_stock'].length; index++) {
        variationsStock!.add([]);
        for(int i=0; i<json['variations_stock'][index].length; i++) {
          variationsStock![index].add(json['variations_stock'][index][i]);
        }
      }
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['price'] = price;
    data['discounted_price'] = discountedPrice;
    data['discount_amount'] = discountAmount;
    data['quantity'] = quantity;
    if (addOnIds != null) {
      data['add_on_ids'] = addOnIds!.map((v) => v.toJson()).toList();
    }
    if (addOns != null) {
      data['add_ons'] = addOns!.map((v) => v.toJson()).toList();
    }
    data['is_campaign'] = isCampaign;
    data['product'] = product!.toJson();
    data['variations'] = variations;
    data['quantity_limit'] = quantityLimit?.toString();
    return data;
  }
}

class AddOn {
  int? id;
  int? quantity;

  AddOn({this.id, this.quantity});

  AddOn.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    quantity = json['quantity'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['quantity'] = quantity;
    return data;
  }
}
