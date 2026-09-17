class EarningReportModel {
  final SummaryModel? summary;
  final TrendsModel? trends;
  TransactionContainer? transactions;
  int? totalSize;

  EarningReportModel({
    required this.summary,
    required this.trends,
    required this.transactions,
    required this.totalSize,
  });

  factory EarningReportModel.fromJson(Map<String, dynamic> json) {
    return EarningReportModel(
      summary: json['summary'] != null
          ? SummaryModel.fromJson(json['summary'])
          : null,
      trends: json['trends'] != null
          ? TrendsModel.fromJson(json['trends'])
          : null,
      transactions: TransactionContainer.fromJson(json['transactions']),
      totalSize: json['total_size'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'summary': summary?.toJson(),
      'trends': trends?.toJson(),
      'transactions': transactions?.toJson(),
      'total_size' : totalSize,
    };
  }
}

class TransactionContainer {
  final List<TransactionModel> data;
  final PaginationModel? pagination;

  TransactionContainer({
    required this.data,
    this.pagination,
  });

  factory TransactionContainer.fromJson(dynamic json) {
    // Earning response: transactions is a List
    if (json is List) {
      return TransactionContainer(
        data: json.map((e) => TransactionModel.fromJson(e)).toList(),
        pagination: null,
      );
    }

    // Expense response: transactions is an object with data + pagination
    if (json is Map<String, dynamic>) {
      final List<TransactionModel> items = (json['data'] as List? ?? [])
          .map((e) => TransactionModel.fromJson(e))
          .toList();

      return TransactionContainer(
        data: items,
        pagination: PaginationModel.fromJson(json),
      );
    }

    return TransactionContainer(data: [], pagination: null);
  }

  Map<String, dynamic> toJson() {
    return {
      'data': data.map((e) => e.toJson()).toList(),
      'pagination': pagination?.toJson(),
    };
  }
}

class TransactionModel {
  final String? transactionId;
  final String? date;
  final String? source;
  final String? sourceType;

  // Unified fields
  final String? reference;
  final String? referenceType; // earning / expense
  final String? badge;

  final int? orderId;
  final double? amount;

  // For earning this is usually an object
  // For expense this may be an empty list
  final dynamic breakdown;

  TransactionModel({
    this.transactionId,
    this.date,
    this.source,
    this.sourceType,
    this.reference,
    this.referenceType,
    this.badge,
    this.orderId,
    this.amount,
    this.breakdown,
  });

  factory TransactionModel.fromJson(Map<String, dynamic> json) {
    final bool isEarning = json.containsKey('earning_from');
    final bool isExpense = json.containsKey('expense_source');

    return TransactionModel(
      transactionId: json['transaction_id']?.toString(),
      date: json['date']?.toString(),
      source: json['source']?.toString(),
      sourceType: json['source_type']?.toString(),
      reference: isEarning
          ? json['earning_from']?.toString()
          : json['expense_source']?.toString(),
      referenceType: isEarning
          ? 'earning'
          : isExpense
          ? 'expense'
          : null,
      badge: json['expense_source_badge']?.toString(),
      orderId: _toInt(json['order_id']),
      amount: _toDouble(json['amount']),
      breakdown: json['breakdown'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'transaction_id': transactionId,
      'date': date,
      'source': source,
      'source_type': sourceType,
      'reference': reference,
      'reference_type': referenceType,
      'badge': badge,
      'order_id': orderId,
      'amount': amount,
      'breakdown': breakdown,
    };
  }

  static int? _toInt(dynamic value) {
    if (value == null) return null;
    if (value is int) return value;
    return int.tryParse(value.toString());
  }

  static double? _toDouble(dynamic value) {
    if (value == null) return null;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    return double.tryParse(value.toString());
  }
}

class PaginationModel {
  final int? currentPage;
  final int? lastPage;
  final int? perPage;
  final int? total;
  final int? from;
  final int? to;
  final String? nextPageUrl;
  final String? prevPageUrl;
  final String? firstPageUrl;
  final String? lastPageUrl;
  final String? path;

  PaginationModel({
    this.currentPage,
    this.lastPage,
    this.perPage,
    this.total,
    this.from,
    this.to,
    this.nextPageUrl,
    this.prevPageUrl,
    this.firstPageUrl,
    this.lastPageUrl,
    this.path,
  });

  factory PaginationModel.fromJson(Map<String, dynamic> json) {
    return PaginationModel(
      currentPage: _toInt(json['current_page']),
      lastPage: _toInt(json['last_page']),
      perPage: _toInt(json['per_page']),
      total: _toInt(json['total']),
      from: _toInt(json['from']),
      to: _toInt(json['to']),
      nextPageUrl: json['next_page_url']?.toString(),
      prevPageUrl: json['prev_page_url']?.toString(),
      firstPageUrl: json['first_page_url']?.toString(),
      lastPageUrl: json['last_page_url']?.toString(),
      path: json['path']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'current_page': currentPage,
      'last_page': lastPage,
      'per_page': perPage,
      'total': total,
      'from': from,
      'to': to,
      'next_page_url': nextPageUrl,
      'prev_page_url': prevPageUrl,
      'first_page_url': firstPageUrl,
      'last_page_url': lastPageUrl,
      'path': path,
    };
  }

  static int? _toInt(dynamic value) {
    if (value == null) return null;
    if (value is int) return value;
    return int.tryParse(value.toString());
  }
}

class SummaryModel {
  final double? totalEarningsWithAdminCommission;
  final double? totalEarningsPercentage;
  final bool? totalEarningsPositive;
  final double? totalExpenses;
  final double? totalExpensesPercentage;
  final bool? totalExpensesPositive;
  final double? netProfit;
  final double? netProfitPercentage;
  final bool? netProfitPositive;
  final int? totalTransaction;
  final double? totalTransactionPercentage;
  final bool? totalTransactionPositive;
  final int? totalTransactionExpense;
  final double? totalTransactionExpensePercentage;
  final bool? totalTransactionExpensePositive;
  final int? totalTransactionEarning;
  final double? totalTransactionEarningPercentage;
  final bool? totalTransactionEarningPositive;
  final int? totalTransactionSubscription;
  final double? totalTransactionSubscriptionPercentage;
  final bool? totalTransactionSubscriptionPositive;
  final BreakdownSummaryModel? breakdown;

  SummaryModel({
    this.totalEarningsWithAdminCommission,
    this.totalEarningsPercentage,
    this.totalEarningsPositive,
    this.totalExpenses,
    this.totalExpensesPercentage,
    this.totalExpensesPositive,
    this.netProfit,
    this.netProfitPercentage,
    this.netProfitPositive,
    this.totalTransaction,
    this.totalTransactionPercentage,
    this.totalTransactionPositive,
    this.totalTransactionExpense,
    this.totalTransactionExpensePercentage,
    this.totalTransactionExpensePositive,
    this.totalTransactionEarning,
    this.totalTransactionEarningPercentage,
    this.totalTransactionEarningPositive,
    this.totalTransactionSubscription,
    this.totalTransactionSubscriptionPercentage,
    this.totalTransactionSubscriptionPositive,
    this.breakdown,
  });

  factory SummaryModel.fromJson(Map<String, dynamic> json) {
    return SummaryModel(
      totalEarningsWithAdminCommission: _toDouble(json['total_earnings_with_admin_commission']),
      totalEarningsPercentage: _toDouble(json['total_earnings_percentage']),
      totalEarningsPositive: json['total_earnings_positive'],
      totalExpenses: _toDouble(json['total_expenses']),
      totalExpensesPercentage: _toDouble(json['total_expenses_percentage']),
      totalExpensesPositive: json['total_expenses_positive'],
      netProfit: _toDouble(json['net_profit']),
      netProfitPercentage: _toDouble(json['net_profit_percentage']),
      netProfitPositive: json['net_profit_positive'],
      totalTransaction: _toInt(json['total_transaction']),
      totalTransactionPercentage:
      _toDouble(json['total_transaction_percentage']),
      totalTransactionPositive: json['total_transaction_positive'],
      totalTransactionExpense: _toInt(json['total_transaction_expense']),
      totalTransactionExpensePercentage:
      _toDouble(json['total_transaction_expense_percentage']),
      totalTransactionExpensePositive:
      json['total_transaction_expense_positive'],
      totalTransactionEarning: _toInt(json['total_transaction_earning']),
      totalTransactionEarningPercentage:
      _toDouble(json['total_transaction_earning_percentage']),
      totalTransactionEarningPositive:
      json['total_transaction_earning_positive'],
      totalTransactionSubscription: _toInt(json['total_transaction_subscription']),
      totalTransactionSubscriptionPercentage: _toDouble(json['total_transaction_subscription_percentage']),
      totalTransactionSubscriptionPositive: json['total_transaction_subscription_positive'],
      breakdown: json['breakdown'] != null
          ? BreakdownSummaryModel.fromJson(json['breakdown'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'total_earnings_with_admin_commission': totalEarningsWithAdminCommission,
      'total_earnings_percentage': totalEarningsPercentage,
      'total_earnings_positive': totalEarningsPositive,
      'total_expenses': totalExpenses,
      'total_expenses_percentage': totalExpensesPercentage,
      'total_expenses_positive': totalExpensesPositive,
      'net_profit': netProfit,
      'net_profit_percentage': netProfitPercentage,
      'net_profit_positive': netProfitPositive,
      'total_transaction': totalTransaction,
      'total_transaction_percentage': totalTransactionPercentage,
      'total_transaction_positive': totalTransactionPositive,
      'total_transaction_expense': totalTransactionExpense,
      'total_transaction_expense_percentage': totalTransactionExpensePercentage,
      'total_transaction_expense_positive': totalTransactionExpensePositive,
      'total_transaction_earning': totalTransactionEarning,
      'total_transaction_earning_percentage': totalTransactionEarningPercentage,
      'total_transaction_earning_positive': totalTransactionEarningPositive,
      'total_transaction_subscription': totalTransactionSubscription,
      'total_transaction_subscription_percentage': totalTransactionSubscriptionPercentage,
      'total_transaction_subscription_positive': totalTransactionSubscriptionPositive,
      'breakdown': breakdown?.toJson(),
    };
  }

  static int? _toInt(dynamic value) {
    if (value == null) return null;
    if (value is int) return value;
    return int.tryParse(value.toString());
  }

  static double? _toDouble(dynamic value) {
    if (value == null) return null;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    return double.tryParse(value.toString());
  }
}

class BreakdownSummaryModel {
  final double? orderSales;
  final double? taxCollected;
  final double? packagingFeeCollected;
  final double? adminCommission;
  final double? restaurantExpense;
  final double? productDiscount;
  final double? subscriptionFee;
  final double? couponContribution;
  final double? freeDelivery;

  BreakdownSummaryModel({
    this.orderSales,
    this.taxCollected,
    this.packagingFeeCollected,
    this.adminCommission,
    this.restaurantExpense,
    this.productDiscount,
    this.subscriptionFee,
    this.couponContribution,
    this.freeDelivery,
  });

  factory BreakdownSummaryModel.fromJson(Map<String, dynamic> json) {
    return BreakdownSummaryModel(
      orderSales: _toDouble(json['order_sales']),
      taxCollected: _toDouble(json['tax_collected']),
      packagingFeeCollected: _toDouble(json['packaging_fee_collected']),
      adminCommission: _toDouble(json['admin_commission']),
      restaurantExpense: _toDouble(json['restaurant_expense']),
      productDiscount: _toDouble(json['product_discount']),
      subscriptionFee: _toDouble(json['subscription_fee']),
      couponContribution: _toDouble(json['coupon_contribution']),
      freeDelivery: _toDouble(json['free_delivery']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'order_sales': orderSales,
      'tax_collected': taxCollected,
      'packaging_fee_collected': packagingFeeCollected,
      'admin_commission': adminCommission,
      'restaurant_expense': restaurantExpense,
      'product_discount': productDiscount,
      'subscription_fee': subscriptionFee,
      'coupon_contribution': couponContribution,
      'free_delivery': freeDelivery,
    };
  }

  static double? _toDouble(dynamic value) {
    if (value == null) return null;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    return double.tryParse(value.toString());
  }
}

class TrendsModel {
  final List<String> categories;
  final List<double> earningSeries;
  final List<double> expenseSeries;

  TrendsModel({
    required this.categories,
    required this.earningSeries,
    required this.expenseSeries,
  });

  factory TrendsModel.fromJson(Map<String, dynamic> json) {
    return TrendsModel(
      categories: (json['categories'] as List? ?? [])
          .map((e) => e.toString())
          .toList(),
      earningSeries: (json['earning_series'] as List? ?? [])
          .map((e) => _toDouble(e) ?? 0.0)
          .toList(),
      expenseSeries: (json['expense_series'] as List? ?? [])
          .map((e) => _toDouble(e) ?? 0.0)
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'categories': categories,
      'earning_series': earningSeries,
      'expense_series': expenseSeries,
    };
  }

  static double? _toDouble(dynamic value) {
    if (value == null) return null;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    return double.tryParse(value.toString());
  }
}
