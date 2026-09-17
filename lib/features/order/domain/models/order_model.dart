class CurrentOrderModel {
  int? totalSize;
  String? limit;
  String? offset;
  OrderStatusCount? statusCount;
  List<OrderModel>? orders;

  CurrentOrderModel({this.totalSize, this.limit, this.offset, this.statusCount, this.orders});

  CurrentOrderModel.fromJson(Map<String, dynamic> json) {
    totalSize = json['total_size'];
    limit = json['limit'].toString();
    offset = json['offset'].toString();
    statusCount = json['status_count'] != null ? OrderStatusCount.fromJson(json['status_count']) : null;
    if (json['orders'] != null) {
      orders = [];
      json['orders'].forEach((v) {
        orders!.add(OrderModel.fromJson(v));
      });
    }
  }
}

class OrderStatusCount {
  int? pending;
  int? accepted;
  int? confirmed;
  int? processing;
  int? handover;
  int? pickedUp;

  OrderStatusCount({this.pending, this.accepted, this.confirmed, this.processing, this.handover, this.pickedUp});

  OrderStatusCount.fromJson(Map<String, dynamic> json) {
    pending = json['pending'];
    accepted = json['accepted'];
    confirmed = json['confirmed'];
    processing = json['processing'];
    handover = json['handover'];
    pickedUp = json['picked_up'];
  }
}

class PaginatedOrderModel {
  int? delivered;
  int? refunded;
  int? canceled;
  int? failed;
  int? totalSize;
  String? limit;
  String? offset;
  List<OrderModel>? orders;

  PaginatedOrderModel({this.delivered, this.refunded, this.canceled, this.failed, this.totalSize, this.limit, this.offset, this.orders});

