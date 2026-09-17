import 'package:stackfood_multivendor_restaurant/features/restaurant/domain/models/product_model.dart';

class ProfileModel {
  int? id;
  String? fName;
  String? lName;
  String? phone;
  String? email;
  String? createdAt;
  String? updatedAt;
  String? bankName;
  String? branch;
  String? holderName;
  String? accountNo;
  String? imageFullUrl;
  int? orderCount;
  int? productCount;
  int? reviewCount;
  int? todaysOrderCount;
  int? thisWeekOrderCount;
  int? thisMonthOrderCount;
  double? memberSinceDays;
  double? cashInHands;
  double? balance;
  double? totalEarning;
  double? todaysEarning;
  double? thisWeekEarning;
  double? thisMonthEarning;
  List<Restaurant>? restaurants;
  List<Translation>? translations;
  double? withdrawAbleBalance;
  double? payableBalance;
  bool? adjustable;
  bool? overFlowWarning;
  bool? overFlowBlockWarning;
  double? pendingWithdraw;
  double? alreadyWithdrawn;
  String? dynamicBalanceType;
  double? dynamicBalance;
  bool? showPayNowButton;
  Subscription? subscription;
  SubscriptionOtherData? subscriptionOtherData;
  bool? subscriptionTransactions;
  List<String>? roles;
  EmployeeInfo? employeeInfo;

  ProfileModel({
    this.id,
    this.fName,
    this.lName,
    this.phone,
    this.email,
    this.createdAt,
    this.updatedAt,
    this.bankName,
    this.branch,
    this.holderName,
    this.accountNo,
    this.imageFullUrl,
    this.orderCount,
    this.productCount,
    this.reviewCount,
    this.todaysOrderCount,
    this.thisWeekOrderCount,
    this.thisMonthOrderCount,
    this.memberSinceDays,
    this.cashInHands,
    this.balance,
    this.totalEarning,
    this.todaysEarning,
    this.thisWeekEarning,
    this.thisMonthEarning,
    this.restaurants,
    this.subscription,
    this.subscriptionOtherData,
    this.translations,
    this.withdrawAbleBalance,
    this.payableBalance,
    this.adjustable,
    this.overFlowWarning,
    this.overFlowBlockWarning,
    this.pendingWithdraw,
    this.alreadyWithdrawn,
    this.dynamicBalanceType,
    this.dynamicBalance,
    this.showPayNowButton,
    this.subscriptionTransactions,
    this.roles,
    this.employeeInfo,
  });

  ProfileModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    fName = json['f_name'];
    lName = json['l_name'];
    phone = json['phone'];
    email = json['email'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    bankName = json['bank_name'];
    branch = json['branch'];
    holderName = json['holder_name'];
    accountNo = json['account_no'];
    imageFullUrl = json['image_full_url'];
    orderCount = json['order_count'];
    productCount = json['product_count'];
    reviewCount = json['review_count'];
    todaysOrderCount = json['todays_order_count'];
    thisWeekOrderCount = json['this_week_order_count'];
    thisMonthOrderCount = json['this_month_order_count'];
    memberSinceDays = json['member_since_days']?.toDouble();
    cashInHands = json['cash_in_hands']?.toDouble();
    balance = json['balance']?.toDouble();
    totalEarning = json['total_earning']?.toDouble();
    todaysEarning = json['todays_earning']?.toDouble();
    thisWeekEarning = json['this_week_earning']?.toDouble();
    thisMonthEarning = json['this_month_earning']?.toDouble();
    if (json['restaurants'] != null) {
      restaurants = [];
      json['restaurants'].forEach((v) {
        restaurants!.add(Restaurant.fromJson(v));
      });
    }
    if (json['subscription'] != null) {
      subscription = Subscription.fromJson(json['subscription']);
    }
    subscriptionOtherData = json['subscription_other_data'] != null ? SubscriptionOtherData.fromJson(json['subscription_other_data']) : null;
    if (json['translations'] != null) {
      translations = [];
      json['translations'].forEach((v) {
        translations!.add(Translation.fromJson(v));
      });
    }
    withdrawAbleBalance = json['withdraw_able_balance']?.toDouble();
    payableBalance = json['Payable_Balance']?.toDouble();
    adjustable = json['adjust_able'];
    overFlowWarning = json['over_flow_warning'];
    overFlowBlockWarning = json['over_flow_block_warning'];
    pendingWithdraw = json['pending_withdraw']?.toDouble();
    alreadyWithdrawn = json['total_withdrawn']?.toDouble();
    dynamicBalanceType = json['dynamic_balance_type'];
    dynamicBalance = json['dynamic_balance']?.toDouble();
    showPayNowButton = json['show_pay_now_button'];
    subscriptionTransactions = json['subscription_transactions'] ?? false;
    if (json['roles'] != null) {
      roles = [];
      json['roles'].forEach((v) => roles!.add(v));
    }
    if (json['employee_info'] != null) {
      employeeInfo = EmployeeInfo.fromJson(json['employee_info']);
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['f_name'] = fName;
    data['l_name'] = lName;
    data['phone'] = phone;
    data['email'] = email;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['bank_name'] = bankName;
    data['branch'] = branch;
    data['holder_name'] = holderName;
    data['account_no'] = accountNo;
    data['image_full_url'] = imageFullUrl;
    data['order_count'] = orderCount;
    data['product_count'] = productCount;
    data['review_count'] = reviewCount;
    data['todays_order_count'] = todaysOrderCount;
    data['this_week_order_count'] = thisWeekOrderCount;
    data['this_month_order_count'] = thisMonthOrderCount;
    data['member_since_days'] = memberSinceDays;
    data['cash_in_hands'] = cashInHands;
    data['balance'] = balance;
    data['total_earning'] = totalEarning;
    data['todays_earning'] = todaysEarning;
    data['this_week_earning'] = thisWeekEarning;
    data['this_month_earning'] = thisMonthEarning;
    if (restaurants != null) {
      data['restaurants'] = restaurants!.map((v) => v.toJson()).toList();
    }
    data['withdraw_able_balance'] = withdrawAbleBalance;
    data['Payable_Balance'] = payableBalance;
    data['adjust_able'] = adjustable;
    data['over_flow_warning'] = overFlowWarning;
    data['over_flow_block_warning'] = overFlowBlockWarning;
    data['pending_withdraw'] = pendingWithdraw;
    data['total_withdrawn'] = alreadyWithdrawn;
    data['dynamic_balance_type'] = dynamicBalanceType;
    data['dynamic_balance'] = dynamicBalance;
    data['show_pay_now_button'] = showPayNowButton;
    data['subscription_transactions'] = subscriptionTransactions;
    if (roles != null) {
      data['roles'] = roles;
    }
    if (employeeInfo != null) {
      data['employee_info'] = employeeInfo!.toJson();
    }
    return data;
  }
}

class Restaurant {
  int? id;
  String? name;
  String? phone;
  String? email;
  String? logoFullUrl;
  String? latitude;
  String? longitude;
  String? address;
  double? minimumOrder;
  bool? scheduleOrder;
  String? currency;
  String? createdAt;
  String? updatedAt;
  bool? freeDelivery;
  String? coverPhotoFullUrl;
  bool? delivery;
  bool? takeAway;
  bool? orderSubscriptionActive;
  double? tax;
  bool? reviewsSection;
  bool? foodSection;
  String? availableTimeStarts;
  String? availableTimeEnds;
  double? avgRating;
  int? ratingCount;
  bool? active;
  bool? gstStatus;
  String? gstCode;
  int? selfDeliverySystem;
  bool? posSystem;
  double? minimumShippingCharge;
  double? maximumShippingCharge;
  double? perKmShippingCharge;
  String? restaurantModel;
  int? veg;
  int? nonVeg;
  Discount? discount;
  List<Schedules>? schedules;
  String? deliveryTime;
  List<Cuisine>? cuisines;
  bool? cutlery;
  List<Translation>? translations;
  String? metaTitle;
  String? metaDescription;
  String? metaKeyWord;
  String? metaImageFullUrl;
  String? announcementMessage;
  int? isAnnouncementActive;
  bool? instanceOrder;
  int? extraPackagingStatus;
  double? extraPackagingAmount;
  bool? isHalalActive;
  List<String>? characteristics;
  bool? isExtraPackagingActive;
  String? restaurantBusinessModel;
  double? comission;
  int? scheduleAdvanceDineInBookingDuration;
  String? scheduleAdvanceDineInBookingDurationTimeFormat;
  bool? isDineInActive;
  bool? customDateOrderStatus;
  int? customOrderDate;
  List<String?>? tags;
  bool? canEditOrder;
  MetaSeoData? metaData;
  bool? openingClosingStatus;
  bool? sameTimeForEveryDay;
  bool? verifiedSeller;

