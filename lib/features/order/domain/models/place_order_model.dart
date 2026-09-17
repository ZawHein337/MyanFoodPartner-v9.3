import 'package:stackfood_multivendor_restaurant/features/restaurant/domain/models/product_model.dart';

class PlaceOrderModel {
  List<Cart>? carts;
  String? orderId;
  List<String>? editHistoryLog;

  PlaceOrderModel({
    this.carts,
    this.orderId,
    this.editHistoryLog,
  });

  PlaceOrderModel.fromJson(Map<String, dynamic> json) {
    if (json['carts'] != null) {
      carts = [];
      json['carts'].forEach((v) {
        carts!.add(Cart.fromJson(v));
      });
    }
    orderId = json['order_id'];
    if (json['edit_history_log'] != null) {
      editHistoryLog = [];
      json['edit_history_log'].forEach((v) {
        editHistoryLog!.add(v.toString());
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (carts != null) {
      data['carts'] = carts!.map((v) => v.toJson()).toList();
    }
    data['order_id'] = orderId;
    if (editHistoryLog != null) {
      data['edit_history_log'] = editHistoryLog!.map((v) => v.toString()).toList();
    }
    return data;
  }
}

class Cart {
  int? itemId;
  String? itemType;
  int? quantity;
  List<int?>? addOnIds;
  List<AddOns>? addOns;
  List<int?>? addOnQtys;
  List<OrderVariation>? variations;
  List<int?>? variationOptionIds;
  bool? newItem;

  Cart({
    this.itemId,
    this.variations,
    this.quantity,
    this.addOnIds,
    this.addOns,
    this.addOnQtys,
    this.itemType,
    this.variationOptionIds,
    this.newItem,
  });

  Cart.fromJson(Map<String, dynamic> json) {
    itemId = json['item_id'];
    if (json['variations'] != null) {
      variations = [];
      json['variations'].forEach((v) {
        variations!.add(OrderVariation.fromJson(v));
      });
    }
    quantity = json['quantity'];
    addOnIds = json['add_on_ids'].cast<int>();
    if (json['add_ons'] != null) {
      addOns = [];
      json['add_ons'].forEach((v) {
        addOns!.add(AddOns.fromJson(v));
      });
    }
    addOnQtys = json['add_on_qtys'].cast<int>();
    if(json['item_type'] != null && json['item_type'] != 'null') {
      itemType = json['item_type'];
    }
    variationOptionIds = json['variation_options'].cast<int>();
    newItem = json['new_item'] ?? false;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['item_id'] = itemId;
    if(variations != null) {
      data['variations'] = variations!.map((v) => v.toJson()).toList();
    }
    data['quantity'] = quantity;
    data['add_on_ids'] = addOnIds;
    if (addOns != null) {
      data['add_ons'] = addOns!.map((v) => v.toJson()).toList();
    }
    data['add_on_qtys'] = addOnQtys;
    if(itemType != null) {
      data['item_type'] = itemType;
    }
    data['variation_options'] = variationOptionIds;
    data['new_item'] = newItem ?? false;
    return data;
  }
}

class OrderVariation {
  String? name;
  OrderVariationValue? values;

  OrderVariation({this.name, this.values});

  OrderVariation.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    values = json['values'] != null ? OrderVariationValue.fromJson(json['values']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    if (values != null) {
      data['values'] = values!.toJson();
    }
    return data;
  }
}

class OrderVariationValue {
  List<String?>? label;

  OrderVariationValue({this.label});

  OrderVariationValue.fromJson(Map<String, dynamic> json) {
    label = json['label'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['label'] = label;
    return data;
  }
}