import 'package:stackfood_multivendor_restaurant/common/widgets/custom_app_bar_widget.dart';
import 'package:stackfood_multivendor_restaurant/common/widgets/paginated_list_view_widget.dart';
import 'package:stackfood_multivendor_restaurant/features/happy_hour/controllers/happy_hour_controller.dart';
import 'package:stackfood_multivendor_restaurant/features/happy_hour/domain/models/happy_hour_model.dart';
import 'package:stackfood_multivendor_restaurant/features/happy_hour/widgets/happy_hour_card_widget.dart';
import 'package:stackfood_multivendor_restaurant/helper/happy_hour_action_helper.dart';
import 'package:stackfood_multivendor_restaurant/helper/route_helper.dart';
import 'package:stackfood_multivendor_restaurant/util/dimensions.dart';
import 'package:stackfood_multivendor_restaurant/util/styles.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HappyHourListScreen extends StatefulWidget {
  const HappyHourListScreen({super.key});

  @override
  State<HappyHourListScreen> createState() => _HappyHourListScreenState();
}

class _HappyHourListScreenState extends State<HappyHourListScreen> with SingleTickerProviderStateMixin {

  final ScrollController _scrollController = ScrollController();
  late final TabController _tabController = TabController(length: HappyHourController.typeList.length, vsync: this);

  @override
  void initState() {
    super.initState();

    final HappyHourController happyHourController = Get.find<HappyHourController>();

    /// The tab bar starts on `all`, so the filter behind it has to be put back
    /// to `all` too — otherwise a visit that ended on another tab reopens
    /// showing that tab's rows under the `all` indicator.
    happyHourController.resetType();
    happyHourController.getHappyHourList(offset: 1, reload: true);

    /// Raised here as well as on the home screen, in case the restaurant came
    /// straight to this list. It announces itself only once either way.
    HappyHourActionHelper.showAdminRequest();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _tabController.dispose();
    super.dispose();
  }

  void _openDetails(HappyHourModel happyHour) {
    Get.toNamed(RouteHelper.getHappyHourDetailsRoute(id: happyHour.id!));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: CustomAppBarWidget(title: 'happy_hour_list'.tr, elevation: 0,),

      body: GetBuilder<HappyHourController>(builder: (happyHourController) {
        return Column(children: [

          _buildTabBar(context, happyHourController),


          /// Only the first load takes over the screen; a pull to refresh keeps
          /// the list in place so the RefreshIndicator can run its own spinner.
          Expanded(child: happyHourController.happyHourList == null ? const Center(child: CircularProgressIndicator())
              : happyHourController.happyHourList!.isEmpty ? Center(child: Text('no_happy_hour_found'.tr)) : RefreshIndicator(
            onRefresh: () async {
              await happyHourController.getHappyHourList(offset: 1);
            },
            child: SizedBox(
              width: Dimensions.webMaxWidth,
              child: SingleChildScrollView(
                controller: _scrollController,
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
                child: PaginatedListViewWidget(
                  scrollController: _scrollController,
                  onPaginate: (int? offset) async => await happyHourController.getHappyHourList(offset: offset!),
                  totalSize: happyHourController.happyHourBody?.totalSize,
                  offset: happyHourController.offset,
                  productView: ListView.builder(
                    itemCount: happyHourController.happyHourList!.length,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    padding: EdgeInsets.zero,
                    itemBuilder: (context, index) {
                      final HappyHourModel happyHour = happyHourController.happyHourList![index];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: Dimensions.paddingSizeSmall),
                        child: HappyHourCardWidget(
                          happyHourModel: happyHour,
                          onTap: () => _openDetails(happyHour),
                          isActionLoading: happyHourController.isActionLoadingFor(happyHour.id),
                          onActionPressed: happyHourController.isActionLoading ? null : () {
                            if(!HappyHourActionHelper.run(happyHour)) {
                              _openDetails(happyHour);
                            }
                          },
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
          )),

        ]);
      }),
    );
  }

  /// One tab per `type` the list endpoint accepts, each carrying the count the
  /// envelope reports for it.
  Widget _buildTabBar(BuildContext context, HappyHourController happyHourController) {
    return Container(
      alignment: Alignment.centerLeft,
      padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        border: BorderDirectional(bottom: BorderSide(color: Theme.of(context).disabledColor.withAlpha(100), width: 1)),
      ),
      child: TabBar(
        tabAlignment: TabAlignment.start,
        controller: _tabController,
        isScrollable: true,
        dividerColor: Colors.transparent,
        labelPadding: const EdgeInsets.only(right: Dimensions.paddingSizeDefault),
        indicatorColor: Theme.of(context).primaryColor,
        labelColor: Theme.of(context).textTheme.bodyLarge!.color,
        unselectedLabelColor: Theme.of(context).hintColor,
        indicatorSize: TabBarIndicatorSize.label,
        overlayColor: WidgetStateProperty.all(Colors.transparent),
        labelStyle: robotoBold.copyWith(fontSize: Dimensions.fontSizeSmall),
        unselectedLabelStyle: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall),
        onTap: (int index) => happyHourController.setType(HappyHourController.typeList[index]),
        tabs: HappyHourController.typeList.map((type) {
          final int? count = happyHourController.countOf(type);
          return Tab(text: count == null ? type.tr : '${type.tr} ($count)');
        }).toList(),
      ),
    );
  }
}
