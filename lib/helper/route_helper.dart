import 'dart:convert';
import 'package:get/get.dart';
import 'package:stackfood_multivendor_restaurant/common/screens/payment_screen.dart';
import 'package:stackfood_multivendor_restaurant/features/addon/screens/add_addon_screen.dart';
import 'package:stackfood_multivendor_restaurant/features/addon/screens/addon_screen.dart';
import 'package:stackfood_multivendor_restaurant/features/advertisement/screens/advertisement_details_screen.dart';
import 'package:stackfood_multivendor_restaurant/features/advertisement/screens/advertisement_list_screen.dart';
import 'package:stackfood_multivendor_restaurant/features/advertisement/screens/create_advertisement_screen.dart';
import 'package:stackfood_multivendor_restaurant/features/auth/screens/forget_pass_screen.dart';
import 'package:stackfood_multivendor_restaurant/features/auth/screens/new_pass_screen.dart';
import 'package:stackfood_multivendor_restaurant/features/auth/screens/restaurant_registration_screen.dart';
import 'package:stackfood_multivendor_restaurant/features/auth/screens/sign_in_screen.dart';
import 'package:stackfood_multivendor_restaurant/features/auth/screens/verification_screen.dart';
import 'package:stackfood_multivendor_restaurant/features/bogo_offer/screen/bogo_campaign_list_screen.dart';
import 'package:stackfood_multivendor_restaurant/features/bogo_offer/screen/bogo_offer_setup_screen.dart';
import 'package:stackfood_multivendor_restaurant/features/business/screens/subscription_payment_screen.dart';
import 'package:stackfood_multivendor_restaurant/features/business/screens/subscription_success_or_failed_screen.dart';
import 'package:stackfood_multivendor_restaurant/features/campaign/screens/campaign_details_screen.dart';
import 'package:stackfood_multivendor_restaurant/features/campaign/screens/campaign_screen.dart';
import 'package:stackfood_multivendor_restaurant/features/category/screens/category_screen.dart';
import 'package:stackfood_multivendor_restaurant/features/chat/domain/models/conversation_model.dart';
import 'package:stackfood_multivendor_restaurant/features/chat/domain/models/notification_body_model.dart';
import 'package:stackfood_multivendor_restaurant/features/chat/screens/chat_screen.dart';
import 'package:stackfood_multivendor_restaurant/features/chat/screens/conversation_screen.dart';
import 'package:stackfood_multivendor_restaurant/features/coupon/screens/coupon_screen.dart';
import 'package:stackfood_multivendor_restaurant/features/dashboard/screens/dashboard_screen.dart';
import 'package:stackfood_multivendor_restaurant/features/deliveryman/domain/models/delivery_man_model.dart';
import 'package:stackfood_multivendor_restaurant/features/deliveryman/screens/add_delivery_man_screen.dart';
import 'package:stackfood_multivendor_restaurant/features/deliveryman/screens/delivery_man_details_screen.dart';
import 'package:stackfood_multivendor_restaurant/features/deliveryman/screens/delivery_man_screen.dart';
import 'package:stackfood_multivendor_restaurant/features/disbursement/screens/add_withdraw_method_screen.dart';
import 'package:stackfood_multivendor_restaurant/features/disbursement/screens/disbursement_menu_screen.dart';
import 'package:stackfood_multivendor_restaurant/features/disbursement/screens/disbursement_screen.dart';
import 'package:stackfood_multivendor_restaurant/features/disbursement/screens/withdraw_method_screen.dart';
import 'package:stackfood_multivendor_restaurant/features/expense/screens/expense_screen.dart';
import 'package:stackfood_multivendor_restaurant/features/happy_hour/screens/happy_hour_details_screen.dart';
import 'package:stackfood_multivendor_restaurant/features/happy_hour/screens/happy_hour_list_screen.dart';
import 'package:stackfood_multivendor_restaurant/features/html/screens/html_viewer_screen.dart';
import 'package:stackfood_multivendor_restaurant/features/language/screens/language_screen.dart';
import 'package:stackfood_multivendor_restaurant/features/notification/screens/notification_screen.dart';
import 'package:stackfood_multivendor_restaurant/features/order/domain/models/order_model.dart';
import 'package:stackfood_multivendor_restaurant/features/order/screens/edit_delivery_address/edit_delivery_address_screen.dart';
import 'package:stackfood_multivendor_restaurant/features/order/screens/edit_delivery_address/pick_map_screen.dart';
import 'package:stackfood_multivendor_restaurant/features/order/screens/edit_order/add_new_product_screen.dart';
import 'package:stackfood_multivendor_restaurant/features/order/screens/edit_order/edit_product_screen.dart';
import 'package:stackfood_multivendor_restaurant/features/order/screens/order_details_screen.dart';
import 'package:stackfood_multivendor_restaurant/features/payment/screens/bank_info_screen.dart';
import 'package:stackfood_multivendor_restaurant/features/payment/screens/payment_history_screen.dart';
import 'package:stackfood_multivendor_restaurant/features/payment/screens/payment_successful_screen.dart';
import 'package:stackfood_multivendor_restaurant/features/payment/screens/wallet_screen.dart';
import 'package:stackfood_multivendor_restaurant/features/payment/screens/withdraw_request_history_screen.dart';
import 'package:stackfood_multivendor_restaurant/features/profile/domain/models/profile_model.dart';
import 'package:stackfood_multivendor_restaurant/features/profile/screens/profile_screen.dart';
import 'package:stackfood_multivendor_restaurant/features/profile/screens/setting_screen.dart';
import 'package:stackfood_multivendor_restaurant/features/profile/screens/update_profile_screen.dart';
import 'package:stackfood_multivendor_restaurant/features/reels/domain/models/reel_model.dart';
import 'package:stackfood_multivendor_restaurant/features/reels/screens/add_reel_screen.dart';
import 'package:stackfood_multivendor_restaurant/features/reels/screens/reel_details_screen.dart';
import 'package:stackfood_multivendor_restaurant/features/reels/screens/reels_screen.dart';
import 'package:stackfood_multivendor_restaurant/features/reports/screens/campaign/screens/campaign_report_screen.dart';
import 'package:stackfood_multivendor_restaurant/features/reports/screens/earinig/screens/earning_report_screen.dart';
import 'package:stackfood_multivendor_restaurant/features/reports/screens/food/screens/food_report_screen.dart';
import 'package:stackfood_multivendor_restaurant/features/reports/screens/order/screens/order_report_screen.dart';
import 'package:stackfood_multivendor_restaurant/features/reports/screens/reports_screen.dart';
import 'package:stackfood_multivendor_restaurant/features/reports/screens/tax/screens/tax_report_screen.dart';
import 'package:stackfood_multivendor_restaurant/features/reports/screens/transaction/screens/transaction_report_screen.dart';
import 'package:stackfood_multivendor_restaurant/features/restaurant/domain/models/product_model.dart';
import 'package:stackfood_multivendor_restaurant/features/restaurant/domain/models/review_model.dart';
import 'package:stackfood_multivendor_restaurant/features/restaurant/screens/add_product_screen.dart';
import 'package:stackfood_multivendor_restaurant/features/restaurant/screens/all_product_screen.dart';
import 'package:stackfood_multivendor_restaurant/features/restaurant/screens/product_details_screen.dart';
import 'package:stackfood_multivendor_restaurant/features/restaurant/screens/restaurant_edit_screen.dart';
import 'package:stackfood_multivendor_restaurant/features/restaurant/screens/restaurant_screen.dart';
import 'package:stackfood_multivendor_restaurant/features/restaurant/screens/restaurant_settings_screen.dart';
import 'package:stackfood_multivendor_restaurant/features/review/screens/customer_review_screen.dart';
import 'package:stackfood_multivendor_restaurant/features/review/screens/review_reply_screen.dart';
import 'package:stackfood_multivendor_restaurant/features/splash/screens/splash_screen.dart';
import 'package:stackfood_multivendor_restaurant/features/subscription/screens/my_subscription_screen.dart';
import 'package:stackfood_multivendor_restaurant/features/update/screens/update_screen.dart';

