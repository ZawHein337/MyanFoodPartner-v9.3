class ModulePermissionModel {
  bool? dashboard;
  bool? chat;
  bool? pos;
  bool? newAds;
  bool? adsList;
  bool? campaign;
  bool? coupon;
  bool? food;
  bool? category;
  bool? addon;
  bool? reviews;
  bool? regularOrder;
  bool? subscriptionOrder;
  bool? myWallet;
  bool? walletMethod;
  bool? roleManagement;
  bool? allEmployee;
  bool? expenseReport;
  bool? transaction;
  bool? disbursement;
  bool? orderReport;
  bool? foodReport;
  bool? taxReport;
  bool? myRestaurant;
  bool? restaurantConfig;
  bool? businessPlan;
  bool? myQrCode;
  bool? notificationSetup;
  bool? reels;

  ModulePermissionModel({
    this.dashboard,
    this.chat,
    this.pos,
    this.newAds,
    this.adsList,
    this.campaign,
    this.coupon,
    this.food,
    this.category,
    this.addon,
    this.reviews,
    this.regularOrder,
    this.subscriptionOrder,
    this.myWallet,
    this.walletMethod,
    this.roleManagement,
    this.allEmployee,
    this.expenseReport,
    this.transaction,
    this.disbursement,
    this.orderReport,
    this.foodReport,
    this.taxReport,
    this.myRestaurant,
    this.restaurantConfig,
    this.businessPlan,
    this.myQrCode,
    this.notificationSetup,
    this.reels,
  });

  ModulePermissionModel.fromJson(Map<String, dynamic> json) {
    dashboard = json['dashboard'];
    chat = json['chat'];
    pos = json['pos'];
    newAds = json['new_ads'];
    adsList = json['ads_list'];
    campaign = json['campaign'];
    coupon = json['coupon'];
    food = json['food'];
    category = json['category'];
    addon = json['addon'];
    reviews = json['reviews'];
    regularOrder = json['regular_order'];
    subscriptionOrder = json['subscription_order'];
    myWallet = json['my_wallet'];
    walletMethod = json['wallet_method'];
    roleManagement = json['role_management'];
    allEmployee = json['all_employee'];
    expenseReport = json['expense_report'];
    transaction = json['transaction'];
    disbursement = json['disbursement'];
    orderReport = json['order_report'];
    foodReport = json['food_report'];
    taxReport = json['tax_report'];
    myRestaurant = json['my_restaurant'];
    restaurantConfig = json['restaurant_config'];
    businessPlan = json['business_plan'];
    myQrCode = json['my_qr_code'];
    notificationSetup = json['notification_setup'];
    reels = json['reels'];
  }

  Map<String, bool?> toJson() {
    final Map<String, bool?> data = <String, bool?>{};
    data['dashboard'] = dashboard;
    data['chat'] = chat;
    data['pos'] = pos;
    data['new_ads'] = newAds;
    data['ads_list'] = adsList;
    data['campaign'] = campaign;
    data['coupon'] = coupon;
    data['food'] = food;
    data['category'] = category;
    data['addon'] = addon;
    data['reviews'] = reviews;
    data['regular_order'] = regularOrder;
    data['subscription_order'] = subscriptionOrder;
    data['my_wallet'] = myWallet;
    data['wallet_method'] = walletMethod;
    data['role_management'] = roleManagement;
    data['all_employee'] = allEmployee;
    data['expense_report'] = expenseReport;
    data['transaction'] = transaction;
    data['disbursement'] = disbursement;
    data['order_report'] = orderReport;
    data['food_report'] = foodReport;
    data['tax_report'] = taxReport;
    data['my_restaurant'] = myRestaurant;
    data['restaurant_config'] = restaurantConfig;
    data['business_plan'] = businessPlan;
    data['my_qr_code'] = myQrCode;
    data['notification_setup'] = notificationSetup;
    data['reels'] = reels;
    return data;
  }
}
