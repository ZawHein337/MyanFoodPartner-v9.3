class BogoOfferModel {
  int? totalSize;
  int? limit;
  int? offset;
  int? all;
  int? notJoined;
  int? pending;
  int? adminRequested;
  int? approved;
  int? rejected;
  List<BogoOffer>? offers;

  BogoOfferModel({
    this.totalSize, this.limit, this.offset, this.all, this.notJoined, this.pending,
    this.adminRequested, this.approved, this.rejected, this.offers,
  });

  BogoOfferModel.fromJson(Map<String, dynamic> json) {
    totalSize = json['total_size'];
    limit = json['limit'];
    offset = json['offset'];
    all = json['all'];
    notJoined = json['not_joined'];
    pending = json['pending'];
    adminRequested = json['admin_requested'];
    approved = json['approved'];
    rejected = json['rejected'];
    if(json['offers'] != null) {
      offers = [];
      json['offers'].forEach((offer) {
        offers!.add(BogoOffer.fromJson(offer));
      });
    }
  }
}

class BogoOffer {
  int? id;
  String? slug;
  String? title;
  String? description;
  String? imageFullUrl;
  int? buyQty;
  int? getQty;
  List<String>? orderTypes;
  int? usageLimitTotal;
  int? usageLimitPerCustomer;
  int? totalUses;
  String? startDate;
  String? endDate;
  int? status;
  bool? isExpired;
  bool? isEligible;
  String? ineligibleReason;
  String? enrollmentState;
  BogoEnrollment? enrollment;
  BogoOfferActions? actions;
  String? visibilityStatus;
  String? visibilityLabel;
  List<String>? visibilityReasons;

  BogoOffer({
    this.id, this.slug, this.title, this.description, this.imageFullUrl, this.buyQty, this.getQty,
    this.orderTypes, this.usageLimitTotal, this.usageLimitPerCustomer, this.totalUses, this.startDate,
    this.endDate, this.status, this.isExpired, this.isEligible, this.ineligibleReason, this.enrollmentState,
    this.enrollment, this.actions, this.visibilityStatus, this.visibilityLabel, this.visibilityReasons,
  });

  /// An approved offer the customer app still cannot show — the vendor needs telling why.
  bool get isNotVisibleToCustomers => visibilityStatus == 'not_visible';

  /// An invitation the admin raised that the restaurant has not answered yet.
  bool get isPendingAdminRequest => enrollmentState == 'admin_requested'
      && enrollment?.status == 'pending' && enrollment?.requestedBy == 'admin';

  BogoOffer.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    slug = json['slug'];
    title = json['title'];
    description = json['description'];
    imageFullUrl = json['image_full_url'];
    buyQty = json['buy_qty'];
    getQty = json['get_qty'];
    orderTypes = json['order_types'] != null ? List<String>.from(json['order_types']) : null;
    usageLimitTotal = json['usage_limit_total'];
    usageLimitPerCustomer = json['usage_limit_per_customer'];
    totalUses = json['total_uses'];
    startDate = json['start_date'];
    endDate = json['end_date'];
    status = json['status'];
    isExpired = json['is_expired'];
    isEligible = json['is_eligible'];
    ineligibleReason = json['ineligible_reason'];
    enrollmentState = json['enrollment_state'];
    enrollment = json['enrollment'] != null ? BogoEnrollment.fromJson(json['enrollment']) : null;
    actions = json['actions'] != null ? BogoOfferActions.fromJson(json['actions']) : null;
    visibilityStatus = json['visibility_status'];
    visibilityLabel = json['visibility_label'];
    visibilityReasons = json['visibility_reasons'] != null
        ? List<String>.from(json['visibility_reasons'].map((reason) => reason.toString())) : null;
  }
}

class BogoOfferJoinResponseModel {
  String? message;
  double? bundlePrice;
  String? enrollmentState;

  BogoOfferJoinResponseModel({this.message, this.bundlePrice, this.enrollmentState});

  BogoOfferJoinResponseModel.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    bundlePrice = double.tryParse(json['bundle_price'].toString());
    enrollmentState = json['enrollment_state'];
  }
}

class BogoOfferActions {
  bool? canJoin;
  bool? canResubmit;
  bool? canRespond;
  bool? canLeave;

  BogoOfferActions({this.canJoin, this.canResubmit, this.canRespond, this.canLeave});

  BogoOfferActions.fromJson(Map<String, dynamic> json) {
    canJoin = json['can_join'];
    canResubmit = json['can_resubmit'];
    canRespond = json['can_respond'];
    canLeave = json['can_leave'];
  }
}

class BogoEnrollment {
  int? id;
  String? status;
  String? requestedBy;
  String? rejectionReason;
  double? bundlePrice;
  String? joinedAt;
  List<BogoEnrollmentItem>? buyItems;
  List<BogoEnrollmentItem>? getItems;

  BogoEnrollment({
    this.id, this.status, this.requestedBy, this.rejectionReason, this.bundlePrice, this.joinedAt,
    this.buyItems, this.getItems,
  });

  BogoEnrollment.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    status = json['status'];
    requestedBy = json['requested_by'];
    rejectionReason = json['rejection_reason'];
    bundlePrice = double.tryParse(json['bundle_price'].toString());
    joinedAt = json['joined_at'];
    if(json['buy_items'] != null) {
      buyItems = [];
      json['buy_items'].forEach((item) {
        buyItems!.add(BogoEnrollmentItem.fromJson(item));
      });
    }
    if(json['get_items'] != null) {
      getItems = [];
      json['get_items'].forEach((item) {
        getItems!.add(BogoEnrollmentItem.fromJson(item));
      });
    }
  }
}

class BogoEnrollmentItem {
  int? foodId;
  String? foodName;
  String? foodImageFullUrl;
  int? quantity;
  double? price;
  List<dynamic>? variations;
  List<dynamic>? variationOptions;
  List<int>? addOnIds;
  List<int>? addOnQtys;
  List<dynamic>? addOns;

  BogoEnrollmentItem({
    this.foodId, this.foodName, this.foodImageFullUrl, this.quantity, this.price, this.variations,
    this.variationOptions, this.addOnIds, this.addOnQtys, this.addOns,
  });

  BogoEnrollmentItem.fromJson(Map<String, dynamic> json) {
    foodId = json['food_id'];
    foodName = json['food_name'];
    foodImageFullUrl = json['food_image_full_url'];
    quantity = json['quantity'];
    price = double.tryParse(json['price'].toString());
    variations = json['variations'];
    variationOptions = json['variation_options'];
    addOnIds = json['add_on_ids'] != null ? List<int>.from(json['add_on_ids'].map((v) => int.parse(v.toString()))) : null;
    addOnQtys = json['add_on_qtys'] != null ? List<int>.from(json['add_on_qtys'].map((v) => int.parse(v.toString()))) : null;
    addOns = json['add_ons'];
  }
}