class RouteHelper {
  static const String initial = '/';
  static const String splash = '/splash';
  static const String language = '/language';
  static const String signIn = '/sign-in';
  static const String verification = '/verification';
  static const String main = '/main';
  static const String forgotPassword = '/forgot-password';
  static const String resetPassword = '/reset-password';
  static const String orderDetails = '/order-details';
  static const String profile = '/profile';
  static const String updateProfile = '/update-profile';
  static const String notification = '/notification';
  static const String bankInfo = '/bank-info';
  static const String wallet = '/wallet';
  static const String withdrawHistory = '/withdraw-history';
  static const String restaurant = '/restaurant';
  static const String campaign = '/campaign';
  static const String campaignDetails = '/campaign-details';
  static const String bogoOffer = '/bogo-offer';
  static const String bogoOfferDetails = '/bogo-offer-details';
  static const String happyHour = '/happy-hour';
  static const String happyHourDetails = '/happy-hour-details';
  static const String addProduct = '/add-product';
  static const String categories = '/categories';
  static const String restaurantEdit = '/restaurant-edit';
  static const String addons = '/addons';
  static const String productDetails = '/product-details';
  static const String pos = '/pos';
  static const String deliveryMan = '/delivery-man';
  static const String addDeliveryMan = '/add-delivery-man';
  static const String deliveryManDetails = '/delivery-man-details';
  static const String terms = '/terms-and-condition';
  static const String privacy = '/privacy-policy';
  static const String update = '/update';
  static const String chatScreen = '/chat-screen';
  static const String conversationListScreen = '/chat-list-screen';
  static const String restaurantRegistration = '/restaurant-registration';
  static const String coupon = '/coupon';
  static const String expense = '/expense';
  static const String earning = '/earning';
  static const String payment = '/payment';
  static const String success = '/success';
  static const String transactionReport = '/transaction-report';
  static const String orderReport = '/order-report';
  static const String foodReport = '/food-report';
  static const String campaignReport = '/campaign-report';
  static const String taxReport = '/tax-report';
  static const String disbursement = '/disbursement';
  static const String withdrawMethod = '/withdraw-method';
  static const String addWithdrawMethod = '/add-withdraw-method';
  static const String paymentHistory = '/payment-history';
  static const String reports = '/reports';
  static const String disbursementMenu = '/disbursement-menu';
  static const String customerReview = '/customer-review';
  static const String reviewReply = '/review-reply';
  static const String advertisementList = '/advertisement-list';
  static const String createAdvertisement = '/create-advertisement';
  static const String advertisementDetails = '/advertisement-details';
  static const String addAddon = '/add-addon';
  static const String restaurantSetting = '/restaurant-setting';
  static const String allProducts = '/all-products';
  static const String subscriptionSuccess = '/subscription-success';
  static const String subscriptionPayment = '/subscription-payment';
  static const String mySubscription = '/my-subscription';
  static const String editDeliveryAddress = '/edit-delivery-address';
  static const String pickMap = '/pick-map';
  static const String addNewProduct = '/add-new-product';
  static const String editProduct = '/edit-product';
  static const String setting = '/setting';
  static const String reels = '/reels';
  static const String addReel = '/add-reel';
  static const String reelDetails = '/reel-details';

