import 'package:stackfood_multivendor_restaurant/features/happy_hour/domain/models/happy_hour_model.dart';
import 'package:stackfood_multivendor_restaurant/helper/date_converter_helper.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

/// Single source of truth for happy hour status/action colors and the formatted
/// strings shared by the list card and the details screen.
class HappyHourHelper {

  /// Background and text color for an enrolment state badge.
  static (Color background, Color text) statusColor(BuildContext context, String? state) {
    if(state == 'approved') {
      return (const Color(0x1a00AA6D), const Color(0xff019463));
    } else if(state == 'pending') {
      return (const Color(0x1a5C8FFC), const Color(0xff245BD1));
    } else if(state == 'rejected') {
      return (Theme.of(context).colorScheme.error.withValues(alpha: 0.1), Theme.of(context).colorScheme.error);
    } else if(state == 'admin_requested' || state == 'not_joined') {
      return (Theme.of(context).hintColor.withAlpha(70), Theme.of(context).textTheme.bodyLarge!.color!);
    }
    return (Theme.of(context).disabledColor.withValues(alpha: 0.15), Theme.of(context).hintColor);
  }

  /// Fill color for the action button. Only the two that undo an enrolment are
  /// destructive.
  static Color actionColor(BuildContext context, String? action) {
    if(action == 'leave' || action == 'cancel') {
      return Theme.of(context).colorScheme.error;
    }
    return Theme.of(context).primaryColor;
  }

  /// The one action the button offers, resolved from `actions` and never from
  /// `status` — the server settles which of these is open, and the panel reads
  /// the same code.
  ///
  /// `can_resubmit` is not consulted: it exists for BOGO, where a food
  /// selection can be reworked, and a happy hour never has one.
  static String actionKey(HappyHourModel happyHour) {
    final HappyHourActions? actions = happyHour.actions;
    if(actions == null) {
      return 'view';
    }
    if(actions.canRespond ?? false) {
      return 'approve';
    } else if(actions.canJoin ?? false) {
      return 'join';
    } else if(actions.canCancel ?? false) {
      return 'cancel';
    } else if(actions.canLeave ?? false) {
      return 'leave';
    }
    return 'view';
  }

  /// Who refused the enrolment, in the restaurant's own terms. Read from
  /// `rejected_by` rather than inferred from `requested_by`, which stops
  /// agreeing with it after a round trip.
  static String? rejectedByText(HappyHourModel happyHour) {
    switch(happyHour.enrollment?.rejectedBy) {
      case 'admin': return 'denied_by_admin'.tr;
      case 'restaurant': return 'you_declined_this_offer'.tr;
    }
    return null;
  }

  /// A happy hour discount is always a percentage off the whole restaurant.
  static String discount(HappyHourModel happyHour) {
    if(happyHour.discount == null) {
      return '';
    }
    return '${happyHour.discount!.toStringAsFixed(0)}%';
  }

  /// How often the window comes round. `is_permanent` is orthogonal to this —
  /// a rule can be weekly *and* permanent — so it is reported on the validity
  /// line instead of here.
  static String repeatText(HappyHourModel happyHour) {
    switch(happyHour.durationType) {
      case 'daily': return 'daily'.tr;
      case 'weekly': return 'weekly'.tr;
      case 'custom': return 'custom'.tr;
    }
    return '';
  }

  /// A weekly rule only says which days in `weekly_days`, so the days ride
  /// along as a tooltip rather than crowding the card.
  static bool hasWeeklyDays(HappyHourModel happyHour) {
    return happyHour.durationType == 'weekly' && weeklyDays(happyHour).isNotEmpty;
  }

  /// `HH:mm - HH:mm (n hours)`. The window is expressed as two clock times, so
  /// the duration is measured from them rather than read off a field.
  static String timeRange(HappyHourModel happyHour) {
    final String start = formatTime(happyHour.startTime);
    final String end = formatTime(happyHour.endTime);
    if(start.isEmpty || end.isEmpty) {
      return '';
    }
    final String duration = _durationText(happyHour.startTime, happyHour.endTime);
    return duration.isEmpty ? '$start - $end' : '$start - $end ($duration)';
  }

  static String dateRange(HappyHourModel happyHour) {
    if(happyHour.durationType == 'custom') {
      return 'custom_schedule'.tr;
    }
    if(happyHour.isPermanent ?? false) {
      return 'permanent'.tr;
    }

    final String start = _dateTime(happyHour.startDate, happyHour.startTime);
    final String end = _dateTime(happyHour.endDate, happyHour.endTime);
    if(start.isEmpty && end.isEmpty) {
      return 'permanent'.tr;
    }
    if(end.isEmpty) {
      return start;
    }
    return '$start - $end';
  }

  static String weeklyDays(HappyHourModel happyHour) {
    if(happyHour.weeklyDays == null || happyHour.weeklyDays!.isEmpty) {
      return '';
    }
    return happyHour.weeklyDays!.map((day) => day.toLowerCase().tr).join(', ');
  }

 static String formatTime(String? time) {
    final DateTime? parsed = parseTime(time);
    if(parsed == null) {
      return '';
    }
    return DateConverter.convertStringTimeToTime('${parsed.hour.toString().padLeft(2, '0')}:${parsed.minute.toString().padLeft(2, '0')}');
  }

 static String formatDate(String? date) {
    final DateTime? parsed = parseDate(date);
    if(parsed == null) {
      return '';
    }
    return DateFormat('dd MMM yyyy').format(parsed);
  }

  static DateTime? parseDate(String? date) {
    if(date == null || date.isEmpty) {
      return null;
    }
    return DateTime.tryParse(date);
  }

  static String _dateTime(String? date, String? time) {
    final DateTime? day = parseDate(date);
    if(day == null) {
      return '';
    }
    final DateTime? clock = parseTime(time);
    if(clock == null) {
      return formatDate(date);
    }
    return DateConverter.dateTimeToDateTime(DateTime(day.year, day.month, day.day, clock.hour, clock.minute));
  }

  static DateTime? parseTime(String? time) {
    if(time == null || time.isEmpty) {
      return null;
    }
    final List<String> parts = time.split(':');
    if(parts.length < 2) {
      return null;
    }
    final int? hour = int.tryParse(parts[0]);
    final int? minute = int.tryParse(parts[1]);
    if(hour == null || minute == null) {
      return null;
    }
    return DateTime(2000, 1, 1, hour, minute);
  }

  static String _durationText(String? startTime, String? endTime) {
    final DateTime? start = parseTime(startTime);
    final DateTime? end = parseTime(endTime);
    if(start == null || end == null) {
      return '';
    }
    final int minutes = end.difference(start).inMinutes;
    if(minutes <= 0) {
      return '';
    }
    if(minutes % 60 == 0) {
      final int hours = minutes ~/ 60;
      return '$hours ${hours == 1 ? 'hour'.tr : 'hours'.tr}';
    }
    return '$minutes ${'minutes'.tr}';
  }
}
