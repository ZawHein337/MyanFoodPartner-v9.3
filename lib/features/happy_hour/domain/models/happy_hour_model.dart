class HappyHourBodyModel {
  int? totalSize;
  int? limit;
  int? offset;
  int? all;
  int? notJoined;
  int? pending;
  int? adminRequested;
  int? approved;
  int? rejected;
  List<HappyHourModel>? happyHours;

  HappyHourBodyModel({
    this.totalSize, this.limit, this.offset, this.all, this.notJoined,
    this.pending, this.adminRequested, this.approved, this.rejected, this.happyHours,
  });

  HappyHourBodyModel.fromJson(Map<String, dynamic> json) {
    totalSize = json['total_size'];
    limit = int.tryParse(json['limit'].toString());
    offset = int.tryParse(json['offset'].toString());
    all = json['all'];
    notJoined = json['not_joined'];
    pending = json['pending'];
    adminRequested = json['admin_requested'];
    approved = json['approved'];
    rejected = json['rejected'];
    if(json['happy_hours'] != null) {
      happyHours = <HappyHourModel>[];
      json['happy_hours'].forEach((happyHour) {
        happyHours!.add(HappyHourModel.fromJson(happyHour));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['total_size'] = totalSize;
    data['limit'] = limit;
    data['offset'] = offset;
    data['all'] = all;
    data['not_joined'] = notJoined;
    data['pending'] = pending;
    data['admin_requested'] = adminRequested;
    data['approved'] = approved;
    data['rejected'] = rejected;
    if(happyHours != null) {
      data['happy_hours'] = happyHours!.map((happyHour) => happyHour.toJson()).toList();
    }
    return data;
  }
}

class HappyHourModel {
  int? id;
  String? slug;
  String? title;
  String? shortDescription;
  String? coverImageFullUrl;
  String? iconFullUrl;
  int? zoneId;
  String? zoneName;
  double? discount;
  double? minOrderAmount;
  bool? isPermanent;
  String? durationType;
  List<String>? weeklyDays;
  String? startDate;
  String? endDate;
  String? startTime;
  String? endTime;
  bool? isRunningNow;
  int? status;
  bool? isEligible;
  String? ineligibleReason;
  String? enrollmentState;
  HappyHourEnrollment? enrollment;
  HappyHourActions? actions;

  /// Only the details endpoint fills this. A permanent weekly rule returns an
  /// empty list and is described by [weeklyDays] instead.
  List<HappyHourDate>? dates;

  HappyHourModel({
    this.id, this.slug, this.title, this.shortDescription, this.coverImageFullUrl,
    this.iconFullUrl, this.zoneId, this.zoneName, this.discount, this.minOrderAmount,
    this.isPermanent, this.durationType, this.weeklyDays, this.startDate, this.endDate,
    this.startTime, this.endTime, this.isRunningNow, this.status, this.isEligible,
    this.ineligibleReason, this.enrollmentState, this.enrollment, this.actions, this.dates,
  });

  HappyHourModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    slug = json['slug'];
    title = json['title'];
    shortDescription = json['short_description'];
    coverImageFullUrl = json['cover_image_full_url'];
    iconFullUrl = json['icon_full_url'];
    zoneId = json['zone_id'];
    zoneName = json['zone_name'];
    discount = json['discount'] != null ? double.tryParse(json['discount'].toString()) : null;
    minOrderAmount = json['min_order_amount'] != null ? double.tryParse(json['min_order_amount'].toString()) : null;
    isPermanent = json['is_permanent'];
    durationType = json['duration_type'];
    weeklyDays = json['weekly_days'] != null ? List<String>.from(json['weekly_days'].map((day) => day.toString())) : null;
    startDate = json['start_date'];
    endDate = json['end_date'];
    startTime = json['start_time'];
    endTime = json['end_time'];
    isRunningNow = json['is_running_now'];
    status = json['status'];
    isEligible = json['is_eligible'];
    ineligibleReason = json['ineligible_reason'];
    enrollmentState = json['enrollment_state'];
    enrollment = json['enrollment'] != null ? HappyHourEnrollment.fromJson(json['enrollment']) : null;
    actions = json['actions'] != null ? HappyHourActions.fromJson(json['actions']) : null;
    if(json['dates'] != null) {
      dates = <HappyHourDate>[];
      json['dates'].forEach((date) {
        dates!.add(HappyHourDate.fromJson(date));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['slug'] = slug;
    data['title'] = title;
    data['short_description'] = shortDescription;
    data['cover_image_full_url'] = coverImageFullUrl;
    data['icon_full_url'] = iconFullUrl;
    data['zone_id'] = zoneId;
    data['zone_name'] = zoneName;
    data['discount'] = discount;
    data['min_order_amount'] = minOrderAmount;
    data['is_permanent'] = isPermanent;
    data['duration_type'] = durationType;
    data['weekly_days'] = weeklyDays;
    data['start_date'] = startDate;
    data['end_date'] = endDate;
    data['start_time'] = startTime;
    data['end_time'] = endTime;
    data['is_running_now'] = isRunningNow;
    data['status'] = status;
    data['is_eligible'] = isEligible;
    data['ineligible_reason'] = ineligibleReason;
    data['enrollment_state'] = enrollmentState;
    data['enrollment'] = enrollment?.toJson();
    data['actions'] = actions?.toJson();
    if(dates != null) {
      data['dates'] = dates!.map((date) => date.toJson()).toList();
    }
    return data;
  }

  String? get imageFullUrl => coverImageFullUrl;
}

class HappyHourActions {
  bool? canJoin;

  /// Sent for parity with BOGO, where a food selection can be reworked. A happy
  /// hour has nothing to select, so the server always reports it false.
  bool? canResubmit;
  bool? canRespond;

  /// Withdrawing a request that never went live — `pending` or `rejected`.
  /// Posts to the same endpoint as [canLeave]; they are separate flags because
  /// they are separate words to the restaurant.
  bool? canCancel;

  /// Walking away from a running happy hour — `approved` only.
  bool? canLeave;

  HappyHourActions({this.canJoin, this.canResubmit, this.canRespond, this.canCancel, this.canLeave});

  HappyHourActions.fromJson(Map<String, dynamic> json) {
    canJoin = json['can_join'];
    canResubmit = json['can_resubmit'];
    canRespond = json['can_respond'];
    canCancel = json['can_cancel'];
    canLeave = json['can_leave'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['can_join'] = canJoin;
    data['can_resubmit'] = canResubmit;
    data['can_respond'] = canRespond;
    data['can_cancel'] = canCancel;
    data['can_leave'] = canLeave;
    return data;
  }
}

class HappyHourEnrollment {
  int? id;
  String? status;

  /// Who **raised** the request. Not a reliable guide to who refused it, so the
  /// denial copy reads [rejectedBy] instead.
  String? requestedBy;
  String? rejectionReason;

  /// Who **said no** — `admin`, `restaurant`, or null when it was never
  /// rejected.
  String? rejectedBy;
  String? joinedAt;

  HappyHourEnrollment({this.id, this.status, this.requestedBy, this.rejectionReason, this.rejectedBy, this.joinedAt});

  HappyHourEnrollment.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    status = json['status'];
    requestedBy = json['requested_by'];
    rejectionReason = json['rejection_reason'];
    rejectedBy = json['rejected_by'];
    joinedAt = json['joined_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['status'] = status;
    data['requested_by'] = requestedBy;
    data['rejection_reason'] = rejectionReason;
    data['rejected_by'] = rejectedBy;
    data['joined_at'] = joinedAt;
    return data;
  }
}

/// One occurrence of the window, today onward.
class HappyHourDate {
  String? applicableDate;
  String? startTime;
  String? endTime;
  bool? status;

  HappyHourDate({this.applicableDate, this.startTime, this.endTime, this.status});

  HappyHourDate.fromJson(Map<String, dynamic> json) {
    applicableDate = json['applicable_date'];
    startTime = json['start_time'];
    endTime = json['end_time'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['applicable_date'] = applicableDate;
    data['start_time'] = startTime;
    data['end_time'] = endTime;
    data['status'] = status;
    return data;
  }
}