  static String getInitialRoute() => initial;
  static String getSplashRoute(NotificationBodyModel? body) {
    String data = 'null';
    if(body != null) {
      List<int> encoded = utf8.encode(jsonEncode(body.toJson()));
      data = base64Encode(encoded);
    }
    return '$splash?data=$data';
  }
  static String getLanguageRoute(String page) => '$language?page=$page';
  static String getSignInRoute() => signIn;
  static String getVerificationRoute(String email) => '$verification?email=$email';
  static String getMainRoute(String page) => '$main?page=$page';
  static String getForgotPassRoute() => forgotPassword;
  static String getResetPasswordRoute(String? phone, String token, String page) => '$resetPassword?phone=$phone&token=$token&page=$page';
  static String getOrderDetailsRoute(int? orderID, {bool fromNotification = false}) => '$orderDetails?id=$orderID&from_notification=$fromNotification';
  static String getProfileRoute() => profile;
  static String getUpdateProfileRoute() => updateProfile;
  static String getNotificationRoute({bool fromNotification = false}) => '$notification?from_notification=${fromNotification.toString()}';
  static String getBankInfoRoute() => bankInfo;
  static String getWalletRoute() => wallet;
  static String getWithdrawHistoryRoute() => withdrawHistory;
  static String getRestaurantRoute() => restaurant;
  static String getCampaignRoute() => campaign;
  static String getCampaignDetailsRoute({int? id, bool fromNotification = false}) => '$campaignDetails?id=$id&from_notification=$fromNotification';
  static String getBogoOfferRoute({bool fromNotification = false}) => '$bogoOffer?from_notification=$fromNotification';
  static String getBogoOfferDetailsRoute({required int id, bool fromNotification = false}) => '$bogoOfferDetails?id=$id&from_notification=$fromNotification';
  static String getHappyHourRoute() => happyHour;