  Restaurant({
    this.id,
    this.name,
    this.phone,
    this.email,
    this.logoFullUrl,
    this.latitude,
    this.longitude,
    this.address,
    this.minimumOrder,
    this.scheduleOrder,
    this.currency,
    this.createdAt,
    this.updatedAt,
    this.freeDelivery,
    this.coverPhotoFullUrl,
    this.delivery,
    this.takeAway,
    this.orderSubscriptionActive,
    this.tax,
    this.reviewsSection,
    this.foodSection,
    this.availableTimeStarts,
    this.availableTimeEnds,
    this.avgRating,
    this.ratingCount,
    this.active,
    this.gstStatus,
    this.gstCode,
    this.selfDeliverySystem,
    this.posSystem,
    this.minimumShippingCharge,
    this.maximumShippingCharge,
    this.perKmShippingCharge,
    this.restaurantModel,
    this.veg,
    this.nonVeg,
    this.discount,
    this.schedules,
    this.deliveryTime,
    this.cuisines,
    this.cutlery,
    this.translations,
    this.metaTitle,
    this.metaDescription,
    this.metaKeyWord,
    this.metaImageFullUrl,
    this.announcementMessage,
    this.isAnnouncementActive,
    this.instanceOrder,
    this.extraPackagingStatus,
    this.extraPackagingAmount,
    this.isHalalActive,
    this.characteristics,
    this.isExtraPackagingActive,
    this.restaurantBusinessModel,
    this.comission,
    this.scheduleAdvanceDineInBookingDuration,
    this.scheduleAdvanceDineInBookingDurationTimeFormat,
    this.isDineInActive,
    this.customDateOrderStatus,
    this.customOrderDate,
    this.tags,
    this.canEditOrder,
    this.metaData,
    this.openingClosingStatus,
    this.sameTimeForEveryDay,
    this.verifiedSeller,
  });

