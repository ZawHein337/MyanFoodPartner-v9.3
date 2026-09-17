import 'package:stackfood_multivendor_restaurant/features/restaurant/domain/models/product_model.dart';

class OrderDetailsModel {
  int? id;
  int? foodId;
  int? orderId;
  double? price;
  Product? foodDetails;
  List<Variation>? variation;
  List<OldVariation>? oldVariation;
  List<AddOn>? addOns;
  double? discountOnFood;
  String? discountType;
  int? quantity;
  double? taxAmount;
  String? variant;
  String? createdAt;
  String? updatedAt;
  int? itemCampaignId;
  double? totalAddOnPrice;
  List<OrderEditLogs>? orderEditLogs;
  int? bogoOfferId;
  String? bogoGroupId;
  int? isFreeItem;

  OrderDetailsModel({
    this.id,
    this.foodId,
    this.orderId,
    this.price,
    this.foodDetails,
    this.variation,
    this.oldVariation,
    this.addOns,
    this.discountOnFood,
    this.discountType,
    this.quantity,
    this.taxAmount,
    this.variant,
    this.createdAt,
    this.updatedAt,
    this.itemCampaignId,
    this.totalAddOnPrice,
    this.orderEditLogs,
    this.bogoOfferId,
    this.bogoGroupId,
    this.isFreeItem,
  });

  bool get isBogoItem => bogoGroupId != null;
  bool get isFree => isFreeItem == 1;

  OrderDetailsModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    foodId = json['food_id'];
    orderId = json['order_id'];
    price = json['price']?.toDouble();
    foodDetails = json['food_details'] != null ? Product.fromJson(json['food_details']) : null;
    variation = [];
    oldVariation = [];
    if (json['variation'] != null && json['variation'].isNotEmpty) {
      if(json['variation'][0]['values'] != null) {
        json['variation'].forEach((v) {
          variation!.add(Variation.fromJson(v));
        });
      }else {
        json['variation'].forEach((v) {
          oldVariation!.add(OldVariation.fromJson(v));
        });
      }
    }
    if (json['add_ons'] != null) {
      addOns = [];
      json['add_ons'].forEach((v) {
        addOns!.add(AddOn.fromJson(v));
      });
    }
    discountOnFood = json['discount_on_food']?.toDouble();
    discountType = json['discount_type'];
    quantity = json['quantity'];
    taxAmount = json['tax_amount']?.toDouble();
    variant = json['variant'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    itemCampaignId = json['item_campaign_id'];
    totalAddOnPrice = json['total_add_on_price']?.toDouble();
    if (json['order_edit_logs'] != null) {
      orderEditLogs = <OrderEditLogs>[];
      json['order_edit_logs'].forEach((v) {
        orderEditLogs!.add(OrderEditLogs.fromJson(v));
      });
    }
    bogoOfferId = json['bogo_offer_id'];
    bogoGroupId = json['bogo_group_id'];
    isFreeItem = json['is_free_item'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['food_id'] = foodId;
    data['order_id'] = orderId;
    data['price'] = price;
    if (foodDetails != null) {
      data['food_details'] = foodDetails!.toJson();
    }
    if (variation != null) {
      data['variation'] = variation!.map((v) => v.toJson()).toList();
    }
    if (addOns != null) {
      data['add_ons'] = addOns!.map((v) => v.toJson()).toList();
    }
    data['discount_on_food'] = discountOnFood;
    data['discount_type'] = discountType;
    data['quantity'] = quantity;
    data['tax_amount'] = taxAmount;
    data['variant'] = variant;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['item_campaign_id'] = itemCampaignId;
    data['total_add_on_price'] = totalAddOnPrice;
    if (orderEditLogs != null) {
      data['order_edit_logs'] = orderEditLogs!.map((v) => v.toJson()).toList();
    }
    data['bogo_offer_id'] = bogoOfferId;
    data['bogo_group_id'] = bogoGroupId;
    data['is_free_item'] = isFreeItem;
    return data;
  }
}

class AddOn {
  int? id;
  String? name;
  double? price;
  int? quantity;

  AddOn({this.id, this.name, this.price, this.quantity});

  AddOn.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    price = json['price']?.toDouble();
    quantity = int.parse(json['quantity'].toString());
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['price'] = price;
    data['quantity'] = quantity;
    return data;
  }
}

class OldVariation {
  String? type;
  double? price;

  OldVariation({this.type, this.price});

  OldVariation.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    price = json['price']?.toDouble();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['type'] = type;
    data['price'] = price;
    return data;
  }
}

class OrderEditLogs {
  int? id;
  int? orderId;
  String? log;
  String? editedBy;
  String? createdAt;
  String? updatedAt;

  OrderEditLogs({
    this.id,
    this.orderId,
    this.log,
    this.editedBy,
    this.createdAt,
    this.updatedAt,
  });

  OrderEditLogs.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    orderId = json['order_id'];
    log = json['log'];
    editedBy = json['edited_by'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['order_id'] = orderId;
    data['log'] = log;
    data['edited_by'] = editedBy;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}