  static String getHappyHourDetailsRoute({required int id, bool fromNotification = false}) => '$happyHourDetails?id=$id&from_notification=$fromNotification';
  static String getUpdateRoute(bool willUpdate) => '$update?update=${willUpdate.toString()}';
  static String getAddProductRoute(Product? productModel) {
    if(productModel == null) {
      return '$addProduct?data=null';
    }

    String data = base64Encode(utf8.encode(jsonEncode(productModel.toJson())));
    return '$addProduct?data=$data';
  }
  static String getCategoriesRoute() => categories;
  static String getCouponRoute() => coupon;
  static String getRestaurantEditRoute(Restaurant restaurant) {
    List<int> encoded = utf8.encode(jsonEncode(restaurant.toJson()));
    String data = base64Encode(encoded);
    return '$restaurantEdit?data=$data';
  }
  static String getAddonsRoute() => addons;
  static String getProductDetailsRoute({required int productId, bool isCampaign = false}) => '$productDetails?product_id=$productId&is_campaign=$isCampaign';
  static String getPosRoute() => pos;
  static String getDeliveryManRoute() => deliveryMan;
  static String getAddDeliveryManRoute(DeliveryManModel? deliveryMan) {
    if(deliveryMan == null) {
      return '$addDeliveryMan?data=null';
    }
    List<int> encoded = utf8.encode(jsonEncode(deliveryMan.toJson()));
    String data = base64Encode(encoded);
    return '$addDeliveryMan?data=$data';
  }
  static String getDeliveryManDetailsRoute(DeliveryManModel deliveryMan) {
    List<int> encoded = utf8.encode(jsonEncode(deliveryMan.toJson()));
    String data = base64Encode(encoded);
    return '$deliveryManDetails?data=$data';
  }
  static String getTermsRoute() => terms;
  static String getPrivacyRoute() => privacy;
  static String getChatRoute({required NotificationBodyModel? notificationBody, User? user, int? conversationId, int? index, bool fromNotification = false}) {
    
    String notificationBody0 = 'null';
    String user0 = 'null';
    
    if(notificationBody != null) {
      notificationBody0 = base64Encode(utf8.encode(jsonEncode(notificationBody)));
    }
    if(user != null) {
      user0 = base64Encode(utf8.encode(jsonEncode(user.toJson())));
    }
    return '$chatScreen?notification_body=$notificationBody0&user=$user0&conversation_id=$conversationId&index=$index&from_notification=$fromNotification';
  }
  static String getConversationListRoute() => conversationListScreen;
  static String getRestaurantRegistrationRoute() => restaurantRegistration;
  static String getExpenseRoute() => expense;
  static String getEarningRoute() => earning;
  static String getPaymentRoute(String? paymentMethod, String? redirectUrl, int? restaurantId, bool? isSubscriptionPayment, int? packageId) {
    return '$payment?payment-method=$paymentMethod&redirect-url=$redirectUrl&restaurant_id=$restaurantId&is_subscription_payment=$isSubscriptionPayment&package_id=$packageId';
  }
  static String getSuccessRoute(String status, {bool isWalletPayment = false}) => '$success?status=$status&is_wallet_payment=${isWalletPayment.toString()}';
  static String getTransactionReportRoute() => transactionReport;
  static String getOrderReportRoute() => orderReport;
  static String getFoodReportRoute() => foodReport;
  static String getCampaignReportRoute() => campaignReport;
  static String getTaxReportRoute() => taxReport;
  static String getDisbursementRoute() => disbursement;
  static String getWithdrawMethodRoute({bool isFromDashBoard = false}) => '$withdrawMethod?from_dashboard=$isFromDashBoard';
  static String getAddWithdrawMethodRoute() => addWithdrawMethod;
  static String getPaymentHistoryRoute() => paymentHistory;
  static String getReportsRoute() => reports;
  static String getDisbursementMenuRoute() => disbursementMenu;
  static String getCustomerReviewRoute() => customerReview;
  static String getReviewReplyRoute({bool isGiveReply = false, required ReviewModel review, bool restaurantReviewReplyStatus = false}){
    List<int> encoded = utf8.encode(jsonEncode(review.toJson()));
    String data = base64Encode(encoded);
    return '$reviewReply?is_give_reply=$isGiveReply&data=$data&restaurant_review_reply_status=$restaurantReviewReplyStatus';
  }
  static String getAdvertisementListRoute() => advertisementList;
  static String getCreateAdvertisementRoute() => createAdvertisement;
  static String getRestaurantSettingRoute(Restaurant? restaurant) {
  List<int> encoded = utf8.encode(jsonEncode(restaurant?.toJson()));
  String data = base64Encode(encoded);
  return '$restaurantSetting?data=$data';
  }
  static String getAdvertisementDetailsScreen({required int? advertisementId, bool? fromNotification}) => '$advertisementDetails?advertisementId=$advertisementId&fromNotification=$fromNotification';
  static String getAddAddonRoute({AddOns? addon}) {
    if(addon == null) {
      return '$addAddon?data=null';
    }
    List<int> encoded = utf8.encode(jsonEncode(addon.toJson()));
    String data = base64Encode(encoded);
    return '$addAddon?data=$data';
  }
  static String getAllProductsRoute() => allProducts;
  static String getSubscriptionSuccessRoute({String? status, required bool fromSubscription, int? restaurantId, int? packageId}) => '$subscriptionSuccess?flag=$status&from_subscription=$fromSubscription&restaurant_id=$restaurantId&package_id=$packageId';
  static String getSubscriptionPaymentRoute({required int? restaurantId, required int? packageId}) => '$subscriptionPayment?id=$restaurantId&package_id=$packageId';
  static String getMySubscriptionRoute({bool fromNotification = false}) => '$mySubscription?from_notification=$fromNotification';
  static String getEditDeliveryAddressRoute({required DeliveryAddress deliveryAddress, required int orderId}) {
    List<int> encoded = utf8.encode(jsonEncode(deliveryAddress.toJson()));
    String data = base64Encode(encoded);
    return '$editDeliveryAddress?data=$data&order_id=$orderId';
  }
  static String getPickMapRoute() => pickMap;
  static String getAddNewProductRoute() => addNewProduct;
  static String getEditProductRoute() => editProduct;
  static String getSettingRoute() => setting;
  static String getReelsRoute() => reels;
  static String getAddReelRoute({Reel? reel}) {
    if (reel == null) {
      return '$addReel?data=null';
    }
    String data = base64Encode(utf8.encode(jsonEncode(reel.toJson())));
    return '$addReel?data=$data';
  }
  static String getReelDetailsRoute(Reel reel) {
    String data = base64Encode(utf8.encode(jsonEncode(reel.toJson())));
    return '$reelDetails?data=$data';
  }