  Restaurant.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    phone = json['phone'];
    email = json['email'];
    logoFullUrl = json['logo_full_url'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    address = json['address'];
    minimumOrder = json['minimum_order']?.toDouble();
    scheduleOrder = json['schedule_order'];
    currency = json['currency'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    freeDelivery = json['free_delivery'];
    coverPhotoFullUrl = json['cover_photo_full_url'];
    delivery = json['delivery'];
    takeAway = json['take_away'];
    orderSubscriptionActive = json['order_subscription_active'];
    tax = json['tax']?.toDouble();
    reviewsSection = json['reviews_section'];
    foodSection = json['food_section'];
    availableTimeStarts = json['available_time_starts'];
    availableTimeEnds = json['available_time_ends'];
    avgRating = json['avg_rating']?.toDouble();
    ratingCount = json['rating_count'];
    active = json['active'];
    gstStatus = json['gst_status'];
    gstCode = json['gst_code'];
    selfDeliverySystem = json['self_delivery_system'];
    posSystem = json['pos_system'];
    minimumShippingCharge = json['minimum_shipping_charge']?.toDouble();
    maximumShippingCharge = json['maximum_shipping_charge']?.toDouble();
    perKmShippingCharge = json['per_km_shipping_charge']?.toDouble();
    restaurantModel = json['restaurant_model'];
    veg = json['veg'];
    nonVeg = json['non_veg'];
    discount = json['discount'] != null ? Discount.fromJson(json['discount']) : null;
    if (json['schedules'] != null) {
      schedules = <Schedules>[];
      json['schedules'].forEach((v) {
        schedules!.add(Schedules.fromJson(v));
      });
    }
    deliveryTime = json['delivery_time'];
    if (json['cuisine'] != null) {
      cuisines = <Cuisine>[];
      json['cuisine'].forEach((v) {
        cuisines!.add(Cuisine.fromJson(v));
      });
    }
    cutlery = json['cutlery'];
    if (json['translations'] != null) {
      translations = [];
      json['translations'].forEach((v) {
        translations!.add(Translation.fromJson(v));
      });
    }
    metaTitle = json['meta_title'];
    metaDescription = json['meta_description'];
    metaKeyWord = json['meta_key_word'];
    metaImageFullUrl = json['meta_image_full_url'];
    announcementMessage = json['announcement_message'];
    isAnnouncementActive = json['announcement'];
    instanceOrder = json['instant_order'];
    extraPackagingStatus = json['extra_packaging_status'].runtimeType == bool ? 1 : 0;
    extraPackagingAmount = json['extra_packaging_amount']?.toDouble();
    isHalalActive = json['halal_tag_status'] ?? false;
    characteristics = json['characteristics'].cast<String>();
    isExtraPackagingActive = json['is_extra_packaging_active'];
    restaurantBusinessModel = json['restaurant_model'];
    comission = json['comission']?.toDouble();
    scheduleAdvanceDineInBookingDuration = json['schedule_advance_dine_in_booking_duration'];
    scheduleAdvanceDineInBookingDurationTimeFormat = json['schedule_advance_dine_in_booking_duration_time_format'];
    isDineInActive = json['is_dine_in_active'];
    customDateOrderStatus = json['customer_date_order_sratus'];
    customOrderDate = json['customer_order_date'];
    if(json['tags'] != null) {
      tags = [];
      for(String v in json['tags']) {
        tags!.add(v);
      }
    }
    canEditOrder = json['can_edit_order'] ?? false;
    metaData = json['meta_data'] != null ? MetaSeoData.fromJson(json['meta_data']) : null;
    openingClosingStatus = json['opening_closing_status'];
    sameTimeForEveryDay = json['same_time_for_every_day'];
    verifiedSeller = json['verified_seller'] == 1 || json['verified_seller'] == true;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['phone'] = phone;
    data['email'] = email;
    data['logo_full_url'] = logoFullUrl;
    data['latitude'] = latitude;
    data['longitude'] = longitude;
    data['address'] = address;
    data['minimum_order'] = minimumOrder;
    data['schedule_order'] = scheduleOrder;
    data['currency'] = currency;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['free_delivery'] = freeDelivery;
    data['cover_photo_full_url'] = coverPhotoFullUrl;
    data['delivery'] = delivery;
    data['take_away'] = takeAway;
    data['order_subscription_active'] = orderSubscriptionActive;
    data['tax'] = tax;
    data['reviews_section'] = reviewsSection;
    data['food_section'] = foodSection;
    data['available_time_starts'] = availableTimeStarts;
    data['available_time_ends'] = availableTimeEnds;
    data['avg_rating'] = avgRating;
    data['rating_count '] = ratingCount;
    data['active'] = active;
    data['gst_status'] = gstStatus;
    data['gst_code'] = gstCode;
    data['self_delivery_system'] = selfDeliverySystem;
    data['pos_system'] = posSystem;
    data['minimum_shipping_charge'] = minimumShippingCharge;
    data['maximum_shipping_charge'] = maximumShippingCharge;
    data['per_km_shipping_charge'] = perKmShippingCharge;
    data['restaurant_model'] = restaurantModel;
    data['veg'] = veg;
    data['non_veg'] = nonVeg;
    if (discount != null) {
      data['discount'] = discount!.toJson();
    }
    if (schedules != null) {
      data['schedules'] = schedules!.map((v) => v.toJson()).toList();
    }
    data['delivery_time'] = deliveryTime;
    if (cuisines != null) {
      data['cuisine'] = cuisines!.map((v) => v.toJson()).toList();
    }
    data['cutlery'] = cutlery;
    data['meta_title'] = metaTitle;
    data['meta_description'] = metaDescription;
    data['meta_key_word'] = metaKeyWord;
    data['meta_image_full_url'] = metaImageFullUrl;
    data['announcement_message'] = announcementMessage;
    data['announcement'] = isAnnouncementActive;
    data['instant_order'] = instanceOrder;
    data['extra_packaging_status'] = extraPackagingStatus;
    data['extra_packaging_amount'] = extraPackagingAmount;
    data['halal_tag_status'] = isHalalActive;
    data['characteristics'] = characteristics;
    data['is_extra_packaging_active'] = isExtraPackagingActive;
    data['restaurant_model'] = restaurantBusinessModel;
    data['comission'] = comission;
    data['schedule_advance_dine_in_booking_duration'] = scheduleAdvanceDineInBookingDuration;
    data['schedule_advance_dine_in_booking_duration_time_format'] = scheduleAdvanceDineInBookingDurationTimeFormat;
    data['is_dine_in_active'] = isDineInActive;
    data['customer_date_order_sratus'] = customDateOrderStatus;
    data['customer_order_date'] = customOrderDate;
    if(tags != null) {
      data['tags'] = tags;
    }
    data['can_edit_order'] = canEditOrder;
    if (metaData != null) {
      data['meta_data'] = metaData!.toJson();
    }
    data['opening_closing_status'] = openingClosingStatus;
    data['same_time_for_every_day'] = sameTimeForEveryDay;
    data['verified_seller'] = verifiedSeller;
    return data;
  }
}

class Cuisine {
  int? id;
  String? name;
  String? image;
  int? status;
  String? slug;
  String? createdAt;
  String? updatedAt;
  Pivot? pivot;

