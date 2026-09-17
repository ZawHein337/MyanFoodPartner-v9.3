import 'package:stackfood_multivendor_restaurant/common/widgets/confirmation_dialog_widget.dart';
import 'package:stackfood_multivendor_restaurant/common/widgets/custom_button_widget.dart';
import 'package:stackfood_multivendor_restaurant/common/widgets/custom_snackbar_widget.dart';
import 'package:stackfood_multivendor_restaurant/common/widgets/custom_time_picker_widget.dart';
import 'package:stackfood_multivendor_restaurant/features/profile/controllers/profile_controller.dart';
import 'package:stackfood_multivendor_restaurant/features/restaurant/controllers/restaurant_controller.dart';
import 'package:stackfood_multivendor_restaurant/features/profile/domain/models/profile_model.dart';
import 'package:stackfood_multivendor_restaurant/helper/date_converter_helper.dart';
import 'package:stackfood_multivendor_restaurant/util/dimensions.dart';
import 'package:stackfood_multivendor_restaurant/util/images.dart';
import 'package:stackfood_multivendor_restaurant/util/styles.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DailyTimeWidget extends StatelessWidget {
  final int weekDay;
  final bool isSameTimeForEveryDay;
  const DailyTimeWidget({super.key, required this.weekDay, required this.isSameTimeForEveryDay});

  @override
  Widget build(BuildContext context) {
    List<Schedules> scheduleList = [];

    int backendWeekDay = weekDay == 6 ? 0 : weekDay + 1;

    for (var schedule in Get.find<RestaurantController>().scheduleList!) {
      // Match based on the backend's day numbering system
      if (schedule.day == backendWeekDay) {
        scheduleList.add(schedule);
      }
    }

    // UI mapping: 0=Monday, 1=Tuesday, 2=Wednesday, 3=Thursday, 4=Friday, 5=Saturday, 6=Sunday
    String dayString = weekDay == 0 ? 'monday' : weekDay == 1 ? 'tuesday' : weekDay == 2 ? 'wednesday'
        : weekDay == 3 ? 'thursday' : weekDay == 4 ? 'friday' : weekDay == 5 ? 'saturday' : 'sunday';

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeSmall),
      child: Row(crossAxisAlignment: scheduleList.isEmpty ? CrossAxisAlignment.center : CrossAxisAlignment.start, children: [
        SizedBox(
          width: 100,
          child: Text(
            dayString.tr,
            style: robotoMedium.copyWith(
              fontSize: Dimensions.fontSizeDefault,
              color: Theme.of(context).textTheme.bodyLarge!.color?.withValues(alpha: 0.7),
            ),
          ),
        ),
        const SizedBox(width: Dimensions.paddingSizeDefault),

        // Schedule list column
        Expanded(
          child: scheduleList.isEmpty ? _buildOffDayRow(context, dayString, backendWeekDay) : _buildScheduleList(context, scheduleList, dayString, backendWeekDay),
        ),
      ]),
    );
  }

  Widget _buildOffDayRow(BuildContext context, String dayString, int backendWeekDay) {
    return Row(children: [
      Container(
        padding: const EdgeInsets.symmetric(
          horizontal: Dimensions.paddingSizeSmall,
          vertical: Dimensions.paddingSizeExtraSmall,
        ),
        decoration: BoxDecoration(
          color: Colors.red.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
        ),
        child: Text(
          'off_day'.tr,
          style: robotoMedium.copyWith(color: Colors.red),
        ),
      ),
      const SizedBox(width: Dimensions.paddingSizeLarge),

      if (!isSameTimeForEveryDay || (isSameTimeForEveryDay && weekDay == 0))
        _buildAddButton(context, dayString, [], backendWeekDay),
    ]);
  }

  Widget _buildScheduleList(BuildContext context, List<Schedules> scheduleList, String dayString, int backendWeekDay) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      ...scheduleList.asMap().entries.map((entry) {
        int idx = entry.key;
        Schedules schedule = entry.value;
        return Padding(
          padding: EdgeInsets.only(
            bottom: idx < scheduleList.length - 1 ? Dimensions.paddingSizeLarge : 0,
          ),
          child: Row(children: [
            // Time display
            Stack(clipBehavior: Clip.none, children: [
              Container(
                padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                decoration: BoxDecoration(
                  color: (!isSameTimeForEveryDay || (isSameTimeForEveryDay && weekDay == 0)) ? Theme.of(context).cardColor : Theme.of(context).disabledColor.withValues(alpha: 0.1),
                  border: Border.all(color: Theme.of(context).disabledColor.withValues(alpha: 0.3)),
                  boxShadow: [
                    BoxShadow(
                      color: Get.isDarkMode ? Colors.white.withValues(alpha: 0.05) : const Color(0xffBDBDBD).withValues(alpha: 0.1),
                      blurRadius: 20, spreadRadius: 0, offset: const Offset(0, 10),
                    ),
                  ],
                  borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                ),
                child: Text(
                  '${DateConverter.convertStringTimeToTime(schedule.openingTime!.substring(0, 5))}  -  '
                      '${DateConverter.convertStringTimeToTime(schedule.closingTime!.substring(0, 5))}',
                  style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).textTheme.bodyLarge!.color),
                ),
              ),

              if (!isSameTimeForEveryDay || (isSameTimeForEveryDay && weekDay == 0))
                Positioned(
                  top: -10, right: -10,
                  child: InkWell(
                    onTap: () => Get.dialog(
                      ConfirmationDialogWidget(
                        icon: Images.warning,
                        description: 'are_you_sure_to_delete_this_schedule'.tr,
                        onYesPressed: () async {
                          await Get.find<RestaurantController>().deleteSchedule(schedule.id);
                          Get.find<ProfileController>().getProfile().then((profileModel) {
                            if(profileModel != null) {
                              Restaurant? restaurant = Get.find<ProfileController>().profileModel != null ? Get.find<ProfileController>().profileModel!.restaurants![0] : null;
                              Get.find<RestaurantController>().initRestaurantData(restaurant!);
                            }
                          });
                        },
                      ),
                      barrierDismissible: false,
                    ),
                    child: Container(
                      padding: const EdgeInsets.all(2),
                      child: Icon(Icons.cancel_outlined, color: Colors.red, size: 20),
                    ),
                  ),
                ),
            ]),
            const SizedBox(width: Dimensions.paddingSizeDefault),

            // Add button - only show on last item and when not same time for every day
            if (idx == scheduleList.length - 1 && (!isSameTimeForEveryDay || (isSameTimeForEveryDay && weekDay == 0))) ...[
              const SizedBox(width: Dimensions.paddingSizeExtraSmall),
              _buildAddButton(context, dayString, scheduleList, backendWeekDay),
            ],

          ]),
        );
      }),
    ]);
  }

  Widget _buildAddButton(BuildContext context, String dayString, List<Schedules> scheduleList, int backendWeekDay) {
    String? openingTime;
    String? closingTime;

    return InkWell(
      onTap: () => Get.dialog(
        Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(Dimensions.radiusLarge)),
          child: Padding(
            padding: const EdgeInsets.all(Dimensions.paddingSizeLarge),
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              Text(
                '${'schedule_for'.tr} ${dayString.tr}',
                style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeLarge),
              ),
              const SizedBox(height: Dimensions.paddingSizeLarge),

              Row(children: [
                Expanded(
                  child: CustomTimePickerWidget(
                    title: 'open_time'.tr,
                    time: openingTime,
                    onTimeChanged: (time) => openingTime = time,
                  ),
                ),
                const SizedBox(width: Dimensions.paddingSizeSmall),

                Expanded(
                  child: CustomTimePickerWidget(
                    title: 'close_time'.tr,
                    time: closingTime,
                    onTimeChanged: (time) => closingTime = time,
                  ),
                ),
              ]),
              const SizedBox(height: Dimensions.paddingSizeLarge),

              GetBuilder<RestaurantController>(builder: (restaurantController) {
                return restaurantController.scheduleLoading ? const Center(child: CircularProgressIndicator()) : Row(children: [
                  Expanded(
                    child: TextButton(
                      onPressed: () => Get.back(),
                      style: TextButton.styleFrom(
                        backgroundColor: Theme.of(context).hintColor.withValues(alpha: 0.1),
                        minimumSize: const Size(1170, 45),
                        padding: EdgeInsets.zero,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(Dimensions.radiusDefault)),
                      ),
                      child: Text(
                        'cancel'.tr,
                        textAlign: TextAlign.center,
                        style: robotoBold.copyWith(color: Theme.of(context).textTheme.bodyLarge!.color),
                      ),
                    ),
                  ),
                  const SizedBox(width: Dimensions.paddingSizeLarge),

                  Expanded(
                    child: CustomButtonWidget(
                      buttonText: 'add'.tr,
                      height: 45,
                      onPressed: () async {
                        bool overlapped = false;
                        if (openingTime != null && closingTime != null) {
                          for (int index = 0; index < scheduleList.length; index++) {
                            if (_isUnderTime(scheduleList[index].openingTime!, openingTime!, closingTime) ||
                                _isUnderTime(scheduleList[index].closingTime!, openingTime!, closingTime) ||
                                _isUnderTime(openingTime!, scheduleList[index].openingTime!, scheduleList[index].closingTime) ||
                                _isUnderTime(closingTime!, scheduleList[index].openingTime!, scheduleList[index].closingTime)) {
                              overlapped = true;
                              break;
                            }
                          }
                        }
                        if (openingTime == null) {
                          showCustomSnackBar('pick_start_time'.tr);
                        } else if (closingTime == null) {
                          showCustomSnackBar('pick_end_time'.tr);
                        } else if (DateConverter.convertTimeToDateTime(openingTime!).isAfter(DateConverter.convertTimeToDateTime(closingTime!))) {
                          showCustomSnackBar('closing_time_must_be_after_the_opening_time'.tr);
                        } else if (overlapped) {
                          showCustomSnackBar('this_schedule_is_overlapped'.tr);
                        } else {
                          // Use backend day numbering when saving
                          await restaurantController.addSchedule(
                            Schedules(day: backendWeekDay, openingTime: openingTime, closingTime: closingTime),
                          );
                          Get.find<ProfileController>().getProfile().then((profileModel) {
                            if(profileModel != null) {
                              Restaurant? restaurant = Get.find<ProfileController>().profileModel != null ? Get.find<ProfileController>().profileModel!.restaurants![0] : null;
                              Get.find<RestaurantController>().initRestaurantData(restaurant!);
                            }
                          });
                        }
                      },
                    ),
                  ),
                ]);
              }),
            ]),
          ),
        ),
        barrierDismissible: false,
      ),
      child: Container(
        height: 30, width: 30,
        decoration: BoxDecoration(
          color: Theme.of(context).primaryColor,
          borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
        ),
        child: const Icon(Icons.add, color: Colors.white, size: 20),
      ),
    );
  }

  bool _isUnderTime(String time, String startTime, String? endTime) {
    return DateConverter.convertTimeToDateTime(time).isAfter(DateConverter.convertTimeToDateTime(startTime)) &&
        DateConverter.convertTimeToDateTime(time).isBefore(DateConverter.convertTimeToDateTime(endTime!));
  }
}