import 'package:permission_handler/permission_handler.dart';
import 'package:stackfood_multivendor_restaurant/common/widgets/custom_asset_image_widget.dart';
import 'package:stackfood_multivendor_restaurant/common/widgets/custom_card.dart';
import 'package:stackfood_multivendor_restaurant/common/widgets/custom_ink_well_widget.dart';
import 'package:stackfood_multivendor_restaurant/common/widgets/custom_snackbar_widget.dart';
import 'package:stackfood_multivendor_restaurant/common/widgets/order_shimmer_widget.dart';
import 'package:stackfood_multivendor_restaurant/common/widgets/order_widget.dart';
import 'package:stackfood_multivendor_restaurant/features/home/screens/ongoing_orders_screen.dart';
import 'package:stackfood_multivendor_restaurant/features/home/widgets/ads_section_widget.dart';
import 'package:stackfood_multivendor_restaurant/features/home/widgets/business_analytics_widget.dart';
import 'package:stackfood_multivendor_restaurant/features/notification/controllers/notification_controller.dart';
import 'package:stackfood_multivendor_restaurant/features/order/controllers/order_controller.dart';
import 'package:stackfood_multivendor_restaurant/features/order/domain/models/order_model.dart';
import 'package:stackfood_multivendor_restaurant/features/home/widgets/order_button_widget.dart';
import 'package:stackfood_multivendor_restaurant/features/profile/controllers/profile_controller.dart';
import 'package:stackfood_multivendor_restaurant/features/splash/controllers/splash_controller.dart';
import 'package:stackfood_multivendor_restaurant/features/subscription/controllers/subscription_controller.dart';
import 'package:stackfood_multivendor_restaurant/helper/bogo_offer_action_helper.dart';
import 'package:stackfood_multivendor_restaurant/helper/happy_hour_action_helper.dart';
import 'package:stackfood_multivendor_restaurant/helper/route_helper.dart';
import 'package:stackfood_multivendor_restaurant/util/dimensions.dart';
import 'package:stackfood_multivendor_restaurant/util/images.dart';
import 'package:stackfood_multivendor_restaurant/util/styles.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer_animation/shimmer_animation.dart';
part '../widgets/bogo_offer_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  late final AppLifecycleListener _listener;
  late final TabController _orderTabController;
  bool _isNotificationPermissionGranted = true;
  bool _isBatteryOptimizationGranted = true;

  @override
  void initState() {
    super.initState();

    _orderTabController = TabController(length: Get.find<OrderController>().runningStatusList.length, vsync: this);

    _checkSystemNotification();

    // Initialize the AppLifecycleListener class and pass callbacks
    _listener = AppLifecycleListener(
      onStateChange: _onStateChanged,
    );

    _loadData();

    Future.delayed(const Duration(milliseconds: 200), () {
      checkPermission();
    });
  }

  Future<void> _checkSystemNotification() async {
    if(await Permission.notification.status.isDenied || await Permission.notification.status.isPermanentlyDenied) {
      Get.find<ProfileController>().setNotificationActive(false);
    }
  }

  // Listen to the app lifecycle state changes
  void _onStateChanged(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.detached:
        break;
      case AppLifecycleState.resumed:
        Future.delayed(const Duration(milliseconds: 200), () {
          checkPermission();
        });
        break;
      case AppLifecycleState.inactive:
        break;
      case AppLifecycleState.hidden:
        break;
      case AppLifecycleState.paused:
        break;
    }
  }

  @override
  void dispose() {
    _orderTabController.dispose();
    _listener.dispose();
    super.dispose();
  }

  Future<void> _loadData() async {
    await Get.find<ProfileController>().getProfile();
    await Get.find<OrderController>().getCurrentOrders();
    await Get.find<NotificationController>().getNotificationList();
    HappyHourActionHelper.showAdminRequest();
    BogoOfferActionHelper.showAdminRequest();
  }

  Future<void> checkPermission() async {
    var notificationStatus = await Permission.notification.status;
    var batteryStatus = await Permission.ignoreBatteryOptimizations.status;

    if(notificationStatus.isDenied || notificationStatus.isPermanentlyDenied) {
      setState(() {
        _isNotificationPermissionGranted = false;
        _isBatteryOptimizationGranted = true;
      });

      Get.find<ProfileController>().setNotificationActive(false);

    } else if(batteryStatus.isDenied) {
      setState(() {
        _isBatteryOptimizationGranted = false;
        _isNotificationPermissionGranted = true;
      });
    } else {
      setState(() {
        _isNotificationPermissionGranted = true;
        _isBatteryOptimizationGranted = true;
      });
      Get.find<ProfileController>().setBackgroundNotificationActive(true);
    }

    if(batteryStatus.isDenied) {
      Get.find<ProfileController>().setBackgroundNotificationActive(false);
    }
  }

  Future<void> requestNotificationPermission() async {
    if (await Permission.notification.request().isGranted) {
      checkPermission();
      return;
    } else {
      await openAppSettings();
    }

    checkPermission();
  }

  void requestBatteryOptimization() async {
    var status = await Permission.ignoreBatteryOptimizations.status;

    if (status.isGranted) {
      return;
    } else if(status.isDenied) {
      await Permission.ignoreBatteryOptimizations.request();
    } else {
      openAppSettings();
    }

    checkPermission();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        backgroundColor: Theme.of(context).cardColor,
        leading: Padding(
          padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
          child: Image.asset(Images.logo, height: 30, width: 30),
        ),
        titleSpacing: 0,
        surfaceTintColor: Theme.of(context).cardColor,
        shadowColor: Theme.of(context).hintColor.withValues(alpha: 0.5),
        elevation: 2,
        title: Image.asset(Images.logoName, width: 120),
        actions: [IconButton(
          icon: GetBuilder<NotificationController>(builder: (notificationController) {

            bool hasNewNotification = false;

            if(notificationController.notificationList != null) {
              hasNewNotification = notificationController.notificationList!.length != notificationController.getSeenNotificationCount();
            }

            return Stack(children: [

              Icon(Icons.notifications, size: 25, color: Theme.of(context).textTheme.bodyLarge!.color),

              hasNewNotification ? Positioned(top: 0, right: 0, child: Container(
                height: 10, width: 10, decoration: BoxDecoration(
                color: Theme.of(context).primaryColor, shape: BoxShape.circle,
                border: Border.all(width: 1, color: Theme.of(context).cardColor),
              ),
              )) : const SizedBox(),

            ]);
          }),
          onPressed: () {
            Get.find<SubscriptionController>().trialEndBottomSheet().then((trialEnd) {
              if(trialEnd) {
                Get.toNamed(RouteHelper.getNotificationRoute());
              }
            });
          },
        )],
      ),

      body: RefreshIndicator(
        onRefresh: () async {
          await _loadData();
        },
        child: Column(
          children: [

            if(!_isNotificationPermissionGranted)
              permissionWarning(isBatteryPermission: false, onTap: requestNotificationPermission, closeOnTap: () {
                setState(() {
                  _isNotificationPermissionGranted = true;
                });
              }),

            if(!_isBatteryOptimizationGranted)
              permissionWarning(isBatteryPermission: true, onTap: requestBatteryOptimization, closeOnTap: () {
                setState(() {
                  _isBatteryOptimizationGranted = true;
                });
              }),

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
                physics: const AlwaysScrollableScrollPhysics(),
                child: GetBuilder<ProfileController>(builder: (profileController) {
                  return profileController.profileModel != null ? Column(children: [

                    BusinessAnalyticsWidget(profileController: profileController),
                    SizedBox(height: Dimensions.paddingSizeLarge),

                    profileController.modulePermission?.newAds ?? false ? const AdsSectionWidget() : const SizedBox(),
                    SizedBox(height: profileController.modulePermission?.newAds ?? false ? Dimensions.paddingSizeLarge : 0),

                    _buildReelsEntry(context, profileController),

                    _BogoOfferCard(),
                    SizedBox(height: Dimensions.paddingSizeSmall),

                    Row(children: [
                      Text('ongoing_orders'.tr, style: robotoBold.copyWith(fontSize: Dimensions.fontSizeLarge)),
                      const Spacer(),

                      CustomInkWellWidget(
                        onTap: () => Get.to(()=> OngoingOrdersScreen()),
                        radius: Dimensions.radiusDefault,
                        child: Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: Row(children: [
                            Text('view_all'.tr, style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeSmall),),
                            const SizedBox(width: Dimensions.paddingSizeExtraSmall),

                            Icon(Icons.arrow_forward_ios_sharp, size: 16),
                          ]),
                        ),
                      ),

                    ]),
                   const SizedBox(height: Dimensions.paddingSizeDefault),

                   (profileController.modulePermission?.regularOrder ?? false) ||  (profileController.modulePermission?.subscriptionOrder ?? false) ? GetBuilder<OrderController>(builder: (orderController) {

                      List<OrderModel> orderList = [];

                      if(orderController.runningOrders != null) {
                        orderList = orderController.runningOrders![orderController.orderIndex].orderList;
                      }

                      return CustomCard(
                        padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                        child: Column(children: [

                          orderController.runningOrders != null ? _buildOrderTabBar(orderController) : const SizedBox(),

                          const SizedBox(height: Dimensions.paddingSizeSmall),

                          Padding(
                            padding: const EdgeInsets.only(top: Dimensions.paddingSizeDefault),
                            child: Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [

                              orderController.runningOrders != null ? InkWell(
                                onTap: () => orderController.toggleCampaignOnly(),
                                child: Row(children: [
                                  Container(
                                    padding: const EdgeInsets.all(2),
                                    margin: const EdgeInsets.only(right: Dimensions.paddingSizeExtraSmall),
                                    decoration: BoxDecoration(
                                      color: orderController.campaignOnly ? Colors.green : Theme.of(context).cardColor,
                                      border: Border.all(color: orderController.campaignOnly ? Colors.transparent : Theme.of(context).hintColor),
                                      shape: BoxShape.circle,
                                    ),
                                    child: Icon(Icons.check, size: 14, color: orderController.campaignOnly ? Theme.of(context).cardColor :Theme.of(context).hintColor,),
                                  ),

                                  Text(
                                    'campaign_order'.tr,
                                    style: orderController.campaignOnly ? robotoMedium.copyWith(color: Theme.of(context).textTheme.bodyMedium!.color!)
                                        : robotoRegular.copyWith(color: Theme.of(context).hintColor),
                                  ),
                                ]),
                              ) : const SizedBox(),

                              orderController.runningOrders != null ? InkWell(
                                onTap: () {
                                  if(profileController.modulePermission?.subscriptionOrder ?? false) {
                                    orderController.toggleSubscriptionOnly();
                                  } else {
                                    showCustomSnackBar('you_have_no_permission_to_access_this_feature'.tr);
                                  }
                                },
                                child: Row(children: [
                                  Container(
                                    padding: const EdgeInsets.all(2),
                                    margin: const EdgeInsets.only(right: Dimensions.paddingSizeExtraSmall),
                                    decoration: BoxDecoration(
                                      color: orderController.subscriptionOnly ? Colors.green : Theme.of(context).cardColor,
                                      border: Border.all(color: orderController.subscriptionOnly ? Colors.transparent : Theme.of(context).hintColor),
                                      shape: BoxShape.circle,
                                    ),
                                    child: Icon(Icons.check, size: 14, color: orderController.subscriptionOnly ? Theme.of(context).cardColor :Theme.of(context).hintColor,),
                                  ),

                                  Text(
                                    'subscription_order'.tr,
                                    style: orderController.subscriptionOnly ? robotoMedium.copyWith(color: Theme.of(context).textTheme.bodyMedium!.color!)
                                        : robotoRegular.copyWith(color: Theme.of(context).hintColor),
                                  ),
                                ]),
                              ) : const SizedBox(),

                            ]),
                          ),

                          const Divider(height: Dimensions.paddingSizeOverLarge),

                          (orderController.runningOrders == null || orderController.runningOrderLoading) ? ListView.builder(
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: 10,
                            itemBuilder: (context, index) {
                              return const OrderShimmerWidget(isEnabled: true);
                            },
                          ) : orderList.isNotEmpty ? ListView.builder(
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: orderList.length,
                            itemBuilder: (context, index) {
                              return OrderWidget(orderModel: orderList[index], hasDivider: index != orderList.length-1, isRunning: true);
                            },
                          ) : Padding(
                            padding: const EdgeInsets.only(top: 50, bottom: 50),
                            child: Center(child: Text('no_order_found'.tr)),
                          ),

                        ]),
                      );
                    }) : const SizedBox(),

                  ]) : Column(children: [

                    ClipRRect(
                      borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                      child: Shimmer(
                        child: Container(
                          height: 50, width: double.infinity,
                          color: Theme.of(context).shadowColor,
                        ),
                      ),
                    ),
                    const SizedBox(height: Dimensions.paddingSizeDefault),

                    ClipRRect(
                      borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                      child: Shimmer(
                        child: Container(
                          height: 200, width: double.infinity,
                          color: Theme.of(context).shadowColor,
                        ),
                      ),
                    ),
                    const SizedBox(height: Dimensions.paddingSizeDefault),

                    ClipRRect(
                      borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                      child: Shimmer(
                        child: Container(
                          height: 150, width: double.infinity,
                          color: Theme.of(context).shadowColor,
                        ),
                      ),
                    ),
                    const SizedBox(height: Dimensions.paddingSizeDefault),

                    ClipRRect(
                      borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                      child: Shimmer(
                        child: Container(
                          height: 70, width: double.infinity,
                          color: Theme.of(context).shadowColor,
                        ),
                      ),
                    ),
                    const SizedBox(height: Dimensions.paddingSizeDefault),

                    ClipRRect(
                      borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                      child: Shimmer(
                        child: Container(
                          height: 70, width: double.infinity,
                          color: Theme.of(context).shadowColor,
                        ),
                      ),
                    ),
                    const SizedBox(height: Dimensions.paddingSizeDefault),

                    ClipRRect(
                      borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                      child: Shimmer(
                        child: Container(
                          height: 70, width: double.infinity,
                          color: Theme.of(context).shadowColor,
                        ),
                      ),
                    ),
                    const SizedBox(height: Dimensions.paddingSizeDefault),

                    ClipRRect(
                      borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                      child: Shimmer(
                        child: Container(
                          height: 70, width: double.infinity,
                          color: Theme.of(context).shadowColor,
                        ),
                      ),
                    ),

                  ]);
                }),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOrderTabBar(OrderController orderController) {
    if(_orderTabController.index != orderController.orderIndex) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if(mounted && _orderTabController.index != orderController.orderIndex) {
          _orderTabController.animateTo(orderController.orderIndex);
        }
      });
    }

    return SizedBox(
      height: 40,
      child: TabBar(
        controller: _orderTabController,
        onTap: (index) => orderController.setOrderIndex(index),
        isScrollable: true,
        tabAlignment: TabAlignment.start,
        padding: EdgeInsets.zero,
        labelPadding: EdgeInsets.zero,
        indicator: const BoxDecoration(),
        indicatorSize: TabBarIndicatorSize.tab,
        dividerColor: Colors.transparent,
        overlayColor: WidgetStateProperty.all(Colors.transparent),
        splashFactory: NoSplash.splashFactory,
        tabs: List.generate(orderController.runningOrders!.length, (index) {
          return Tab(
            height: 40,
            child: IgnorePointer(
              child: OrderButtonWidget(
                title: orderController.runningOrders![index].status.tr, index: index,
                orderController: orderController, fromHistory: false,
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildReelsEntry(BuildContext context, ProfileController profileController) {
    final bool reelsModuleOn = Get.find<SplashController>().configModel?.reelsModule?.vendorCanUploadReels ?? false;
    final bool reelsPermission = profileController.modulePermission?.reels ?? true;
    if (!reelsModuleOn || !reelsPermission) {
      return const SizedBox();
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: Dimensions.paddingSizeLarge),
      child: CustomInkWellWidget(
        onTap: () => Get.toNamed(RouteHelper.getReelsRoute()),
        radius: Dimensions.radiusDefault,
        child: Container(
          padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
            gradient: LinearGradient(
              begin: Alignment.centerLeft, end: Alignment.centerRight,
              colors: [
                Theme.of(context).primaryColor.withValues(alpha: 0.9),
                Theme.of(context).primaryColor,
              ],
            ),
            boxShadow: [
              BoxShadow(
                color: Theme.of(context).primaryColor.withValues(alpha: 0.15),
                blurRadius: 8, offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Row(children: [
            Container(
              padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
              ),
              child: const Icon(Icons.video_library_outlined, color: Colors.white, size: 28),
            ),
            const SizedBox(width: Dimensions.paddingSizeDefault),
            Expanded(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text('reels'.tr, style: robotoBold.copyWith(color: Colors.white, fontSize: Dimensions.fontSizeLarge)),
                const SizedBox(height: 2),
                Text(
                  'promote_your_restaurant_with_short_videos'.tr,
                  style: robotoRegular.copyWith(color: Colors.white.withValues(alpha: 0.9), fontSize: Dimensions.fontSizeSmall),
                  maxLines: 1, overflow: TextOverflow.ellipsis,
                ),
              ]),
            ),
            const Icon(Icons.arrow_forward_ios_rounded, color: Colors.white, size: 16),
          ]),
        ),
      ),
    );
  }

  Widget permissionWarning({required bool isBatteryPermission, required Function() onTap, required Function() closeOnTap}) {
    return GetPlatform.isAndroid ? Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor.withValues(alpha: 0.7),
      ),
      child: InkWell(
        onTap: onTap,
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
              child: Row(children: [

                if(isBatteryPermission)
                  const Padding(
                    padding: EdgeInsets.only(right: 8.0),
                    child: Icon(Icons.warning_rounded, color: Colors.yellow,),
                  ),

                Expanded(
                  child: Row(children: [
                    Flexible(
                      child: Text(
                        isBatteryPermission ? 'for_better_performance_allow_notification_to_run_in_background'.tr
                            : 'notification_is_disabled_please_allow_notification'.tr,
                        maxLines: 2, style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Colors.white),
                      ),
                    ),
                    const SizedBox(width: Dimensions.paddingSizeSmall),
                    const Icon(Icons.arrow_circle_right_rounded, color: Colors.white, size: 24,),
                  ]),
                ),

                const SizedBox(width: 20),
              ]),
            ),

            Positioned(
              top: 5, right: 5,
              child: InkWell(
                onTap: closeOnTap,
                child: const Icon(Icons.clear, color: Colors.white, size: 18),
              ),
            ),
          ],
        ),
      ),
    ) : const SizedBox();
  }
}