  Cuisine({
    this.id,
    this.name,
    this.image,
    this.status,
    this.slug,
    this.createdAt,
    this.updatedAt,
    this.pivot,
  });

  Cuisine.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    image = json['image'];
    status = json['status'];
    slug = json['slug'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    pivot = json['pivot'] != null ? Pivot.fromJson(json['pivot']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['image'] = image;
    data['status'] = status;
    data['slug'] = slug;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    if (pivot != null) {
      data['pivot'] = pivot!.toJson();
    }
    return data;
  }
}

class Pivot {
  int? restaurantId;
  int? cuisineId;

  Pivot({this.restaurantId, this.cuisineId});

  Pivot.fromJson(Map<String, dynamic> json) {
    restaurantId = int.parse(json['restaurant_id'].toString());
    cuisineId = int.parse(json['cuisine_id'].toString());
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['restaurant_id'] = restaurantId;
    data['cuisine_id'] = cuisineId;
    return data;
  }
}

class Discount {
  int? id;
  String? startDate;
  String? endDate;
  String? startTime;
  String? endTime;
  double? minPurchase;
  double? maxDiscount;
  double? discount;
  String? discountType;
  int? restaurantId;
  String? createdAt;
  String? updatedAt;

  Discount({
    this.id,
    this.startDate,
    this.endDate,
    this.startTime,
    this.endTime,
    this.minPurchase,
    this.maxDiscount,
    this.discount,
    this.discountType,
    this.restaurantId,
    this.createdAt,
    this.updatedAt,
  });

  Discount.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    startDate = json['start_date'];
    endDate = json['end_date'];
    startTime = json['start_time'];
    endTime = json['end_time'];
    minPurchase = json['min_purchase']?.toDouble();
    maxDiscount = json['max_discount']?.toDouble();
    discount = json['discount']?.toDouble();
    discountType = json['discount_type'];
    restaurantId = json['restaurant_id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['start_date'] = startDate;
    data['end_date'] = endDate;
    data['start_time'] = startTime;
    data['end_time'] = endTime;
    data['min_purchase'] = minPurchase;
    data['max_discount'] = maxDiscount;
    data['discount'] = discount;
    data['discount_type'] = discountType;
    data['restaurant_id'] = restaurantId;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}

class Schedules {
  int? id;
  int? restaurantId;
  int? day;
  String? openingTime;
  String? closingTime;

  Schedules({
    this.id,
    this.restaurantId,
    this.day,
    this.openingTime,
    this.closingTime,
  });

