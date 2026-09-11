class OrderModel {
  final String id;
  final String productName;
  final int quantity;
  final double price;
  final DateTime date;
  final String customerName;
  final String phone;
  final String comment;
  final String referrer;
  final String status;
  final String paymentStatus;
  final double amountPaid;
  final double servicePrice;

  // Buyurtmani/sotuvni qaysi account yaratgan
  final Map<String, dynamic>? createdBy;

  OrderModel({
    required this.id,
    required this.productName,
    required this.quantity,
    required this.price,
    required this.date,
    this.customerName = "",
    this.phone = "",
    this.comment = "",
    this.referrer = "",
    this.status = "Tayyorlash",
    this.paymentStatus = "To'lanmagan",
    this.amountPaid = 0.0,
    this.servicePrice = 0.0,
    this.createdBy,
  });

  OrderModel copyWith({
    String? id,
    String? productName,
    int? quantity,
    double? price,
    DateTime? date,
    String? customerName,
    String? phone,
    String? comment,
    String? referrer,
    String? status,
    String? paymentStatus,
    double? amountPaid,
    double? servicePrice,
    Map<String, dynamic>? createdBy,
  }) {
    return OrderModel(
      id: id ?? this.id,
      productName: productName ?? this.productName,
      quantity: quantity ?? this.quantity,
      price: price ?? this.price,
      date: date ?? this.date,
      customerName: customerName ?? this.customerName,
      phone: phone ?? this.phone,
      comment: comment ?? this.comment,
      referrer: referrer ?? this.referrer,
      status: status ?? this.status,
      paymentStatus: paymentStatus ?? this.paymentStatus,
      amountPaid: amountPaid ?? this.amountPaid,
      servicePrice: servicePrice ?? this.servicePrice,
      createdBy: createdBy ?? this.createdBy,
    );
  }
}