  PaginatedOrderModel.fromJson(Map<String, dynamic> json) {
    delivered = json['delivered'];
    refunded = json['refunded'];
    canceled = json['canceled'];
    failed = json['failed'];
    totalSize = json['total_size'];
    limit = json['limit'].toString();
    offset = json['offset'].toString();
    if (json['orders'] != null) {
      orders = [];
      json['orders'].forEach((v) {
        orders!.add(OrderModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['delivered'] = delivered;
    data['refunded'] = refunded;
    data['canceled'] = canceled;
    data['failed'] = failed;
    data['total_size'] = totalSize;
    data['limit'] = limit;
    data['offset'] = offset;
    if (orders != null) {
      data['orders'] = orders!.map((v) => v.toJson()).toList();
    }
    return data;
  }

}

class OrderModel {
  int? id;
  double? orderAmount;
  double? couponDiscountAmount;
  String? couponDiscountTitle;
  String? paymentStatus;
  String? orderStatus;
  double? totalTaxAmount;
  String? paymentMethod;
  String? orderNote;
  String? orderType;
  String? createdAt;
  String? updatedAt;
  double? deliveryCharge;
  String? scheduleAt;
  String? otp;
  String? pending;
  String? accepted;
  String? confirmed;
  String? processing;
  String? handover;
  String? pickedUp;
  String? delivered;
  String? canceled;
  String? refundRequested;
  String? refunded;
  DeliveryAddress? deliveryAddress;
  int? scheduled;
  double? restaurantDiscountAmount;
  double? proDiscount;
  String? restaurantName;
  String? restaurantAddress;
  String? restaurantPhone;
  String? restaurantLat;
  String? restaurantLng;
  String? restaurantLogo;
  int? foodCampaign;
  int? detailsCount;
  Customer? customer;
  double? dmTips;
  int? processingTime;
  DeliveryMan? deliveryMan;
  bool? taxStatus;
  bool? cutlery;
  int? subscriptionId;
  String? unavailableItemNote;
  String? deliveryInstruction;
  double? additionalCharge;
  List<String>? orderProofFullUrl;
  List<Payments>? payments;
  bool? isGuest;
  double? extraPackagingAmount;
  double? referrerBonusAmount;
  OrderReference? orderReference;
  double? bringChangeAmount;
  List<OrderEditLogs>? orderEditLogs;
  String? deliveryType;
  double? deliveryTypeCharge;
  Eta? eta;

  OrderModel({
    this.id,
    this.orderAmount,
    this.couponDiscountAmount,
    this.couponDiscountTitle,
    this.paymentStatus,
    this.orderStatus,
    this.totalTaxAmount,
    this.paymentMethod,
    this.orderNote,
    this.orderType,
    this.createdAt,
    this.updatedAt,
    this.deliveryCharge,
    this.scheduleAt,
    this.otp,
    this.pending,
    this.accepted,
    this.confirmed,
    this.processing,
    this.handover,
    this.pickedUp,
    this.delivered,
    this.canceled,
    this.refundRequested,
    this.refunded,
    this.deliveryAddress,
    this.scheduled,
    this.restaurantDiscountAmount,
    this.proDiscount,
    this.restaurantName,
    this.restaurantAddress,
    this.restaurantPhone,
    this.restaurantLat,
    this.restaurantLng,
    this.restaurantLogo,
    this.foodCampaign,
    this.detailsCount,
    this.customer,
    this.dmTips,
    this.processingTime,
    this.deliveryMan,
    this.taxStatus,
    this.cutlery,
    this.subscriptionId,
    this.unavailableItemNote,
    this.deliveryInstruction,
    this.additionalCharge,
    this.orderProofFullUrl,
    this.payments,
    this.isGuest,
    this.extraPackagingAmount,
    this.referrerBonusAmount,
    this.orderReference,
    this.bringChangeAmount,
    this.orderEditLogs,
    this.deliveryType,
    this.deliveryTypeCharge,
    this.eta,
  });

  OrderModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    orderAmount = json['order_amount']?.toDouble();
    couponDiscountAmount = json['coupon_discount_amount']?.toDouble();
    couponDiscountTitle = json['coupon_discount_title'];
    paymentStatus = json['payment_status'];
    orderStatus = json['order_status'];
    totalTaxAmount = json['total_tax_amount']?.toDouble();
    paymentMethod = json['payment_method'];
    orderNote = json['order_note'];
    orderType = json['order_type'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    deliveryCharge = json['delivery_charge']?.toDouble();
    scheduleAt = json['schedule_at'];
    otp = json['otp'];
    pending = json['pending'];
    accepted = json['accepted'];
    confirmed = json['confirmed'];
    processing = json['processing'];
    handover = json['handover'];
    pickedUp = json['picked_up'];
    delivered = json['delivered'];
    canceled = json['canceled'];
    refundRequested = json['refund_requested'];
    refunded = json['refunded'];
    deliveryAddress = json['delivery_address'] != null ? DeliveryAddress.fromJson(json['delivery_address']) : null;
    scheduled = json['scheduled'];
    restaurantDiscountAmount = json['restaurant_discount_amount']?.toDouble();
    proDiscount = json['pro_discount']?.toDouble();
    restaurantName = json['restaurant_name'];
    restaurantAddress = json['restaurant_address'];
    restaurantPhone = json['restaurant_phone'];
    restaurantLat = json['restaurant_lat'];
    restaurantLng = json['restaurant_lng'];
    restaurantLogo = json['restaurant_logo'];
    foodCampaign = json['food_campaign'];
    detailsCount = json['details_count'];
    customer = json['customer'] != null ? Customer.fromJson(json['customer']) : null;
    dmTips = json['dm_tips']?.toDouble();
    processingTime = json['processing_time'];
    deliveryMan = json['delivery_man'] != null ? DeliveryMan.fromJson(json['delivery_man']) : null;
    taxStatus = json['tax_status'] == 'included' ? true : false;
    cutlery = json['cutlery'];
    subscriptionId = json['subscription_id'];
    unavailableItemNote = json['unavailable_item_note'];
    deliveryInstruction = json['delivery_instruction'];
    additionalCharge = json['additional_charge']?.toDouble() ?? 0;
    if (json['order_proof_full_url'] != null && json['order_proof_full_url'] != "null") {
      orderProofFullUrl = [];
      json['order_proof_full_url'].forEach((v) {
        if(v != null) {
          orderProofFullUrl!.add(v.toString());
        }
      });
    }
    if (json['payments'] != null) {
      payments = <Payments>[];
      json['payments'].forEach((v) {
        payments!.add(Payments.fromJson(v));
      });
    }
    isGuest = json['is_guest'];
    extraPackagingAmount = json['extra_packaging_amount']?.toDouble();
    referrerBonusAmount = json['ref_bonus_amount']?.toDouble();
    orderReference = json['order_reference'] != null ? OrderReference.fromJson(json['order_reference']) : null;
    bringChangeAmount = json['bring_change_amount']?.toDouble();
    if (json['order_edit_logs'] != null) {
      orderEditLogs = <OrderEditLogs>[];
      json['order_edit_logs'].forEach((v) {
        orderEditLogs!.add(OrderEditLogs.fromJson(v));
      });
    }
    deliveryType = json['delivery_type'];
    deliveryTypeCharge = json['delivery_type_charge']?.toDouble();
    eta = json['eta'] != null ? Eta.fromJson(json['eta']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['order_amount'] = orderAmount;
    data['coupon_discount_amount'] = couponDiscountAmount;
    data['coupon_discount_title'] = couponDiscountTitle;
    data['payment_status'] = paymentStatus;
    data['order_status'] = orderStatus;
    data['total_tax_amount'] = totalTaxAmount;
    data['payment_method'] = paymentMethod;
    data['order_note'] = orderNote;
    data['order_type'] = orderType;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['delivery_charge'] = deliveryCharge;
    data['schedule_at'] = scheduleAt;
    data['otp'] = otp;
    data['pending'] = pending;
    data['accepted'] = accepted;
    data['confirmed'] = confirmed;
    data['processing'] = processing;
    data['handover'] = handover;
    data['picked_up'] = pickedUp;
    data['delivered'] = delivered;
    data['canceled'] = canceled;
    data['refund_requested'] = refundRequested;
    data['refunded'] = refunded;
    if (deliveryAddress != null) {
      data['delivery_address'] = deliveryAddress!.toJson();
    }
    data['scheduled'] = scheduled;
    data['restaurant_discount_amount'] = restaurantDiscountAmount;
    data['pro_discount'] = proDiscount;
    data['restaurant_name'] = restaurantName;
    data['restaurant_address'] = restaurantAddress;
    data['restaurant_phone'] = restaurantPhone;
    data['restaurant_lat'] = restaurantLat;
    data['restaurant_lng'] = restaurantLng;
    data['restaurant_logo'] = restaurantLogo;
    data['food_campaign'] = foodCampaign;
    data['details_count'] = detailsCount;
    if (customer != null) {
      data['customer'] = customer!.toJson();
    }
    data['dm_tips'] = dmTips;
    data['processing_time'] = processingTime;
    data['subscription_id'] = subscriptionId;
    data['cutlery'] = cutlery;
    data['unavailable_item_note'] = unavailableItemNote;
    data['delivery_instruction'] = deliveryInstruction;
    data['additional_charge'] = additionalCharge;
    data['order_proof_full_url'] = orderProofFullUrl;
    if (payments != null) {
      data['payments'] = payments!.map((v) => v.toJson()).toList();
    }
    data['is_guest'] = isGuest;
    data['extra_packaging_amount'] = extraPackagingAmount;
    data['ref_bonus_amount'] = referrerBonusAmount;
    if (orderReference != null) {
      data['order_reference'] = orderReference!.toJson();
    }
    data['bring_change_amount'] = bringChangeAmount;
    if (orderEditLogs != null) {
      data['order_edit_logs'] = orderEditLogs!.map((v) => v.toJson()).toList();
    }
    data["delivery_type"] = deliveryType;
    data["delivery_type_charge"] = deliveryTypeCharge;
    if (eta != null) {
      data['eta'] = eta!.toJson();
    }
    return data;
  }
}

class DeliveryAddress {
  String? contactPersonName;
  String? contactPersonNumber;
  String? addressType;
  String? address;
  String? longitude;
  String? latitude;
  String? streetNumber;
  String? house;
  String? floor;

  DeliveryAddress({
    this.contactPersonName,
    this.contactPersonNumber,
    this.addressType,
    this.address,
    this.longitude,
    this.latitude,
    this.streetNumber,
    this.house,
    this.floor,
  });

  DeliveryAddress.fromJson(Map<String, dynamic> json) {
    contactPersonName = json['contact_person_name'];
    contactPersonNumber = json['contact_person_number'];
    addressType = json['address_type'];
    address = json['address'];
    longitude = json['longitude'];
    latitude = json['latitude'];
    streetNumber = json['road'];
    house = json['house'];
    floor = json['floor'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['contact_person_name'] = contactPersonName;
    data['contact_person_number'] = contactPersonNumber;
    data['address_type'] = addressType;
    data['address'] = address;
    data['longitude'] = longitude;
    data['latitude'] = latitude;
    data['road'] = streetNumber;
    data['house'] = house;
    data['floor'] = floor;
    return data;
  }
}

class Customer {
  int? id;
  String? fName;
  String? lName;
  String? phone;
  String? email;
  String? imageFullUrl;
  String? createdAt;
  String? updatedAt;

  Customer({
    this.id,
    this.fName,
    this.lName,
    this.phone,
    this.email,
    this.imageFullUrl,
    this.createdAt,
    this.updatedAt,
  });

  Customer.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    fName = json['f_name'];
    lName = json['l_name'];
    phone = json['phone'];
    email = json['email'];
    imageFullUrl = json['image_full_url'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['f_name'] = fName;
    data['l_name'] = lName;
    data['phone'] = phone;
    data['email'] = email;
    data['image_full_url'] = imageFullUrl;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}

class DeliveryMan {
  int? id;
  String? fName;
  String? lName;
  String? phone;
  String? email;
  String? imageFullUrl;
  int? zoneId;
  int? active;
  String? status;

  DeliveryMan({
    this.id,
    this.fName,
    this.lName,
    this.phone,
    this.email,
    this.imageFullUrl,
    this.zoneId,
    this.active,
    this.status,
  });

  DeliveryMan.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    fName = json['f_name'];
    lName = json['l_name'];
    phone = json['phone'];
    email = json['email'];
    imageFullUrl = json['image_full_url'];
    zoneId = json['zone_id'];
    active = json['active'];
    status = json['application_status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['f_name'] = fName;
    data['l_name'] = lName;
    data['phone'] = phone;
    data['email'] = email;
    data['image_full_url'] = imageFullUrl;
    data['zone_id'] = zoneId;
    data['active'] = active;
    data['available'] = status;
    return data;
  }
}

class Payments {
  int? id;
  int? orderId;
  double? amount;
  String? paymentStatus;
  String? paymentMethod;
  String? createdAt;
  String? updatedAt;

  Payments({
    this.id,
    this.orderId,
    this.amount,
    this.paymentStatus,
    this.paymentMethod,
    this.createdAt,
    this.updatedAt,
  });

  Payments.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    orderId = json['order_id'];
    amount = json['amount']?.toDouble();
    paymentStatus = json['payment_status'];
    paymentMethod = json['payment_method'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['order_id'] = orderId;
    data['amount'] = amount;
    data['payment_status'] = paymentStatus;
    data['payment_method'] = paymentMethod;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}

class OrderReference{
  int? id;
  int? orderId;
  String? tokenNumber;
  String? tableNumber;
  String? createdAt;
  String? updatedAt;

  OrderReference({this.id, this.orderId, this.tokenNumber, this.tableNumber, this.createdAt, this.updatedAt});

  OrderReference.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    orderId = json['order_id'];
    tokenNumber = json['token_number'];
    tableNumber = json['table_number'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['order_id'] = orderId;
    data['token_number'] = tokenNumber;
    data['table_number'] = tableNumber;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
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

class Eta {
  int? min;
  int? max;
  String? unit;
  String? text;
  String? from;
  String? to;
  String? window;
  String? fromAt;
  String? toAt;
  String? timezone;
  String? stage;

  Eta({
    this.min,
    this.max,
    this.unit,
    this.text,
    this.from,
    this.to,
    this.window,
    this.fromAt,
    this.toAt,
    this.timezone,
    this.stage,
  });

  Eta.fromJson(Map<String, dynamic> json) {
    min = json['min'];
    max = json['max'];
    unit = json['unit'];
    text = json['text'];
    from = json['from'];
    to = json['to'];
    window = json['window'];
    fromAt = json['from_at'];
    toAt = json['to_at'];
    timezone = json['timezone'];
    stage = json['stage'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['min'] = min;
    data['max'] = max;
    data['unit'] = unit;
    data['text'] = text;
    data['from'] = from;
    data['to'] = to;
    data['window'] = window;
    data['from_at'] = fromAt;
    data['to_at'] = toAt;
    data['timezone'] = timezone;
    data['stage'] = stage;
    return data;
  }
}