  Schedules.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    restaurantId = json['restaurant_id'];
    day = json['day'];
    openingTime = json['opening_time'].substring(0, 5);
    closingTime = json['closing_time'].substring(0, 5);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['restaurant_id'] = restaurantId;
    data['day'] = day;
    data['opening_time'] = openingTime;
    data['closing_time'] = closingTime;
    return data;
  }
}

class Subscription {
  int? id;
  int? packageId;
  int? restaurantId;
  String? expiryDate;
  String? maxOrder;
  String? maxProduct;
  int? pos;
  int? mobileApp;
  int? chat;
  int? review;
  int? selfDelivery;
  int? status;
  int? isTrial;
  int? totalPackageRenewed;
  String? createdAt;
  String? updatedAt;
  String? renewedAt;
  int? isCanceled;
  String? canceledBy;
  int? validity;
  Package? package;

  Subscription({
    this.id,
    this.packageId,
    this.restaurantId,
    this.expiryDate,
    this.maxOrder,
    this.maxProduct,
    this.pos,
    this.mobileApp,
    this.chat,
    this.review,
    this.selfDelivery,
    this.status,
    this.isTrial,
    this.totalPackageRenewed,
    this.createdAt,
    this.updatedAt,
    this.renewedAt,
    this.isCanceled,
    this.canceledBy,
    this.validity,
    this.package,
  });

  Subscription.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    packageId = json['package_id'];
    restaurantId = json['restaurant_id'];
    expiryDate = json['expiry_date'];
    maxOrder = json['max_order'];
    maxProduct = json['max_product'];
    pos = json['pos'] ?? 0;
    mobileApp = json['mobile_app'] ?? 0;
    chat = json['chat'] ?? 0;
    review = json['review'] ?? 0;
    selfDelivery = json['self_delivery'];
    status = json['status'];
    isTrial = json['is_trial'];
    totalPackageRenewed = json['total_package_renewed'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    renewedAt = json['renewed_at'];
    isCanceled = json['is_canceled'];
    canceledBy = json['canceled_by'];
    validity = json['validity'];
    package = json['package'] != null ? Package.fromJson(json['package']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['package_id'] = packageId;
    data['restaurant_id'] = restaurantId;
    data['expiry_date'] = expiryDate;
    data['max_order'] = maxOrder;
    data['max_product'] = maxProduct;
    data['pos'] = pos;
    data['mobile_app'] = mobileApp;
    data['chat'] = chat;
    data['review'] = review;
    data['self_delivery'] = selfDelivery;
    data['status'] = status;
    data['total_package_renewed'] = totalPackageRenewed;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['renewed_at'] = renewedAt;
    data['is_canceled'] = isCanceled;
    data['canceled_by'] = canceledBy;
    data['validity'] = validity;
    if (package != null) {
      data['package'] = package!.toJson();
    }
    return data;
  }
}

class Package {
  int? id;
  String? packageName;
  double? price;
  int? validity;
  String? maxOrder;
  String? maxProduct;
  int? pos;
  int? mobileApp;
  int? chat;
  int? review;
  int? selfDelivery;
  int? status;
  int? def;
  String? colour;
  String? text;
  String? createdAt;
  String? updatedAt;

  Package({
    this.id,
    this.packageName,
    this.price,
    this.validity,
    this.maxOrder,
    this.maxProduct,
    this.pos,
    this.mobileApp,
    this.chat,
    this.review,
    this.selfDelivery,
    this.status,
    this.def,
    this.colour,
    this.text,
    this.createdAt,
    this.updatedAt,
  });

  Package.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    packageName = json['package_name'];
    price = json['price']?.toDouble();
    validity = json['validity'];
    maxOrder = json['max_order'];
    maxProduct = json['max_product'];
    pos = json['pos'];
    mobileApp = json['mobile_app'];
    chat = json['chat'];
    review = json['review'];
    selfDelivery = json['self_delivery'];
    status = json['status'];
    def = json['default'];
    colour = json['colour'];
    text = json['text'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['package_name'] = packageName;
    data['price'] = price;
    data['validity'] = validity;
    data['max_order'] = maxOrder;
    data['max_product'] = maxProduct;
    data['pos'] = pos;
    data['mobile_app'] = mobileApp;
    data['chat'] = chat;
    data['review'] = review;
    data['self_delivery'] = selfDelivery;
    data['status'] = status;
    data['default'] = def;
    data['colour'] = colour;
    data['text'] = text;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}

class SubscriptionOtherData {
  double? totalBill;
  int? maxProductUpload;
  double? pendingBill;

