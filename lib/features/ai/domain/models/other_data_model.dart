class OtherDataModel {
  GeneralData? generalData;
  PriceData? priceData;
  SeoData? seoData;

  OtherDataModel({this.generalData, this.priceData, this.seoData});

  OtherDataModel.fromJson(Map<String, dynamic> json) {
    generalData = json['generalData'] != null ? GeneralData.fromJson(json['generalData']) : null;
    priceData = json['priceData'] != null ? PriceData.fromJson(json['priceData']) : null;
    seoData = json['seoData'] != null ? SeoData.fromJson(json['seoData']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (generalData != null) {
      data['generalData'] = generalData!.toJson();
    }
    if (priceData != null) {
      data['priceData'] = priceData!.toJson();
    }
    if (seoData != null) {
      data['seoData'] = seoData!.toJson();
    }
    return data;
  }
}

class GeneralData {
  Data? data;

  GeneralData({this.data});

  GeneralData.fromJson(Map<String, dynamic> json) {
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  String? categoryName;
  String? subCategoryName;
  List<String>? nutrition;
  List<String>? allergy;
  String? productType;
  List<String>? searchTags;
  bool? isHalal;
  String? availableTimeStarts;
  String? availableTimeEnds;
  int? categoryId;
  int? subCategoryId;
  List<String>? addonsNames;
  List<int>? addonsIds;

  Data({
    this.categoryName,
    this.subCategoryName,
    this.nutrition,
    this.allergy,
    this.productType,
    this.searchTags,
    this.isHalal,
    this.availableTimeStarts,
    this.availableTimeEnds,
    this.categoryId,
    this.subCategoryId,
    this.addonsNames,
    this.addonsIds,
  });

  Data.fromJson(Map<String, dynamic> json) {
    categoryName = json['category_name'];
    subCategoryName = json['sub_category_name'];
    nutrition = json['nutrition'].cast<String>();
    allergy = json['allergy'].cast<String>();
    productType = json['product_type'];
    searchTags = json['search_tags'].cast<String>();
    isHalal = json['is_halal'];
    availableTimeStarts = json['available_time_starts'];
    availableTimeEnds = json['available_time_ends'];
    categoryId = json['category_id'];
    subCategoryId = json['sub_category_id'];
    addonsNames = json['addonsNames'].cast<String>();
    addonsIds = json['addonsIds'].cast<int>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['category_name'] = categoryName;
    data['sub_category_name'] = subCategoryName;
    data['nutrition'] = nutrition;
    data['allergy'] = allergy;
    data['product_type'] = productType;
    data['search_tags'] = searchTags;
    data['is_halal'] = isHalal;
    data['available_time_starts'] = availableTimeStarts;
    data['available_time_ends'] = availableTimeEnds;
    data['category_id'] = categoryId;
    data['sub_category_id'] = subCategoryId;
    data['addonsNames'] = addonsNames;
    data['addonsIds'] = addonsIds;
    return data;
  }
}

class PriceData {
  double? unitPrice;
  int? minimumOrderQuantity;
  double? discountAmount;

  PriceData({this.unitPrice, this.minimumOrderQuantity, this.discountAmount});

  PriceData.fromJson(Map<String, dynamic> json) {
    unitPrice = json['unit_price']?.toDouble() ?? 0.0;
    minimumOrderQuantity = json['minimum_order_quantity'];
    discountAmount = double.tryParse(json['discount_amount'].toString()) ?? 0.0;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['unit_price'] = unitPrice;
    data['minimum_order_quantity'] = minimumOrderQuantity;
    data['discount_amount'] = discountAmount;
    return data;
  }
}

class SeoData {
  String? metaTitle;
  String? metaDescription;
  String? metaIndex;
  int? metaNoFollow;
  int? metaNoImageIndex;
  int? metaNoArchive;
  int? metaNoSnippet;
  int? metaMaxSnippet;
  int? metaMaxSnippetValue;
  int? metaMaxVideoPreview;
  int? metaMaxVideoPreviewValue;
  int? metaMaxImagePreview;
  String? metaMaxImagePreviewValue;

  SeoData({
    this.metaTitle,
    this.metaDescription,
    this.metaIndex,
    this.metaNoFollow,
    this.metaNoImageIndex,
    this.metaNoArchive,
    this.metaNoSnippet,
    this.metaMaxSnippet,
    this.metaMaxSnippetValue,
    this.metaMaxVideoPreview,
    this.metaMaxVideoPreviewValue,
    this.metaMaxImagePreview,
    this.metaMaxImagePreviewValue,
  });

  SeoData.fromJson(Map<String, dynamic> json) {
    metaTitle = json['meta_title'];
    metaDescription = json['meta_description'];
    metaIndex = json['meta_index'];
    metaNoFollow = json['meta_no_follow'];
    metaNoImageIndex = json['meta_no_image_index'];
    metaNoArchive = json['meta_no_archive'];
    metaNoSnippet = json['meta_no_snippet'];
    metaMaxSnippet = json['meta_max_snippet'];
    metaMaxSnippetValue = json['meta_max_snippet_value'];
    metaMaxVideoPreview = json['meta_max_video_preview'];
    metaMaxVideoPreviewValue = json['meta_max_video_preview_value'];
    metaMaxImagePreview = json['meta_max_image_preview'];
    metaMaxImagePreviewValue = json['meta_max_image_preview_value'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['meta_title'] = metaTitle;
    data['meta_description'] = metaDescription;
    data['meta_index'] = metaIndex;
    data['meta_no_follow'] = metaNoFollow;
    data['meta_no_image_index'] = metaNoImageIndex;
    data['meta_no_archive'] = metaNoArchive;
    data['meta_no_snippet'] = metaNoSnippet;
    data['meta_max_snippet'] = metaMaxSnippet;
    data['meta_max_snippet_value'] = metaMaxSnippetValue;
    data['meta_max_video_preview'] = metaMaxVideoPreview;
    data['meta_max_video_preview_value'] = metaMaxVideoPreviewValue;
    data['meta_max_image_preview'] = metaMaxImagePreview;
    data['meta_max_image_preview_value'] = metaMaxImagePreviewValue;
    return data;
  }
}