  static List<GetPage> routes = [
    GetPage(name: initial, page: () => const DashboardScreen(pageIndex: 0)),
    GetPage(name: splash, page: () {
      NotificationBodyModel? data;
      if(Get.parameters['data'] != 'null') {
        List<int> decode = base64Decode(Get.parameters['data']!.replaceAll(' ', '+'));
        data = NotificationBodyModel.fromJson(jsonDecode(utf8.decode(decode)));
      }
      return SplashScreen(body: data);
    }),
    GetPage(name: language, page: () => LanguageScreen(fromMenu: Get.parameters['page'] == 'menu')),
    GetPage(name: signIn, page: () => const SignInScreen()),
    GetPage(name: verification, page: () => VerificationScreen(email: Get.parameters['email'])),
    GetPage(name: main, page: () => DashboardScreen(
      pageIndex: Get.parameters['page'] == 'home' ? 0 : Get.parameters['page'] == 'favourite' ? 1
          : Get.parameters['page'] == 'cart' ? 2 : Get.parameters['page'] == 'order' ? 3 : Get.parameters['page'] == 'menu' ? 4 : 0,
    )),
    GetPage(name: forgotPassword, page: () => const ForgetPassScreen()),
    GetPage(name: resetPassword, page: () => NewPassScreen(
      resetToken: Get.parameters['token'], email: Get.parameters['phone'], fromPasswordChange: Get.parameters['page'] == 'password-change',
    )),
    GetPage(name: orderDetails, page: () {
      return Get.arguments ?? OrderDetailsScreen(
        orderModel: OrderModel(id: int.parse(Get.parameters['id']!)), isRunningOrder: false,
        orderId: int.parse(Get.parameters['id']!),
        fromNotification: Get.parameters['from_notification'] == 'true',
      );
    }),
    GetPage(name: profile, page: () => const ProfileScreen()),
    GetPage(name: updateProfile, page: () => const UpdateProfileScreen()),
    GetPage(name: notification, page: () => NotificationScreen(fromNotification: Get.parameters['from_notification'] == 'true')),
    GetPage(name: bankInfo, page: () => const BankInfoScreen()),
    GetPage(name: wallet, page: () => const WalletScreen()),
    GetPage(name: withdrawHistory, page: () => const WithdrawRequestHistoryScreen()),
    GetPage(name: restaurant, page: () => const RestaurantScreen()),
    GetPage(name: campaign, page: () => const CampaignScreen()),
    GetPage(name: campaignDetails, page: () => CampaignDetailsScreen(id: int.parse(Get.parameters['id']!), fromNotification: Get.parameters['from_notification'] == 'true')),
    GetPage(name: bogoOffer, page: () => BogoCampaignListScreen(fromNotification: Get.parameters['from_notification'] == 'true')),
    GetPage(name: bogoOfferDetails, page: () => BogoOfferSetupScreen(
      offerId: int.parse(Get.parameters['id']!),
      fromNotification: Get.parameters['from_notification'] == 'true',
    )),
    GetPage(name: happyHour, page: () => const HappyHourListScreen()),
    GetPage(name: happyHourDetails, page: () => HappyHourDetailsScreen(
      happyHourId: int.parse(Get.parameters['id']!),
      fromNotification: Get.parameters['from_notification'] == 'true',
    )),
    GetPage(name: addProduct, page: () {
      if(Get.parameters['data'] == 'null') {
        return const AddProductScreen(product: null);
      }
      List<int> decode = base64Decode(Get.parameters['data']!.replaceAll(' ', '+'));
      Product data = Product.fromJson(jsonDecode(utf8.decode(decode)));
      return AddProductScreen(product: data);
    }),
    GetPage(name: categories, page: () => const CategoryScreen()),
    GetPage(name: restaurantEdit, page: () {
      List<int> decode = base64Decode(Get.parameters['data']!.replaceAll(' ', '+'));
      Restaurant data = Restaurant.fromJson(jsonDecode(utf8.decode(decode)));
      return RestaurantEditScreen(restaurant: data);
    }),
    GetPage(name: addons, page: () => const AddonScreen()),
    GetPage(name: productDetails, page: () {
      return ProductDetailsScreen(productId: int.parse(Get.parameters['product_id']!), isCampaign: Get.parameters['is_campaign'] == 'true');
    }),
    GetPage(name: deliveryMan, page: () => const DeliveryManScreen()),
    GetPage(name: addDeliveryMan, page: () {
      if(Get.parameters['data'] == 'null') {
        return const AddDeliveryManScreen(deliveryMan: null);
      }
      List<int> decode = base64Decode(Get.parameters['data']!.replaceAll(' ', '+'));
      DeliveryManModel data = DeliveryManModel.fromJson(jsonDecode(utf8.decode(decode)));
      return AddDeliveryManScreen(deliveryMan: data);
    }),
    GetPage(name: deliveryManDetails, page: () {
      List<int> decode = base64Decode(Get.parameters['data']!.replaceAll(' ', '+'));
      DeliveryManModel data = DeliveryManModel.fromJson(jsonDecode(utf8.decode(decode)));
      return DeliveryManDetailsScreen(deliveryMan: data);
    }),
    GetPage(name: terms, page: () => const HtmlViewerScreen(isPrivacyPolicy: false)),
    GetPage(name: privacy, page: () => const HtmlViewerScreen(isPrivacyPolicy: true)),
    GetPage(name: update, page: () => UpdateScreen(willUpdate: Get.parameters['update'] == 'true')),
    GetPage(name: chatScreen, page: () {
      
      NotificationBodyModel? notificationBody;
      if(Get.parameters['notification_body'] != 'null') {
        notificationBody = NotificationBodyModel.fromJson(jsonDecode(utf8.decode(base64Url.decode(Get.parameters['notification_body']!.replaceAll(' ', '+')))));
      }
      User? user;
      if(Get.parameters['user'] != 'null') {
        user = User.fromJson(jsonDecode(utf8.decode(base64Url.decode(Get.parameters['user']!.replaceAll(' ', '+')))));
      }
      return ChatScreen(
        notificationBody : notificationBody, user: user, index: Get.parameters['index'] != 'null' ? int.parse(Get.parameters['index']!) : null,
        conversationId: Get.parameters['conversation_id'] != null && Get.parameters['conversation_id'] != 'null' ? int.parse(Get.parameters['conversation_id']!) : null,
        fromNotification: Get.parameters['from_notification'] == 'true',
      );
    }),
    GetPage(name: conversationListScreen, page: () => const ConversationScreen()),
    GetPage(name: restaurantRegistration, page: () => const RestaurantRegistrationScreen()),
    GetPage(name: coupon, page: () => const CouponScreen()),
    GetPage(name: expense, page: () => const ExpenseScreen()),
    GetPage(name: earning, page: () => const EarningReportScreen()),
    GetPage(name: payment, page: () {
      String paymentMethod = Get.parameters['payment-method']!;
      String addFundUrl = Get.parameters['redirect-url']!;
      int? restaurantId = (Get.parameters['restaurant_id'] != null && Get.parameters['restaurant_id'] != 'null') ? int.parse(Get.parameters['restaurant_id']!) : null;
      bool isSubscriptionPayment = Get.parameters['is_subscription_payment'] == 'true';
      int? packageId = (Get.parameters['package_id'] != null && Get.parameters['package_id'] != 'null') ? int.parse(Get.parameters['package_id']!) : null;
      return PaymentScreen(paymentMethod: paymentMethod, redirectUrl: addFundUrl, restaurantId: restaurantId, isSubscriptionPayment: isSubscriptionPayment, packageId: packageId);
    }),
    GetPage(name: success, page: () => PaymentSuccessfulScreen(success: Get.parameters['status'] == 'success', isWalletPayment: Get.parameters['is_wallet_payment'] == 'true')),
    GetPage(name: transactionReport, page: () => const TransactionReportScreen()),
    GetPage(name: orderReport, page: () => const OrderReportScreen()),
    GetPage(name: foodReport, page: () => const FoodReportScreen()),
    GetPage(name: campaignReport, page: () => const CampaignReportScreen()),
    GetPage(name: taxReport, page: () => const TaxReportScreen()),
    GetPage(name: disbursement, page: () => const DisbursementScreen()),
    GetPage(name: withdrawMethod, page: () => WithdrawMethodScreen(isFromDashboard: Get.parameters['from_dashboard'] == 'true')),
    GetPage(name: addWithdrawMethod, page: () => const AddWithDrawMethodScreen()),
    GetPage(name: paymentHistory, page: () => const PaymentHistoryScreen()),
    GetPage(name: reports, page: () => const ReportsScreen()),
    GetPage(name: disbursementMenu, page: () => const DisbursementMenuScreen()),
    GetPage(name: customerReview, page: () => const CustomerReviewScreen()),
    GetPage(name: reviewReply, page: () {
    List<int> decode = base64Decode(Get.parameters['data']!.replaceAll(' ', '+'));
    ReviewModel data = ReviewModel.fromJson(jsonDecode(utf8.decode(decode)));
      return ReviewReplyScreen(isGiveReply: Get.parameters['is_give_reply'] == 'true', review: data, restaurantReviewReplyStatus: Get.parameters['restaurant_review_reply_status'] == 'true');
    }),
    GetPage(name: advertisementList, page: () => const AdvertisementListScreen()),
    GetPage(name: createAdvertisement, page: () => const CreateAdvertisementScreen()),
    GetPage(name: restaurantSetting, page: () {
      List<int> decode = base64Decode(Get.parameters['data']!.replaceAll(' ', '+'));
      Restaurant data = Restaurant.fromJson(jsonDecode(utf8.decode(decode)));
      return RestaurantSettingsScreen(restaurant: data);
    }),
    GetPage(name: advertisementDetails, page: () => AdvertisementDetailsScreen(
      id: int.parse(Get.parameters['advertisementId']!), fromNotification: Get.parameters['fromNotification'] == 'true',
    )),
    GetPage(name: addAddon, page: () {
      if(Get.parameters['data'] == 'null') {
        return const AddAddonScreen(addon: null);
      }
      List<int> decode = base64Decode(Get.parameters['data']!.replaceAll(' ', '+'));
      AddOns data = AddOns.fromJson(jsonDecode(utf8.decode(decode)));
      return AddAddonScreen(addon: data);
    }),
    GetPage(name: subscriptionSuccess, page: () => SubscriptionSuccessOrFailedScreen(
      success: Get.parameters['flag'] == 'success',
      fromSubscription: Get.parameters['from_subscription'] == 'true',
      restaurantId: (Get.parameters['restaurant_id'] != null && Get.parameters['restaurant_id'] != 'null') ? int.parse(Get.parameters['restaurant_id']!) : null,
      packageId: (Get.parameters['package_id'] != null && Get.parameters['package_id'] != 'null') ? int.parse(Get.parameters['package_id']!) : null,
    )),
    GetPage(name: subscriptionPayment, page: () => SubscriptionPaymentScreen(restaurantId: int.parse(Get.parameters['id']!), packageId: int.parse(Get.parameters['package_id']!))),
    GetPage(name: mySubscription, page: () => MySubscriptionScreen(fromNotification: Get.parameters['from_notification'] == 'true')),
    GetPage(name: allProducts, page: () => const AllProductScreen()),
    GetPage(name: editDeliveryAddress, page: () {
      List<int> decode = base64Decode(Get.parameters['data']!.replaceAll(' ', '+'));
      DeliveryAddress data = DeliveryAddress.fromJson(jsonDecode(utf8.decode(decode)));
      return EditDeliveryAddressScreen(deliveryAddress: data, orderId: int.parse(Get.parameters['order_id']!));
    }),
    GetPage(name: pickMap, page: () {
      PickMapScreen? pickMapScreen = Get.arguments;
      return pickMapScreen ?? PickMapScreen();
    }),
    GetPage(name: addNewProduct, page: () => const AddNewProductScreen()),
    GetPage(name: editProduct, page: () {
      EditProductScreen? editProductScreen = Get.arguments;
      return editProductScreen ?? EditProductScreen();
    }),
    GetPage(name: setting, page: () => const SettingScreen()),
    GetPage(name: reels, page: () => const ReelsScreen()),
    GetPage(name: addReel, page: () {
      if (Get.parameters['data'] == 'null') {
        return const AddReelScreen(reel: null);
      }
      List<int> decode = base64Decode(Get.parameters['data']!.replaceAll(' ', '+'));
      Reel data = Reel.fromJson(jsonDecode(utf8.decode(decode)));
      return AddReelScreen(reel: data);
    }),
    GetPage(name: reelDetails, page: () {
      List<int> decode = base64Decode(Get.parameters['data']!.replaceAll(' ', '+'));
      Reel data = Reel.fromJson(jsonDecode(utf8.decode(decode)));
      return ReelDetailsScreen(reel: data);
    }),
  ];
}