  SubscriptionOtherData({
    this.totalBill,
    this.maxProductUpload,
    this.pendingBill,
  });

  SubscriptionOtherData.fromJson(Map<String, dynamic> json) {
    totalBill = json['total_bill']?.toDouble();
    maxProductUpload = json['max_product_uploads'];
    pendingBill = json['pending_bill']?.toDouble();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['total_bill'] = totalBill;
    data['max_product_uploads'] = maxProductUpload;
    data['pending_bill'] = pendingBill;
    return data;
  }
}

class EmployeeInfo {
  int? id;
  String? fName;
  String? lName;
  String? phone;
  String? email;
  String? imageFullUrl;
  int? employeeRoleId;
  int? restaurantId;

  EmployeeInfo({
    this.id,
    this.fName,
    this.lName,
    this.phone,
    this.email,
    this.imageFullUrl,
    this.employeeRoleId,
    this.restaurantId,
  });

  EmployeeInfo.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    fName = json['f_name'];
    lName = json['l_name'];
    phone = json['phone'];
    email = json['email'];
    imageFullUrl = json['image_full_url'];
    employeeRoleId = json['employee_role_id'];
    restaurantId = json['restaurant_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['f_name'] = fName;
    data['l_name'] = lName;
    data['phone'] = phone;
    data['email'] = email;
    data['image_full_url'] = imageFullUrl;
    data['employee_role_id'] = employeeRoleId;
    data['restaurant_id'] = restaurantId;
    return data;
  }
}

class MetaSeoData {
  String? metaIndex;
  String? metaNoFollow;
  String? metaNoArchive;
  String? metaNoSnippet;
  String? metaMaxSnippet;
  String? metaNoImageIndex;
  String? metaMaxImagePreview;
  String? metaMaxSnippetValue;
  String? metaMaxVideoPreview;
  String? metaMaxImagePreviewValue;
  String? metaMaxVideoPreviewValue;

  MetaSeoData({this.metaIndex, this.metaNoFollow, this.metaNoArchive, this.metaNoSnippet, this.metaMaxSnippet, this.metaNoImageIndex, this.metaMaxImagePreview, this.metaMaxSnippetValue, this.metaMaxVideoPreview, this.metaMaxImagePreviewValue, this.metaMaxVideoPreviewValue});

  MetaSeoData.fromJson(Map<String, dynamic> json) {
    metaIndex = json['meta_index']?.toString();
    metaNoFollow = json['meta_no_follow']?.toString();
    metaNoArchive = json['meta_no_archive']?.toString();
    metaNoSnippet = json['meta_no_snippet']?.toString();
    metaMaxSnippet = json['meta_max_snippet']?.toString();
    metaNoImageIndex = json['meta_no_image_index']?.toString();
    metaMaxImagePreview = json['meta_max_image_preview']?.toString();
    metaMaxSnippetValue = json['meta_max_snippet_value']?.toString();
    metaMaxVideoPreview = json['meta_max_video_preview']?.toString();
    metaMaxImagePreviewValue = json['meta_max_image_preview_value']?.toString();
    metaMaxVideoPreviewValue = json['meta_max_video_preview_value']?.toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['meta_index'] = metaIndex;
    data['meta_no_follow'] = metaNoFollow;
    data['meta_no_archive'] = metaNoArchive;
    data['meta_no_snippet'] = metaNoSnippet;
    data['meta_max_snippet'] = metaMaxSnippet;
    data['meta_no_image_index'] = metaNoImageIndex;
    data['meta_max_image_preview'] = metaMaxImagePreview;
    data['meta_max_snippet_value'] = metaMaxSnippetValue;
    data['meta_max_video_preview'] = metaMaxVideoPreview;
    data['meta_max_image_preview_value'] = metaMaxImagePreviewValue;
    data['meta_max_video_preview_value'] = metaMaxVideoPreviewValue;
    return data;
  }
}