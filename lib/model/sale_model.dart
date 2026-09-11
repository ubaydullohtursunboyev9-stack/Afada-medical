import 'mahsulot_modeli.dart';
import 'mijoz_modeli.dart';

class SaleModel {
  final int? id;
  final MahsulotModel? product;
  final MijozModel? customer;
  final MijozModel? referrer;
  final String saleType;
  final int quantity;
  final double price;
  final double discount;
  final double cashback;
  final double amountPaid; // API field 'paid'
  final double debt;
  final double jamiSumma; // API field 'total'
  final Map<String, dynamic>? createdBy;
  final DateTime date; // API field 'createdAt'
  final String? phoneNumber;

  SaleModel({
    this.id,
    this.product,
    this.customer,
    this.referrer,
    required this.saleType,
    required this.quantity,
    required this.price,
    this.discount = 0.0,
    this.cashback = 0.0,
    this.amountPaid = 0.0,
    this.debt = 0.0,
    this.jamiSumma = 0.0,
    this.createdBy,
    required this.date,
    this.phoneNumber,
  });

  String get productName => product?.nomi ?? "Noma'lum";
  String get customerName => customer != null ? "${customer!.ism} ${customer!.familya}" : (phoneNumber ?? "Mehmon");
  String get referrerName => referrer != null ? "${referrer!.ism} ${referrer!.familya}" : "";

  factory SaleModel.fromJson(Map<String, dynamic> json) {
    return SaleModel(
      id: json['id'],
      product: json['product'] != null ? MahsulotModel.fromJson(json['product']) : null,
      customer: json['customer'] != null ? MijozModel.fromJson(json['customer']) : null,
      referrer: json['referrer'] != null ? MijozModel.fromJson(json['referrer']) : null,
      saleType: json['saleType'] ?? 'patient',
      quantity: _toInt(json['quantity']),
      price: _toDouble(json['price']),
      discount: _toDouble(json['discount']),
      cashback: _toDouble(json['cashback']),
      amountPaid: _toDouble(json['paid']),
      debt: _toDouble(json['debt']),
      jamiSumma: _toDouble(json['total']),
      createdBy: json['createdBy'],
      date: json['createdAt'] != null ? DateTime.parse(json['createdAt']) : DateTime.now(),
      phoneNumber: json['phone_number'],
    );
  }

  static double _toDouble(dynamic val) {
    if (val == null) return 0.0;
    if (val is num) return val.toDouble();
    if (val is String) return double.tryParse(val) ?? 0.0;
    return 0.0;
  }

  static int _toInt(dynamic val) {
    if (val == null) return 0;
    if (val is num) return val.toInt();
    if (val is String) return int.tryParse(val) ?? 0;
    return 0;
  }
}
