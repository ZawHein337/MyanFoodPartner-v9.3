class ProductModel {
  int? totalSize;
  String? limit;
  String? offset;
  List<Product>? products;

  ProductModel({
    int? totalSize,
    String? limit,
    String? offset,
    List<Product>? products,
  });

  ProductModel.fromJson(Map<String, dynamic> json) {
    totalSize = json['total_size'];
    limit = json['limit'];
    offset = json['offset'];
    if (json['products'] != null) {
      products = [];
      json['products'].forEach((v) {
        products!.add(Product.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['total_size'] = totalSize;
    data['limit'] = limit;
    data['offset'] = offset;
    if (products != null) {
      data['products'] = products!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Product {
  int? id;
  String? name;
  String? description;
  String? imageFullUrl;
  int? categoryId;
  List<CategoryIds>? categoryIds;
  List<Variation>? variations;
  List<AddOns>? addOns;
  double? price;
  double? tax;
  double? discount;
  String? discountType;
  String? availableTimeStarts;
  String? availableTimeEnds;
  int? setMenu;
  int? status;
  int? restaurantId;
  String? createdAt;
  String? updatedAt;
  String? restaurantName;
  double? restaurantDiscount;
  String? restaurantOpeningTime;
  String? restaurantClosingTime;
  bool? scheduleOrder;
  double? avgRating;
  int? ratingCount;
  int? veg;
  List<Translation>? translations;
  List<Tag>? tags;
  int? recommendedStatus;
  int? maxOrderQuantity;
  int? itemStock;
  String? stockType;
  int? isHalal;
  int? halalTagStatus;
  List<String?>? nutrition;
  List<String?>? allergies;
  List<int>? taxVatIds;
  List<TaxData>? taxData;
  int? cartQuantityLimit;
  int? restaurantCategoryId;
  String? restaurantCategoryName;

  Product({
    this.id,
    this.name,
    this.description,
    this.imageFullUrl,
    this.categoryId,
    this.categoryIds,
    this.variations,
    this.addOns,
    this.price,
    this.tax,
    this.discount,
    this.discountType,
    this.availableTimeStarts,
    this.availableTimeEnds,
    this.setMenu,
    this.status,
    this.restaurantId,
    this.createdAt,
    this.updatedAt,
    this.restaurantName,
    this.restaurantDiscount,
    this.restaurantOpeningTime,
    this.restaurantClosingTime,
    this.scheduleOrder,
    this.avgRating,
    this.ratingCount,
    this.veg,
    this.translations,
    this.tags,
    this.recommendedStatus,
    this.maxOrderQuantity,
    this.itemStock,
    this.stockType,
    this.isHalal,
    this.halalTagStatus,
    this.nutrition,
    this.allergies,
    this.taxVatIds,
    this.taxData,
    this.cartQuantityLimit,
    this.restaurantCategoryId,
    this.restaurantCategoryName,
  });

  Product.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    description = json['description'];
    imageFullUrl = json['image_full_url'];
    categoryId = json['category_id'];
    if (json['category_ids'] != null) {
      categoryIds = [];
      json['category_ids'].forEach((v) {
        categoryIds!.add(CategoryIds.fromJson(v));
      });
    }
    if (json['variations'] != null) {
      variations = [];
      if(json['variations'] != null && json['variations'].length > 0 && json['variations'][0] != '[') {
        json['variations'].forEach((v) {
          variations!.add(Variation.fromJson(v));
        });
      }
    }
    if (json['add_ons'] != null) {
      addOns = [];
      json['add_ons'].forEach((v) {
        addOns!.add(AddOns.fromJson(v));
      });
    }
    price = json['price']?.toDouble();
    tax = json['tax']?.toDouble();
    discount = json['discount']?.toDouble();
    discountType = json['discount_type'];
    availableTimeStarts = json['available_time_starts'];
    availableTimeEnds = json['available_time_ends'];
    setMenu = json['set_menu'];
    status = json['status'];
    restaurantId = json['restaurant_id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    restaurantName = json['restaurant_name'];
    restaurantDiscount = json['restaurant_discount']?.toDouble();
    restaurantOpeningTime = json['restaurant_opening_time'];
    restaurantClosingTime = json['restaurant_closing_time'];
    scheduleOrder = json['schedule_order'];
    avgRating = json['avg_rating']?.toDouble();
    ratingCount = json['rating_count'];
    veg = json['veg'];
    if (json['translations'] != null) {
      translations = [];
      json['translations'].forEach((v) {
        translations!.add(Translation.fromJson(v));
      });
    }
    if (json['tags'] != null) {
      tags = [];
      json['tags'].forEach((v) {
        tags!.add(Tag.fromJson(v));
      });
    }
    recommendedStatus = json['recommended'];
    maxOrderQuantity = json['maximum_cart_quantity'] ?? 0;
    itemStock = json['item_stock'];
    stockType = json['stock_type'];
    isHalal = json['is_halal'];
    halalTagStatus = json['halal_tag_status'];
    if(json['nutritions_name'] != null) {
      nutrition = [];
      for(String v in json['nutritions_name']) {
        nutrition!.add(v);
      }
    }
    if(json['allergies_name'] != null) {
      allergies = [];
      for(String v in json['allergies_name']) {
        allergies!.add(v);
      }
    }
    if (json['tax_ids'] != null) {
      taxVatIds = [];
      json['tax_ids'].forEach((v) {
        taxVatIds!.add(int.parse(v.toString()));
      });
    }
    if (json['tax_data'] != null) {
      taxData = <TaxData>[];
      json['tax_data'].forEach((v) { taxData!.add(TaxData.fromJson(v)); });
    }
    cartQuantityLimit = json['maximum_cart_quantity'];
    restaurantCategoryId = json['restaurant_category_id'];
    restaurantCategoryName = json['restaurant_category_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['description'] = description;
    data['image_full_url'] = imageFullUrl;
    data['category_id'] = categoryId;
    if (categoryIds != null) {
      data['category_ids'] = categoryIds!.map((v) => v.toJson()).toList();
    }
    if (variations != null) {
      data['variations'] = variations!.map((v) => v.toJson()).toList();
    }
    if (addOns != null) {
      data['add_ons'] = addOns!.map((v) => v.toJson()).toList();
    }
    data['price'] = price;
    data['tax'] = tax;
    data['discount'] = discount;
    data['discount_type'] = discountType;
    data['available_time_starts'] = availableTimeStarts;
    data['available_time_ends'] = availableTimeEnds;
    data['set_menu'] = setMenu;
    data['status'] = status;
    data['restaurant_id'] = restaurantId;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['restaurant_name'] = restaurantName;
    data['restaurant_discount'] = restaurantDiscount;
    data['schedule_order'] = scheduleOrder;
    data['avg_rating'] = avgRating;
    data['rating_count'] = ratingCount;
    data['recommended'] = recommendedStatus;
    data['veg'] = veg;
    if (translations != null) {
      data['translations'] = translations!.map((v) => v.toJson()).toList();
    }
    if (tags != null) {
      data['tags'] = tags!.map((v) => v.toJson()).toList();
    }
    data['maximum_cart_quantity'] = maxOrderQuantity;
    data['item_stock'] = itemStock;
    data['stock_type'] = stockType;
    data['is_halal'] = isHalal;
    data['halal_tag_status'] = halalTagStatus;
    if (nutrition != null) {
      data['nutritions_name'] = nutrition;
    }
    if (allergies != null) {
      data['allergies_name'] = allergies;
    }
    if (taxVatIds != null) {
      data['tax_ids'] = taxVatIds!.map((v) => v.toString()).toList();
    }
    if (taxData != null) {
      data['tax_data'] = taxData!.map((v) => v.toJson()).toList();
    }
    data['maximum_cart_quantity'] = cartQuantityLimit;
    data['restaurant_category_id'] = restaurantCategoryId;
    data['restaurant_category_name'] = restaurantCategoryName;
    return data;
  }
}

class CategoryIds {
  String? id;
  String? categoryName;

  CategoryIds({this.id, this.categoryName});

  CategoryIds.fromJson(Map<String, dynamic> json) {
    id = json['id'].toString();
    categoryName = json['category_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['category_name'] = categoryName;
    return data;
  }
}

class Variation {
  String? id;
  String? name;
  String? type;
  String? min;
  String? max;
  String? required;
  List<VariationOption>? variationValues;

  Variation({this.id, this.name, this.type, this.min, this.max, this.required, this.variationValues});

  Variation.fromJson(Map<String, dynamic> json) {
    id = json['variation_id'].toString();
    name = json['name'];
    type = json['type'];
    min = json['min'].toString();
    max = json['max'].toString();
    required = json['required'];
    if (json['values'] != null) {
      variationValues = [];
      json['values'].forEach((v) {
        variationValues!.add(VariationOption.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['variation_id'] = id;
    data['name'] = name;
    data['type'] = type;
    data['min'] = min;
    data['max'] = max;
    data['required'] = required;
    if (variationValues != null) {
      data['values'] = variationValues!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class VariationOption {
  String? level;
  String? optionPrice;
  String? totalStock;
  String? stockType;
  String? sellCount;
  String? optionId;
  String? currentStock;

  VariationOption({this.level, this.optionPrice, this.totalStock, this.stockType, this.sellCount, this.optionId, this.currentStock});

  VariationOption.fromJson(Map<String, dynamic> json) {
    level = json['label'];
    optionPrice = json['optionPrice'].toString();
    totalStock = json['total_stock']?.toString();
    stockType = json['stock_type']?.toString();
    sellCount = json['sell_count']?.toString();
    optionId = json['option_id']?.toString();
    currentStock = json['current_stock']?.toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['label'] = level;
    data['optionPrice'] = optionPrice;
    data['total_stock'] = totalStock;
    data['stock_type'] = stockType;
    data['sell_count'] = sellCount;
    data['option_id'] = optionId;
    data['current_stock'] = currentStock;
    return data;
  }
}

class AddOns {
  int? id;
  String? name;
  double? price;
  int? status;
  List<Translation>? translations;
  int? addonStock;
  String? stockType;
  List<int>? taxVatIds;
  int? addonCategoryId;

  AddOns({this.id, this.name, this.price, this.status, this.translations, this.addonStock, this.stockType, this.taxVatIds, this.addonCategoryId});

  AddOns.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    price = json['price']?.toDouble();
    status = json['status'];
    if (json['translations'] != null) {
      translations = [];
      json['translations'].forEach((v) {
        translations!.add(Translation.fromJson(v));
      });
    }
    addonStock = json['addon_stock'];
    stockType = json['stock_type'];
    if (json['tax_ids'] != null) {
      taxVatIds = [];
      json['tax_ids'].forEach((v) {
        taxVatIds!.add(int.parse(v.toString()));
      });
    }
    addonCategoryId = json['addon_category_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['price'] = price;
    data['status'] = status;
    if (translations != null) {
      data['translations'] = translations!.map((v) => v.toJson()).toList();
    }
    data['addon_stock'] = addonStock;
    data['stock_type'] = stockType;
    if (taxVatIds != null) {
      data['tax_ids'] = taxVatIds!.map((v) => v.toString()).toList();
    }
    data['addon_category_id'] = addonCategoryId;
    return data;
  }
}

class ChoiceOptions {
  String? name;
  String? title;
  List<String>? options;

  ChoiceOptions({this.name, this.title, this.options});

  ChoiceOptions.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    title = json['title'];
    options = json['options'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['title'] = title;
    data['options'] = options;
    return data;
  }
}

class Translation {
  int? id;
  String? locale;
  String? key;
  String? value;

  Translation({this.id, this.locale, this.key, this.value});

  Translation.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    locale = json['locale'];
    key = json['key'];
    value = json['value'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['locale'] = locale;
    data['key'] = key;
    data['value'] = value;
    return data;
  }
}

class Tag {
  int? id;
  String? tag;

  Tag({this.id, this.tag});

  Tag.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    tag = json['tag'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['tag'] = tag;
    return data;
  }
}

class TaxData {
  int? id;
  String? name;
  double? taxRate;

  TaxData({this.id, this.name, this.taxRate});

  TaxData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    taxRate = json['tax_rate']?.toDouble();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['tax_rate'] = taxRate;
    return data;
  }
}