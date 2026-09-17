import 'dart:async';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:stackfood_multivendor_restaurant/features/dashboard/widgets/bottom_nav_item_widget.dart';
import 'package:stackfood_multivendor_restaurant/features/disbursement/helper/disbursement_helper.dart';
import 'package:stackfood_multivendor_restaurant/features/home/screens/home_screen.dart';
import 'package:stackfood_multivendor_restaurant/features/menu/screens/menu_screen.dart';
import 'package:stackfood_multivendor_restaurant/features/order/screens/order_history_screen.dart';
import 'package:stackfood_multivendor_restaurant/features/payment/screens/wallet_screen.dart';
import 'package:stackfood_multivendor_restaurant/features/restaurant/screens/restaurant_screen.dart';
import 'package:stackfood_multivendor_restaurant/features/subscription/controllers/subscription_controller.dart';
import 'package:stackfood_multivendor_restaurant/util/dimensions.dart';
import 'package:stackfood_multivendor_restaurant/util/images.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';

class DashboardScreen extends StatefulWidget {
  final int pageIndex;
  const DashboardScreen({super.key, required this.pageIndex});

  @override
  DashboardScreenState createState() => DashboardScreenState();
}

class DashboardScreenState extends State<DashboardScreen> {

  PageController? _pageController;
  int _pageIndex = 0;
  late List<Widget> _screens;
  FlutterLocalNotificationsPlugin? flutterLocalNotificationsPlugin;
  DisbursementHelper disbursementHelper = DisbursementHelper();
  bool _canExit = false;

  @override
  void initState() {
    super.initState();

    _pageIndex = widget.pageIndex;

    _pageController = PageController(initialPage: widget.pageIndex);

    _screens = [
      const HomeScreen(),
      const OrderHistoryScreen(),
      const RestaurantScreen(),
      const WalletScreen(),
      Container(),
    ];

    Future.delayed(const Duration(seconds: 1), () {
      setState(() {});
    });

    showDisbursementWarningMessage();

    if(Get.find<SubscriptionController>().isTrialEndModalShown){
      Get.find<SubscriptionController>().trialEndBottomSheet();
    }
  }

  Future<void> showDisbursementWarningMessage() async {
    disbursementHelper.enableDisbursementWarningMessage(true);
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if(_pageIndex != 0) {
          _setPage(0);
        }else {
          if(_canExit) {
            if (GetPlatform.isAndroid) {
              SystemNavigator.pop();
            } else if (GetPlatform.isIOS) {
              exit(0);
            }
          }
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('back_press_again_to_exit'.tr, style: const TextStyle(color: Colors.white)),
            behavior: SnackBarBehavior.floating,
            backgroundColor: Colors.green,
            duration: const Duration(seconds: 2),
            margin: const EdgeInsets.all(Dimensions.paddingSizeSmall),
          ));
          _canExit = true;

          Timer(const Duration(seconds: 2), () {
            _canExit = false;
          });
        }
      },
      child: Scaffold(

        floatingActionButton: !GetPlatform.isMobile ? null : Material(
          elevation: 4,
          shape: const CircleBorder(),
          child: FloatingActionButton(
            backgroundColor: _pageIndex == 2 ? Theme.of(context).primaryColor : Theme.of(context).cardColor,
            onPressed: () => _setPage(2),
            child: Image.asset(
              Images.storeButton, height: 25, width: 25,
              color: _pageIndex == 2 ? Theme.of(context).cardColor : Theme.of(context).hintColor,
            ),
          ),
        ),
        floatingActionButtonLocation: !GetPlatform.isMobile ? null : FloatingActionButtonLocation.centerDocked,

        bottomNavigationBar: !GetPlatform.isMobile ? const SizedBox() : BottomAppBar(
          elevation: 10,
          notchMargin: 5,
          surfaceTintColor: Theme.of(context).cardColor,
          shadowColor: Theme.of(context).hintColor,
          shape: const CircularNotchedRectangle(),

          child: Padding(
            padding: const EdgeInsets.all(Dimensions.paddingSizeExtraSmall),
            child: Row(children: [
              BottomNavItemWidget(imageData: Images.homeButton, isSelected: _pageIndex == 0, onTap: () => _setPage(0)),
              BottomNavItemWidget(imageData: Images.orderButton, isSelected: _pageIndex == 1, onTap: () => _setPage(1)),
              const Expanded(child: SizedBox()),
              BottomNavItemWidget(imageData: Images.walletButton, isSelected: _pageIndex == 3, onTap: () => _setPage(3)),
              BottomNavItemWidget(imageData: Images.menuButton, isSelected: _pageIndex == 4, onTap: () {
                Get.bottomSheet(const MenuScreen(), backgroundColor: Colors.transparent, isScrollControlled: true);
              }),
            ]),
          ),
        ),
        body: PageView.builder(
          controller: _pageController,
          itemCount: _screens.length,
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) {
            return _screens[index];
          },
        ),
      ),
    );
  }

  void _setPage(int pageIndex) {
    if (!Get.find<SubscriptionController>().isTrialEndModalShown) {
      Get.find<SubscriptionController>().trialEndBottomSheet().then((trialEnd) {
        if (trialEnd) {
          setState(() {
            _pageController!.jumpToPage(pageIndex);
            _pageIndex = pageIndex;
          });
        } else {
          Get.find<SubscriptionController>().setTrialEndModalShown(true);
        }
      });
    }
  }
}